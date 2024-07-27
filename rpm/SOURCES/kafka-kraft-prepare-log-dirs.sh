#!/bin/sh

# This script creates the kafka-kraft data directory during first service start.
# In subsequent starts, it does nothing much.

# `basename $0`
#
# Usage:
#    `basename $0` [-h, --help] <kafka_cluster_id> <kafka_server_config>
#
# Options:
#    <kafka_cluster_id>       Custom kafka cluster id.
#    <kafka_server_config>    Kafka server config.
#    -h, --help               Print help info.
#
# Examples:
#    -- /usr/libexec/`basename $0` /etc/kafka/kraft/server.properties
#    -- /usr/libexec/`basename $0` \$(/usr/bin/kafka/kafka-storage.sh random-uuid) /etc/kafka/kraft/server.properties
#    -- /usr/libexec/`basename $0` "custom-uuid" /etc/kafka/kraft/server.properties

# Print help info
if [ $# -eq 0 ] || [ "$1" == "-h" ] || [ "$1" == "--help" ]; then
    echo "`basename $0`"
    echo
    echo "Usage:"
    echo "   `basename $0` [-h, --help] <kafka_cluster_id> <kafka_server_config>"
    echo
    echo "Options:"
    echo "   <kafka_cluster_id>       Custom kafka cluster id."
    echo "   <kafka_server_config>    Kafka server config."
    echo "   -h, --help               Print help info."
    echo
    echo "Examples:"
    echo "   -- /usr/libexec/`basename $0` /etc/kafka/kraft/server.properties"
    echo "   -- /usr/libexec/`basename $0` \$(/usr/bin/kafka/kafka-storage.sh random-uuid) /etc/kafka/kraft/server.properties"
    echo "   -- /usr/libexec/`basename $0` "custom-uuid" /etc/kafka/kraft/server.properties"
    exit 1
fi

# Default kafka_cluster_id and kafka_server_config
if [ $# -ge 2 ]; then
    KAFKA_CLUSTER_ID=$1
    KAFKA_SERVER_CONFIG=$2
else
    KAFKA_SERVER_CONFIG=$1
fi

# Check KAFKA_CLUSTER_ID
if [ $# -ge 2 ] && [ -z "$KAFKA_CLUSTER_ID" ]; then
    echo "config <kafka_cluster_id> can not be null"
    exit 1
fi

# Check KAFKA_SERVER_CONFIG
if [ -z "$KAFKA_SERVER_CONFIG" ]; then
    echo "config <kafka_server_config> can not be null"
    exit 1
fi

# Check config file exists
if [ ! -f $KAFKA_SERVER_CONFIG ]; then
    echo "config <kafka_server_config> file not found"
    exit 1
fi

# Read property "log.dirs=" from config file
LOG_DIRS=$(grep "log.dirs" $KAFKA_SERVER_CONFIG | grep -v '#' | cut -d'=' -f2 | sed 's/\r//')
# Check LOG_DIRS
if [ -z "$LOG_DIRS" ]; then
    echo "config file property \"log.dirs=\" is empty"
    exit 1
fi

echo "KAFKA_SERVER_CONFIG=$KAFKA_SERVER_CONFIG"
echo "LOG_DIRS=$LOG_DIRS"

# A comma separated "," list of directories under which to store log files
# Make LOG_DIRS to array
array=(${LOG_DIRS//,/ })
# Forearch log directories list
uninitialized_count=0
initialized_count=0
for var in ${array[@]}
do
    data_dir=$var
    # Check LOG_DIR should initialize
    ls_result=$( ( ls -1A "$data_dir" 2>/dev/null || echo "fake-file" ) | grep -E "meta.properties|bootstrap.checkpoint" )
    if test -z "$ls_result"; then
        let uninitialized_count++
        # kraft dir not exists
        echo "kafka-kraft is uninitialized in $data_dir present." >&2
    else
        let initialized_count++
        # kraft dir exists, it seems data are initialized properly
        echo "kafka-kraft is initialized in $data_dir already." >&2
    fi
done

# Check initialized count
if [ $initialized_count -gt 0 ]; then
    echo "There are more than one directories that have been initialized, nothing is done."
    if [ $uninitialized_count -gt 0 ]; then
        echo "kafka-storage.sh can not initialize with uninitialized and initialized log directories together."
    fi
    exit 0
fi

# Initializing
echo "Initializing kafka-kraft log directories..."

# Random KAFKA_CLUSTER_ID
if [ -z "$KAFKA_CLUSTER_ID" ]; then
    KAFKA_CLUSTER_ID=$(/usr/bin/kafka/kafka-storage.sh random-uuid)
fi

# Format Log Directories
/usr/bin/kafka/kafka-storage.sh format -t "$KAFKA_CLUSTER_ID" -c "$KAFKA_SERVER_CONFIG" >&2
ret=$?
if [ $ret -ne 0 ]; then
    echo "Initialization of kafka-kraft log directories failed." >&2
    exit $ret
else
    # Get User and Group
    SERVICE_NAME="kafka-kraft"
    kraft_user=`systemctl show -p User "${SERVICE_NAME}" | sed 's/^User=//'`
    if [ x"$kraft_user" = x ]; then
        kraft_user=kraft
    fi

    kraft_group=`systemctl show -p Group "${SERVICE_NAME}" | sed 's/^Group=//'`
    if [ x"$kraft_group" = x ]; then
        kraft_group=kraft
    fi

    # Forearch log directories list
    for var in ${array[@]}
    do
        data_dir=$var    
        echo "Chowning and Chmoding $data_dir"
        chown "$kraft_user:$kraft_group" "$data_dir"
        chmod 0755 "$data_dir"
    done
    echo "Initialization of kafka-kraft log directories successfully."
fi

exit 0

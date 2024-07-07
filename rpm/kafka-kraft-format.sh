#!/bin/bash

# tmp env PATH
source /etc/sysconfig/kafka-kraft

# Generate a Cluster UUID
KAFKA_CLUSTER_ID="$(/usr/bin/kafka/kafka-storage.sh random-uuid)"

# Print KAFKA_CLUSTER_ID
echo "KAFKA_CLUSTER_ID is:" $KAFKA_CLUSTER_ID

# Format Log Directories
/usr/bin/kafka/kafka-storage.sh format -t $KAFKA_CLUSTER_ID -c $KAFKA_SERVER_CONFIG

#!/bin/bash

# env
export KAFKA_SERVER_CONFIG=/etc/kafka/kraft/server.properties
# After Patch, not need to add
# export CLASSPATH=.:/usr/lib64/kafka/*
# export LOG4J_DIR=/etc/kafka/tools-log4j.properties
# export KAFKA_LOG4J_OPTS=-Dlog4j2.configurationFile=${LOG4J_DIR}

# Generate a Cluster UUID
KAFKA_CLUSTER_ID="$(/usr/bin/kafka/kafka-storage.sh random-uuid)"

# Print KAFKA_CLUSTER_ID
echo "KAFKA_CLUSTER_ID is:" ${KAFKA_CLUSTER_ID}

# Format Log Directories
/usr/bin/kafka/kafka-storage.sh format -t ${KAFKA_CLUSTER_ID} -c ${KAFKA_SERVER_CONFIG}

# Change Lib User and Group
/bin/chown -R kafka:kafka /var/lib/kraft/kraft-combined-logs/

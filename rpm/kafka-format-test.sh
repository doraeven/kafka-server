#!/bin/bash

# env
export KAFKA_SERVER_CONFIG=/etc/kafka/server.properties
# After Patch, not need to add
# export CLASSPATH=.:/usr/lib64/kafka/*
# export KAFKA_LOG4J_OPTS=-Dlog4j2.configurationFile=file:///etc/kafka/tools-log4j2.yaml

# Generate a Cluster UUID
KAFKA_CLUSTER_ID="$(/usr/bin/kafka/kafka-storage.sh random-uuid)"

# Print KAFKA_CLUSTER_ID
echo "KAFKA_CLUSTER_ID is:" ${KAFKA_CLUSTER_ID}

# Format Log Directories
/usr/bin/kafka/kafka-storage.sh format --standalone -t ${KAFKA_CLUSTER_ID} -c ${KAFKA_SERVER_CONFIG}

# Change Lib User and Group
/bin/chown kafka:kafka /var/lib/kafka/kraft-combined-logs/bootstrap.checkpoint
/bin/chown kafka:kafka /var/lib/kafka/kraft-combined-logs/meta.properties

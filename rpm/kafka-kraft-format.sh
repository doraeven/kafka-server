#!/bin/bash

# env
export CLASSPATH=.:/usr/lib64/kafka/*
export KAFKA_SERVER_CONFIG=/etc/kafka/kraft/server.properties
export KAFKA_LOG4J_OPTS=-Dlog4j.configuration=file:///etc/kafka/tools-log4j.properties

# Generate a Cluster UUID
KAFKA_CLUSTER_ID="$(/usr/bin/kafka/kafka-storage.sh random-uuid)"

# Print KAFKA_CLUSTER_ID
echo "KAFKA_CLUSTER_ID is:" $KAFKA_CLUSTER_ID

# Format Log Directories
/usr/bin/kafka/kafka-storage.sh format -t $KAFKA_CLUSTER_ID -c $KAFKA_SERVER_CONFIG


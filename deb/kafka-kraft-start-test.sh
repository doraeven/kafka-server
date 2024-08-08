#!/bin/bash

# stop kafka-zookeeper server
echo "stop kafka-zookeeper server"
systemctl stop kafka-zookeeper.service

# stop kafka server
echo "stop kafka server"
systemctl stop kafka.service

# start kafka-kraft server
echo "start kafka-kraft server"
systemctl start kafka-kraft.service

# status kafka-kraft server
systemctl status kafka-kraft.service

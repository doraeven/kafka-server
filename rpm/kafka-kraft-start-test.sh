#!/bin/bash

# stop kafka-zookeeper server
echo "stop kafka-zookeeper server"
systemctl stop kafka-zookeeper.service
systemctl status kafka-zookeeper.service

# stop kafka server
echo "stop kafka server"
systemctl stop kafka.service
systemctl status kafka.service

# start kafka-kraft server
echo "start kafka-kraft server"
systemctl start kafka-kraft.service
systemctl status kafka-kraft.service

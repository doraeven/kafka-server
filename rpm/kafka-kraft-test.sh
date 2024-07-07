#!/bin/bash

echo "1. stop kafka-zookeeper server"
systemctl stop kafka-zookeeper.service
systemctl status kafka-zookeeper.service

echo "2. stop kafka server"
systemctl stop kafka.service
systemctl status kafka.service

echo "3. start kafka-kraft server"
systemctl start kafka-kraft.service
systemctl status kafka-kraft.service

#!/bin/bash

# def
KAFKA_VERSION=3.7.1
EPOCH=1
PACKAGE_NAME=kafka-$KAFKA_VERSION-$EPOCH.el8.x86_64

# remove old rpm
echo "1. rpm remove"
rpm -e $PACKAGE_NAME
echo "delete old log, old data"
rm /var/log/kafka/ -rf
rm /var/log/zookeeper/ -rf
rm /var/log/kraft/ -rf
rm /var/lib/kafka/ -rf
rm /var/lib/zookeeper/ -rf
rm /var/lib/kraft/ -rf

# install new rpm
echo "2. install new"
rpm -ivh ~/rpmbuild/RPMS/x86_64/$PACKAGE_NAME.rpm

# print config info
echo "3. print config info"
echo "--- print /usr/lib/systemd/system/kafka.service:"
cat /usr/lib/systemd/system/kafka.service
echo "--- print /etc/sysconfig/kafka:"
cat /etc/sysconfig/kafka
echo "--- print /usr/lib/systemd/system/kafka-zookeeper.service:"
cat /usr/lib/systemd/system/kafka-zookeeper.service
echo "--- print /etc/sysconfig/kafka-zookeeper:"
cat /etc/sysconfig/kafka-zookeeper
echo "--- print /usr/lib/systemd/system/kafka-kraft.service:"
cat /usr/lib/systemd/system/kafka-kraft.service
echo "--- print /etc/sysconfig/kafka-kraft:"
cat /etc/sysconfig/kafka-kraft

# start server
echo "4. start server"
systemctl start kafka-zookeeper.service
systemctl start kafka.service
systemctl status kafka-zookeeper.service
systemctl status kafka.service

#!/bin/bash

# def
KAFKA_VERSION=3.9.0
EPOCH=1
PACKAGE_NAME=kafka_${KAFKA_VERSION}-${EPOCH}_amd64
TOPDIR=~/debbuild

# remove old deb
echo "deb remove"
dpkg -r kafka
dpkg --purge kafka
echo "delete old log, old data"
rm /var/log/kafka/ -rf
rm /var/log/zookeeper/ -rf
rm /var/log/kraft/ -rf
rm /var/lib/kafka/ -rf
rm /var/lib/zookeeper/ -rf
rm /var/lib/kraft/ -rf

# install new deb
echo "install new"
dpkg -i ${TOPDIR}/BUILDROOT/${PACKAGE_NAME}.deb

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
echo "start server"
systemctl start kafka-zookeeper.service
systemctl start kafka.service
systemctl status kafka-zookeeper.service
systemctl status kafka.service

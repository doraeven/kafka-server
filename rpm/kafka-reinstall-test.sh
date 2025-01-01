#!/bin/bash

# def
KAFKA_VERSION=3.7.2
EPOCH=1
DIST=""
distro_info=$(cat /etc/os-release)
if echo "${distro_info}" | grep -q 'el9'; then
    DIST="el9"
elif echo "${distro_info}" | grep -q 'el8'; then
    DIST="el8"
elif echo "${distro_info}" | grep -q 'el7'; then
    DIST="el7"
else
    echo "unknow os"
    exit 1;
fi
PACKAGE_NAME=kafka-${KAFKA_VERSION}-${EPOCH}.${DIST}.x86_64
TOPDIR=~/rpmbuild

# remove old rpm
echo "rpm remove"
rpm -e ${PACKAGE_NAME}
echo "delete old log, old data"
rm /var/log/kafka/ -rf
rm /var/log/zookeeper/ -rf
rm /var/log/kraft/ -rf
rm /var/lib/kafka/ -rf
rm /var/lib/zookeeper/ -rf
rm /var/lib/kraft/ -rf

# install new rpm
echo "install new"
rpm -ivh ${TOPDIR}/RPMS/x86_64/${PACKAGE_NAME}.rpm

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

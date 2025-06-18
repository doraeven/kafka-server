#!/bin/bash

# def
KAFKA_VERSION=4.0.0
EPOCH=1
PACKAGE_NAME=kafka_${KAFKA_VERSION}-${EPOCH}_amd64
TOPDIR=~/debbuild

# remove old deb
echo "deb remove"
dpkg -r kafka
dpkg --purge kafka
echo "delete old log, old data"
rm /var/log/kafka/ -rf
rm /var/lib/kafka/ -rf

# install new deb
echo "install new"
dpkg -i ${TOPDIR}/BUILDROOT/${PACKAGE_NAME}.deb

# print config info
echo "print config info"
echo "--- print /usr/lib/systemd/system/kafka.service:"
cat /usr/lib/systemd/system/kafka.service
echo "--- print /etc/sysconfig/kafka:"
cat /etc/sysconfig/kafka

# start server
echo "start server"
systemctl start kafka.service
systemctl status kafka.service

#!/bin/bash

# def
KAFKA_VERSION=4.0.0
SCALA_VERSION=2.13
PACKAGE_NAME=kafka_${SCALA_VERSION}-${KAFKA_VERSION}
TOPDIR=~/debbuild

# tar and cp new
echo "tar sources and cp new sources"
cd ${TOPDIR}/SOURCES/
rm -rf ${PACKAGE_NAME}/
rm -rf ${PACKAGE_NAME}-new/
tar -zxvf ${PACKAGE_NAME}.tgz
cp -rf ${PACKAGE_NAME}/ ${PACKAGE_NAME}-new/

# patch /bin/kafka-run-class.sh
# ```
# # Patch for linux ENV
# if [ -d "/usr/lib64/kafka/" ] && [ -z "$CLASSPATH" ]; then
#   CLASSPATH=".:/usr/lib64/kafka/*"
#   LOG4J_DIR="/etc/kafka/tools-log4j2.yaml"
#   KAFKA_LOG4J_OPTS="-Dlog4j2.configurationFile=file:${LOG4J_DIR}"
# fi
# ```
# Patch for linux ENV
echo "patch /bin/kafka-run-class.sh"
PATCH_CODE='\
\
# Patch for linux ENV\
if [ -d "/usr/lib64/kafka/" ] \&\& [ -z "$CLASSPATH" ]; then\
  CLASSPATH=".\:/usr/lib64/kafka/*"\
  LOG4J_DIR="/etc/kafka/tools-log4j2.yaml"\
  KAFKA_LOG4J_OPTS="-Dlog4j2.configurationFile=file\:${LOG4J_DIR}"\
fi\
'
sed -i 's:^shopt -u nullglob:&'"${PATCH_CODE}"':' ${PACKAGE_NAME}-new/bin/kafka-run-class.sh

# Generate patch file
echo "generate kafka-run-class.sh.patch"
diff -u ${PACKAGE_NAME}/bin/kafka-run-class.sh ${PACKAGE_NAME}-new/bin/kafka-run-class.sh > kafka-run-class.sh.patch


# patch config
# /etc/kafka/
# replace config
# /etc/kafka/server.properties
# replace server.properties with datadir log.dirs=/tmp/kraft-combined-logs -> log.dirs=/var/lib/kafka/kraft-combined-logs
sed -i "s:^log.dirs=.*:log.dirs=/var/lib/kafka/kraft-combined-logs:" ${PACKAGE_NAME}-new/config/server.properties
# /etc/kafka/controller.properties
# replace controller.properties with datadir log.dirs=/tmp/kraft-controller-logs -> log.dirs=/var/lib/kafka/kraft-controller-logs
sed -i "s:^log.dirs=.*:log.dirs=/var/lib/kafka/kraft-controller-logs:" ${PACKAGE_NAME}-new/config/controller.properties
# /etc/kafka/broker.properties
# replace broker.properties with datadir log.dirs=/tmp/kraft-broker-logs -> log.dirs=/var/lib/kafka/kraft-broker-logs
sed -i "s:^log.dirs=.*:log.dirs=/var/lib/kafka/kraft-broker-logs:" ${PACKAGE_NAME}-new/config/broker.properties
# /etc/kafka/connect-standalone.properties
# replace connect-standalone.properties with datadir offset.storage.file.filename=/tmp/connect.offsets -> offset.storage.file.filename=/var/lib/kafka/connect.offsets
sed -i "s:^offset.storage.file.filename=.*:offset.storage.file.filename=/var/lib/kafka/connect.offsets:" ${PACKAGE_NAME}-new/config/connect-standalone.properties

# Generate patch file
echo "generate kafka-config-properties.patch"
diff -ur ${PACKAGE_NAME}/config/ ${PACKAGE_NAME}-new/config/ > kafka-config-properties.patch

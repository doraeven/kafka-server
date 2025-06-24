#!/bin/bash

# def
KAFKA_VERSION=3.7.2
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


# Patch config
# /etc/kafka/
echo "patch /etc/kafka/"
# replace config
# /etc/kafka/server.properties
# replace server.properties with datadir log.dirs=/tmp/kafka-logs -> log.dirs=/var/lib/kafka/kafka-logs
sed -i "s:^log.dirs=.*:log.dirs=/var/lib/kafka/kafka-logs:" ${PACKAGE_NAME}-new/config/server.properties
# /etc/kafka/zookeeper.properties
# replace zookeeper.properties with datadir dataDir=/tmp/zookeeper -> dataDir=/var/lib/zookeeper/
sed -i "s:^dataDir=.*:dataDir=/var/lib/zookeeper/:" ${PACKAGE_NAME}-new/config/zookeeper.properties
# /etc/kafka/connect-standalone.properties
# replace connect-standalone.properties with datadir offset.storage.file.filename=/tmp/connect.offsets -> offset.storage.file.filename=/var/lib/kafka/connect.offsets
sed -i "s:^offset.storage.file.filename=.*:offset.storage.file.filename=/var/lib/kafka/connect.offsets:" ${PACKAGE_NAME}-new/config/connect-standalone.properties
# /etc/kafka/kraft/
# /etc/kafka/kraft/server.properties
# replace kraft/server.properties with datadir log.dirs=/tmp/kraft-combined-logs -> log.dirs=/var/lib/kraft/kraft-combined-logs
sed -i "s:^log.dirs=.*:log.dirs=/var/lib/kraft/kraft-combined-logs:" ${PACKAGE_NAME}-new/config/kraft/server.properties
# /etc/kafka/kraft/controller.properties
# replace kraft/controller.properties with datadir log.dirs=/tmp/kraft-controller-logs -> log.dirs=/var/lib/kraft/kraft-controller-logs
sed -i "s:^log.dirs=.*:log.dirs=/var/lib/kraft/kraft-controller-logs:" ${PACKAGE_NAME}-new/config/kraft/controller.properties
# /etc/kafka/kraft/broker.properties
# replace kraft/broker.properties with datadir log.dirs=/tmp/kraft-broker-logs -> log.dirs=/var/lib/kraft/kraft-broker-logs
sed -i "s:^log.dirs=.*:log.dirs=/var/lib/kraft/kraft-broker-logs:" ${PACKAGE_NAME}-new/config/kraft/broker.properties

# Generate patch file
echo "generate kafka-config.patch"
diff -ur ${PACKAGE_NAME}/config/ ${PACKAGE_NAME}-new/config/ > kafka-config.patch


# Patch bin
# /usr/bin/kafka/
echo "patch /usr/bin/kafka/"
# replace bin
# /usr/bin/kafka/connect-distributed.sh
# replace connect-distributed.sh with config $base_dir/../config/connect-log4j.properties -> /etc/kafka/connect-log4j.properties
sed -i "s:-Dlog4j.configuration=file\:\$base_dir/../config/connect-log4j.properties:-Dlog4j.configuration=file\:/etc/kafka/connect-log4j.properties:" ${PACKAGE_NAME}-new/bin/connect-distributed.sh
# /usr/bin/kafka/connect-mirror-maker.sh
# replace connect-mirror-maker.sh with config $base_dir/../config/connect-log4j.properties -> /etc/kafka/connect-log4j.properties
sed -i "s:-Dlog4j.configuration=file\:\$base_dir/../config/connect-log4j.properties:-Dlog4j.configuration=file\:/etc/kafka/connect-log4j.properties:" ${PACKAGE_NAME}-new/bin/connect-mirror-maker.sh
# /usr/bin/kafka/connect-standalone.sh
# replace connect-standalone.sh with config $base_dir/../config/connect-log4j.properties -> /etc/kafka/connect-log4j.properties
sed -i "s:-Dlog4j.configuration=file\:\$base_dir/../config/connect-log4j.properties:-Dlog4j.configuration=file\:/etc/kafka/connect-log4j.properties:" ${PACKAGE_NAME}-new/bin/connect-standalone.sh
# /usr/bin/kafka/kafka-run-class.sh
# replace kafka-run-class.sh with config $base_dir/config/tools-log4j.properties -> /etc/kafka/tools-log4j.properties
sed -i "s:\$base_dir/config/tools-log4j.properties:/etc/kafka/tools-log4j.properties:" ${PACKAGE_NAME}-new/bin/kafka-run-class.sh
# /usr/bin/kafka/kafka-run-class.sh, env
# ```
# # Patch for linux ENV
# if [ -d "/usr/lib64/kafka/" ] && [ -z "$CLASSPATH" ]; then
#   CLASSPATH=".:/usr/lib64/kafka/*"
# fi
# ```
# Patch for linux ENV
PATCH_CODE='\
\
# Patch for linux ENV\
if [ -d "/usr/lib64/kafka/" ] \&\& [ -z "$CLASSPATH" ]; then\
  CLASSPATH=".\:/usr/lib64/kafka/*"\
fi\
'
sed -i 's:^shopt -u nullglob:&'"${PATCH_CODE}"':' ${PACKAGE_NAME}-new/bin/kafka-run-class.sh
# /usr/bin/kafka/kafka-server-start.sh
# replace kafka-server-start.sh with config $base_dir/../config/log4j.properties -> /etc/kafka/log4j.properties
sed -i "s:-Dlog4j.configuration=file\:\$base_dir/../config/log4j.properties:-Dlog4j.configuration=file\:/etc/kafka/log4j.properties:" ${PACKAGE_NAME}-new/bin/kafka-server-start.sh
# /usr/bin/kafka/zookeeper-server-start.sh
# replace zookeeper-server-start.sh with config $base_dir/../config/log4j.properties -> /etc/kafka/log4j.properties
sed -i "s:-Dlog4j.configuration=file\:\$base_dir/../config/log4j.properties:-Dlog4j.configuration=file\:/etc/kafka/log4j.properties:" ${PACKAGE_NAME}-new/bin/zookeeper-server-start.sh

# Generate patch file
echo "generate kafka-bin.patch"
diff -ur ${PACKAGE_NAME}/bin/ ${PACKAGE_NAME}-new/bin/ > kafka-bin.patch

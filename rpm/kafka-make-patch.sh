#!/bin/bash

# def
KAFKA_VERSION=2.13-3.7.1
PACKAGE_NAME=kafka_$KAFKA_VERSION

# tar and cp new
echo "tar sources and cp new sources"
cd ~/rpmbuild/SOURCES/
rm -rf $PACKAGE_NAME/
rm -rf $PACKAGE_NAME-new/
tar -zxvf $PACKAGE_NAME.tgz
cp -rf $PACKAGE_NAME/ $PACKAGE_NAME-new/

# patch /bin/kafka-run-class.sh
# ```
# # Patch for linux ENV
# if [ -d "/usr/lib64/kafka/" ] && [ -z "$CLASSPATH" ]; then
#   CLASSPATH=".:/usr/lib64/kafka/*"
#   LOG4J_DIR="/etc/kafka/tools-log4j.properties"
#   KAFKA_LOG4J_OPTS="-Dlog4j.configuration=file:${LOG4J_DIR}"
# fi
# ```
# Patch for linux ENV
echo "patch /bin/kafka-run-class.sh"
PATCH_CODE='\
\
# Patch for linux ENV\
if [ -d "/usr/lib64/kafka/" ] \&\& [ -z "$CLASSPATH" ]; then\
  CLASSPATH=".\:/usr/lib64/kafka/*"\
  LOG4J_DIR="/etc/kafka/tools-log4j.properties"\
  KAFKA_LOG4J_OPTS="-Dlog4j.configuration=file\:${LOG4J_DIR}"\
fi\
'
sed -i 's:^shopt -u nullglob:&'"$PATCH_CODE"':' $PACKAGE_NAME-new/bin/kafka-run-class.sh

# Generate patch file
echo "generate kafka-run-class.sh.patch"
diff -u $PACKAGE_NAME/bin/kafka-run-class.sh $PACKAGE_NAME-new/bin/kafka-run-class.sh > kafka-run-class.sh.patch

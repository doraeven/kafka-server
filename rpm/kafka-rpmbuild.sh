#!/bin/bash

# prepare
# yum install rpm-build -y
# yum install rpmdevtools -y

# build on current directory
# rpmbuild -ba SPECS/kafka.spec --define="_topdir `pwd`"

# def
TOPDIR=~/rpmbuild

# make TOPDIR
mkdir -p $TOPDIR

# copy SPECS to TOPDIR
cp -rf SPECS $TOPDIR
# copy SOURCES to TOPDIR
cp -rf SOURCES $TOPDIR

# build
spectool -g -R $TOPDIR/SPECS/kafka.spec
rpmbuild -ba $TOPDIR/SPECS/kafka.spec

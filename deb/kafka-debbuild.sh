#!/bin/bash
set -x

# prepare dpkg core
# install deb build tools
# sudo apt install dpkg-dev -y
# sudo apt install debhelper -y
# sudo apt install dh-make -y
# sudo apt install dh-exec -y

# prepare debuild tools
# sudo apt install devscripts -y
# sudo apt install debmake -y
# sudo apt install build-essential -y
# sudo apt install equivs -y


# prepare from source by dh_make
# dh_make --single --copyright apache --email <your email> --file kafka-{version}.tar.gz
# dh_make -s -c apache -e <your email> -f kafka-{version}.tar.gz

# prepare from source by dmake
# dmake


# def
NAME=kafka
VERSION=3.7.2
SCALA_VERSION=2.13
EPOCH=1

# def kafka
_kafka_user=${NAME}
_kafka_group=${NAME}
_zookeeper_name=zookeeper
_zookeeper_user=${_zookeeper_name}
_zookeeper_group=${_zookeeper_name}
_kraft_name=kraft
_kraft_user=${_kraft_name}
_kraft_group=${_kraft_name}


# macros for DEB build
_topdir=~/debbuild
_builddir=${_topdir}/BUILD
_sourcedir=${_topdir}/SOURCES
_debiandir=${_topdir}/DEBIAN
_buildrootdir=${_topdir}/BUILDROOT
BUILDROOT=${_buildrootdir}/${NAME}-${VERSION}

# macros for paths set and used
_sysconfdir=/etc
_prefix=/usr
_lib=lib64
_exec_prefix=${_prefix}
_includedir=${_prefix}/include
_bindir=${_exec_prefix}/bin
_libdir=${_exec_prefix}/${_lib}
_libexecdir=${_exec_prefix}/libexec
_datarootdir=${_prefix}/share
_datadir=${_datarootdir}
_infodir=${_datarootdir}/info
_mandir=${_datarootdir}/man
_docdir=${_datadir}/doc
_rundir=/run
_localstatedir=/var
_sharedstatedir=/var/lib
_tmpfilesdir=${_prefix}/lib/tmpfiles.d
_sysusersdir=${_prefix}/lib/sysusers.d
_unitdir=${_prefix}/lib/systemd/system

# some seldomly used macros
_var=/var
_sbindir=${_bindir}
_tmppath=${_var}/tmp
_usr=/usr
_usrsrc=${_usr}/src
_initddir=${_sysconfdir}/rc.d/init.d
_initrddir=${_initddir}

# def SOURCES
SOURCE0=https://downloads.apache.org/${NAME}/${VERSION}/${NAME}_${SCALA_VERSION}-${VERSION}.tgz
SOURCE1=${NAME}.service
SOURCE2=${NAME}.xml
SOURCE3=${NAME}.sysconfig
SOURCE4=${NAME}.logrotate.d
SOURCE5=${NAME}.tmpfiles.d
SOURCE6=${NAME}.sysusers.d
SOURCE7=${NAME}-${_zookeeper_name}.service
SOURCE8=${NAME}-${_zookeeper_name}.xml
SOURCE9=${NAME}-${_zookeeper_name}.sysconfig
SOURCE10=${NAME}-${_zookeeper_name}.logrotate.d
SOURCE11=${NAME}-${_zookeeper_name}.tmpfiles.d
SOURCE12=${NAME}-${_zookeeper_name}.sysusers.d
SOURCE13=${NAME}-${_kraft_name}.service
SOURCE14=${NAME}-${_kraft_name}.xml
SOURCE15=${NAME}-${_kraft_name}.sysconfig
SOURCE16=${NAME}-${_kraft_name}.logrotate.d
SOURCE17=${NAME}-${_kraft_name}.tmpfiles.d
SOURCE18=${NAME}-${_kraft_name}.sysusers.d
SOURCE19=${NAME}-${_kraft_name}-prepare-log-dirs.sh
PATCH0=${NAME}-run-class.sh.patch
PATCH1=${NAME}-config-properties.patch

# dirname
dirname=$(cd `dirname $0`; pwd)
# get SOURCE0 file name
TARBALL=${SOURCE0##*/}

# prep
echo "%prep debbuild"
# make debbuild dir
mkdir -p ${_topdir}
mkdir -p ${_builddir}
mkdir -p ${_sourcedir}
mkdir -p ${_debiandir}
mkdir -p ${_buildrootdir}

# copy DEBIAN to _topdir
cp -rfa DEBIAN ${_topdir}
# copy SOURCES to _topdir
cp -rf SOURCES ${_topdir}

# cd _sourcedir
cd ${_sourcedir}

# download source file
if [ ! -f "${TARBALL}" ]; then
    wget ${SOURCE0} || exit 1
else
    echo "${TARBALL} is downloaded"
fi

# tar source file
tar -xzvf ${TARBALL} -C ${_builddir}


# build
echo "%build debbuild"
# use binary package not need to build

# create package
mkdir -p ${BUILDROOT}


# install
echo "%install debbuild"
# SOURCES/kafka_${SCALA_VERSION}-${VERSION}.tgz -> _buildrootdir/kafka-{VERSION}.tar.gz
cp -rf ${_sourcedir}/${TARBALL} ${_buildrootdir}/${NAME}-${VERSION}.tar.gz

# BUILD/kafka_${SCALA_VERSION}-${VERSION}/* -> _buildrootdir/kafka-{VERSION}/
cp -rf ${_builddir}/${NAME}_${SCALA_VERSION}-${VERSION}/* ${BUILDROOT}/

# DEBIAN/* -> BUILDROOT/kafka-{VERSION}/debian/
mkdir -p ${BUILDROOT}/debian/
cp -rfa ${_debiandir}/* ${BUILDROOT}/debian/
chmod +x ${BUILDROOT}/debian/kafka.install

# SOURCES/* -> BUILDROOT/kafka-{VERSION}/debian/SOURCES/
mkdir -p ${BUILDROOT}/debian/SOURCES/
cp -rf ${_sourcedir}/${SOURCE1} ${BUILDROOT}/debian/SOURCES/
cp -rf ${_sourcedir}/${SOURCE2} ${BUILDROOT}/debian/SOURCES/
cp -rf ${_sourcedir}/${SOURCE3} ${BUILDROOT}/debian/SOURCES/
cp -rf ${_sourcedir}/${SOURCE4} ${BUILDROOT}/debian/SOURCES/
cp -rf ${_sourcedir}/${SOURCE5} ${BUILDROOT}/debian/SOURCES/
cp -rf ${_sourcedir}/${SOURCE6} ${BUILDROOT}/debian/SOURCES/
cp -rf ${_sourcedir}/${SOURCE7} ${BUILDROOT}/debian/SOURCES/
cp -rf ${_sourcedir}/${SOURCE8} ${BUILDROOT}/debian/SOURCES/
cp -rf ${_sourcedir}/${SOURCE9} ${BUILDROOT}/debian/SOURCES/
cp -rf ${_sourcedir}/${SOURCE10} ${BUILDROOT}/debian/SOURCES/
cp -rf ${_sourcedir}/${SOURCE11} ${BUILDROOT}/debian/SOURCES/
cp -rf ${_sourcedir}/${SOURCE12} ${BUILDROOT}/debian/SOURCES/
cp -rf ${_sourcedir}/${SOURCE13} ${BUILDROOT}/debian/SOURCES/
cp -rf ${_sourcedir}/${SOURCE14} ${BUILDROOT}/debian/SOURCES/
cp -rf ${_sourcedir}/${SOURCE15} ${BUILDROOT}/debian/SOURCES/
cp -rf ${_sourcedir}/${SOURCE16} ${BUILDROOT}/debian/SOURCES/
cp -rf ${_sourcedir}/${SOURCE17} ${BUILDROOT}/debian/SOURCES/
cp -rf ${_sourcedir}/${SOURCE18} ${BUILDROOT}/debian/SOURCES/
cp -rf ${_sourcedir}/${SOURCE19} ${BUILDROOT}/debian/SOURCES/

# SOURCES/*.patch -> BUILDROOT/kafka-{VERSION}/debian/patches/
cp -rf ${_sourcedir}/${PATCH0} ${BUILDROOT}/debian/patches/
cp -rf ${_sourcedir}/${PATCH1} ${BUILDROOT}/debian/patches/
echo "${PATCH0}" >> ${BUILDROOT}/debian/patches/series
echo "${PATCH1}" >> ${BUILDROOT}/debian/patches/series


# files
echo "%files debbuild"
# build
cd ${BUILDROOT}
debmake
debuild


# clean
echo "%clean debbuild"
rm -rf ${BUILDROOT}


# changelog
# * Wed Jan 01 2025 Dora Even <doraeven@163.com> - 3.7.2-1
# - Upgrade 3.7.1 to 3.7.2

# * Sat Jul 27 2024 Dora Even <doraeven@163.com> - 3.7.1-1
# - Add kraft User and Group for fixed sysusers.d conflict

# * Mon Jul 08 2024 Dora Even <doraeven@163.com> - 3.7.1-1
# - Add kafka-run-class.sh.patch for Linux ENV patch

# * Mon Jul 01 2024 Dora Even <doraeven@163.com> - 3.7.1-1
# - Build kafka package

# * Sat Jun 29 2024 Dora Even <doraeven@163.com>
# - Create kafka package project

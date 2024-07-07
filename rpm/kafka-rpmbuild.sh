#!/bin/bash

# current directory
# rpmbuild -ba SPECS/kafka.spec --define="_topdir `pwd`"

# /root/rpmbuild/
spectool -g -R SPECS/kafka.spec
rpmbuild -ba SPECS/kafka.spec

#!/bin/bash

# current directory
# rpmbuild -ba SPECS/kafka.spec --define="_topdir `pwd`"

# ~/rpmbuild/
spectool -g -R ~/rpmbuild/SPECS/kafka.spec
rpmbuild -ba ~/rpmbuild/SPECS/kafka.spec

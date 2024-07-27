# To avoid removing symbolic links and repacking jar files, set the parameters as follows.
%define debug_package %{nil}
%define __jar_repack 0
%define _scala_version 2.13
%define _kafka_user %{name}
%define _kafka_group %{name}
%define _zookeeper_name zookeeper
%define _zookeeper_user %{_zookeeper_name}
%define _zookeeper_group %{_zookeeper_name}
%define _kraft_name kraft
%define _kraft_user %{_kraft_name}
%define _kraft_group %{_kraft_name}

Name:           kafka
Version:        3.7.1
Release:        1%{?dist}
Summary:        Apache Kafka is an open-source distributed event streaming platform used by thousands of companies for high-performance data pipelines, streaming analytics, data integration, and mission-critical applications.

Epoch:          1

License:        Apache License v2
URL:            https://kafka.apache.org/
Source0:        https://downloads.apache.org/%{name}/%{version}/%{name}_%{_scala_version}-%{version}.tgz
Source1:        %{name}.service
Source2:        %{name}.xml
Source3:        %{name}.sysconfig
Source4:        %{name}.logrotate.d
Source5:        %{name}.tmpfiles.d
Source6:        %{name}.sysusers.d
Source7:        %{name}-%{_zookeeper_name}.service
Source8:        %{name}-%{_zookeeper_name}.xml
Source9:        %{name}-%{_zookeeper_name}.sysconfig
Source10:       %{name}-%{_zookeeper_name}.logrotate.d
Source11:       %{name}-%{_zookeeper_name}.tmpfiles.d
Source12:       %{name}-%{_zookeeper_name}.sysusers.d
Source13:       %{name}-%{_kraft_name}.service
Source14:       %{name}-%{_kraft_name}.xml
Source15:       %{name}-%{_kraft_name}.sysconfig
Source16:       %{name}-%{_kraft_name}.logrotate.d
Source17:       %{name}-%{_kraft_name}.tmpfiles.d
Source18:       %{name}-%{_kraft_name}.sysusers.d
Source19:       %{name}-%{_kraft_name}-prepare-log-dirs.sh
Patch0:         %{name}-run-class.sh.patch

Provides:       kafka
Packager:       Dora Even <doraeven@163.com>

BuildRequires:  java-21-openjdk
Requires:       systemd
# For now, the OpenJDK 11 packages in RHEL 7 and 8 don¡¯t provide java-headless, jre-headless, or any of the unversioned Java packages.
# Requires:       java >= 1.8.0

Requires(pre):     /usr/sbin/groupadd
Requires(pre):     /usr/sbin/useradd
Requires(postun):  /usr/sbin/userdel

%description
Kafka is a distributed system consisting of servers and clients that communicate via a high-performance TCP network protocol. It can be deployed on bare-metal hardware, virtual machines, and containers in on-premise as well as cloud environments.
Servers: Kafka is run as a cluster of one or more servers that can span multiple datacenters or cloud regions. Some of these servers form the storage layer, called the brokers. Other servers run Kafka Connect to continuously import and export data as event streams to integrate Kafka with your existing systems such as relational databases as well as other Kafka clusters. To let you implement mission-critical use cases, a Kafka cluster is highly scalable and fault-tolerant: if any of its servers fails, the other servers will take over their work to ensure continuous operations without any data loss.
Clients: They allow you to write distributed applications and microservices that read, write, and process streams of events in parallel, at scale, and in a fault-tolerant manner even in the case of network problems or machine failures. Kafka ships with some such clients included, which are augmented by dozens of clients provided by the Kafka community: clients are available for Java and Scala including the higher-level Kafka Streams library, for Go, Python, C/C++, and many other programming languages as well as REST APIs.

# kafka-server
https://github.com/doraeven/kafka-server
https://kafka.apache.org/documentation/#introduction


%prep
%setup -q -n %{name}_%{_scala_version}-%{version}
%patch0 -p1


%build
# use binary package not need to build


%install
# bin
# /usr/bin/kafka/
install -d -m 0755 %{buildroot}%{_bindir}/%{name}/
install -p -m 0755 %{_builddir}/%{name}_%{_scala_version}-%{version}/bin/*.sh %{buildroot}%{_bindir}/%{name}/

# config
# /etc/kafka/
install -d -m 0755 %{buildroot}%{_sysconfdir}/%{name}/
install -p -m 0644 %{_builddir}/%{name}_%{_scala_version}-%{version}/config/*.properties %{buildroot}%{_sysconfdir}/%{name}/
install -p -m 0644 %{_builddir}/%{name}_%{_scala_version}-%{version}/config/*.conf %{buildroot}%{_sysconfdir}/%{name}/
# replace server.properties with datadir log.dirs=/tmp/kafka-logs -> log.dirs=/var/lib/kafka/
sed -i "s:^log.dirs=.*:log.dirs=%{_sharedstatedir}/%{name}/:" %{buildroot}%{_sysconfdir}/%{name}/server.properties
# replace zookeeper.properties with datadir dataDir=/tmp/zookeeper -> dataDir=/var/lib/zookeeper/
sed -i "s:^dataDir=.*:dataDir=%{_sharedstatedir}/%{_zookeeper_name}/:" %{buildroot}%{_sysconfdir}/%{name}/zookeeper.properties
# /etc/kafka/kraft/
install -d -m 0755 %{buildroot}%{_sysconfdir}/%{name}/kraft/
install -p -m 0644 %{_builddir}/%{name}_%{_scala_version}-%{version}/config/kraft/*.properties %{buildroot}%{_sysconfdir}/%{name}/kraft/
# replace kraft/server.properties with datadir log.dirs=/tmp/kraft-combined-logs -> log.dirs=/var/lib/kraft/
sed -i "s:^log.dirs=.*:log.dirs=%{_sharedstatedir}/%{_kraft_name}/:" %{buildroot}%{_sysconfdir}/%{name}/%{_kraft_name}/server.properties
# /etc/sysconfig/
install -d -m 0755 %{buildroot}%{_sysconfdir}/sysconfig/
install -p -m 0644 %{SOURCE3} %{buildroot}%{_sysconfdir}/sysconfig/%{name}
install -p -m 0644 %{SOURCE9} %{buildroot}%{_sysconfdir}/sysconfig/%{name}-%{_zookeeper_name}
install -p -m 0644 %{SOURCE15} %{buildroot}%{_sysconfdir}/sysconfig/%{name}-%{_kraft_name}
# /etc/logrotate.d/
install -d -m 0755 %{buildroot}%{_sysconfdir}/logrotate.d/
install -p -m 0644 %{SOURCE4} %{buildroot}%{_sysconfdir}/logrotate.d/%{name}
install -p -m 0644 %{SOURCE10} %{buildroot}%{_sysconfdir}/logrotate.d/%{name}-%{_zookeeper_name}
install -p -m 0644 %{SOURCE16} %{buildroot}%{_sysconfdir}/logrotate.d/%{name}-%{_kraft_name}
# /usr/lib/tmpfiles.d/
install -d -m 0755 %{buildroot}%{_tmpfilesdir}/
install -p -m 0644 %{SOURCE5} %{buildroot}%{_tmpfilesdir}/%{name}.conf
install -p -m 0644 %{SOURCE11} %{buildroot}%{_tmpfilesdir}/%{name}-%{_zookeeper_name}.conf
install -p -m 0644 %{SOURCE17} %{buildroot}%{_tmpfilesdir}/%{name}-%{_kraft_name}.conf
# /usr/lib/sysusers.d/
install -d -m 0755 %{buildroot}%{_sysusersdir}/
install -p -m 0644 %{SOURCE6} %{buildroot}%{_sysusersdir}/%{name}.conf
install -p -m 0644 %{SOURCE12} %{buildroot}%{_sysusersdir}/%{name}-%{_zookeeper_name}.conf
install -p -m 0644 %{SOURCE18} %{buildroot}%{_sysusersdir}/%{name}-%{_kraft_name}.conf

# libs
# /usr/lib64/kafka-{version}/
install -d -m 0755 %{buildroot}%{_libdir}/%{name}_%{_scala_version}-%{version}/
install -p -m 0644 %{_builddir}/%{name}_%{_scala_version}-%{version}/libs/* %{buildroot}%{_libdir}/%{name}_%{_scala_version}-%{version}/
# symlink
# /usr/lib64/kafka/ -> /usr/lib64/kafka-{version}/
ln -s %{name}_%{_scala_version}-%{version}/ %{buildroot}%{_libdir}/%{name}

# libexec
# /usr/libexec/
install -d -m 0755 %{buildroot}%{_libexecdir}/
install -p -m 0755 %{SOURCE19} %{buildroot}%{_libexecdir}/%{name}-%{_kraft_name}-prepare-log-dirs

# log
# /var/log/kafka/
install -d -m 0755 %{buildroot}%{_var}/log/%{name}/
# /var/log/zookeeper/
install -d -m 0755 %{buildroot}%{_var}/log/%{_zookeeper_name}/
# /var/log/kraft/
install -d -m 0755 %{buildroot}%{_var}/log/%{_kraft_name}/

# data
# /var/lib/kafka/
install -d -m 0755 %{buildroot}%{_sharedstatedir}/%{name}/
# /var/lib/zookeeper/
install -d -m 0755 %{buildroot}%{_sharedstatedir}/%{_zookeeper_name}/
# /var/lib/kraft/
install -d -m 0755 %{buildroot}%{_sharedstatedir}/%{_kraft_name}/

# run
# /run/kafka/
install -d -m 0755 %{buildroot}%{_rundir}/%{name}/
# /run/zookeeper/
install -d -m 0755 %{buildroot}%{_rundir}/%{_zookeeper_name}/
# /run/kraft/
install -d -m 0755 %{buildroot}%{_rundir}/%{_kraft_name}/


# systemd
# /usr/lib/systemd/system/
install -d -m 0755 %{buildroot}%{_unitdir}/
install -p -m 0644 %{SOURCE1} %{buildroot}%{_unitdir}/%{name}.service
install -p -m 0644 %{SOURCE7} %{buildroot}%{_unitdir}/%{name}-%{_zookeeper_name}.service
install -p -m 0644 %{SOURCE13} %{buildroot}%{_unitdir}/%{name}-%{_kraft_name}.service

# firewalld
# /usr/lib/firewalld/services/
install -d -m 0755 %{buildroot}%{_prefix}/lib/firewalld/services/
install -p -m 0644 %{SOURCE2} %{buildroot}%{_prefix}/lib/firewalld/services/%{name}.xml
install -p -m 0644 %{SOURCE8} %{buildroot}%{_prefix}/lib/firewalld/services/%{name}-%{_zookeeper_name}.xml
install -p -m 0644 %{SOURCE14} %{buildroot}%{_prefix}/lib/firewalld/services/%{name}-%{_kraft_name}.xml


%files
# bin
%{_bindir}/%{name}/

# config
%config(noreplace) %{_sysconfdir}/%{name}/
%config(noreplace) %{_sysconfdir}/sysconfig/%{name}
%config(noreplace) %{_sysconfdir}/sysconfig/%{name}-%{_zookeeper_name}
%config(noreplace) %{_sysconfdir}/sysconfig/%{name}-%{_kraft_name}
%config(noreplace) %{_sysconfdir}/logrotate.d/%{name}
%config(noreplace) %{_sysconfdir}/logrotate.d/%{name}-%{_zookeeper_name}
%config(noreplace) %{_sysconfdir}/logrotate.d/%{name}-%{_kraft_name}
%config %{_tmpfilesdir}/%{name}.conf
%config %{_tmpfilesdir}/%{name}-%{_zookeeper_name}.conf
%config %{_tmpfilesdir}/%{name}-%{_kraft_name}.conf
%config %{_sysusersdir}/%{name}.conf
%config %{_sysusersdir}/%{name}-%{_zookeeper_name}.conf
%config %{_sysusersdir}/%{name}-%{_kraft_name}.conf

# libs
%{_libdir}/%{name}_%{_scala_version}-%{version}/
# symlink
%{_libdir}/%{name}

# libexec
%{_libexecdir}/%{name}-%{_kraft_name}-prepare-log-dirs

# log
%attr(0755,%{_kafka_user},%{_kafka_group}) %dir %{_var}/log/%{name}/
%attr(0755,%{_zookeeper_user},%{_zookeeper_group}) %dir %{_var}/log/%{_zookeeper_name}/
%attr(0755,%{_kraft_user},%{_kraft_group}) %dir %{_var}/log/%{_kraft_name}/

# data
%attr(0755,%{_kafka_user},%{_kafka_group}) %dir %{_sharedstatedir}/%{name}/
%attr(0755,%{_zookeeper_user},%{_zookeeper_group}) %dir %{_sharedstatedir}/%{_zookeeper_name}/
%attr(0755,%{_kraft_user},%{_kraft_group}) %dir %{_sharedstatedir}/%{_kraft_name}/

# run
%attr(0755,%{_kafka_user},%{_kafka_group}) %dir %{_rundir}/%{name}/
%attr(0755,%{_zookeeper_user},%{_zookeeper_group}) %dir %{_rundir}/%{_zookeeper_name}/
%attr(0755,%{_kraft_user},%{_kraft_group}) %dir %{_rundir}/%{_kraft_name}/

# systemd
%{_unitdir}/%{name}.service
%{_unitdir}/%{name}-%{_zookeeper_name}.service
%{_unitdir}/%{name}-%{_kraft_name}.service

# firewalld
%{_prefix}/lib/firewalld/services/%{name}.xml
%{_prefix}/lib/firewalld/services/%{name}-%{_zookeeper_name}.xml
%{_prefix}/lib/firewalld/services/%{name}-%{_kraft_name}.xml


%license LICENSE
%license licenses/


%doc NOTICE
%doc site-docs/
%doc config/


%pre
/usr/sbin/groupadd -r %{_kafka_group} >/dev/null 2>&1 || :
/usr/sbin/useradd -r -g %{_kafka_group} -d %{_sharedstatedir}/%{name}/ -s /sbin/nologin -c "Kafka Server" %{_kafka_user} >/dev/null 2>&1 || :
/usr/sbin/groupadd -r %{_zookeeper_group} >/dev/null 2>&1 || :
/usr/sbin/useradd -r -g %{_zookeeper_group} -d %{_sharedstatedir}/%{_zookeeper_name}/ -s /sbin/nologin -c "Zookeeper Server" %{_zookeeper_user} >/dev/null 2>&1 || :
/usr/sbin/groupadd -r %{_kraft_group} >/dev/null 2>&1 || :
/usr/sbin/useradd -r -g %{_kraft_group} -d %{_sharedstatedir}/%{_kraft_name}/ -s /sbin/nologin -c "Kafka KRaft Server" %{_kraft_user} >/dev/null 2>&1 || :


%post
%systemd_post %{name}-%{_zookeeper_name}.service
%systemd_post %{name}.service


%preun
%systemd_preun %{name}.service
%systemd_preun %{name}-%{_zookeeper_name}.service
%systemd_preun %{name}-%{_kraft_name}.service


%postun
%systemd_postun_with_restart %{name}.service
%systemd_postun_with_restart %{name}-%{_zookeeper_name}.service
%systemd_postun_with_restart %{name}-%{_kraft_name}.service
/usr/sbin/userdel %{_kafka_user}
/usr/sbin/userdel %{_zookeeper_user}
/usr/sbin/userdel %{_kraft_user}


%clean
rm -rf %{buildroot}


%changelog
* Sat Jul 27 2024 Dora Even <doraeven@163.com> - 3.7.1-1
- Add kraft User and Group for fixed sysusers.d conflict

* Mon Jul 08 2024 Dora Even <doraeven@163.com> - 3.7.1-1
- Add kafka-run-class.sh.patch for Linux ENV patch

* Mon Jul 01 2024 Dora Even <doraeven@163.com> - 3.7.1-1
- Build kafka package

* Sat Jun 29 2024 Dora Even <doraeven@163.com>
- Create kafka package project

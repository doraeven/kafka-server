# To avoid removing symbolic links and repacking jar files, set the parameters as follows.
%define debug_package %{nil}
%define __jar_repack 0
%define _scala_version 2.13
%define _kafka_user %{name}
%define _kafka_group %{name}

Name:           kafka
Version:        4.0.0
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
Source19:       %{name}-prepare-log-dirs.sh
Patch0:         %{name}-bin.patch
Patch1:         %{name}-config.patch

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
%patch1 -p1


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
install -p -m 0644 %{_builddir}/%{name}_%{_scala_version}-%{version}/config/*.yaml %{buildroot}%{_sysconfdir}/%{name}/
# /etc/sysconfig/
install -d -m 0755 %{buildroot}%{_sysconfdir}/sysconfig/
install -p -m 0644 %{SOURCE3} %{buildroot}%{_sysconfdir}/sysconfig/%{name}
# /etc/logrotate.d/
install -d -m 0755 %{buildroot}%{_sysconfdir}/logrotate.d/
install -p -m 0644 %{SOURCE4} %{buildroot}%{_sysconfdir}/logrotate.d/%{name}
# /usr/lib/tmpfiles.d/
install -d -m 0755 %{buildroot}%{_tmpfilesdir}/
install -p -m 0644 %{SOURCE5} %{buildroot}%{_tmpfilesdir}/%{name}.conf
# /usr/lib/sysusers.d/
install -d -m 0755 %{buildroot}%{_sysusersdir}/
install -p -m 0644 %{SOURCE6} %{buildroot}%{_sysusersdir}/%{name}.conf

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
install -p -m 0755 %{SOURCE19} %{buildroot}%{_libexecdir}/%{name}-prepare-log-dirs

# log
# /var/log/kafka/
install -d -m 0755 %{buildroot}%{_var}/log/%{name}/

# data
# /var/lib/kafka/
install -d -m 0755 %{buildroot}%{_sharedstatedir}/%{name}/

# run
# /run/kafka/
install -d -m 0755 %{buildroot}%{_rundir}/%{name}/


# systemd
# /usr/lib/systemd/system/
install -d -m 0755 %{buildroot}%{_unitdir}/
install -p -m 0644 %{SOURCE1} %{buildroot}%{_unitdir}/%{name}.service

# firewalld
# /usr/lib/firewalld/services/
install -d -m 0755 %{buildroot}%{_prefix}/lib/firewalld/services/
install -p -m 0644 %{SOURCE2} %{buildroot}%{_prefix}/lib/firewalld/services/%{name}.xml


%files
# bin
%{_bindir}/%{name}/

# config
%config(noreplace) %{_sysconfdir}/%{name}/
%config(noreplace) %{_sysconfdir}/sysconfig/%{name}
%config(noreplace) %{_sysconfdir}/logrotate.d/%{name}
%config %{_tmpfilesdir}/%{name}.conf
%config %{_sysusersdir}/%{name}.conf

# libs
%{_libdir}/%{name}_%{_scala_version}-%{version}/
# symlink
%{_libdir}/%{name}

# libexec
%{_libexecdir}/%{name}-prepare-log-dirs

# log
%attr(0755,%{_kafka_user},%{_kafka_group}) %dir %{_var}/log/%{name}/

# data
%attr(0755,%{_kafka_user},%{_kafka_group}) %dir %{_sharedstatedir}/%{name}/

# run
%attr(0755,%{_kafka_user},%{_kafka_group}) %dir %{_rundir}/%{name}/

# systemd
%{_unitdir}/%{name}.service

# firewalld
%{_prefix}/lib/firewalld/services/%{name}.xml


%license LICENSE
%license licenses/


%doc NOTICE
%doc site-docs/
%doc config/


%pre
/usr/sbin/groupadd -r %{_kafka_group} >/dev/null 2>&1 || :
/usr/sbin/useradd -r -g %{_kafka_group} -d %{_sharedstatedir}/%{name}/ -s /sbin/nologin -c "Kafka Server" %{_kafka_user} >/dev/null 2>&1 || :


%post
%systemd_post %{name}.service


%preun
%systemd_preun %{name}.service


%postun
%systemd_postun_with_restart %{name}.service
/usr/sbin/userdel %{_kafka_user}


%clean
rm -rf %{buildroot}


%changelog
* Wed Jun 04 2025 Dora Even <doraeven@163.com> - 4.0.0-1
- Upgrade kafka package

* Sun Jun 01 2025 Dora Even <doraeven@163.com> - 3.9.1-1
- Upgrade kafka package

* Fri Nov 29 2024 Dora Even <doraeven@163.com> - 3.9.0-1
- Upgrade kafka package

* Thu Nov 28 2024 Dora Even <doraeven@163.com> - 3.8.1-1
- Upgrade kafka package

* Mon Aug 09 2024 Dora Even <doraeven@163.com> - 3.8.0-1
- Build kafka package

* Sat Aug 09 2024 Dora Even <doraeven@163.com>
- Create kafka package project

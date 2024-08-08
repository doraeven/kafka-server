# kafka-server
Build apache kafka server packages from official.

![Static Badge](https://img.shields.io/badge/build-passing-brightgreen)
![Static Badge](https://img.shields.io/badge/tag-3.8.0-blue)
![Static Badge](https://img.shields.io/badge/released-v20240809-blue)
![GitHub License](https://img.shields.io/github/license/doraeven/kafka-server)

## Introduction
### 3.8.0
- Released July 29, 2024
- [Release Notes](https://downloads.apache.org/kafka/3.8.0/RELEASE_NOTES.html)

### RPM for EL9 and EL8.
Support:
- Enterprise Linux 9 (RHEL 9, Rocky Linux 9, AlmaLinux 9, CentOS 9 Stream)
- Enterprise Linux 8 (RHEL 8, Rocky Linux 8, AlmaLinux 8)

### DEB for Debian and Ubuntu.
Support:
- Debian 12 (Bookworm)
- Debian 11 (Bullseye)
- Debian 10 (Buster)
- Ubuntu 24.04 LTS (Noble Numbat)
- Ubuntu 22.04 LTS (Jammy Jellyfish)
- Ubuntu 20.04 LTS (Focal Fossa)

## Usage
### Download Kafka
Download the package from releases

> [https://github.com/doraeven/kafka-server/releases](https://github.com/doraeven/kafka-server/releases)

### Install Kafka
#### install with RPM
RHEL, Rocky Linux, AlmaLinux, CentOS

Install jdk
```shell
yum install java-21-openjdk
```
EL9
```shell
rpm -ivh kafka-3.8.0-1.el9.x86_64.rpm
```
EL8
```shell
rpm -ivh kafka-3.8.0-1.el8.x86_64.rpm
```

#### install with DEB
Install jdk
```shell
apt install openjdk-21-jdk
```
Debian or Ubuntu
```shell
dpkg -i kafka_3.8.0-1_amd64.deb
```

### Run Kafka with Zookeeper
Start kafka-zookeeper.service
```shell
systemctl start kafka-zookeeper.service
```

Start kafka.service
```shell
systemctl start kafka.service
```

View service status
```shell
systemctl status kafka-zookeeper.service
systemctl status kafka.service
```

Add auto start
```shell
systemctl enable kafka-zookeeper.service
systemctl enable kafka.service
```

Stop service
```shell
systemctl stop kafka.service
systemctl stop kafka-zookeeper.service
```

Disable auto start
```shell
systemctl disable kafka-zookeeper.service
systemctl disable kafka.service
```

### Run Kafka with KRaft
Stop kafka and kafka-zookeeper service first
```shell
systemctl stop kafka.service
systemctl stop kafka-zookeeper.service
```

Start Kafka with KRaft
```shell
systemctl start kafka-kraft.service
```
_Your need not to init KRaft data dirs, `/usr/libexec/kafka-kraft-prepare-log-dirs` will do it automatically._

View service status
```shell
systemctl status kafka-kraft.service
```

Add auto start
```shell
systemctl enable kafka-kraft.service
```

Stop service
```shell
systemctl stop kafka-kraft.service
```

Disable auto start
```shell
systemctl disable kafka-kraft.service
```

### Uninstall Kafka
#### uninstall for RPM
RHEL, Rocky Linux, AlmaLinux, CentOS

EL9
```shell
rpm -e kafka-3.8.0-1.el9.x86_64
```
EL8
```shell
rpm -e kafka-3.8.0-1.el8.x86_64
```

#### uninstall for DEB
Debian or Ubuntu
```shell
dpkg -r kafka
dpkg --purge kafka
```

## Special
**Run Kafka with Zookeeper** conflict with **Run Kafka with KRaft**.

data dirs is:
- kafka - /var/lib/kafka
- zookeeper - /var/lib/zookeeper
- kraft - /var/lib/kraft

log dir is:
- kafka - /var/log/kafka
- zookeeper - /var/log/zookeeper
- kraft - /var/log/kraft

## License

The project is released under version 2.0 of the [Apache License](https://www.apache.org/licenses/LICENSE-2.0).

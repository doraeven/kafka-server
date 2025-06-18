# kafka-server
Build apache kafka server packages from official.

![Static Badge](https://img.shields.io/badge/build-passing-brightgreen)
![Static Badge](https://img.shields.io/badge/tag-4.0.0-blue)
![Static Badge](https://img.shields.io/badge/released-v20250610-blue)
![GitHub License](https://img.shields.io/github/license/doraeven/kafka-server)

## Introduction
### 4.0.0
- Released March 18, 2025
- [Release Notes](https://downloads.apache.org/kafka/4.0.0/RELEASE_NOTES.html)

### Upgrading to 4.0.0
Note: Apache Kafka 4.0 only supports KRaft mode - ZooKeeper mode has been removed. 
Link: [Upgrading Servers to 4.0.0 from any version 3.3.x through 3.9.x](https://kafka.apache.org/documentation.html#upgrade_4_0_0)

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
rpm -ivh kafka-4.0.0-1.el9.x86_64.rpm
```
EL8
```shell
rpm -ivh kafka-4.0.0-1.el8.x86_64.rpm
```

#### install with DEB
Install jdk
```shell
apt install openjdk-21-jdk
```
Debian or Ubuntu
```shell
dpkg -i kafka_4.0.0-1_amd64.deb
```

### Run Kafka (KRaft mode only)
Start Kafka
```shell
systemctl start kafka.service
```
_Your need not to init Kafka data dirs, `/usr/libexec/kafka-prepare-log-dirs` will do it automatically._

View service status
```shell
systemctl status kafka.service
```

Add auto start
```shell
systemctl enable kafka.service
```

Stop service
```shell
systemctl stop kafka.service
```

Disable auto start
```shell
systemctl disable kafka.service
```

### Uninstall Kafka
#### uninstall for RPM
RHEL, Rocky Linux, AlmaLinux, CentOS

EL9
```shell
rpm -e kafka-4.0.0-1.el9.x86_64
```
EL8
```shell
rpm -e kafka-4.0.0-1.el8.x86_64
```

#### uninstall for DEB
Debian or Ubuntu
```shell
dpkg -r kafka
dpkg --purge kafka
```

## Special
**Since 4.0.0, Run Kafka with KRaft mode only**.

data dirs is:
- kafka - /var/lib/kafka

log dir is:
- kafka - /var/log/kafka

## License

The project is released under version 2.0 of the [Apache License](https://www.apache.org/licenses/LICENSE-2.0).

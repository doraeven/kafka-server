# kafka-server
Build Apache Kafka server packages from official.

![Static Badge](https://img.shields.io/badge/build-passing-brightgreen)
![Static Badge](https://img.shields.io/badge/tag-3.7.1-blue)
![Static Badge](https://img.shields.io/badge/released-v20240730-blue)
![GitHub License](https://img.shields.io/github/license/doraeven/kafka-server)

## Introduction
#### 3.7.1
- Released Jun 28, 2024
- [Release Notes](https://downloads.apache.org/kafka/3.7.1/RELEASE_NOTES.html)

#### RPM for EL9 and EL8.
Support:
- Enterprise Linux 9 (RHEL 9, Rocky Linux 9, AlmaLinux 9, CentOS 9 Stream)
- Enterprise Linux 8 (RHEL 8, Rocky Linux 8, AlmaLinux 8)

#### DEB for DEBIAN and UBUNTU.
Support:
- Debian 12 (Bookworm)
- Debian 11 (Bullseye)
- Debian 10 (Buster)
- Ubuntu 24.04 LTS (Noble Numbat)
- Ubuntu 22.04 LTS (Jammy Jellyfish)
- Ubuntu 20.04 LTS (Focal Fossa)

## Usage
### Install Kafka
#### RPM
1. Download the rpm package from releases

> [https://github.com/doraeven/kafka-server/releases](https://github.com/doraeven/kafka-server/releases)

2. Install rpm
EL9
```shell
rpm -ivh kafka-3.7.1-1.el9.x86_64.rpm
```
EL8
```shell
rpm -ivh kafka-3.7.1-1.el8.x86_64.rpm
```

#### DEB
It on the way...


### Run Kafka with Zookeeper
1. Start kafka-zookeeper.service
```shell
systemctl start kafka-zookeeper.service
```

2. Start kafka.service
```shell
systemctl start kafka.service
```

3. View service status
```shell
systemctl status kafka-zookeeper.service
systemctl status kafka.service
```

4. Add auto start
```shell
systemctl enable kafka-zookeeper.service
systemctl enable kafka.service
```

5. Stop service
```shell
systemctl stop kafka.service
systemctl stop kafka-zookeeper.service
```

6. Disable auto start
```shell
systemctl disable kafka-zookeeper.service
systemctl disable kafka.service
```

### Run Kafka with KRaft
1. Stop kafka and kafka-zookeeper service first
```shell
systemctl stop kafka.service
systemctl stop kafka-zookeeper.service
```

2. Start Kafka with KRaft
```shell
systemctl start kafka-kraft.service
```

3. View service status
```shell
systemctl status kafka-kraft.service
```

4. Add auto start
```shell
systemctl enable kafka-kraft.service
```

5. Stop service
```shell
systemctl stop kafka-kraft.service
```

6. Disable auto start
```shell
systemctl disable kafka-kraft.service
```

## License

The project is released under version 2.0 of the [Apache License](https://www.apache.org/licenses/LICENSE-2.0).

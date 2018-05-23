---
title: Mesosphere Data Center Operation Systeam
date: 2016-11-29 23:10:25
categories:
- 工作日常
- 服务器集群架构
tags:
- Angularjs
permalink: Cwork
toc: 1
---

**原因**：2016年11月29日 星期二 架设`DCOS`（Data Center Operation Systeam）。
**说明**：本文主要记录DCOS架设过程中的问题与解决办法。
<!-- more -->

## 简介

---
### 百度百科
>数据中心操作系统（DCOS）是为整个数据中心提供分布式调度与资源协调功能，实现数据中心级弹性伸缩能力的软件堆栈，它将所有数据中心的资源当做一台计算机来调度和管理。

>数据中心操作系统（DCOS）是为整个数据中心提供分布式调度与协调功能，实现数据中心级弹性伸缩能力的软件堆栈，它将所有数据中心的资源当做一台计算机来调度。

>大规模应用的数据中心操作系统有：Google Borg/Omega系统和Twitter、Apple、Netflix等公司基于Mesos构建的系统。
可以用于数据中心操作系统构建的开源解决方案有：
- 1) Mesos：Mesos最早由美国加州大学伯克利分校AMPLab实验室开发，后在Twitter、Apple、Netflix等互联网企业广泛使用，成熟度高。其中，Mesosphere公司DCOS产品，就是以Mesos为核心，支持多领域的分布式集群调度框架，包括Docker容器集群调度框架Marathon、分布式 Cron（周期性执行任务）集群调度框架Chronos和大数据的主流平台Hadoop和Spark的集群调度框架等，实现系统的资源弹性调度。
- 2) Apache Hadoop YARN：Apache Hadoop YARN一种新的 Hadoop 资源管理器，它是一个通用资源管理系统，可为上层应用提供统一的资源管理和调度。
- 3) Kubernetes：Kubernetes是Google多年大规模容器管理技术的开源版本，面世以来就受到各大巨头及初创公司的青睐，社区活跃。
- 4) Docker Machine + Compose + Swarm：Docker公司的容器编排管理工具。
- 5) 此外，CloudFoundry/OpenShift等PaaS产品也可以作为DCOS的解决方案。

---

### 官网介绍及理解
>[DC/OS](https://dcos.io) is based on the production proven Apache Mesos distributed systems kernel, combining years of real-life experience with best practices for building and running modern applications in production.

>DCOS（数据中心操作系统）即是Mesos的“核心”与其周边的服务及功能组件所组成的一个生态系统。例如像mesos-dns这样的插件模块，类似一个CLI，一个GUI又或者是提供你想运行的所有的包的仓库等工具，以及像Marathon（又名分布式的init）、Chronos（又名分布式的cron）这样的框架等等。

>顾名思义，它即是意味着一个跨越在数据中心或者云环境所有主机之上的操作系统。DCOS 可以运行在任意的现代Linux环境，公有或私有云，虚拟机甚至是裸机环境。（当前所支持的平台有：亚马逊AWS、谷歌GCE、微软Azure、OpenStack、Vmware、RedHat、CentOS、CoreOS以及Ubuntu）。迄今为止，DCOS 在其公有仓库上已经提供了多达40余种服务组件（Hadoop、Spark、Cassandra、Jenkins、Kafka、MemSQL等等）。

---
## 环境搭建

### DC/OS Vagrant

Quickly provision a [DC/OS](https://github.com/dcos/dcos) cluster on a local machine for development, testing, or demonstration.

Deploying DC/OS Vagrant involves creating a local cluster of VirtualBox VMs using the [dcos-vagrant-box](https://github.com/dcos/dcos-vagrant-box) base image and then installing [DC/OS](https://dcos.io/).

[![Build Status](https://jenkins.mesosphere.com/service/jenkins/buildStatus/icon?job=dcos-vagrant-oinker)](https://jenkins.mesosphere.com/service/jenkins/view/dcos-vagrant/job/dcos-vagrant-oinker/)

##### Issue Tracking

- Issue tracking is in [DCOS JIRA](https://jira.mesosphere.com/projects/DCOS_VAGRANT/).
- Remember to make a DC/OS JIRA account and login so you can get update notifications!


### Quick Start

1. Install [Git](https://git-scm.com/downloads), [Vagrant](https://www.vagrantup.com/downloads.html), and [VirtualBox](https://www.virtualbox.org/wiki/Downloads)

1. Install vagrant-hostmanager plugin

    ```
    vagrant plugin install vagrant-hostmanager
    ```

1. Clone, Configure, and Deploy

    ```
    git clone https://github.com/dcos/dcos-vagrant
    cd dcos-vagrant
    cp VagrantConfig-1m-1a-1p.yaml VagrantConfig.yaml
    vagrant up
    ```

    When prompted for a password, provide your local machine user password (modifies `/etc/hosts`).

1. Access the GUI <http://m1.dcos/>

1. Install the DC/OS CLI

   ```
   ci/dcos-install-cli.sh
   ```

For more detailed instructions, see [Deploy](/docs/deploy.md) and [Configure](/docs/configure.md).


### DC/OS Versions

Official releases of DC/OS can be found at <http://dcos.io/releases/>

By default, DC/OS Vagrant uses the latest **stable** version of DC/OS.

To use a different **stable** or **early access** version, specify the version explicitly (must be in the [list of known releases](dcos-versions.yaml)):

```
export DCOS_VERSION=1.9.0-rc1
vagrant up
```

To use a bleeding edge **master**, **enterprise**, or **custom** build, download the installer yourself, place it under the dcos-vagrant directory, and configure DC/OS Vagrant to use it:

```
export DCOS_GENERATE_CONFIG_PATH=dcos_generate_config-1.9.0-dev.sh
export DCOS_CONFIG_PATH=etc/config-1.9.yaml
vagrant up
```


### DC/OS Vagrant Documentation

- [Deploy](/docs/deploy.md)
- [Configure](/docs/configure.md)
- [Upgrade](/docs/upgrade.md)
- [Examples](/examples)
- [Audience and Goals](/docs/audience-and-goals.md)
- [Network Topology](/docs/network-topology.md)
- [Alternate Install Methods](/docs/alternate-install-methods.md)
- [DC/OS Install Process](/docs/dcos-install-process.md)
- [Install Ruby](/docs/install-ruby.md)
- [Repo Structure](/docs/repo-structure.md)
- [Troubleshooting](/docs/troubleshooting.md)
- [VirtualBox Guest Additions](/docs/virtualbox-guest-additions.md)


### How Do I...?

- Learn More - https://dcos.io/
- Find the Docs - https://dcos.io/docs/
- Get Help - http://chat.dcos.io/
- Join the Discussion - https://groups.google.com/a/dcos.io/d/forum/users/
- Report a DC/OS Vagrant Issue - https://jira.mesosphere.com/projects/DCOS_VAGRANT/
- Report a DC/OS Issue - https://jira.mesosphere.com/projects/DCOS_OSS/
- Contribute - https://dcos.io/contribute/


##### License

Copyright 2015-2017 Mesosphere, Inc.

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this repository except in compliance with the License.

The contents of this repository are solely licensed under the terms described in the [LICENSE file](/LICENSE) included in this repository.

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.

---
title: Openstack之Newton
toc: 1
date: 2017-04-28 10:00:37
tags:
- openstak
categories:
- 部署
permalink:
---
**原因**：2017年4月28日 星期五 记录一下
**说明**：运维无止境。

<!-- more -->
# 环境准备

## 虚拟机
- 创建三台centOS 7.2虚拟机，使用1511镜像，minimal安装，并设置网卡，nat外网，host-only两块，同时全部取消DHCP


## vlan
## vlan的划分：

一、组网需求：
1、如下图所示，某用户内网被划分为VLAN 10、VLAN 20、VLAN 30，以实现相互间的2 层隔离；
2、3 个VLAN 对应的IP 子网分别为192.168.10.0/24 、192.168.20.0/24 、192.168.30.0/24，3 个VLAN 通过3 层核心交换机的IP 转发能力实现子网互连。
三、配置要点：
本用例以核心交换机和1 台接入交换机为例说明配置过程。要点如下：
 1）在核心交换机配置3 个VLAN，配置下连接入交换机的端口为trunk 口
 2）在核心交换机配置3 个SVI 口，分别作为3 个VLAN 对应IP 子网的网关接口，配置对应的IP 地址；
 3）分别在3 台接入交换机创建VLAN，为各VLAN 分配Access 口，指定上连核心交换机的trunk 口。本用例以接入交换机Switch A 为例说明配置步骤。

四、配置步骤:
注意：配置之前建议使用 Ruijie#show interface status查看接口名称，常用接口名称有FastEthernet（百兆）、GigabitEthernet（千兆）和TenGigabitEthernet(万兆),以下配置千兆接口为例。

核心交换机的配置：
```
Ruijie>enable 
Ruijie#configure terminal
Ruijie(config)#vlan 10     ------>创建VLAN 10
Ruijie(config-vlan)#vlan 20     ------>  创建VLAN 20
Ruijie(config-vlan)#vlan 30       ------>创建VLAN 30
Ruijie(config-vlan)#exit
Ruijie(config)#interface range GigabitEthernet 0/2-4       ------>配置该端口Gi 0/2-4 都为trunk 口
Ruijie(config-if-range)#switchport mode trunk
Ruijie(config-if-range)#exit
Ruijie(config)#interface vlan 10      ------>创建SVI 10
Ruijie(config-if)#ip address 192.168.10.1 255.255.255.0      ------>配置vlan 10的网关地址
Ruijie(config-if)#interface vlan 20      ------> 创建SVI 20
Ruijie(config-if)#ip address 192.168.20.1 255.255.255.0       ------> 配置vlan 20的网关地址
Ruijie(config-if)#interface vlan 30        ------>创建SVI 30
Ruijie(config-if)#ip address 192.168.30.1 255.255.255.0      ------> 配置vlan 20的网关地址 
Ruijie(config-if)#end      ------>退出到特权模式
Ruijie#write             ------>确认配置正确，保存配置
```
五、配置验证：
核心交换机：查看vlan 信息，包括vlan id、名称、状态、包括的端口
Ruijie#show vlan
VLAN    Name                              Status             Ports    
----    -----------------------      ---------   -----------------------------------
vlan号     vlan名称                      vlan 属性          可以传输该vlan数据的端口
   1     VLAN0001                         STATIC     Gi0/1, Gi0/2, Gi0/3, Gi0/4           
                                                Gi0/5, Gi0/6, Gi0/7, Gi0/8           
                                                Gi0/9, Gi0/10, Gi0/11, Gi0/12        
                                                Gi0/13, Gi0/14, Gi0/15, Gi0/16       
                                                Gi0/17, Gi0/18, Gi0/19, Gi0/20       
                                                Gi0/21, Gi0/22, Gi0/23, Gi0/24       
                                                Gi0/25, Gi0/26, Gi0/27, Gi0/28       
  10     VLAN0010                         STATIC    Gi0/2, Gi0/3, Gi0/4                  
  20     VLAN0020                         STATIC    Gi0/2, Gi0/3, Gi0/4                  
  30     VLAN0030                         STATIC    Gi0/2, Gi0/3, Gi0/4         

查看端口Gi 0/2 的vlan 状态
Ruijie#show interfaces gigabitEthernet 0/2 switchport
Interface                    Switchport      Mode      Access     Native    Protected VLAN lists
------------------------    ----------    ---------       ------        ------        ---------     ----------
GigabitEthernet 0/2      enabled      TRUNK           1           1           Disabled     ALL


## 搭建内部yum源
- 由于centOS外部源多已为7.3，这一版本会有很多问题，推荐自行找到7.2在本地搭建源，windows使用Xampp，而unix可以使用httpd或者apache进行搭建，具体方式不赘述。

## 网络拓扑

```
external 9.110.187.0/24 外网
admin mgt 10.1.1.0/24 管理
tunnel 10.2.2.0/24 私网
```

## 下载安装必备软件包
- 首先centOS为7.2版本，版本号为1511.不要运行yum update升级到1611即7.3版本。
```
yum install wget net-tools vim ntpupdate bash-completion -y
```

## 配置安装NTP
```
yum install ntpdate ntp -y
vi /etc/ntp.conf
/etc/nova/nova.conf//替换服务器
systemctl enable ntpd
systemctl start ntpd
ntpq -p
date
```

# Controller
## 配置安装MariaDB
1. 安装mariadb数据库

```
 yum install -y MariaDB-server MariaDB-client
```

2. 配置mariadb

```
vim /etc/my.cnf.d/mariadb-openstack.cnf
```

- 在mysqld区块添加如下内容： 

```
[mysqld]
default-storage-engine = innodb
innodb_file_per_table
collation-server = utf8_general_ci
init-connect = 'SET NAMES utf8'
character-set-server = utf8
bind-address = 10.1.1.150
```

3. 启动数据库及设置mariadb开机启动

```
systemctl enable mariadb.service
systemctl restart mariadb.service
systemctl status mariadb.service
systemctl list-unit-files |grep mariadb.service
```

4. 配置mariadb，给mariadb设置密码

```
mysql_secure_installation //先按回车，然后按Y，设置mysql密码，然后一直按y结束 这里我们设置的密码是123
```

## 配置安装Rabbitmq
1 .每个节点都安装erlang

```
yum install -y erlang
```

2 .每个节点都安装RabbitMQ

```
yum install -y rabbitmq-server
```

3 .每个节点都启动rabbitmq及设置开机启动

```
systemctl enable rabbitmq-server.service 
systemctl restart rabbitmq-server.service 
systemctl status rabbitmq-server.service 
systemctl list-unit-files |grep rabbitmq-server.service
```

4 .创建openstack，注意将PASSWOED替换为自己的合适密码

```
rabbitmqctl add_user openstack 123
```

5 .将openstack用户赋予权限

```
rabbitmqctl set_permissions openstack ".*" ".*" ".*" 
rabbitmqctl set_user_tags openstack administrator 
rabbitmqctl list_users
```

6 .看下监听端口 rabbitmq用的是5672端口

```
netstat -ntlp |grep 5672
```

7 .查看RabbitMQ插件

```
/usr/lib/rabbitmq/bin/rabbitmq-plugins list
```

8 .打开RabbitMQ相关插件

```
/usr/lib/rabbitmq/bin/rabbitmq-plugins enable rabbitmq_management mochiweb webmachine rabbitmq_web_dispatch amqp_client rabbitmq_management_agent
```

- 打开相关插件后，重启下rabbitmq服务 
- 浏览器输入：http://9.110.187.150:15672 默认用户名密码：guest/guest 
- 通过这个界面，我们能很直观的看到rabbitmq的运行和负载情况 
- 当然我们可以不用guest，我们换一个另外用户，比如:mqadmin 

```
rabbitmqctl add_user mqadmin mqadmin
rabbitmqctl set_user_tags mqadmin administrator
rabbitmqctl set_permissions -p / mqadmin ".*" ".*" ".*" //我们还可以通过这命令把密码换了，比如把guest用户的密码变成123
rabbitmqctl change_password guest 123
```

## 配置安装Keystone

1 .创建keystone数据库

```
CREATE DATABASE keystone;
```

3 .创建数据库用户及赋予权限

```
GRANT ALL PRIVILEGES ON keystone.* TO 'keystone'@'localhost' IDENTIFIED BY '123';
GRANT ALL PRIVILEGES ON keystone.* TO 'keystone'@'%' IDENTIFIED BY '123';
```

- 注意将123替换为自己的数据库密码

4 .安装keystone和memcached

```
yum -y install openstack-keystone httpd mod_wsgi python-openstackclient memcached python-memcached openstack-utils
```

5、启动memcache服务并设置开机自启动

```
systemctl enable memcached.service
systemctl restart memcached.service
systemctl status memcached.service
netstat -ntlp | grep 11211
```

6、配置/etc/keystone/keystone.conf文件

```
openssl rand -hex 10 //首先需要先产生一个随机数，用作初始配置时的管理员令牌，ADMIN_TOKEN=929c32c35c315b694536 这个字符串就是上面openssl随机生成的
cp /etc/keystone/keystone.conf /etc/keystone/keystone.conf.bak
>/etc/keystone/keystone.conf
openstack-config --set /etc/keystone/keystone.conf DEFAULT debug false
openstack-config --set /etc/keystone/keystone.conf DEFAULT verbose true
openstack-config --set /etc/keystone/keystone.conf DEFAULT admin_token 929c32c35c315b694536
openstack-config --set /etc/keystone/keystone.conf DEFAULT admin_endpoint http://controller1:35357
openstack-config --set /etc/keystone/keystone.conf DEFAULT public_endpoint http://controller1:5000
openstack-config --set /etc/keystone/keystone.conf database connection mysql://keystone:123@controller1/keystone
openstack-config --set /etc/keystone/keystone.conf oslo_messaging_rabbit rabbit_host controller1
openstack-config --set /etc/keystone/keystone.conf oslo_messaging_rabbit rabbit_port 5672
openstack-config --set /etc/keystone/keystone.conf oslo_messaging_rabbit rabbit_userid openstack
openstack-config --set /etc/keystone/keystone.conf oslo_messaging_rabbit rabbit_password 123
openstack-config --set /etc/keystone/keystone.conf cache backend oslo_cache.memcache_pool 
openstack-config --set /etc/keystone/keystone.conf cache enabled true
openstack-config --set /etc/keystone/keystone.conf cache memcache_servers controller1:11211 
openstack-config --set /etc/keystone/keystone.conf memcache servers controller1:11211 
openstack-config --set /etc/keystone/keystone.conf token expiration 3600 
openstack-config --set /etc/keystone/keystone.conf token provider fernet
```

7 .配置httpd.conf文件&memcached文件

```
sed -i "s/#ServerName www.example.com:80/ServerName controller1/" /etc/httpd/conf/httpd.conf 
sed -i 's/OPTIONS*.*/OPTIONS="-l 127.0.0.1,::1,10.1.1.150"/' /etc/sysconfig/memcached
```

8 .配置keystone与httpd结合

```
vim /etc/httpd/conf.d/wsgi-keystone.conf
Listen 5000
Listen 35357

<VirtualHost *:5000>

WSGIDaemonProcess keystone-public processes=5 threads=1 user=keystone group=keystone display-name=%{GROUP}
WSGIProcessGroup keystone-public
WSGIScriptAlias / /usr/bin/keystone-wsgi-public
WSGIApplicationGroup %{GLOBAL}
WSGIPassAuthorization On
ErrorLogFormat "%{cu}t %M"
ErrorLog /var/log/httpd/keystone-error.log
CustomLog /var/log/httpd/keystone-access.log combined

<Directory /usr/bin>
Require all granted
</Directory>
</VirtualHost>

<VirtualHost *:35357>
WSGIDaemonProcess keystone-admin processes=5 threads=1 user=keystone group=keystone display-name=%{GROUP}
WSGIProcessGroup keystone-admin
WSGIScriptAlias / /usr/bin/keystone-wsgi-admin
WSGIApplicationGroup %{GLOBAL}
WSGIPassAuthorization On
ErrorLogFormat "%{cu}t %M"
ErrorLog /var/log/httpd/keystone-error.log
CustomLog /var/log/httpd/keystone-access.log combined

<Directory /usr/bin>
Require all granted
</Directory>
</VirtualHost>
```

9 .数据库同步

```
su -s /bin/sh -c "keystone-manage db_sync" keystone
```

10 .初始化fernet

```
keystone-manage fernet_setup --keystone-user keystone --keystone-group keystone
keystone-manage credential_setup --keystone-user keystone --keystone-group keystone
```

11 .启动httpd，并设置httpd开机启动

```
systemctl enable httpd.service
systemctl restart httpd.service
```

12 .创建admin用户角色

```
keystone-manage bootstrap \
--bootstrap-password 123 \ 
--bootstrap-username admin \ 
--bootstrap-project-name admin \ 
--bootstrap-role-name admin \ 
--bootstrap-service-name keystone \ 
--bootstrap-region-id RegionOne \ 
--bootstrap-admin-url http://controller1:35357/v3 \ 
--bootstrap-internal-url http://controller1:35357/v3 \ 
--bootstrap-public-url http://controller1:5000/v3
```

- 验证配置是否成功：

```
openstack project list --os-username admin --os-project-name admin --os-user-domain-id default --os-project-domain-id default --os-identity-api-version 3 --os-auth-url http://controller1:5000 --os-password 123
```

![](http://image.yaopig.com/blog/Jietu20170428-103005.jpg)

13 .创建admin用户环境，创建/root/admin-openrc文件并写入如下内容：

```
export OS_USER_DOMAIN_ID=default
export OS_PROJECT_DOMAIN_ID=default
export OS_USERNAME=admin
export OS_PROJECT_NAME=admin
export OS_PASSWORD=123
export OS_IDENTITY_API_VERSION=3
export OS_AUTH_URL=http://controller1:35357/v3
```

14 .创建service项目

```
source /root/admin-openrc
openstack project create --domain default --description "Service Project" service
```

15 .创建demo项目及用户

```
openstack project create --domain default --description "Demo Project" demo
openstack user create --domain default demo --password 123 //注意：123为demo用户密码
```

16 .创建user角色将demo用户赋予user角色

```
openstack role create user
openstack role add --project demo --user demo user
```

17 .验证keystone

```
unset OS_TOKEN OS_URL
openstack --os-auth-url http://controller1:35357/v3 --os-project-domain-name default --os-user-domain-name default --os-project-name admin --os-username admin token issue --os-password 123
openstack --os-auth-url http://controller1:5000/v3 --os-project-domain-name default --os-user-domain-name default --os-project-name demo --os-username demo token issue --os-password 123
```
![](http://image.yaopig.com/blog/%E9%AA%8C%E8%AF%81keystone.jpg)

## 配置安装Glance

1 .创建glance数据库

```
CREATE DATABASE glance;
```

2 .创建数据库用户并赋予权限


```
GRANT ALL PRIVILEGES ON glance.* TO 'glance'@'localhost' IDENTIFIED BY '123';
GRANT ALL PRIVILEGES ON glance.* TO 'glance'@'%' IDENTIFIED BY '123';
```

3 .创建glance用户及赋予admin权限

```
source /root/admin-openrc
openstack user create --domain default glance --password 123
openstack role add --project service --user glance admin
```

4 .创建image服务

```
openstack service create --name glance --description "OpenStack Image service" image
```

5 .创建glance的endpoint

```
openstack endpoint create --region RegionOne image public http://controller1:9292
openstack endpoint create --region RegionOne image internal http://controller1:9292
openstack endpoint create --region RegionOne image admin http://controller1:9292
```

![](http://image.yaopig.com/blog/GLANCE1-5.jpg)

6 .安装glance相关rpm包

```
yum install openstack-glance -y
```

7 .修改glance配置文件/etc/glance/glance-api.conf
- 注意密码设置成你自己的:

```
cp /etc/glance/glance-api.conf /etc/glance/glance-api.conf.bak
>/etc/glance/glance-api.conf
openstack-config --set /etc/glance/glance-api.conf database connection mysql+pymysql://glance:123@controller1/glance
openstack-config --set /etc/glance/glance-api.conf oslo_messaging_rabbit rabbit_host controller1
openstack-config --set /etc/glance/glance-api.conf oslo_messaging_rabbit rabbit_port 5672
openstack-config --set /etc/glance/glance-api.conf oslo_messaging_rabbit rabbit_userid openstack
openstack-config --set /etc/glance/glance-api.conf oslo_messaging_rabbit rabbit_password 123
openstack-config --set /etc/glance/glance-api.conf keystone_authtoken auth_uri http://controller1:5000
openstack-config --set /etc/glance/glance-api.conf keystone_authtoken auth_url http://controller1:35357
openstack-config --set /etc/glance/glance-api.conf keystone_authtoken memcached_servers controller1:11211
openstack-config --set /etc/glance/glance-api.conf keystone_authtoken auth_type password
openstack-config --set /etc/glance/glance-api.conf keystone_authtoken project_domain_name default
openstack-config --set /etc/glance/glance-api.conf keystone_authtoken user_domain_name default
openstack-config --set /etc/glance/glance-api.conf keystone_authtoken username glance
openstack-config --set /etc/glance/glance-api.conf keystone_authtoken password 123
openstack-config --set /etc/glance/glance-api.conf keystone_authtoken project_name service
openstack-config --set /etc/glance/glance-api.conf paste_deploy flavor keystone
openstack-config --set /etc/glance/glance-api.conf glance_store stores file,http
openstack-config --set /etc/glance/glance-api.conf glance_store default_store file
openstack-config --set /etc/glance/glance-api.conf glance_store filesystem_store_datadir /var/lib/glance/images/
```

- 修改后查看`vi /etc/glance/glance-api.conf`：

```
[database]
connection = mysql+pymysql://glance:123@controller1/glance


[oslo_messaging_rabbit]
rabbit_host = controller1
rabbit_port = 5672
rabbit_userid = openstack
rabbit_password = 123


[keystone_authtoken]
auth_uri = http://controller1:5000
auth_url = http://controller1:35357
memcached_servers = controller1:11211
auth_type = password
project_domain_name = default
user_domain_name = default
username = glance
password = 123
project_name = service


[paste_deploy]
flavor = keystone


[glance_store]
stores = file,http
default_store = file
filesystem_store_datadir = /var/lib/glance/images/
```
8 .修改glance配置文件/etc/glance/glance-registry.conf：

```
cp /etc/glance/glance-registry.conf /etc/glance/glance-registry.conf.bak
>/etc/glance/glance-registry.conf
openstack-config --set /etc/glance/glance-registry.conf database connection mysql+pymysql://glance:123@controller1/glance
openstack-config --set /etc/glance/glance-registry.conf oslo_messaging_rabbit rabbit_host controller1
openstack-config --set /etc/glance/glance-registry.conf oslo_messaging_rabbit rabbit_port 5672
openstack-config --set /etc/glance/glance-registry.conf oslo_messaging_rabbit rabbit_userid openstack
openstack-config --set /etc/glance/glance-registry.conf oslo_messaging_rabbit rabbit_password 123
openstack-config --set /etc/glance/glance-registry.conf keystone_authtoken auth_uri http://controller1:5000
openstack-config --set /etc/glance/glance-registry.conf keystone_authtoken auth_url http://controller1:35357
openstack-config --set /etc/glance/glance-registry.conf keystone_authtoken memcached_servers controller1:11211
openstack-config --set /etc/glance/glance-registry.conf keystone_authtoken auth_type password
openstack-config --set /etc/glance/glance-registry.conf keystone_authtoken project_domain_name default
openstack-config --set /etc/glance/glance-registry.conf keystone_authtoken user_domain_name default
openstack-config --set /etc/glance/glance-registry.conf keystone_authtoken project_name service
openstack-config --set /etc/glance/glance-registry.conf keystone_authtoken username glance
openstack-config --set /etc/glance/glance-registry.conf keystone_authtoken password 123
openstack-config --set /etc/glance/glance-registry.conf paste_deploy flavor keystone
```

- 修改后查看`vi /etc/glance/glance-registry.conf`
```
[database]
connection = mysql+pymysql://glance:123@controller1/glance


[oslo_messaging_rabbit]
rabbit_host = controller1
rabbit_port = 5672
rabbit_userid = openstack
rabbit_password = 123


[keystone_authtoken]
auth_uri = http://controller1:5000
auth_url = http://controller1:35357
memcached_servers = controller1:11211
auth_type = password
project_domain_name = default
user_domain_name = default
project_name = service
username = glance
password = 123


[paste_deploy]
flavor = keystone
```

9 .同步glance数据库

```
su -s /bin/sh -c "glance-manage db_sync" glance
```

10、启动glance及设置开机启动

```
systemctl enable openstack-glance-api.service openstack-glance-registry.service
systemctl restart openstack-glance-api.service openstack-glance-registry.service
systemctl status openstack-glance-api.service openstack-glance-registry.service
```

11、将glance版本号写入环境变量中

```
echo " " >> /root/admin-openrc && \
echo " " >> /root/demo-openrc && \
echo "export OS_IMAGE_API_VERSION=2" | tee -a /root/admin-openrc /root/demo-openrc
```

13、下载测试镜像文件

```
wget http://download.cirros-cloud.net/0.3.4/cirros-0.3.4-x86_64-disk.img
```

14、上传镜像到glance

```
source /root/admin-openrc
glance image-create --name "cirros-0.3.4-x86_64" --file cirros-0.3.4-x86_64-disk.img --disk-format qcow2 --container-format bare --visibility public --progress
```

- 如果你做好了一个CentOS6.7系统的镜像，也可以用这命令操作，例：

```
glance image-create --name "CentOS7.1-x86_64" --file CentOS_7.1.qcow2 --disk-format qcow2 --container-format bare --visibility public --progress
```

- 查看镜像列表：`glance image-list`
![](http://image.yaopig.com/blog/Jietu20170428-131022.jpg)

## 配置安装nova

1 .创建nova数据库

```
CREATE DATABASE nova;
CREATE DATABASE nova_api;
```

2 .创建数据库用户并赋予权限

```
GRANT ALL PRIVILEGES ON nova.* TO 'nova'@'localhost' IDENTIFIED BY '123';
GRANT ALL PRIVILEGES ON nova.* TO 'nova'@'%' IDENTIFIED BY '123';
GRANT ALL PRIVILEGES ON nova_api.* TO 'nova'@'localhost' IDENTIFIED BY '123';
GRANT ALL PRIVILEGES ON nova_api.* TO 'nova'@'%' IDENTIFIED BY '123';
```

3 .创建nova用户及赋予admin权限

```
source /root/admin-openrc
openstack user create --domain default nova --password 123
openstack role add --project service --user nova admin
```

4 .创建computer服务

```
openstack service create --name nova --description "OpenStack Compute" compute
```
5 .创建nova的endpoint

```
openstack endpoint create --region RegionOne compute public http://controller1:8774/v2.1/%\(tenant_id\)s
openstack endpoint create --region RegionOne compute internal http://controller1:8774/v2.1/%\(tenant_id\)s
openstack endpoint create --region RegionOne compute admin http://controller1:8774/v2.1/%\(tenant_id\)s
```

6 .安装nova相关软件

```
yum install -y openstack-nova-api openstack-nova-conductor openstack-nova-cert openstack-nova-console openstack-nova-novncproxy openstack-nova-scheduler
```

7 .配置nova的配置文件/etc/nova/nova.conf

```
cp /etc/nova/nova.conf /etc/nova/nova.conf.bak
>/etc/nova/nova.conf
openstack-config --set /etc/nova/nova.conf DEFAULT enabled_apis osapi_compute,metadata
openstack-config --set /etc/nova/nova.conf DEFAULT auth_strategy keystone
openstack-config --set /etc/nova/nova.conf DEFAULT my_ip 10.1.1.150
openstack-config --set /etc/nova/nova.conf DEFAULT use_neutron True
openstack-config --set /etc/nova/nova.conf DEFAULT firewall_driver nova.virt.firewall.NoopFirewallDriver
openstack-config --set /etc/nova/nova.conf database connection mysql+pymysql://nova:123@controller1/nova
openstack-config --set /etc/nova/nova.conf api_database connection mysql+pymysql://nova:123@controller1/nova_api
openstack-config --set /etc/nova/nova.conf oslo_messaging_rabbit rabbit_host controller1
openstack-config --set /etc/nova/nova.conf oslo_messaging_rabbit rabbit_port 5672
openstack-config --set /etc/nova/nova.conf oslo_messaging_rabbit rabbit_userid openstack
openstack-config --set /etc/nova/nova.conf oslo_messaging_rabbit rabbit_password 123
openstack-config --set /etc/nova/nova.conf keystone_authtoken auth_uri http://controller1:5000
openstack-config --set /etc/nova/nova.conf keystone_authtoken auth_url http://controller1:35357
openstack-config --set /etc/nova/nova.conf keystone_authtoken memcached_servers controller1:11211
openstack-config --set /etc/nova/nova.conf keystone_authtoken auth_type password
openstack-config --set /etc/nova/nova.conf keystone_authtoken project_domain_name default
openstack-config --set /etc/nova/nova.conf keystone_authtoken user_domain_name default
openstack-config --set /etc/nova/nova.conf keystone_authtoken project_name service
openstack-config --set /etc/nova/nova.conf keystone_authtoken username nova
openstack-config --set /etc/nova/nova.conf keystone_authtoken password 123
openstack-config --set /etc/nova/nova.conf vnc vncserver_listen 10.1.1.150
openstack-config --set /etc/nova/nova.conf vnc vncserver_proxyclient_address 10.1.1.150
openstack-config --set /etc/nova/nova.conf glance api_servers http://controller1:9292
openstack-config --set /etc/nova/nova.conf oslo_concurrency lock_path /var/lib/nova/tmp
```

- 修改后查看vi /etc/nova/nova.conf：

```
[DEFAULT]
enabled_apis = osapi_compute,metadata
auth_strategy = keystone
my_ip = 10.1.1.150
use_neutron = True
firewall_driver = nova.virt.firewall.NoopFirewallDriver


[database]
connection = mysql+pymysql://nova:123@controller1/nova


[api_database]
connection = mysql+pymysql://nova:123@controller1/nova_api


[oslo_messaging_rabbit]
rabbit_host = controller1
rabbit_port = 5672
rabbit_userid = openstack
rabbit_password = 123


[keystone_authtoken]
auth_uri = http://controller1:5000
auth_url = http://controller1:35357
memcached_servers = controller1:11211
auth_type = password
project_domain_name = default
user_domain_name = default
project_name = service
username = nova
password = 123


[vnc]
vncserver_listen = 10.1.1.150
vncserver_proxyclient_address = 10.1.1.150


[glance]
api_servers = http://controller1:9292


[oslo_concurrency]
lock_path = /var/lib/nova/tmp
```

8 .同步nova数据

```
su -s /bin/sh -c "nova-manage api_db sync" nova
su -s /bin/sh -c "nova-manage db sync" nova
```

9 .设置开机启动

```
systemctl enable openstack-nova-api.service openstack-nova-cert.service openstack-nova-consoleauth.service openstack-nova-scheduler.service openstack-nova-conductor.service openstack-nova-novncproxy.service
```

- 启动nova服务：

```
systemctl restart openstack-nova-api.service openstack-nova-cert.service openstack-nova-consoleauth.service openstack-nova-scheduler.service openstack-nova-conductor.service openstack-nova-novncproxy.service
```

- 查看nova服务：

```
systemctl status openstack-nova-api.service openstack-nova-cert.service openstack-nova-consoleauth.service openstack-nova-scheduler.service openstack-nova-conductor.service openstack-nova-novncproxy.service
```

```
systemctl list-unit-files |grep openstack-nova-*
```

10 .验证nova服务

```
unset OS_TOKEN OS_URL
source /root/admin-openrc
nova service-list
openstack endpoint list //查看endpoint list
```
![](http://image.yaopig.com/blog/Jietu20170428-133749.jpg)


## 配置安装neutron

1 .创建neutron数据库

```
CREATE DATABASE neutron;
```

2 .创建数据库用户并赋予权限

```
GRANT ALL PRIVILEGES ON neutron.* TO 'neutron'@'localhost' IDENTIFIED BY '123';
GRANT ALL PRIVILEGES ON neutron.* TO 'neutron'@'%' IDENTIFIED BY '123';
```

3 .创建neutron用户及赋予admin权限

```
source /root/admin-openrc
openstack user create --domain default neutron --password 123
openstack role add --project service --user neutron admin
```

4 .创建network服务

```
openstack service create --name neutron --description "OpenStack Networking" network
```

5 .创建endpoint

```
openstack endpoint create --region RegionOne network public http://controller1:9696
openstack endpoint create --region RegionOne network internal http://controller1:9696
openstack endpoint create --region RegionOne network admin http://controller1:9696
```

6 .安装neutron相关软件

```
yum install openstack-neutron openstack-neutron-ml2 openstack-neutron-linuxbridge ebtables -y
```

7 .配置neutron配置文件/etc/neutron/neutron.conf

```
cp /etc/neutron/neutron.conf /etc/neutron/neutron.conf.bak
>/etc/neutron/neutron.conf
openstack-config --set /etc/neutron/neutron.conf DEFAULT core_plugin ml2
openstack-config --set /etc/neutron/neutron.conf DEFAULT service_plugins router
openstack-config --set /etc/neutron/neutron.conf DEFAULT allow_overlapping_ips True
openstack-config --set /etc/neutron/neutron.conf DEFAULT auth_strategy keystone
openstack-config --set /etc/neutron/neutron.conf oslo_messaging_rabbit rabbit_host controller1
openstack-config --set /etc/neutron/neutron.conf oslo_messaging_rabbit rabbit_port 5672
openstack-config --set /etc/neutron/neutron.conf oslo_messaging_rabbit rabbit_userid openstack
openstack-config --set /etc/neutron/neutron.conf oslo_messaging_rabbit rabbit_password 123
openstack-config --set /etc/neutron/neutron.conf keystone_authtoken auth_uri http://controller1:5000
openstack-config --set /etc/neutron/neutron.conf keystone_authtoken auth_url http://controller1:35357
openstack-config --set /etc/neutron/neutron.conf keystone_authtoken memcached_servers controller1:11211
openstack-config --set /etc/neutron/neutron.conf keystone_authtoken auth_type password
openstack-config --set /etc/neutron/neutron.conf keystone_authtoken project_domain_name default
openstack-config --set /etc/neutron/neutron.conf keystone_authtoken user_domain_name default
openstack-config --set /etc/neutron/neutron.conf keystone_authtoken project_name service
openstack-config --set /etc/neutron/neutron.conf keystone_authtoken username neutron
openstack-config --set /etc/neutron/neutron.conf keystone_authtoken password 123
openstack-config --set /etc/neutron/neutron.conf database connection mysql+pymysql://neutron:123@controller1/neutron
openstack-config --set /etc/neutron/neutron.conf nova auth_url http://controller1:35357
openstack-config --set /etc/neutron/neutron.conf nova auth_type password
openstack-config --set /etc/neutron/neutron.conf nova project_domain_name default
openstack-config --set /etc/neutron/neutron.conf nova user_domain_name default
openstack-config --set /etc/neutron/neutron.conf nova region_name RegionOne
openstack-config --set /etc/neutron/neutron.conf nova project_name service
openstack-config --set /etc/neutron/neutron.conf nova username nova
openstack-config --set /etc/neutron/neutron.conf nova password 123
openstack-config --set /etc/neutron/neutron.conf oslo_concurrency lock_path /var/lib/neutron/tmp
```

- 修改后查看vi /etc/neutron/neutron.conf：

```
[DEFAULT]
core_plugin = ml2
service_plugins = router
allow_overlapping_ips = True
auth_strategy = keystone


[oslo_messaging_rabbit]
rabbit_host = controller1
rabbit_port = 5672
rabbit_userid = openstack
rabbit_password = 123


[keystone_authtoken]
auth_uri = http://controller1:5000
auth_url = http://controller1:35357
memcached_servers = controller1:11211
auth_type = password
project_domain_name = default
user_domain_name = default
project_name = service
username = neutron
password = 123


[database]
connection = mysql+pymysql://neutron:123@controller1/neutron


[nova]
auth_url = http://controller1:35357
auth_type = password
project_domain_name = default
user_domain_name = default
region_name = RegionOne
project_name = service
username = nova
password = 123


[oslo_concurrency]
lock_path = /var/lib/neutron/tmp
```

8 .配置/etc/neutron/plugins/ml2/ml2_conf.ini

```
openstack-config --set /etc/neutron/plugins/ml2/ml2_conf.ini ml2 type_drivers flat,vlan,vxlan
openstack-config --set /etc/neutron/plugins/ml2/ml2_conf.ini ml2 mechanism_drivers linuxbridge,l2population
openstack-config --set /etc/neutron/plugins/ml2/ml2_conf.ini ml2 extension_drivers port_security
openstack-config --set /etc/neutron/plugins/ml2/ml2_conf.ini ml2 tenant_network_types vxlan
openstack-config --set /etc/neutron/plugins/ml2/ml2_conf.ini ml2 path_mtu 1500
openstack-config --set /etc/neutron/plugins/ml2/ml2_conf.ini ml2_type_flat flat_networks provider
openstack-config --set /etc/neutron/plugins/ml2/ml2_conf.ini ml2_type_vxlan vni_ranges 1:1000
openstack-config --set /etc/neutron/plugins/ml2/ml2_conf.ini securitygroup enable_ipset True
```

9 .配置/etc/neutron/plugins/ml2/linuxbridge_agent.ini

```
openstack-config --set /etc/neutron/plugins/ml2/linuxbridge_agent.ini DEFAULT debug false
openstack-config --set /etc/neutron/plugins/ml2/linuxbridge_agent.ini linux_bridge physical_interface_mappings provider:eno16777736
openstack-config --set /etc/neutron/plugins/ml2/linuxbridge_agent.ini vxlan enable_vxlan True
openstack-config --set /etc/neutron/plugins/ml2/linuxbridge_agent.ini vxlan local_ip 10.2.2.150 
openstack-config --set /etc/neutron/plugins/ml2/linuxbridge_agent.ini vxlan l2_population True
openstack-config --set /etc/neutron/plugins/ml2/linuxbridge_agent.ini agent prevent_arp_spoofing True
openstack-config --set /etc/neutron/plugins/ml2/linuxbridge_agent.ini securitygroup enable_security_group True
openstack-config --set /etc/neutron/plugins/ml2/linuxbridge_agent.ini securitygroup firewall_driver neutron.agent.linux.iptables_firewall.IptablesFirewallDriver
```

- 注意eno16777736是public网卡，一般这里写的网卡名都是能访问外网的，如果不是外网网卡，那么VM就会与外界网络隔离。 local_ip 定义的是隧道网络，vxLan下 vm-linuxbridge->vxlan ------tunnel-----vxlan->linuxbridge-vm

10 .配置 /etc/neutron/l3_agent.ini

```
openstack-config --set /etc/neutron/l3_agent.ini DEFAULT interface_driver neutron.agent.linux.interface.BridgeInterfaceDriver
openstack-config --set /etc/neutron/l3_agent.ini DEFAULT external_network_bridge
openstack-config --set /etc/neutron/l3_agent.ini DEFAULT debug false
```

11 .配置/etc/neutron/dhcp_agent.ini

```
openstack-config --set /etc/neutron/dhcp_agent.ini DEFAULT interface_driver neutron.agent.linux.interface.BridgeInterfaceDriver
openstack-config --set /etc/neutron/dhcp_agent.ini DEFAULT dhcp_driver neutron.agent.linux.dhcp.Dnsmasq
openstack-config --set /etc/neutron/dhcp_agent.ini DEFAULT enable_isolated_metadata True
openstack-config --set /etc/neutron/dhcp_agent.ini DEFAULT verbose True
openstack-config --set /etc/neutron/dhcp_agent.ini DEFAULT debug false
```

12、重新配置/etc/nova/nova.conf，配置这步的目的是让compute节点能使用上neutron网络

```
openstack-config --set /etc/nova/nova.conf neutron url http://controller1:9696
openstack-config --set /etc/nova/nova.conf neutron auth_url http://controller1:35357 
openstack-config --set /etc/nova/nova.conf neutron auth_plugin password
openstack-config --set /etc/nova/nova.conf neutron project_domain_id default
openstack-config --set /etc/nova/nova.conf neutron user_domain_id default
openstack-config --set /etc/nova/nova.conf neutron region_name RegionOne
openstack-config --set /etc/nova/nova.conf neutron project_name service
openstack-config --set /etc/nova/nova.conf neutron username neutron
openstack-config --set /etc/nova/nova.conf neutron password 123
openstack-config --set /etc/nova/nova.conf neutron service_metadata_proxy True
openstack-config --set /etc/nova/nova.conf neutron metadata_proxy_shared_secret 123
```

- 修改后查看vi /etc/nova/nova.conf：
```
[DEFAULT]
enabled_apis = osapi_compute,metadata
auth_strategy = keystone
my_ip = 10.1.1.150
use_neutron = True
firewall_driver = nova.virt.firewall.NoopFirewallDriver


[database]
connection = mysql+pymysql://nova:123@controller1/nova


[api_database]
connection = mysql+pymysql://nova:123@controller1/nova_api


[oslo_messaging_rabbit]
rabbit_host = controller1
rabbit_port = 5672
rabbit_userid = openstack
rabbit_password = 123


[keystone_authtoken]
auth_uri = http://controller1:5000
auth_url = http://controller1:35357
memcached_servers = controller1:11211
auth_type = password
project_domain_name = default
user_domain_name = default
project_name = service
username = nova
password = 123


[vnc]
vncserver_listen = 10.1.1.150
vncserver_proxyclient_address = 10.1.1.150


[glance]
api_servers = http://controller1:9292


[oslo_concurrency]
lock_path = /var/lib/nova/tmp


[neutron]
url = http://controller1:9696
auth_url = http://controller1:35357
auth_plugin = password
project_domain_id = default
user_domain_id = default
region_name = RegionOne
project_name = service
username = neutron
password = 123
service_metadata_proxy = True
metadata_proxy_shared_secret = 123
```

13 .将dhcp-option-force=26,1450写入/etc/neutron/dnsmasq-neutron.conf

```
echo "dhcp-option-force=26,1450" >/etc/neutron/dnsmasq-neutron.conf
```

14 .配置/etc/neutron/metadata_agent.ini

```
openstack-config --set /etc/neutron/metadata_agent.ini DEFAULT nova_metadata_ip controller1
openstack-config --set /etc/neutron/metadata_agent.ini DEFAULT metadata_proxy_shared_secret 123
openstack-config --set /etc/neutron/metadata_agent.ini DEFAULT metadata_workers 4
openstack-config --set /etc/neutron/metadata_agent.ini DEFAULT verbose True
openstack-config --set /etc/neutron/metadata_agent.ini DEFAULT debug false
openstack-config --set /etc/neutron/metadata_agent.ini DEFAULT nova_metadata_protocol http
```

15 .创建硬链接

```
ln -s /etc/neutron/plugins/ml2/ml2_conf.ini /etc/neutron/plugin.ini
```

16 .同步数据库

```
su -s /bin/sh -c "neutron-db-manage --config-file /etc/neutron/neutron.conf --config-file /etc/neutron/plugins/ml2/ml2_conf.ini upgrade head" neutron
```

17 .重启nova服务，因为刚才改了nova.conf

```
systemctl restart openstack-nova-api.service
systemctl status openstack-nova-api.service
```

18 .重启neutron服务并设置开机启动

```
systemctl enable neutron-server.service neutron-linuxbridge-agent.service neutron-dhcp-agent.service neutron-metadata-agent.service
systemctl restart neutron-server.service neutron-linuxbridge-agent.service neutron-dhcp-agent.service neutron-metadata-agent.service
systemctl status neutron-server.service neutron-linuxbridge-agent.service neutron-dhcp-agent.service neutron-metadata-agent.service
```

19 .启动neutron-l3-agent.service并设置开机启动

```
systemctl enable neutron-l3-agent.service
systemctl start neutron-l3-agent.service
systemctl status neutron-l3-agent.service
```

20 .执行验证

```
source /root/admin-openrc
neutron ext-list
neutron agent-list
```

21 .创建vxLan模式网络，让虚拟机能外出

- a. 首先先执行环境变量

```
source /root/admin-openrc
```

- b. 创建flat模式的public网络，注意这个public是外出网络，必须是flat模式的

```
neutron --debug net-create --shared provider --router:external True --provider:network_type flat --provider:physical_network provider
```
- 执行完这步，在界面里进行操作，把public网络设置为共享和外部网络，创建后，结果为:
- c. 创建public网络子网，名为provider-sub，网段就是9.110.187，并且IP范围是50-90（这个一般是给VM用的floating IP了），dns设 置为8.8.8.8，网关为9.110.187.2

```
neutron subnet-create provider 9.110.187.0/24 --name provider-sub --allocation-pool start=9.110.187.50,end=9.110.187.90 --dns-nameserver 8.8.8.8 --gateway 9.110.187.2
```

- d. 创建名为private的私有网络, 网络模式为vxlan

```neutron net-create private --provider:network_type vxlan --router:external False --shared
```

- e. 创建名为private-subnet的私有网络子网，网段为192.168.1.0, 这个网段就是虚拟机获取的私有的IP地址

```
neutron subnet-create private --name private-subnet --gateway 192.168.1.1 192.168.1.0/24
```

- 假如你们公司的私有云环境是用于不同的业务，比如行政、销售、技术等，那么你可以创建3个不同名称的私有网络

```neutron net-create private-office --provider:network_type vxlan --router:external False --shared
neutron subnet-create private-office --name office-net --gateway 192.168.2.1 192.168.2.0/24
neutron net-create private-sale --provider:network_type vxlan --router:external False --shared # neutron subnet-create private-sale --name sale-net --gateway 192.168.3.1 192.168.3.0/24
neutron net-create private-technology --provider:network_type vxlan --router:external False --shared # neutron subnet-create private-technology --name technology-net --gateway 192.168.4.1 192.168.4.0/24
```

f. 创建路由，我们在界面上操作 点击项目-->网络-->路由-->新建路由

22 .检查网络服务

```
neutron agent-list
```
- 服务是否有笑脸

## 配置安装Dashboard

1 .安装dashboard相关软件包

```
yum install openstack-dashboard -y
```

2 .修改配置文件/etc/openstack-dashboard/local_settings

```
vim /etc/openstack-dashboard/local_settings
```


3 .启动dashboard服务并设置开机启动

```
systemctl enable httpd.service memcached.service
systemctl restart httpd.service memcached.service
systemctl status httpd.service memcached.service
```

## 配置安装Cinder

1 .创建数据库用户并赋予权限

```
CREATE DATABASE cinder;
GRANT ALL PRIVILEGES ON cinder.* TO 'cinder'@'localhost' IDENTIFIED BY '123';
GRANT ALL PRIVILEGES ON cinder.* TO 'cinder'@'%' IDENTIFIED BY '123';
```

2 .创建cinder用户并赋予admin权限

```
source /root/admin-openrc
openstack user create --domain default cinder --password 123
openstack role add --project service --user cinder admin
```

3 .创建volume服务

```
openstack service create --name cinder --description "OpenStack Block Storage" volume
openstack service create --name cinderv2 --description "OpenStack Block Storage" volumev2
```

4 .创建endpoint

```
openstack endpoint create --region RegionOne volume public http://controller1:8776/v1/%\(tenant_id\)s
openstack endpoint create --region RegionOne volume internal http://controller1:8776/v1/%\(tenant_id\)s
openstack endpoint create --region RegionOne volume admin http://controller1:8776/v1/%\(tenant_id\)s
openstack endpoint create --region RegionOne volumev2 public http://controller1:8776/v2/%\(tenant_id\)s
openstack endpoint create --region RegionOne volumev2 internal http://controller1:8776/v2/%\(tenant_id\)s
openstack endpoint create --region RegionOne volumev2 admin http://controller1:8776/v2/%\(tenant_id\)s
```

5 .安装cinder相关服务

```
yum install openstack-cinder -y
```

6 .配置cinder配置文件

```
cp /etc/cinder/cinder.conf /etc/cinder/cinder.conf.bak
>/etc/cinder/cinder.conf
openstack-config --set /etc/cinder/cinder.conf DEFAULT debug False
openstack-config --set /etc/cinder/cinder.conf DEFAULT verbose True
openstack-config --set /etc/cinder/cinder.conf DEFAULT my_ip 10.1.1.150
openstack-config --set /etc/cinder/cinder.conf DEFAULT osapi_volume_listen_port 8776
openstack-config --set /etc/cinder/cinder.conf DEFAULT auth_strategy keystone
openstack-config --set /etc/cinder/cinder.conf DEFAULT enable_v1_api True
openstack-config --set /etc/cinder/cinder.conf DEFAULT enable_v2_api True
openstack-config --set /etc/cinder/cinder.conf DEFAULT enable_v3_api True
openstack-config --set /etc/cinder/cinder.conf DEFAULT storage_availability_zone nova
openstack-config --set /etc/cinder/cinder.conf DEFAULT default_availability_zone nova
openstack-config --set /etc/cinder/cinder.conf DEFAULT service_down_time 180
openstack-config --set /etc/cinder/cinder.conf DEFAULT report_interval 10
openstack-config --set /etc/cinder/cinder.conf DEFAULT osapi_volume_workers 4
openstack-config --set /etc/cinder/cinder.conf database connection mysql+pymysql://cinder:123@controller1/cinder
openstack-config --set /etc/cinder/cinder.conf oslo_messaging_rabbit rabbit_host controller1
openstack-config --set /etc/cinder/cinder.conf oslo_messaging_rabbit rabbit_port 5672
openstack-config --set /etc/cinder/cinder.conf oslo_messaging_rabbit rabbit_userid openstack
openstack-config --set /etc/cinder/cinder.conf oslo_messaging_rabbit rabbit_password 123
openstack-config --set /etc/cinder/cinder.conf oslo_messaging_rabbit amqp_durable_queues False
openstack-config --set /etc/cinder/cinder.conf keystone_authtoken auth_uri http://controller1:5000
openstack-config --set /etc/cinder/cinder.conf keystone_authtoken auth_url http://controller1:35357
openstack-config --set /etc/cinder/cinder.conf keystone_authtoken memcached_servers controller1:11211
openstack-config --set /etc/cinder/cinder.conf keystone_authtoken auth_type password
openstack-config --set /etc/cinder/cinder.conf keystone_authtoken project_domain_name default
openstack-config --set /etc/cinder/cinder.conf keystone_authtoken user_domain_name default
openstack-config --set /etc/cinder/cinder.conf keystone_authtoken project_name service
openstack-config --set /etc/cinder/cinder.conf keystone_authtoken username cinder
openstack-config --set /etc/cinder/cinder.conf keystone_authtoken password 123
openstack-config --set /etc/cinder/cinder.conf oslo_concurrency lock_path /var/lib/cinder/tmp
```

- 修改后查看`vi /etc/cinder/cinder.conf：`

```
[DEFAULT]
debug = False
verbose = True
my_ip = 10.1.1.150
osapi_volume_listen_port = 8776
auth_strategy = keystone
enable_v1_api = True
enable_v2_api = True
enable_v3_api = True
storage_availability_zone = nova
default_availability_zone = nova
service_down_time = 180
report_interval = 10
osapi_volume_workers = 4


[database]
connection = mysql+pymysql://cinder:123@controller1/cinder


[oslo_messaging_rabbit]
rabbit_host = controller1
rabbit_port = 5672
rabbit_userid = openstack
rabbit_password = 123
amqp_durable_queues = False


[keystone_authtoken]
auth_uri = http://controller1:5000
auth_url = http://controller1:35357
memcached_servers = controller1:11211
auth_type = password
project_domain_name = default
user_domain_name = default
project_name = service
username = cinder
password = 123


[oslo_concurrency]
lock_path = /var/lib/cinder/tmp
```

7 .上同步数据库

```
su -s /bin/sh -c "cinder-manage db sync" cinder
```

8 .在controller上启动cinder服务，并设置开机启动

```
systemctl enable openstack-cinder-api.service openstack-cinder-scheduler.service
systemctl start openstack-cinder-api.service openstack-cinder-scheduler.service
systemctl status openstack-cinder-api.service openstack-cinder-scheduler.service
```


# Cinder
1 .安装Cinder节点，Cinder节点这里我们需要额外的添加一个硬盘（/dev/sdb)用作cinder的存储服务(注意！这一步是在cinder节点 操作的）

```
yum install lvm2 -y
```

2 .启动服务并设置为开机自启

```
systemctl enable lvm2-lvmetad.service
systemctl start lvm2-lvmetad.service
systemctl status lvm2-lvmetad.service
```

3 .创建lvm, 这里的/dev/sdb就是额外添加的硬盘

```
fdisk -l
pvcreate /dev/sdb
vgcreate cinder-volumes /dev/sdb
```

4 .编辑存储节点lvm.conf文件

```
vim /etc/lvm/lvm.conf
```
- 在devices 下面添加 filter = [ "a/sda/", "a/sdb/", "r/.*/"]
- 然后重启下lvm2服务：

```
systemctl restart lvm2-lvmetad.service
systemctl status lvm2-lvmetad.service
```

5 .安装openstack-cinder、targetcli

```
yum install openstack-cinder openstack-utils targetcli python-keystone ntpdate -y
```

6 .配置cinder配置文件

```
cp /etc/cinder/cinder.conf /etc/cinder/cinder.conf.bak
>/etc/cinder/cinder.conf
openstack-config --set /etc/cinder/cinder.conf DEFAULT debug False
openstack-config --set /etc/cinder/cinder.conf DEFAULT verbose True
openstack-config --set /etc/cinder/cinder.conf DEFAULT auth_strategy keystone
openstack-config --set /etc/cinder/cinder.conf DEFAULT my_ip 10.1.1.152
openstack-config --set /etc/cinder/cinder.conf DEFAULT enabled_backends lvm
openstack-config --set /etc/cinder/cinder.conf DEFAULT glance_api_servers http://controller1:9292
openstack-config --set /etc/cinder/cinder.conf DEFAULT glance_api_version 2
openstack-config --set /etc/cinder/cinder.conf DEFAULT enable_v1_api True
openstack-config --set /etc/cinder/cinder.conf DEFAULT enable_v2_api True
openstack-config --set /etc/cinder/cinder.conf DEFAULT enable_v3_api True
openstack-config --set /etc/cinder/cinder.conf DEFAULT storage_availability_zone nova
openstack-config --set /etc/cinder/cinder.conf DEFAULT default_availability_zone nova
openstack-config --set /etc/cinder/cinder.conf DEFAULT os_region_name RegionOne
openstack-config --set /etc/cinder/cinder.conf DEFAULT api_paste_config /etc/cinder/api-paste.ini
openstack-config --set /etc/cinder/cinder.conf oslo_messaging_rabbit rabbit_host controller1
openstack-config --set /etc/cinder/cinder.conf oslo_messaging_rabbit rabbit_port 5672
openstack-config --set /etc/cinder/cinder.conf oslo_messaging_rabbit rabbit_userid openstack
openstack-config --set /etc/cinder/cinder.conf oslo_messaging_rabbit rabbit_password 123
openstack-config --set /etc/cinder/cinder.conf database connection mysql+pymysql://cinder:123@controller1/cinder
openstack-config --set /etc/cinder/cinder.conf keystone_authtoken auth_uri http://controller1:5000
openstack-config --set /etc/cinder/cinder.conf keystone_authtoken auth_url http://controller1:35357
openstack-config --set /etc/cinder/cinder.conf keystone_authtoken memcached_servers controller1:11211
openstack-config --set /etc/cinder/cinder.conf keystone_authtoken auth_type password
openstack-config --set /etc/cinder/cinder.conf keystone_authtoken project_domain_name default
openstack-config --set /etc/cinder/cinder.conf keystone_authtoken user_domain_name default
openstack-config --set /etc/cinder/cinder.conf keystone_authtoken project_name service
openstack-config --set /etc/cinder/cinder.conf keystone_authtoken username cinder
openstack-config --set /etc/cinder/cinder.conf keystone_authtoken password 123
openstack-config --set /etc/cinder/cinder.conf lvm volume_driver cinder.volume.drivers.lvm.LVMVolumeDriver
openstack-config --set /etc/cinder/cinder.conf lvm volume_group cinder-volumes
openstack-config --set /etc/cinder/cinder.conf lvm iscsi_protocol iscsi
openstack-config --set /etc/cinder/cinder.conf lvm iscsi_helper lioadm
openstack-config --set /etc/cinder/cinder.conf oslo_concurrency lock_path /var/lib/cinder/tmp
```

- 修改后查看`vi /etc/cinder/cinder.conf：`

```
[DEFAULT]
debug = False
verbose = True
auth_strategy = keystone
my_ip = 10.1.1.152
enabled_backends = lvm
glance_api_servers = http://controller1:9292
glance_api_version = 2
enable_v1_api = True
enable_v2_api = True
enable_v3_api = True
storage_availability_zone = nova
default_availability_zone = nova
os_region_name = RegionOne
api_paste_config = /etc/cinder/api-paste.ini


[oslo_messaging_rabbit]
rabbit_host = controller1
rabbit_port = 5672
rabbit_userid = openstack
rabbit_password = 123


[database]
connection = mysql+pymysql://cinder:123@controller1/cinder


[keystone_authtoken]
auth_uri = http://controller1:5000
auth_url = http://controller1:35357
memcached_servers = controller1:11211
auth_type = password
project_domain_name = default
user_domain_name = default
project_name = service
username = cinder
password = 123


[lvm]
volume_driver = cinder.volume.drivers.lvm.LVMVolumeDriver
volume_group = cinder-volumes
iscsi_protocol = iscsi
iscsi_helper = lioadm


[oslo_concurrency]
lock_path = /var/lib/cinder/tmp
```

7 .启动openstack-cinder-volume和target并设置开机启动

```
systemctl enable openstack-cinder-volume.service target.service
systemctl restart openstack-cinder-volume.service target.service
systemctl status openstack-cinder-volume.service target.service
```

8 .返回Controller验证cinder服务是否正常

```
source /root/admin-openrc
cinder service-list
```

# Compute
## 安装相关依赖包

```
yum install openstack-selinux python-openstackclient yum-plugin-priorities openstack-nova-compute openstack-utils ntpdate -y
```

## 配置安装nova
1 .配置nova.conf

```
cp /etc/nova/nova.conf /etc/nova/nova.conf.bak
>/etc/nova/nova.conf
openstack-config --set /etc/nova/nova.conf DEFAULT debug False
openstack-config --set /etc/nova/nova.conf DEFAULT verbose True
openstack-config --set /etc/nova/nova.conf DEFAULT auth_strategy keystone
openstack-config --set /etc/nova/nova.conf DEFAULT my_ip 10.1.1.151
openstack-config --set /etc/nova/nova.conf DEFAULT use_neutron True
openstack-config --set /etc/nova/nova.conf DEFAULT firewall_driver nova.virt.firewall.NoopFirewallDriver
openstack-config --set /etc/nova/nova.conf oslo_messaging_rabbit rabbit_host controller1
openstack-config --set /etc/nova/nova.conf oslo_messaging_rabbit rabbit_port 5672
openstack-config --set /etc/nova/nova.conf oslo_messaging_rabbit rabbit_userid openstack
openstack-config --set /etc/nova/nova.conf oslo_messaging_rabbit rabbit_password 123
openstack-config --set /etc/nova/nova.conf keystone_authtoken auth_uri http://controller1:5000
openstack-config --set /etc/nova/nova.conf keystone_authtoken auth_url http://controller1:35357
openstack-config --set /etc/nova/nova.conf keystone_authtoken memcached_servers controller1:11211
openstack-config --set /etc/nova/nova.conf keystone_authtoken auth_type password
openstack-config --set /etc/nova/nova.conf keystone_authtoken project_domain_name default
openstack-config --set /etc/nova/nova.conf keystone_authtoken user_domain_name default
openstack-config --set /etc/nova/nova.conf keystone_authtoken project_name service
openstack-config --set /etc/nova/nova.conf keystone_authtoken username nova
openstack-config --set /etc/nova/nova.conf keystone_authtoken password 123
openstack-config --set /etc/nova/nova.conf vnc enabled True
openstack-config --set /etc/nova/nova.conf vnc keymap en-us
openstack-config --set /etc/nova/nova.conf vnc vncserver_listen 0.0.0.0
openstack-config --set /etc/nova/nova.conf vnc vncserver_proxyclient_address 10.1.1.151
openstack-config --set /etc/nova/nova.conf vnc novncproxy_base_url http://10.1.1.150:6080/vnc_auto.html
openstack-config --set /etc/nova/nova.conf glance api_servers http://controller1:9292
openstack-config --set /etc/nova/nova.conf oslo_concurrency lock_path /var/lib/nova/tmp
openstack-config --set /etc/nova/nova.conf libvirt virt_type qemu
```

- 修改后查看`vi /etc/nova/nova.conf：`
```
[DEFAULT]
debug = False
verbose = True
auth_strategy = keystone
my_ip = 10.1.1.151
use_neutron = True
firewall_driver = nova.virt.firewall.NoopFirewallDriver


[oslo_messaging_rabbit]
rabbit_host = controller1
rabbit_port = 5672
rabbit_userid = openstack
rabbit_password = 123


[keystone_authtoken]
auth_uri = http://controller1:5000
auth_url = http://controller1:35357
memcached_servers = controller1:11211
auth_type = password
project_domain_name = default
user_domain_name = default
project_name = service
username = nova
password = 123


[vnc]
enabled = True
keymap = en-us
vncserver_listen = 0.0.0.0
vncserver_proxyclient_address = 10.1.1.151
novncproxy_base_url = http://10.1.1.150:6080/vnc_auto.html


[glance]
api_servers = http://controller1:9292


[oslo_concurrency]
lock_path = /var/lib/nova/tmp


[libvirt]
virt_type = qemu
```

2 .设置libvirtd.service 和openstack-nova-compute.service开机启动

```
systemctl enable libvirtd.service openstack-nova-compute.service
systemctl restart libvirtd.service openstack-nova-compute.service
systemctl status libvirtd.service openstack-nova-compute.service
```

3 .添加环境变量

```
cat <<END >/root/admin-openrc
export OS_PROJECT_DOMAIN_NAME=default
export OS_USER_DOMAIN_NAME=default
export OS_PROJECT_NAME=admin
export OS_USERNAME=admin
export OS_PASSWORD=123
export OS_AUTH_URL=http://controller1:35357/v3
export OS_IDENTITY_API_VERSION=3
END

cat <<END >/root/demo-openrc
export OS_PROJECT_DOMAIN_NAME=default
export OS_USER_DOMAIN_NAME=default
export OS_PROJECT_NAME=demo
export OS_USERNAME=demo
export OS_PASSWORD=123
export OS_AUTH_URL=http://controller1:5000/v3 export OS_IDENTITY_API_VERSION=3
END
```

4 .验证

```
source /root/admin-openrc
openstack compute service list
```

## 配置安装Neutron

1 .安装相关软件包

```
yum install openstack-neutron-linuxbridge ebtables ipset -y
```

2 .配置neutron.conf

```
cp /etc/neutron/neutron.conf /etc/neutron/neutron.conf.bak
>/etc/neutron/neutron.conf
openstack-config --set /etc/neutron/neutron.conf DEFAULT debug False
openstack-config --set /etc/neutron/neutron.conf DEFAULT verbose True
openstack-config --set /etc/neutron/neutron.conf DEFAULT auth_strategy keystone
openstack-config --set /etc/neutron/neutron.conf DEFAULT advertise_mtu True
openstack-config --set /etc/neutron/neutron.conf DEFAULT dhcp_agents_per_network 2
openstack-config --set /etc/neutron/neutron.conf DEFAULT control_exchange neutron
openstack-config --set /etc/neutron/neutron.conf DEFAULT nova_url http://controller1:8774/v2
openstack-config --set /etc/neutron/neutron.conf oslo_messaging_rabbit rabbit_host controller1
openstack-config --set /etc/neutron/neutron.conf oslo_messaging_rabbit rabbit_port 5672
openstack-config --set /etc/neutron/neutron.conf oslo_messaging_rabbit rabbit_userid openstack
openstack-config --set /etc/neutron/neutron.conf oslo_messaging_rabbit rabbit_password 123
openstack-config --set /etc/neutron/neutron.conf keystone_authtoken auth_uri http://controller1:5000
openstack-config --set /etc/neutron/neutron.conf keystone_authtoken auth_url http://controller1:35357
openstack-config --set /etc/neutron/neutron.conf keystone_authtoken memcached_servers controller1:11211
openstack-config --set /etc/neutron/neutron.conf keystone_authtoken auth_type password
openstack-config --set /etc/neutron/neutron.conf keystone_authtoken project_domain_name default
openstack-config --set /etc/neutron/neutron.conf keystone_authtoken user_domain_name default
openstack-config --set /etc/neutron/neutron.conf keystone_authtoken project_name service
openstack-config --set /etc/neutron/neutron.conf keystone_authtoken username neutron
openstack-config --set /etc/neutron/neutron.conf keystone_authtoken password 123
openstack-config --set /etc/neutron/neutron.conf oslo_concurrency lock_path /var/lib/neutron/tmp
```

- 修改后查看：`vi /etc/neutron/neutron.conf`

```
[DEFAULT]
debug = False
verbose = True
auth_strategy = keystone
advertise_mtu = True
dhcp_agents_per_network = 2
control_exchange = neutron
nova_url = http://controller1:8774/v2


[oslo_messaging_rabbit]
rabbit_host = controller1
rabbit_port = 5672
rabbit_userid = openstack
rabbit_password = 123


[keystone_authtoken]
auth_uri = http://controller1:5000
auth_url = http://controller1:35357
memcached_servers = controller1:11211
auth_type = password
project_domain_name = default
user_domain_name = default
project_name = service
username = neutron
password = 123


[oslo_concurrency]
lock_path = /var/lib/neutron/tmp
```

3 .配置/etc/neutron/plugins/ml2/linuxbridge_agent.ini

```
openstack-config --set /etc/neutron/plugins/ml2/linuxbridge_agent.ini linux_bridge physical_interface_mappings provider:eno16777736
openstack-config --set /etc/neutron/plugins/ml2/linuxbridge_agent.ini vxlan enable_vxlan True
openstack-config --set /etc/neutron/plugins/ml2/linuxbridge_agent.ini vxlan local_ip 10.2.2.151
openstack-config --set /etc/neutron/plugins/ml2/linuxbridge_agent.ini vxlan l2_population True
openstack-config --set /etc/neutron/plugins/ml2/linuxbridge_agent.ini securitygroup enable_security_group True
openstack-config --set /etc/neutron/plugins/ml2/linuxbridge_agent.ini securitygroup firewall_driver neutron.agent.linux.iptables_firewall.IptablesFirewallDriver
```
- 注意 provider后面那个网卡名是第一块网卡的名称。

4 .配置nova.conf

```
openstack-config --set /etc/nova/nova.conf neutron url http://controller1:9696
openstack-config --set /etc/nova/nova.conf neutron auth_url http://controller1:35357
openstack-config --set /etc/nova/nova.conf neutron auth_type password
openstack-config --set /etc/nova/nova.conf neutron project_domain_name default
openstack-config --set /etc/nova/nova.conf neutron user_domain_name default
openstack-config --set /etc/nova/nova.conf neutron region_name RegionOne
openstack-config --set /etc/nova/nova.conf neutron project_name service
openstack-config --set /etc/nova/nova.conf neutron username neutron
openstack-config --set /etc/nova/nova.conf neutron password 123
```

5 .重启和enable neutron-linuxbridge-agent服务

```
systemctl restart libvirtd.service openstack-nova-compute.service
systemctl enable neutron-linuxbridge-agent.service
systemctl restart neutron-linuxbridge-agent.service
systemctl status libvirtd.service openstack-nova-compute.service neutron-linuxbridge-agent.service
```


## 配置安装Cinder

1 .计算节点要是想用cinder,那么需要配置nova配置文件(注意！这一步是在计算节点操作的）

```
openstack-config --set /etc/nova/nova.conf cinder os_region_name RegionOne
systemctl restart libvirtd.service openstack-nova-compute.service
```

2 .然后在controller上重启nova服务

```
systemctl restart openstack-nova-api.service
systemctl status openstack-nova-api.service
```

## 验证

```
source /root/admin-openrc
neutron ext-list
neutron agent-list
```

- 到此，Compute节点搭建完毕，运行nova host-list可以查看新加入的compute1节点 如果需要再添加另外一个compute节点，只要重复下第二大部即可，记得把计算机名和IP地址改下。


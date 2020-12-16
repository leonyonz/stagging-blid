---
layout: post
title: 'Openstack: Floating IP via CLI'
featured: true
date: '2020-11-07 11:05:37'
tags:
- openstack
---

[Belajar Linux ID](/) - Tutorial kali ini kita akan mencoba melakukan management floating di Openstack melalui CLI.

Sebelumnya kita telah membuat instance via CLI yang dapat Anda lihat pada link berikut: _[Openstack: Membuat Instance via CLI](/openstack-membuat-instance-via-cli/)_

Silakan cek list instance Anda saat ini, gunakan perintah berikut

<!--kg-card-begin: markdown-->

    [root@hamim-controller ~(keystone_admin)]#
    [root@hamim-controller ~(keystone_admin)]# openstack server list
    +--------------------------------------+--------------+--------+----------------------------------------+---------------------+----------+
    | ID | Name | Status | Networks | Image | Flavor |
    +--------------------------------------+--------------+--------+----------------------------------------+---------------------+----------+
    | a660e97c-b1a4-4c39-967c-f15f4d7df70b | my-instance1 | ACTIVE | net-internal1=192.168.1.101 | CentOS7 | m1.small |
    | d9e43fc3-5f43-4507-abd2-d74d7744dc1b | my-instance | ACTIVE | net-int=192.168.10.116, 10.136.136.112 | cirros-0.5.1-x86_64 | m1.tiny |
    +--------------------------------------+--------------+--------+----------------------------------------+---------------------+----------+
    [root@hamim-controller ~(keystone_admin)]#

<!--kg-card-end: markdown-->

Terlihat diatas untuk instance dengan OS CentOS 7 masih belum memiliki ip `floating`, ip `floating` ini dapat juga disebut dengan ip `public` nya si `instance`, dan untuk membuat `floating ip`, gunakan perintah berikut

<!--kg-card-begin: markdown-->

    [root@hamim-controller ~(keystone_admin)]#
    [root@hamim-controller ~(keystone_admin)]# openstack floating ip create net-ext
    +---------------------+--------------------------------------+
    | Field | Value |
    +---------------------+--------------------------------------+
    | created_at | 2020-09-24T12:34:17Z |
    | description | |
    | fixed_ip_address | None |
    | floating_ip_address | 10.136.136.119 |
    | floating_network_id | b077b37f-c38a-4759-b504-bbf4f91d3e94 |
    | id | 3ed8629a-93f2-47f1-ae43-7e84155158da |
    | name | 10.136.136.119 |
    | port_id | None |
    | project_id | 99f200eba89b49a9b89a981ec76813e1 |
    | qos_policy_id | None |
    | revision_number | 0 |
    | router_id | None |
    | status | DOWN |
    | subnet_id | None |
    | updated_at | 2020-09-24T12:34:17Z |
    +---------------------+--------------------------------------+
    [root@hamim-controller ~(keystone_admin)]#

<!--kg-card-end: markdown-->

Sekarang cek list `floating ip` nya kembali

<!--kg-card-begin: markdown-->

    
    [root@hamim-controller ~(keystone_admin)]# openstack floating ip list
    +--------------------------------------+---------------------+------------------+--------------------------------------+--------------------------------------+----------------------------------+
    | ID | Floating IP Address | Fixed IP Address | Port | Floating Network | Project |
    +--------------------------------------+---------------------+------------------+--------------------------------------+--------------------------------------+----------------------------------+
    | 3ed8629a-93f2-47f1-ae43-7e84155158da | 10.136.136.119 | None | None | b077b37f-c38a-4759-b504-bbf4f91d3e94 | 99f200eba89b49a9b89a981ec76813e1 |
    | 6875c706-2191-4fb2-94e9-c1ee666bba98 | 10.136.136.112 | 192.168.10.116 | 0a3cec5f-0a92-4405-9552-77c4a39e3a45 | b077b37f-c38a-4759-b504-bbf4f91d3e94 | 99f200eba89b49a9b89a981ec76813e1 |
    +--------------------------------------+---------------------+------------------+--------------------------------------+--------------------------------------+----------------------------------+
    [root@hamim-controller ~(keystone_admin)]#

<!--kg-card-end: markdown-->

Diatas terlihat untuk floating yang baru kita buat masih belum di assign ke instance CentOS 7 Anda.

Untuk assign atau menambahkan floating ip ke instance gunakan perintah berikut

<!--kg-card-begin: markdown-->

    [root@hamim-controller ~(keystone_admin)]#
    [root@hamim-controller ~(keystone_admin)]# openstack server add floating ip my-instance1 10.136.136.119
    [root@hamim-controller ~(keystone_admin)]#

<!--kg-card-end: markdown-->

Sekarang silakan cek instance Anda kembali

<!--kg-card-begin: markdown-->

    [root@hamim-controller ~(keystone_admin)]#
    [root@hamim-controller ~(keystone_admin)]# openstack server list
    +--------------------------------------+--------------+--------+---------------------------------------------+---------------------+----------+
    | ID | Name | Status | Networks | Image | Flavor |
    +--------------------------------------+--------------+--------+---------------------------------------------+---------------------+----------+
    | a660e97c-b1a4-4c39-967c-f15f4d7df70b | my-instance1 | ACTIVE | net-internal1=192.168.1.101, 10.136.136.119 | CentOS7 | m1.small |
    | d9e43fc3-5f43-4507-abd2-d74d7744dc1b | my-instance | ACTIVE | net-int=192.168.10.116, 10.136.136.112 | cirros-0.5.1-x86_64 | m1.tiny |
    +--------------------------------------+--------------+--------+---------------------------------------------+---------------------+----------+
    [root@hamim-controller ~(keystone_admin)]#

<!--kg-card-end: markdown-->

Terlihat diatas instance `my-instance1` dengan OS CentOS 7 sudah menggunakan `floating IP`, silakan cek list dari `floating ip`, gunakan perintah berikut

<!--kg-card-begin: markdown-->

    [root@hamim-controller ~(keystone_admin)]#
    [root@hamim-controller ~(keystone_admin)]# openstack floating ip list
    +--------------------------------------+---------------------+------------------+--------------------------------------+--------------------------------------+----------------------------------+
    | ID | Floating IP Address | Fixed IP Address | Port | Floating Network | Project |
    +--------------------------------------+---------------------+------------------+--------------------------------------+--------------------------------------+----------------------------------+
    | 3ed8629a-93f2-47f1-ae43-7e84155158da | 10.136.136.119 | 192.168.1.101 | 197af39b-5072-43ba-b727-178fcf55b881 | b077b37f-c38a-4759-b504-bbf4f91d3e94 | 99f200eba89b49a9b89a981ec76813e1 |
    | 6875c706-2191-4fb2-94e9-c1ee666bba98 | 10.136.136.112 | 192.168.10.116 | 0a3cec5f-0a92-4405-9552-77c4a39e3a45 | b077b37f-c38a-4759-b504-bbf4f91d3e94 | 99f200eba89b49a9b89a981ec76813e1 |
    +--------------------------------------+---------------------+------------------+--------------------------------------+--------------------------------------+----------------------------------+
    [root@hamim-controller ~(keystone_admin)]#

<!--kg-card-end: markdown-->

Selanjutnya kita coba ping ke floating IP dan test login ke sisi instance menggunakan floating IP

<!--kg-card-begin: markdown-->

    [root@hamim-controller ~(keystone_admin)]#
    [root@hamim-controller ~(keystone_admin)]# ping 10.136.136.119 -c3 |grep icmp
    64 bytes from 10.136.136.119: icmp_seq=1 ttl=63 time=10.9 ms
    64 bytes from 10.136.136.119: icmp_seq=2 ttl=63 time=8.93 ms
    64 bytes from 10.136.136.119: icmp_seq=3 ttl=63 time=4.24 ms
    [root@hamim-controller ~(keystone_admin)]#
    
    [root@hamim-controller ~(keystone_admin)]#
    [root@hamim-controller ~(keystone_admin)]# ssh -l centos 10.136.136.119
    The authenticity of host '10.136.136.119 (10.136.136.119)' can't be established.
    ECDSA key fingerprint is SHA256:0JxtUKc7ksE7bEDfAPa4Hsoc/2fpxobWUpSixmAA6AA.
    ECDSA key fingerprint is MD5:0a:bc:91:c5:37:47:e3:d6:86:3b:87:2e:21:9e:f6:f9.
    Are you sure you want to continue connecting (yes/no)? yes
    Warning: Permanently added '10.136.136.119' (ECDSA) to the list of known hosts.
    [centos@my-instance1 ~]$

<!--kg-card-end: markdown-->

Cek IP instance

<!--kg-card-begin: markdown-->

    [centos@my-instance1 ~]$
    [centos@my-instance1 ~]$ ip a
    1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1000
        link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
        inet 127.0.0.1/8 scope host lo
           valid_lft forever preferred_lft forever
        inet6 ::1/128 scope host
           valid_lft forever preferred_lft forever
    2: eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1450 qdisc pfifo_fast state UP group default qlen 1000
        link/ether fa:16:3e:c8:cd:44 brd ff:ff:ff:ff:ff:ff
        inet 192.168.1.101/24 brd 192.168.1.255 scope global dynamic eth0
           valid_lft 86015sec preferred_lft 86015sec
        inet6 fe80::f816:3eff:fec8:cd44/64 scope link
           valid_lft forever preferred_lft forever
    [centos@my-instance1 ~]$

<!--kg-card-end: markdown-->

Selamat mencoba 😄


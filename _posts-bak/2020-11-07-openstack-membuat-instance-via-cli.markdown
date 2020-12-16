---
layout: post
title: 'Openstack: Membuat Instance via CLI'
featured: true
date: '2020-11-07 10:39:16'
tags:
- openstack
---

[Belajar Linux ID](/) - Pada tutorial kali ini kita akan membuat instance atau VM di openstack melalui CLI. Untuk mengikuti tutorial kali ini kiranya Anda sudah mengikuti tahapan - yang sudah kami lakukan sebelumnya berikut:

- [Openstack: Membuat Image via CLI](/openstack-membuat-image-via-cli/)
- [Openstack: Membuat Network via CLI](/openstack-membuat-network-via-cli/)
- [Openstack: Membuat Router via CLI](/openstack-membuat-router-via-cli/)
- [Openstack: Membuat SSH Key via CLI](/openstack-menambahkan-secu/)
- [Openstack: Membuat Security Group via CLI](/openstack-membuat-security-group-via-cli/)

Pertama silakan lihat insstance yang ada saat ini menggunakan perintah berikut

<!--kg-card-begin: markdown-->

    [root@hamim-controller ~(keystone_admin)]#
    [root@hamim-controller ~(keystone_admin)]# openstack server list
    +--------------------------------------+-------------+--------+----------------------------------------+---------------------+---------+
    | ID | Name | Status | Networks | Image | Flavor |
    +--------------------------------------+-------------+--------+----------------------------------------+---------------------+---------+
    | d9e43fc3-5f43-4507-abd2-d74d7744dc1b | my-instance | ACTIVE | net-int=192.168.10.116, 10.136.136.112 | cirros-0.5.1-x86_64 | m1.tiny |
    +--------------------------------------+-------------+--------+----------------------------------------+---------------------+---------+
    [root@hamim-controller ~(keystone_admin)]#

<!--kg-card-end: markdown-->

Cek `flavor` yang tersedia yang dapat Anda gunakan

<!--kg-card-begin: markdown-->

    [root@hamim-controller ~(keystone_admin)]#
    [root@hamim-controller ~(keystone_admin)]# openstack flavor list
    +----+-----------+-------+------+-----------+-------+-----------+
    | ID | Name | RAM | Disk | Ephemeral | VCPUs | Is Public |
    +----+-----------+-------+------+-----------+-------+-----------+
    | 1 | m1.tiny | 512 | 1 | 0 | 1 | True |
    | 2 | m1.small | 2048 | 20 | 0 | 1 | True |
    | 3 | m1.medium | 4096 | 40 | 0 | 2 | True |
    | 4 | m1.large | 8192 | 80 | 0 | 4 | True |
    | 5 | m1.xlarge | 16384 | 160 | 0 | 8 | True |
    +----+-----------+-------+------+-----------+-------+-----------+
    [root@hamim-controller ~(keystone_admin)]#

<!--kg-card-end: markdown-->

Cek `images` yang tersedia yang akan kita gunakan nantinya

<!--kg-card-begin: markdown-->

    [root@hamim-controller ~(keystone_admin)]#
    [root@hamim-controller ~(keystone_admin)]# openstack image list
    +--------------------------------------+---------------------+--------+
    | ID | Name | Status |
    +--------------------------------------+---------------------+--------+
    | 6dc06b96-e0ff-4755-aa70-0fec3a05a856 | CentOS7 | active |
    | 95300085-0483-4a77-800a-1f3ed015a6a7 | cirros-0.5.1-x86_64 | active |
    | 3a132731-4f54-409c-bafe-121010959fe5 | cirros1 | active |
    +--------------------------------------+---------------------+--------+
    [root@hamim-controller ~(keystone_admin)]#

<!--kg-card-end: markdown-->

Cek `security group` yang tersedia dan yang akan kita gunakan

<!--kg-card-begin: markdown-->

    [root@hamim-controller ~(keystone_admin)]#
    [root@hamim-controller ~(keystone_admin)]# openstack security group list
    +--------------------------------------+--------------+--------------------------------+----------------------------------+
    | ID | Name | Description | Project |
    +--------------------------------------+--------------+--------------------------------+----------------------------------+
    | 5d87fad1-7c30-43f4-89d5-7bea156e8264 | default | Default security group | |
    | 991d8ef1-92e2-498f-a52d-86e6c696a9fe | my-secgroup | | 99f200eba89b49a9b89a981ec76813e1 |
    | ce2832a6-5c9c-4174-a6ca-e5012b64a0b2 | default | Default security group | e44ffd73356643e4b5a7519f99d66168 |
    | e7359ca3-efe1-4792-b854-3166aceb9312 | my-secgroup1 | Security Group dibuat dari CLI | 99f200eba89b49a9b89a981ec76813e1 |
    | f9e24b05-046b-4c44-afa4-d8a6a3e407ff | default | Default security group | 99f200eba89b49a9b89a981ec76813e1 |
    +--------------------------------------+--------------+--------------------------------+----------------------------------+
    [root@hamim-controller ~(keystone_admin)]#

<!--kg-card-end: markdown-->

Cek `keypair` yang akan digunakan

<!--kg-card-begin: markdown-->

    [root@hamim-controller ~(keystone_admin)]#
    [root@hamim-controller ~(keystone_admin)]# openstack keypair list
    +-------------+-------------------------------------------------+
    | Name | Fingerprint |
    +-------------+-------------------------------------------------+
    | my-keypair | f4:64:ec:96:37:6b:46:52:6a:3e:0f:f6:51:e1:67:d7 |
    | my-keypair1 | f4:64:ec:96:37:6b:46:52:6a:3e:0f:f6:51:e1:67:d7 |
    +-------------+-------------------------------------------------+
    [root@hamim-controller ~(keystone_admin)]#

<!--kg-card-end: markdown-->

Cek `network` yang akan kita gunakan

<!--kg-card-begin: markdown-->

    [root@hamim-controller ~(keystone_admin)]#
    [root@hamim-controller ~(keystone_admin)]# openstack network list
    +--------------------------------------+---------------+--------------------------------------+
    | ID | Name | Subnets |
    +--------------------------------------+---------------+--------------------------------------+
    | 4517136f-2436-41ba-a7c3-b973e65bd54a | net-internal1 | 132a0c29-9cba-4451-b24c-619fbe700181 |
    | a747188f-09de-496d-95a4-908d7d6262e6 | net-int | 0e627d43-60fe-4a49-bfc6-3baec80087e1 |
    | b077b37f-c38a-4759-b504-bbf4f91d3e94 | net-ext | 43e2a1a6-3920-437e-8f4f-60f04a3cab91 |
    +--------------------------------------+---------------+--------------------------------------+
    [root@hamim-controller ~(keystone_admin)]#

<!--kg-card-end: markdown-->

Dari informasi diatas Anda dapat membuat instance dengan satu baris perintah, sebagai contoh disini kami akan membuat instance dengan OS `CentOS 7`, keypair nya `my-keypair1`, security yang digunakan `my-secgroup1` dan silkan tentukan ID network yang ingin Anda gunakan.

<!--kg-card-begin: markdown-->

    [root@hamim-controller ~(keystone_admin)]#
    [root@hamim-controller ~(keystone_admin)]# openstack server create --flavor m1.small --image CentOS7 --key-name my-keypair1 --security-group my-secgroup1 --nic net-id=4517136f-2436-41ba-a7c3-b973e65bd54a my-instance1
    +-------------------------------------+------------------------------------------------+
    | Field | Value |
    +-------------------------------------+------------------------------------------------+
    | OS-DCF:diskConfig | MANUAL |
    | OS-EXT-AZ:availability_zone | |
    | OS-EXT-SRV-ATTR:host | None |
    | OS-EXT-SRV-ATTR:hypervisor_hostname | None |
    | OS-EXT-SRV-ATTR:instance_name | |
    | OS-EXT-STS:power_state | NOSTATE |
    | OS-EXT-STS:task_state | scheduling |
    | OS-EXT-STS:vm_state | building |
    | OS-SRV-USG:launched_at | None |
    | OS-SRV-USG:terminated_at | None |
    | accessIPv4 | |
    | accessIPv6 | |
    | addresses | |
    | adminPass | 2E3b4Yam4oDa |
    | config_drive | |
    | created | 2020-09-24T12:31:37Z |
    | flavor | m1.small (2) |
    | hostId | |
    | id | a660e97c-b1a4-4c39-967c-f15f4d7df70b |
    | image | CentOS7 (6dc06b96-e0ff-4755-aa70-0fec3a05a856) |
    | key_name | my-keypair1 |
    | name | my-instance1 |
    | progress | 0 |
    | project_id | 99f200eba89b49a9b89a981ec76813e1 |
    | properties | |
    | security_groups | name='e7359ca3-efe1-4792-b854-3166aceb9312' |
    | status | BUILD |
    | updated | 2020-09-24T12:31:37Z |
    | user_id | daf28d3fbc554e69903f5cba7f9e242c |
    | volumes_attached | |
    +-------------------------------------+------------------------------------------------+
    [root@hamim-controller ~(keystone_admin)]#

<!--kg-card-end: markdown-->

Jika sudah berhasil, silakan cek list instance kembali jika berhasil dibuat akan tampil seperti berikut ini

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

Selamat mencoba 😄


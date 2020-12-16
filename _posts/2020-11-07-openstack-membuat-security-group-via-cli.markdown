---
layout: post
title: 'Openstack: Membuat Security Group via CLI'
featured: true
date: '2020-11-07 10:19:43'
tags:
- openstack
---

[Belajar Linux ID](/) - &nbsp;Tutorial kali ini kita akan mencoba membuat security group melalui CLI.

Bagi Anda yang ingin membuat security group melalui horizon atau dashboard openstack dapat merujuk pada link berikut: _[Openstack: Menambah dan Menggunakan Security Group](/openstack-menambahkan-dan-menggunakan-security-group/)_

Mari kita lihat security group yang kita miliki terlebih saat ini, gunakan perintah berikut

<!--kg-card-begin: markdown-->

    [root@hamim-controller ~(keystone_admin)]#
    [root@hamim-controller ~(keystone_admin)]# openstack security group list
    +--------------------------------------+-------------+------------------------+----------------------------------+
    | ID | Name | Description | Project |
    +--------------------------------------+-------------+------------------------+----------------------------------+
    | 5d87fad1-7c30-43f4-89d5-7bea156e8264 | default | Default security group | |
    | 991d8ef1-92e2-498f-a52d-86e6c696a9fe | my-secgroup | | 99f200eba89b49a9b89a981ec76813e1 |
    | ce2832a6-5c9c-4174-a6ca-e5012b64a0b2 | default | Default security group | e44ffd73356643e4b5a7519f99d66168 |
    | f9e24b05-046b-4c44-afa4-d8a6a3e407ff | default | Default security group | 99f200eba89b49a9b89a981ec76813e1 |
    +--------------------------------------+-------------+------------------------+----------------------------------+
    [root@hamim-controller ~(keystone_admin)]#

<!--kg-card-end: markdown-->

Sekarang kita akan mencoba membuat security group baru dengan nama security group `my-secgroup1`, seperti berikut

<!--kg-card-begin: markdown-->

    [root@hamim-controller ~(keystone_admin)]#
    [root@hamim-controller ~(keystone_admin)]# openstack security group create my-secgroup1 --description 'Security Group dibuat dari CLI'
    +-----------------+-------------------------------------------------------------------------------------------------------------------------------------------------------+
    | Field | Value |
    +-----------------+-------------------------------------------------------------------------------------------------------------------------------------------------------+
    | created_at | 2020-09-24T12:20:13Z |
    | description | Security Group dibuat dari CLI |
    | id | e7359ca3-efe1-4792-b854-3166aceb9312 |
    | name | my-secgroup1 |
    | project_id | 99f200eba89b49a9b89a981ec76813e1 |
    | revision_number | 2 |
    | rules | created_at='2020-09-24T12:20:13Z', direction='egress', ethertype='IPv4', id='6f69e38c-5c2d-419e-b17d-8807a7b07707', updated_at='2020-09-24T12:20:13Z' |
    | | created_at='2020-09-24T12:20:13Z', direction='egress', ethertype='IPv6', id='efe50892-5caf-495c-83d2-3b348317a04e', updated_at='2020-09-24T12:20:13Z' |
    | updated_at | 2020-09-24T12:20:13Z |
    +-----------------+-------------------------------------------------------------------------------------------------------------------------------------------------------+
    [root@hamim-controller ~(keystone_admin)]#

<!--kg-card-end: markdown-->

command diatas terdapat `--description` yang mengartikan deskripsi dari security group yang Anda buat.

Jika sudah berhasil dibuat, cek list security group saat ini

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

Untuk melihat rule list dari security group yang kita buat, gunakan perintah berikut

<!--kg-card-begin: markdown-->

    [root@hamim-controller ~(keystone_admin)]#
    [root@hamim-controller ~(keystone_admin)]# openstack security group rule list my-secgroup1
    +--------------------------------------+-------------+----------+------------+-----------------------+
    | ID | IP Protocol | IP Range | Port Range | Remote Security Group |
    +--------------------------------------+-------------+----------+------------+-----------------------+
    | 6f69e38c-5c2d-419e-b17d-8807a7b07707 | None | None | | None |
    | efe50892-5caf-495c-83d2-3b348317a04e | None | None | | None |
    +--------------------------------------+-------------+----------+------------+-----------------------+
    [root@hamim-controller ~(keystone_admin)]#

<!--kg-card-end: markdown-->

Jika Anda ingin membuat rule security group misal menambahkan rule `icmp` di dalam security group, gunakan perintah

<!--kg-card-begin: markdown-->

    [root@hamim-controller ~(keystone_admin)]#
    [root@hamim-controller ~(keystone_admin)]# openstack security group rule create --proto icmp my-secgroup1
    +-------------------+--------------------------------------+
    | Field | Value |
    +-------------------+--------------------------------------+
    | created_at | 2020-09-24T12:22:50Z |
    | description | |
    | direction | ingress |
    | ether_type | IPv4 |
    | id | 580e0d5a-5bd1-4236-bb82-4c677ad23ba0 |
    | name | None |
    | port_range_max | None |
    | port_range_min | None |
    | project_id | 99f200eba89b49a9b89a981ec76813e1 |
    | protocol | icmp |
    | remote_group_id | None |
    | remote_ip_prefix | 0.0.0.0/0 |
    | revision_number | 0 |
    | security_group_id | e7359ca3-efe1-4792-b854-3166aceb9312 |
    | updated_at | 2020-09-24T12:22:50Z |
    +-------------------+--------------------------------------+
    [root@hamim-controller ~(keystone_admin)]#

<!--kg-card-end: markdown-->

Misal kita ingin menambahkan rule security group untuk ssh, seperti berikut

<!--kg-card-begin: markdown-->

    [root@hamim-controller ~(keystone_admin)]#
    [root@hamim-controller ~(keystone_admin)]# openstack security group rule create --proto tcp --dst-port 22 my-secgroup1
    +-------------------+--------------------------------------+
    | Field | Value |
    +-------------------+--------------------------------------+
    | created_at | 2020-09-24T12:23:36Z |
    | description | |
    | direction | ingress |
    | ether_type | IPv4 |
    | id | cd22de42-a5e7-4396-8bed-e7b382f573b5 |
    | name | None |
    | port_range_max | 22 |
    | port_range_min | 22 |
    | project_id | 99f200eba89b49a9b89a981ec76813e1 |
    | protocol | tcp |
    | remote_group_id | None |
    | remote_ip_prefix | 0.0.0.0/0 |
    | revision_number | 0 |
    | security_group_id | e7359ca3-efe1-4792-b854-3166aceb9312 |
    | updated_at | 2020-09-24T12:23:36Z |
    +-------------------+--------------------------------------+
    [root@hamim-controller ~(keystone_admin)]#

<!--kg-card-end: markdown-->

Untuk melihat list rule security group yang sudah kita buat diatas, gunakan perintah berikut

<!--kg-card-begin: markdown-->

    [root@hamim-controller ~(keystone_admin)]#
    [root@hamim-controller ~(keystone_admin)]# openstack security group rule list my-secgroup1
    +--------------------------------------+-------------+-----------+------------+-----------------------+
    | ID | IP Protocol | IP Range | Port Range | Remote Security Group |
    +--------------------------------------+-------------+-----------+------------+-----------------------+
    | 580e0d5a-5bd1-4236-bb82-4c677ad23ba0 | icmp | 0.0.0.0/0 | | None |
    | 6f69e38c-5c2d-419e-b17d-8807a7b07707 | None | None | | None |
    | cd22de42-a5e7-4396-8bed-e7b382f573b5 | tcp | 0.0.0.0/0 | 22:22 | None |
    | efe50892-5caf-495c-83d2-3b348317a04e | None | None | | None |
    +--------------------------------------+-------------+-----------+------------+-----------------------+
    [root@hamim-controller ~(keystone_admin)]#

<!--kg-card-end: markdown-->

Selamat mencoba 😁


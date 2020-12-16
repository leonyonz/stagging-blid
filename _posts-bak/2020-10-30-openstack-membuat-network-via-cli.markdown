---
layout: post
title: 'Openstack: Membuat Network via CLI'
featured: true
date: '2020-10-30 02:02:26'
tags:
- openstack
---

[Belajar Linux ID](/) – Pada tutoril kali ini kita akan mempelajari bagaimana cara membuat sebuah network baik external atau internal di openstack melalui CLI (Command line interface).

Untuk membuat network di openstack bisa menggunakan 2 cara salah satunya melaui dashboard openstack atau Horizon.

Tutorial membuat network di horizon Anda dapat merujuk pada link berikut: [Openstack: Membuat Network](/openstack-membuat-network/)

Berikut tahapan membuat network openstack melalui CLI:

Untuk melihat help cara membuat network di openstack gunakan perintah berikut

    [root@hamim-controller ~(keystone_admin)]#
    [root@hamim-controller ~(keystone_admin)]# openstack network --help

Cek list network yang sudah dibuat sebelumnya, bisa menggunakan perintah _opentack_ atau _neutron_ berikut contoh perinthnya

    [root@hamim-controller ~(keystone_admin)]#
    [root@hamim-controller ~(keystone_admin)]# openstack network list
    +--------------------------------------+---------+--------------------------------------+
    | ID | Name | Subnets |
    +--------------------------------------+---------+--------------------------------------+
    | a747188f-09de-496d-95a4-908d7d6262e6 | net-int | 0e627d43-60fe-4a49-bfc6-3baec80087e1 |
    | b077b37f-c38a-4759-b504-bbf4f91d3e94 | net-ext | 43e2a1a6-3920-437e-8f4f-60f04a3cab91 |
    +--------------------------------------+---------+--------------------------------------+
    [root@hamim-controller ~(keystone_admin)]#

    [root@hamim-controller ~(keystone_admin)]#
    [root@hamim-controller ~(keystone_admin)]# neutron net-list
    neutron CLI is deprecated and will be removed in the future. Use openstack CLI instead.
    +--------------------------------------+---------+----------------------------------+------------------------------------------------------+
    | id | name | tenant_id | subnets |
    +--------------------------------------+---------+----------------------------------+------------------------------------------------------+
    | a747188f-09de-496d-95a4-908d7d6262e6 | net-int | 99f200eba89b49a9b89a981ec76813e1 | 0e627d43-60fe-4a49-bfc6-3baec80087e1 192.168.10.0/24 |
    | b077b37f-c38a-4759-b504-bbf4f91d3e94 | net-ext | 99f200eba89b49a9b89a981ec76813e1 | 43e2a1a6-3920-437e-8f4f-60f04a3cab91 10.136.136.0/24 |
    +--------------------------------------+---------+----------------------------------+------------------------------------------------------+
    [root@hamim-controller ~(keystone_admin)]#

Untuk membuat external network Anda dapat menggunakan perintah berikut:

    # neutron net-create net-ext --provider:network_type flat --provider:physical_network extnet --shared --router:external
    # neutron net-create net-int1

_Noted: Apabila sudah memiliki external network, maka langkah diatas bisa di skip saja._

Selanjutnya kami akan membuat internal network dengan nama network _net-internal1_ menggunakan perintah berikut

    [root@hamim-controller ~(keystone_admin)]#
    [root@hamim-controller ~(keystone_admin)]# openstack network create net-internal1
    +---------------------------+--------------------------------------+
    | Field | Value |
    +---------------------------+--------------------------------------+
    | admin_state_up | UP |
    | availability_zone_hints | |
    | availability_zones | |
    | created_at | 2020-09-24T11:19:11Z |
    | description | |
    | dns_domain | None |
    | id | 4517136f-2436-41ba-a7c3-b973e65bd54a |
    | ipv4_address_scope | None |
    | ipv6_address_scope | None |
    | is_default | False |
    | is_vlan_transparent | None |
    | mtu | 1450 |
    | name | net-internal1 |
    | port_security_enabled | True |
    | project_id | 99f200eba89b49a9b89a981ec76813e1 |
    | provider:network_type | vxlan |
    | provider:physical_network | None |
    | provider:segmentation_id | 22 |
    | qos_policy_id | None |
    | revision_number | 2 |
    | router:external | Internal |
    | segments | None |
    | shared | False |
    | status | ACTIVE |
    | subnets | |
    | tags | |
    | updated_at | 2020-09-24T11:19:11Z |
    +---------------------------+--------------------------------------+
    [root@hamim-controller ~(keystone_admin)]#

Gunakan perintah berikut untuk melihat list network

    [root@hamim-controller ~(keystone_admin)]# openstack network list
    +--------------------------------------+---------------+--------------------------------------+
    | ID | Name | Subnets |
    +--------------------------------------+---------------+--------------------------------------+
    | 4517136f-2436-41ba-a7c3-b973e65bd54a | net-internal1 | |
    | a747188f-09de-496d-95a4-908d7d6262e6 | net-int | 0e627d43-60fe-4a49-bfc6-3baec80087e1 |
    | b077b37f-c38a-4759-b504-bbf4f91d3e94 | net-ext | 43e2a1a6-3920-437e-8f4f-60f04a3cab91 |
    +--------------------------------------+---------------+--------------------------------------+
    [root@hamim-controller ~(keystone_admin)]#

Gunakan perintah berikut untuk melihat subnet list

    [root@hamim-controller ~(keystone_admin)]#
    [root@hamim-controller ~(keystone_admin)]# openstack subnet list
    +--------------------------------------+------------+--------------------------------------+-----------------+
    | ID | Name | Network | Subnet |
    +--------------------------------------+------------+--------------------------------------+-----------------+
    | 0e627d43-60fe-4a49-bfc6-3baec80087e1 | subnet-int | a747188f-09de-496d-95a4-908d7d6262e6 | 192.168.10.0/24 |
    | 43e2a1a6-3920-437e-8f4f-60f04a3cab91 | subnet-ext | b077b37f-c38a-4759-b504-bbf4f91d3e94 | 10.136.136.0/24 |
    +--------------------------------------+------------+--------------------------------------+-----------------+
    [root@hamim-controller ~(keystone_admin)]#

Saat ini network sudah berhasil dibuat, namun belum memiliki subnet untuk membuat subnet untuk network internal yang sudah kita buat diatas, silakah gunakan perintah berikut

    [root@hamim-controller ~(keystone_admin)]#
    [root@hamim-controller ~(keystone_admin)]# neutron subnet-create net-internal1 192.168.1.0/24 --name subnet-net-internal1 --gateway 192.168.1.1 --allocation-pool start=192.168.1.100,end=192.168.1.199 --dns-nameserver 10.136.136.1
    neutron CLI is deprecated and will be removed in the future. Use openstack CLI instead.
    Created a new subnet:
    +-------------------+----------------------------------------------------+
    | Field | Value |
    +-------------------+----------------------------------------------------+
    | allocation_pools | {"start": "192.168.1.100", "end": "192.168.1.199"} |
    | cidr | 192.168.1.0/24 |
    | created_at | 2020-09-24T11:24:04Z |
    | description | |
    | dns_nameservers | 10.136.136.1 |
    | enable_dhcp | True |
    | gateway_ip | 192.168.1.1 |
    | host_routes | |
    | id | 132a0c29-9cba-4451-b24c-619fbe700181 |
    | ip_version | 4 |
    | ipv6_address_mode | |
    | ipv6_ra_mode | |
    | name | subnet-net-internal1 |
    | network_id | 4517136f-2436-41ba-a7c3-b973e65bd54a |
    | project_id | 99f200eba89b49a9b89a981ec76813e1 |
    | revision_number | 0 |
    | service_types | |
    | subnetpool_id | |
    | tags | |
    | tenant_id | 99f200eba89b49a9b89a981ec76813e1 |
    | updated_at | 2020-09-24T11:24:04Z |
    +-------------------+----------------------------------------------------+
    [root@hamim-controller ~(keystone_admin)]#

Saat ini subnet untuk _net-internal1_ sudah berhasil dibuat, sekarang silakan pastikan untuk network _net-internal1_ sudah mempunyai subnet dengan cara melihat list subnet

    [root@hamim-controller ~(keystone_admin)]#
    [root@hamim-controller ~(keystone_admin)]# neutron subnet-list
    neutron CLI is deprecated and will be removed in the future. Use openstack CLI instead.
    +--------------------------------------+----------------------+----------------------------------+-----------------+------------------------------------------------------+
    | id | name | tenant_id | cidr | allocation_pools |
    +--------------------------------------+----------------------+----------------------------------+-----------------+------------------------------------------------------+
    | 0e627d43-60fe-4a49-bfc6-3baec80087e1 | subnet-int | 99f200eba89b49a9b89a981ec76813e1 | 192.168.10.0/24 | {"start": "192.168.10.100", "end": "192.168.10.199"} |
    | 132a0c29-9cba-4451-b24c-619fbe700181 | subnet-net-internal1 | 99f200eba89b49a9b89a981ec76813e1 | 192.168.1.0/24 | {"start": "192.168.1.100", "end": "192.168.1.199"} |
    | 43e2a1a6-3920-437e-8f4f-60f04a3cab91 | subnet-ext | 99f200eba89b49a9b89a981ec76813e1 | 10.136.136.0/24 | {"start": "10.136.136.100", "end": "10.136.136.199"} |
    +--------------------------------------+----------------------+----------------------------------+-----------------+------------------------------------------------------+
    [root@hamim-controller ~(keystone_admin)]#

Cek network list dan pastikan pemetaan subnet diatas sudah benar

    [root@hamim-controller ~(keystone_admin)]# neutron net-list
    neutron CLI is deprecated and will be removed in the future. Use openstack CLI instead.
    +--------------------------------------+---------------+----------------------------------+------------------------------------------------------+
    | id | name | tenant_id | subnets |
    +--------------------------------------+---------------+----------------------------------+------------------------------------------------------+
    | 4517136f-2436-41ba-a7c3-b973e65bd54a | net-internal1 | 99f200eba89b49a9b89a981ec76813e1 | 132a0c29-9cba-4451-b24c-619fbe700181 192.168.1.0/24 |
    | a747188f-09de-496d-95a4-908d7d6262e6 | net-int | 99f200eba89b49a9b89a981ec76813e1 | 0e627d43-60fe-4a49-bfc6-3baec80087e1 192.168.10.0/24 |
    | b077b37f-c38a-4759-b504-bbf4f91d3e94 | net-ext | 99f200eba89b49a9b89a981ec76813e1 | 43e2a1a6-3920-437e-8f4f-60f04a3cab91 10.136.136.0/24 |
    +--------------------------------------+---------------+----------------------------------+------------------------------------------------------+
    [root@hamim-controller ~(keystone_admin)]#

Selamat mencoba 😁

Please follow and like us:

[![error](/wp-content/plugins/ultimate-social-media-icons/images/follow_subscribe.png)](https://api.follow.it/widgets/icon/VHc3d1lpVGdwRnE5QnV0eERCNUx5RCtvTTVoUkNYS3NNRmd5eVhlQW9tNXRHS3VTbGh6Y0NybkRJRS8zSGpjRDVZb1ZGMlNTSEpJYUpuZzZqNzdnd3VSN3dwM2VlQTF6ejJEaGV5UGRUbnlEcHFNd3luYTV4ZTZtUGowVWI2Q2x8M2kzdnBEeUIrUk5xOFI5TXZ3cHF3bFNQRkRJSGhUNGdrRFd0TlNtdE1OWT0=/OA==/)

[![fb-share-icon](/wp-content/plugins/ultimate-social-media-icons/images/visit_icons/fbshare_bck.png "Facebook Share")](https://www.facebook.com/sharer/sharer.php?u=https%3A%2F%2Fbelajarlinux.id%2F%3Fp%3D776%26ghostexport%3Dtrue%26submit%3DDownload+Ghost+File)

[![Tweet](/wp-content/plugins/ultimate-social-media-icons/images/visit_icons/en_US_Tweet.svg "Tweet")](https://twitter.com/intent/tweet?text=Openstack%3A+Membuat+Network+via+CLI+https://belajarlinux.id/?p=776&ghostexport=true&submit=Download Ghost File)

[![fb-share-icon](/wp-content/plugins/ultimate-social-media-icons/images/share_icons/Pinterest_Save/en_US_save.svg "Pin Share")](#)

<!--kg-card-end: html-->
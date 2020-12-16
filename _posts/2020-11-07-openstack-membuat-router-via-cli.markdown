---
layout: post
title: 'Openstack: Membuat Router via CLI'
featured: true
date: '2020-11-07 09:36:11'
tags:
- openstack
---

[Belajar Linux ID](/) - Tutorial kali ini merupakan kelanjutan dari tutorial sebelumnya atau bisa di bilang sebagai series dari tutorial sebelumnya mengenai openstack.

Untuk membuat router di Openstack terdapat 2 cara bisa melalui horizon dashboard atau CLI (Command Line Interface).

Untuk tutorial membuat router melalui dashboard horizon dapat Anda lihat pada link berikut: _[Openstack: Membuat Router](/openstack-membuat-router/)_

Berikut merupakan tahapan membuat router via CLI, sebelum itu mari kita lihat list router terlebih dahulu, gunakan perintah berikut

<!--kg-card-begin: markdown-->

    [root@hamim-controller ~(keystone_admin)]# neutron router-list
    neutron CLI is deprecated and will be removed in the future. Use openstack CLI instead.
    +--------------------------------------+------------+----------------------------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-------------+-------+
    | id | name | tenant_id | external_gateway_info | distributed | ha |
    +--------------------------------------+------------+----------------------------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-------------+-------+
    | a5b00947-db9a-4846-a202-f4b0c8f51a1c | router-int | 99f200eba89b49a9b89a981ec76813e1 | {"network_id": "b077b37f-c38a-4759-b504-bbf4f91d3e94", "enable_snat": true, "external_fixed_ips": [{"subnet_id": "43e2a1a6-3920-437e-8f4f-60f04a3cab91", "ip_address": "10.136.136.105"}]} | False | False |
    +--------------------------------------+------------+----------------------------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-------------+-------+
    [root@hamim-controller ~(keystone_admin)]#

<!--kg-card-end: markdown-->

Selanjutnya kita akan membuat router dengan nama `router1`

<!--kg-card-begin: markdown-->

    [root@hamim-controller ~(keystone_admin)]#
    [root@hamim-controller ~(keystone_admin)]# neutron router-create router1
    neutron CLI is deprecated and will be removed in the future. Use openstack CLI instead.
    Created a new router:
    +-------------------------+--------------------------------------+
    | Field | Value |
    +-------------------------+--------------------------------------+
    | admin_state_up | True |
    | availability_zone_hints | |
    | availability_zones | |
    | created_at | 2020-09-24T11:27:22Z |
    | description | |
    | distributed | False |
    | external_gateway_info | |
    | flavor_id | |
    | ha | False |
    | id | e2214ca3-1074-489d-acb2-84e4c3d75c5d |
    | name | router1 |
    | project_id | 99f200eba89b49a9b89a981ec76813e1 |
    | revision_number | 1 |
    | routes | |
    | status | ACTIVE |
    | tags | |
    | tenant_id | 99f200eba89b49a9b89a981ec76813e1 |
    | updated_at | 2020-09-24T11:27:22Z |
    +-------------------------+--------------------------------------+
    [root@hamim-controller ~(keystone_admin)]#

<!--kg-card-end: markdown-->

Selanjutnya set gateway untuk router yang telah dibuat

<!--kg-card-begin: markdown-->

    [root@hamim-controller ~(keystone_admin)]#
    [root@hamim-controller ~(keystone_admin)]# neutron router-gateway-set router1 net-ext
    neutron CLI is deprecated and will be removed in the future. Use openstack CLI instead.
    Set gateway for router router1
    [root@hamim-controller ~(keystone_admin)]#

<!--kg-card-end: markdown-->

Jika sudah set gateway secara otomatis network `net-ext` akan di tambahkan ke `router1`, selanjutnya Anda dapat menambahkan interface atau network baru ke router yang telah dibuat sebelumnya

<!--kg-card-begin: markdown-->

    [root@hamim-controller ~(keystone_admin)]#
    [root@hamim-controller ~(keystone_admin)]# neutron router-interface-add router1 subnet-net-internal1
    neutron CLI is deprecated and will be removed in the future. Use openstack CLI instead.
    Added interface ce1f89fc-168f-4a07-9075-4438937d63d5 to router router1.
    [root@hamim-controller ~(keystone_admin)]#

<!--kg-card-end: markdown-->

Cek list router yang telah kita buat, seharusnya sudah ada 2 router

<!--kg-card-begin: markdown-->

    [root@hamim-controller ~(keystone_admin)]#
    [root@hamim-controller ~(keystone_admin)]# neutron router-list
    neutron CLI is deprecated and will be removed in the future. Use openstack CLI instead.
    +--------------------------------------+------------+----------------------------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-------------+-------+
    | id | name | tenant_id | external_gateway_info | distributed | ha |
    +--------------------------------------+------------+----------------------------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-------------+-------+
    | a5b00947-db9a-4846-a202-f4b0c8f51a1c | router-int | 99f200eba89b49a9b89a981ec76813e1 | {"network_id": "b077b37f-c38a-4759-b504-bbf4f91d3e94", "enable_snat": true, "external_fixed_ips": [{"subnet_id": "43e2a1a6-3920-437e-8f4f-60f04a3cab91", "ip_address": "10.136.136.105"}]} | False | False |
    | e2214ca3-1074-489d-acb2-84e4c3d75c5d | router1 | 99f200eba89b49a9b89a981ec76813e1 | {"network_id": "b077b37f-c38a-4759-b504-bbf4f91d3e94", "enable_snat": true, "external_fixed_ips": [{"subnet_id": "43e2a1a6-3920-437e-8f4f-60f04a3cab91", "ip_address": "10.136.136.104"}]} | False | False |
    +--------------------------------------+------------+----------------------------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-------------+-------+
    [root@hamim-controller ~(keystone_admin)]#

<!--kg-card-end: markdown-->

**Keterangan:**

- `Router-int` : Router internal yang telah dibuat sebelumnya melalui horizon
- `Router1`: Router yang baru saja kita buat

Jika ingin melihat detail informasi dari `router1`, gunakan perintah berikut

<!--kg-card-begin: markdown-->

    [root@hamim-controller ~(keystone_admin)]#
    [root@hamim-controller ~(keystone_admin)]# neutron router-port-list router1
    neutron CLI is deprecated and will be removed in the future. Use openstack CLI instead.
    +--------------------------------------+------+----------------------------------+-------------------+---------------------------------------------------------------------------------------+
    | id | name | tenant_id | mac_address | fixed_ips |
    +--------------------------------------+------+----------------------------------+-------------------+---------------------------------------------------------------------------------------+
    | a7e42f6b-a057-4476-9478-fa9b2b4f23b6 | | | fa:16:3e:41:85:35 | {"subnet_id": "43e2a1a6-3920-437e-8f4f-60f04a3cab91", "ip_address": "10.136.136.104"} |
    | ce1f89fc-168f-4a07-9075-4438937d63d5 | | 99f200eba89b49a9b89a981ec76813e1 | fa:16:3e:dc:e8:b6 | {"subnet_id": "132a0c29-9cba-4451-b24c-619fbe700181", "ip_address": "192.168.1.1"} |
    +--------------------------------------+------+----------------------------------+-------------------+---------------------------------------------------------------------------------------+
    [root@hamim-controller ~(keystone_admin)]#

<!--kg-card-end: markdown-->

Testing ping ke IP `router1` yang telah dibuat, jika reply seperti berikut, menandakan router Anda sudah berhasil dibuat dengan baik dan benar

<!--kg-card-begin: markdown-->

    [root@hamim-controller ~(keystone_admin)]#
    [root@hamim-controller ~(keystone_admin)]# ping -c4 10.136.136.104 |grep icmp
    64 bytes from 10.136.136.104: icmp_seq=1 ttl=64 time=1.23 ms
    64 bytes from 10.136.136.104: icmp_seq=2 ttl=64 time=0.062 ms
    64 bytes from 10.136.136.104: icmp_seq=3 ttl=64 time=0.065 ms
    64 bytes from 10.136.136.104: icmp_seq=4 ttl=64 time=0.057 ms
    [root@hamim-controller ~(keystone_admin)]#

<!--kg-card-end: markdown--><figure class="kg-card kg-image-card kg-width-wide"><img src="/content/images/2020/11/1.png" class="kg-image" alt srcset="/content/images/size/w600/2020/11/1.png 600w, /content/images/size/w1000/2020/11/1.png 1000w, /content/images/size/w1600/2020/11/1.png 1600w, /content/images/2020/11/1.png 1762w" sizes="(min-width: 1200px) 1200px"></figure>

Itulah tahapan singkat bagaimana cara membuat router openstack via CLI.

Selamat mencoba 😁


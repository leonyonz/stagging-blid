---
layout: post
title: 'Openstack: Membuat SSH Key via CLI'
featured: true
date: '2020-11-07 10:09:57'
tags:
- openstack
---

**[Belajar Linux ID](/)** - Pada tutorial kali ini kita akan mencoba membuat ssh key atau keypair di Openstack melalui CLI.

Untuk membuat ssh key sebenarnya juga dapat melalui horizon atau dashboard openstack yang dapat Anda lihat pada link berikut: [Openstack: Menambahkan SSH Key](/openstack-menambahkan-ssh-key/)

Mari kita lihat terlebih dahulu list keypair yang ada di openstack menggunakan perintah berikut

<!--kg-card-begin: markdown-->

    [root@hamim-controller ~(keystone_admin)]#
    [root@hamim-controller ~(keystone_admin)]# openstack keypair list
    +------------+-------------------------------------------------+
    | Name | Fingerprint |
    +------------+-------------------------------------------------+
    | my-keypair | f4:64:ec:96:37:6b:46:52:6a:3e:0f:f6:51:e1:67:d7 |
    +------------+-------------------------------------------------+
    [root@hamim-controller ~(keystone_admin)]#

<!--kg-card-end: markdown-->

Untuk membuat keypair baru Anda hanya perlu menjalankan satu baris perintah berikut

<!--kg-card-begin: markdown-->

    [root@hamim-controller ~(keystone_admin)]#
    [root@hamim-controller ~(keystone_admin)]# openstack keypair create --public-key /root/.ssh/id_rsa.pub my-keypair1
    +-------------+-------------------------------------------------+
    | Field | Value |
    +-------------+-------------------------------------------------+
    | fingerprint | f4:64:ec:96:37:6b:46:52:6a:3e:0f:f6:51:e1:67:d7 |
    | name | my-keypair1 |
    | user_id | daf28d3fbc554e69903f5cba7f9e242c |
    +-------------+-------------------------------------------------+
    [root@hamim-controller ~(keystone_admin)]#

<!--kg-card-end: markdown-->

Sekarang silakan cek list keypair Anda kembali

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

Saat ini keypair sudah bertambah dengan keypair yang baru dibuat yaitu `my-keypair1`

Cukup mudah bukan !

Selamat mencoba 😁


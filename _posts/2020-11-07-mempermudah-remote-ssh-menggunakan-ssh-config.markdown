---
layout: post
title: 'SSH: Mempermudah Remote SSH Menggunakan SSH Config'
featured: true
date: '2020-11-07 00:47:44'
tags:
- ssh
- linux
- centos
- ubuntu
---

Pada kali ini saya ingin berbagi pengetahuan saya yaitu **Mempermudah Remote SSH Menggunakan SSH Config**.

SSH Config adalah file konfigurasi yang biasanya diletakan pada folder `~/.ssh/config`, file config ini biasanya berisi konfigurasi pintasan untuk mendefinisikan variable ataupun flag untuk command ssh client.

Sebagai contoh saya ingin menambahkan konfigurasi agar saya dapat langsung terhubung ke server dengan IP : `123.123.123.123` dengan username leon menggunakan hostname vm1, maka konfigurasi yang ditambahkan kurang lebih adalah sebagai berikut :

<!--kg-card-begin: markdown-->

    HostName 123.123.123.123
    User leon
    Port 22
    IdentityFile ~/.ssh/id_rsa```

<!--kg-card-end: markdown-->

Dengan konfigurasi diatas maka untuk dapat terhubung ke server `123.123.123.123` saya hanya perlu menjalankan command **SSH** berikut:

<!--kg-card-begin: markdown-->

`$ ssh vm1`

<!--kg-card-end: markdown-->

Mudah Bukan ?

Kalian bisa menyesuaikan konfigurasi diatas sesuai dengan kebutuhan kalian, dan untuk detail konfigurasi yang bisa ditambahkan dapat melihat ke artikel berikut ini : [https://www.ssh.com/ssh/config/](https://www.ssh.com/ssh/config/)

Sekian dulu sharing kali ini, sampai jumpa pada sharing berikutnya.


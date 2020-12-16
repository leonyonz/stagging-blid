---
layout: post
title: 'CentOS: Cara Install PHP 8 di CentOS 8'
featured: true
date: '2020-11-28 02:08:20'
tags:
- centos
- linux
- php
---

Sebagai informasi PHP 8 telah [rilis](https://www.php.net/archive/2020.php#2020-11-26-3) pada tanggal 26 November 2020, bagi kalian yang ingin mencoba atau menggunakan PHP 8 di Centos 8 berikut saya jelaskan langkahnya.

**Memasang PHP 8 Secara Independent.**

Apabila kalian ingin menggunakan PHP 8 sebagai default silakan ikuti langkah ini:

<!--kg-card-begin: markdown-->

    [root@belajarphp8 ~]# dnf -y install https://dl.fedoraproject.org/pub/epel/epel-release-latest-8.noarch.rpm
    [root@belajarphp8 ~]# dnf -y install https://rpms.remirepo.net/enterprise/remi-release-8.rpm
    [root@belajarphp8 ~]# dnf -y install yum-utils
    [root@belajarphp8 ~]# dnf module reset php
    [root@belajarphp8 ~]# dnf module install php:remi-8.0 -y
    [root@belajarphp8 ~]# dnf install php -y

<!--kg-card-end: markdown-->

Jalankan perintah ini untuk memastikan bahwa PHP 8 telah berhasil dipasang:

<!--kg-card-begin: markdown-->

    [root@belajarphp8 ~]# php -v
    PHP 8.0.0 (cli) (built: Nov 24 2020 17:04:03) ( NTS gcc x86_64 )
    Copyright (c) The PHP Group
    Zend Engine v4.0.0-dev, Copyright (c) Zend Technologies
        with Zend OPcache v8.0.0, Copyright (c), by Zend Technologies

<!--kg-card-end: markdown--><!--kg-card-begin: html--><script async src="https://pagead2.googlesyndication.com/pagead/js/adsbygoogle.js"></script><ins class="adsbygoogle" style="display:block; text-align:center;" data-ad-layout="in-article" data-ad-format="fluid" data-ad-client="ca-pub-1515372853161377" data-ad-slot="4684565489"></ins><script>
     (adsbygoogle = window.adsbygoogle || []).push({});
</script><!--kg-card-end: html-->

**Memasang PHP 8 dengan versi lainnya.**

Jika &nbsp;pada server terdapat versi PHP lain maka untuk dapat melakukan pemasangan PHP 8 agar tidak mengganggu versi lainnya yang sedang berjalan bisa menggunakan perintah berikut:

<!--kg-card-begin: markdown-->

    [root@belajarphp8 ~]# dnf -y install https://dl.fedoraproject.org/pub/epel/epel-release-latest-8.noarch.rpm
    [root@belajarphp8 ~]# dnf -y install https://rpms.remirepo.net/enterprise/remi-release-8.rpm
    [root@belajarphp8 ~]# dnf -y install yum-utils
    [root@belajarphp8 ~]# dnf module reset php
    [root@belajarphp8 ~]# dnf install php80

<!--kg-card-end: markdown-->

Jalankan perintah ini untuk memastikan bahwa PHP 8 telah berhasil dipasang:

<!--kg-card-begin: markdown-->

    [root@belajarphp8 ~]# php80 -v
    PHP 8.0.0 (cli) (built: Nov 24 2020 17:04:03) ( NTS gcc x86_64 )
    Copyright (c) The PHP Group
    Zend Engine v4.0.0-dev, Copyright (c) Zend Technologies

<!--kg-card-end: markdown-->

_Noted: Bagi Anda yang ingin menggunakan PHP 8 untuk website, pastikan website tersebut sudah support dengan PHP 8 dengan melihat paket PHP 8 yang ada sebelum melakukan perubahan._

**Selesai**

Demikian artikel **Cara Install PHP 8 di CentOS 8.** semoga bermanfaat bagi pengunjung yang sengaja ataupun tidak sengaja mengakses halaman ini.


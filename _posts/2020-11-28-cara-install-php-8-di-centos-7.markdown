---
layout: post
title: 'CentOS: Cara Install PHP 8 di CentOS 7'
date: '2020-11-28 03:33:12'
tags:
- centos
- linux
- php
---

[Belajar Linux ID](/) - PHP sudah menjadi bahasa pemrograman yang tak asing di dengar dan bisa dibilang sangat populer dan banyak digunakan oleh para programmer web dan sebagai nya. Dikutip dari laman berita [PHP](https://www.php.net/archive/2020.php#2020-11-26-3) per tanggal 26 November 2020 [PHP](https://www.php.net/archive/2020.php#2020-11-26-3)resmi merilis versi PHP 8 yang dapat Anda coba versi stabil 8.0.0 atau Anda dapat mengunduhnya melalui link berikut: [Current Stable PHP 8.0.0](https://www.php.net/downloads.php)

Pada tutorial kali ini kami akan menjelaskan bagaimana cara instalasi PHP 8 di CentOS 7 dan berikut tahapannya:

_(Baca Juga: [Cara Install PHP 8 di CentOS 8](/cara-install-php-8-di-centos-8/))_

#### Install PHP 8.0 sebagai versi Default (Hanya disarankan untuk rilis GA)

Jika Anda lebih suka melakukan installasi dan menggunakan PHP 8.0 sebagai versi default, gunakan perintah di bawah ini:

<!--kg-card-begin: markdown-->

    [centos@belajarlinux ~]$
    [centos@belajarlinux ~]$ sudo yum -y install https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
    [centos@belajarlinux ~]$ sudo yum -y install https://rpms.remirepo.net/enterprise/remi-release-7.rpm
    [centos@belajarlinux ~]$ sudo yum -y install yum-utils
    [centos@belajarlinux ~]$ sudo yum-config-manager --disable 'remi-php*'
    [centos@belajarlinux ~]$ sudo yum-config-manager --enable remi-php80

<!--kg-card-end: markdown-->

Install paket PHP 8.0 yang Anda butuhkan sebagai contoh

<!--kg-card-begin: html--><script async src="https://pagead2.googlesyndication.com/pagead/js/adsbygoogle.js"></script><ins class="adsbygoogle" style="display:block; text-align:center;" data-ad-layout="in-article" data-ad-format="fluid" data-ad-client="ca-pub-1515372853161377" data-ad-slot="1986938311"></ins><script>
     (adsbygoogle = window.adsbygoogle || []).push({});
</script><!--kg-card-end: html--><!--kg-card-begin: markdown-->

    [centos@belajarlinux ~]$ sudo yum -y install php php-{cli,fpm,mysqlnd,zip,devel,gd,mbstring,curl,xml,pear,bcmath,json}

<!--kg-card-end: markdown-->

Jika sudah cek versi PHP 8.0, gunakan perintah berikut

<!--kg-card-begin: markdown-->

    [centos@belajarlinux ~]$ php -v
    PHP 8.0.0 (cli) (built: Nov 24 2020 17:04:03) ( NTS gcc x86_64 )
    Copyright (c) The PHP Group
    Zend Engine v4.0.0-dev, Copyright (c) Zend Technologies
    [centos@belajarlinux ~]$

<!--kg-card-end: markdown-->

**Install PHP 8.0 bersama versi PHP lainnya (Direkomendasikan untuk rilis Alpha)**

Versi ini merupakan versi rilis awal yang tidak digunakan dalam ruang linkup _ **Production** _ dan jika ingin menjalankan PHP 8 dengan versi PHP lainnya secara bersamaan dapat di lakukan, berikut perintah nya:

<!--kg-card-begin: markdown-->

    [centos@belajarlinux ~]$
    [centos@belajarlinux ~]$ sudo yum -y install https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
    [centos@belajarlinux ~]$ sudo yum -y install https://rpms.remirepo.net/enterprise/remi-release-7.rpm
    [centos@belajarlinux ~]$ sudo yum -y install yum-utils
    [centos@belajarlinux ~]$ sudo yum-config-manager --disable 'remi-php*'
    [centos@belajarlinux ~]$ sudo yum-config-manager --enable remi-safe
    [centos@belajarlinux ~]$ sudo yum -y install php80 

<!--kg-card-end: markdown-->

Install paket PHP 8 yang Anda butuhkan sebagai contoh berikut

<!--kg-card-begin: html--><script async src="https://pagead2.googlesyndication.com/pagead/js/adsbygoogle.js"></script><ins class="adsbygoogle" style="display:block; text-align:center;" data-ad-layout="in-article" data-ad-format="fluid" data-ad-client="ca-pub-1515372853161377" data-ad-slot="4684565489"></ins><script>
     (adsbygoogle = window.adsbygoogle || []).push({});
</script><!--kg-card-end: html--><!--kg-card-begin: markdown-->

    [centos@belajarlinux ~]$ sudo yum install php80-php-{cli,fpm,mysqlnd,zip,devel,gd,mbstring,curl,xml,pear,bcmath,json}

<!--kg-card-end: markdown-->

Cek versi PHP

<!--kg-card-begin: markdown-->

    [centos@belajarlinux ~]$
    [centos@belajarlinux ~]$ php80 --version
    PHP 8.0.0 (cli) (built: Nov 24 2020 17:04:03) ( NTS gcc x86_64 )
    Copyright (c) The PHP Group
    Zend Engine v4.0.0-dev, Copyright (c) Zend Technologies
    [centos@belajarlinux ~]$

<!--kg-card-end: markdown-->

_Noted: Bagi Anda yang ingin menggunakan PHP 8 untuk website, pastikan website tersebut sudah support dengan PHP 8 dengan melihat paket PHP 8 yang ada sebelum melakukan perubahan._

Selamat mencoba 😁


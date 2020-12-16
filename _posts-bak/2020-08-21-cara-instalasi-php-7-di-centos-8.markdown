---
layout: post
title: Cara Instalasi PHP 7 di CentOS 8
featured: true
date: '2020-08-21 08:53:50'
tags:
- centos
- linux
- php
---

PHP adalah salah satu bahasa pemrograman yang paling banyak digunakan. Banyak CMS dan Frameworks seperti WordPress, Magento, dan lavarel dibangun menggunakan PHP.

CentOS 8 didistribusikan dengan default PHP versi 7.2. Versi sebagian besar sudah mendukung aplikasi PHP modern contohnya seperti WordPress yang sudah wajib menggunakan PHP 7.x. Versi PHP yang terbaru ataupun up to date tersedia di **[Remi Repository](https://rpms.remirepo.net)**.

Jika Anda akan menggunakan PHP versi 7.2, maka langkah ini bisa Anda lewatkan. Namun jika Anda ingin menggunakan PHP 7.3 dan 7.4, maka Anda perlu instalasi _repository remi_ terlebih dahulu.

    [root@tutorial ~]#
    [root@tutorial ~]# dnf install dnf-utils http://rpms.remirepo.net/enterprise/remi-release-8.rpm

Untuk melihat module php gunakan perintah berikut

    [root@tutorial ~]#
    [root@tutorial ~]# dnf module list php
    Extra Packages for Enterprise Linux Modular 8 - x86_64 14 kB/s | 82 kB 00:05
    Extra Packages for Enterprise Linux 8 - x86_64 3.5 MB/s | 7.8 MB 00:02
    Remi's Modular repository for Enterprise Linux 8 - x86_64 222 kB/s | 576 kB 00:02
    Safe Remi's RPM repository for Enterprise Linux 8 - x86_64 463 kB/s | 1.5 MB 00:03
    CentOS-8 - AppStream
    Name Stream Profiles Summary
    php 7.2 [d] common [d], devel, minimal PHP scripting language
    php 7.3 common [d], devel, minimal PHP scripting language
    
    Remi's Modular repository for Enterprise Linux 8 - x86_64
    Name Stream Profiles Summary
    php remi-7.2 common [d], devel, minimal PHP scripting language
    php remi-7.3 common [d], devel, minimal PHP scripting language
    php remi-7.4 common [d], devel, minimal PHP scripting language
    
    Hint: [d]efault, [e]nabled, [x]disabled, [i]nstalled
    [root@tutorial ~]#

_Noted: perhatikan bagian hint sudah terdapat keteranganya jika [d] default, [e] enable, [x] disabled, [i] installed._

Jika Anda ingin menggunakan php 7.3 atau 7.4 maka Anda perlu enable terlebih dahulu contohnya disini kami install php 7.4

    [root@tutorial ~]#
    [root@tutorial ~]# dnf module reset php
    Last metadata expiration check: 0:02:30 ago on Fri Aug 21 01:45:08 2020.
    Dependencies resolved.
    Nothing to do.
    Complete!
    [root@tutorial ~]# dnf module enable php:remi-7.4
    Last metadata expiration check: 0:03:02 ago on Fri Aug 21 01:45:08 2020.
    Dependencies resolved.
    ========================================================================================================================
     Package Architecture Version Repository Size
    ========================================================================================================================
    Enabling module streams:
     php remi-7.4
    
    Transaction Summary
    ========================================================================================================================
    
    Is this ok [y/N]: y
    Complete!
    [root@tutorial ~]#

Jika dilihat kembali module php yang digunakan saat ini php 7.4

    [root@tutorial ~]# dnf module list php
    Last metadata expiration check: 0:04:05 ago on Fri Aug 21 01:45:08 2020.
    CentOS-8 - AppStream
    Name Stream Profiles Summary
    php 7.2 [d] common [d], devel, minimal PHP scripting language
    php 7.3 common [d], devel, minimal PHP scripting language
    
    Remi's Modular repository for Enterprise Linux 8 - x86_64
    Name Stream Profiles Summary
    php remi-7.2 common [d], devel, minimal PHP scripting language
    php remi-7.3 common [d], devel, minimal PHP scripting language
    php remi-7.4 [e] common [d], devel, minimal PHP scripting language
    
    Hint: [d]efault, [e]nabled, [x]disabled, [i]nstalled
    [root@tutorial ~]#

Silakan install extensi php yang Anda inginkan sebagai contoh

    [root@tutorial ~]#
    [root@tutorial ~]# dnf install php php-opcache php-gd php-curl php-mysqlnd php-fpm -y

Untuk melihat dan mengetahui extensi php apa saja yang ada gunakan perintah berikut

    [root@tutorial ~]#
    [root@tutorial ~]# dnf search php-

Untuk masuk ke shell php gunakan perintah

    [root@tutorial ~]#
    [root@tutorial ~]# php -a
    Interactive shell
    
    php > exit
    [root@tutorial ~]#

Untuk melihat versi php gunakan perintah

    [root@tutorial ~]#
    [root@tutorial ~]# php -v
    PHP 7.4.9 (cli) (built: Aug 4 2020 08:28:13) ( NTS )
    Copyright (c) The PHP Group
    Zend Engine v3.4.0, Copyright (c) Zend Technologies
        with Zend OPcache v7.4.9, Copyright (c), by Zend Technologies
    [root@tutorial ~]#

Untuk melihat extensi apa saja yang terinstall gunakan perintah

    [root@tutorial ~]#
    [root@tutorial ~]# php -m

Jika Anda ingin membuat php info nginx dapat di lakukan sebagai berikut

    [root@tutorial ~]# cd /usr/share/nginx/html/
    [root@tutorial html]# touch info.php
    [root@tutorial html]# vim info.php

Isikan file info.php berikut

    <?php
    phpinfo();
    ?>

Reload nginx

    [root@tutorial html]# nginx -s reload

Silakan akses IP VM atau VPS Anda /info.php, jika berhasil akan seperti berikut

<figure class="wp-block-image size-large"><img loading="lazy" width="1024" height="531" src="/content/images/wordpress/2020/08/image-23-1024x531.png" alt="" class="wp-image-117" srcset="/content/images/wordpress/2020/08/image-23-1024x531.png 1024w, /content/images/wordpress/2020/08/image-23-300x155.png 300w, /content/images/wordpress/2020/08/image-23-768x398.png 768w, /content/images/wordpress/2020/08/image-23.png 1347w" sizes="(max-width: 1024px) 100vw, 1024px"></figure>

Saat ini php 7 sudah terinstall.

Selamat mencoba 😄

Please follow and like us:

[![error](/wp-content/plugins/ultimate-social-media-icons/images/follow_subscribe.png)](https://api.follow.it/widgets/icon/VHc3d1lpVGdwRnE5QnV0eERCNUx5RCtvTTVoUkNYS3NNRmd5eVhlQW9tNXRHS3VTbGh6Y0NybkRJRS8zSGpjRDVZb1ZGMlNTSEpJYUpuZzZqNzdnd3VSN3dwM2VlQTF6ejJEaGV5UGRUbnlEcHFNd3luYTV4ZTZtUGowVWI2Q2x8M2kzdnBEeUIrUk5xOFI5TXZ3cHF3bFNQRkRJSGhUNGdrRFd0TlNtdE1OWT0=/OA==/)

[![fb-share-icon](/wp-content/plugins/ultimate-social-media-icons/images/visit_icons/fbshare_bck.png "Facebook Share")](https://www.facebook.com/sharer/sharer.php?u=https%3A%2F%2Fbelajarlinux.id%2F%3Fp%3D103%26ghostexport%3Dtrue%26submit%3DDownload+Ghost+File)

[![Tweet](/wp-content/plugins/ultimate-social-media-icons/images/visit_icons/en_US_Tweet.svg "Tweet")](https://twitter.com/intent/tweet?text=Cara+Instalasi+PHP+7+di+CentOS+8+https://belajarlinux.id/?p=103&ghostexport=true&submit=Download Ghost File)

[![fb-share-icon](/wp-content/plugins/ultimate-social-media-icons/images/share_icons/Pinterest_Save/en_US_save.svg "Pin Share")](#)

<!--kg-card-end: html-->
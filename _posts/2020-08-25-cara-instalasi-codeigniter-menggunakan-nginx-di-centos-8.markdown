---
layout: post
title: Cara Instalasi CodeIgniter Menggunakan Nginx di CentOS 8
featured: true
date: '2020-08-25 23:16:42'
tags:
- centos
- framework
---

CodeIgniter merupakan sebuah framework yang dapat Anda gunakan secara bebas karena framework ini open source. CodeIgniter dapat Anda gunakan untuk membangun aplikasi web berbasis PHP.

CodeIgniter sudah banyak digunakan oleh para pengembang dan web developer untuk membangun website yang powerfull tertentunya.

Sebelum melakukan instalasi codeiginet pastikan Anda telah install terlebih dahulu web server yang akan digunakan yaitu Nginx dan database nya MariaDB/MySQL dan PHP versi 7.x, jika Anda belum melakukan installasi kebutuhan tersebut silakan merujuk pada tutorial berikut

- **_[Cara Instalasi Nginx Di CentOS 8](/cara-instalasi-nginx-di-centos-8/)_**
- **_[Cara Instalasi PHP 7 di CentOS 8](/cara-instalasi-php-7-di-centos-8/)_**
- **_[Cara Instalasi Database MariaDB di CentOS 8](/cara-instalasi-database-mariadb-di-centos-8/)_**

Memastikan semua service berjalan (running)

    [root@tutorial ~]#
    [root@tutorial ~]# systemctl status nginx |grep Active
       Active: active (running) since Tue 2020-08-25 15:01:08 UTC; 1h 2min ago
    [root@tutorial ~]# systemctl status php-fpm |grep Active
       Active: active (running) since Tue 2020-08-25 07:38:48 UTC; 8h ago
    [root@tutorial ~]# systemctl status mariadb |grep Active
       Active: active (running) since Tue 2020-08-25 07:37:13 UTC; 8h ago
    [root@tutorial ~]#

Disini kami menggunakan PHP versi 7.4 dan silakan install beberapa module php berikut

    [root@tutorial ~]# php --version
    PHP 7.4.9 (cli) (built: Aug 4 2020 08:28:13) ( NTS )
    Copyright (c) The PHP Group
    Zend Engine v3.4.0, Copyright (c) Zend Technologies
        with Zend OPcache v7.4.9, Copyright (c), by Zend Technologies
    [root@tutorial ~]#
    [root@tutorial ~]#
    [root@tutorial ~]# dnf install php-curl php-common php-cli php-mysql php-mbstring php-xml php-zip -y

Selanjutnya melakukan instalasi composer

    [root@tutorial ~]#
    [root@tutorial ~]# curl -sS https://getcomposer.org/installer | php
    All settings correct for using Composer
    Downloading...
    
    Composer (version 1.10.10) successfully installed to: /root/composer.phar
    Use it: php composer.phar
    
    [root@tutorial ~]# 

Memindahkan file _compos_er_.phar_ ke _/usr/bin/_ dan memberikan permission execute.

    [root@tutorial ~]# ls
    anaconda-ks.cfg composer.phar original-ks.cfg
    [root@tutorial ~]#
    [root@tutorial ~]# mv composer.phar /usr/bin/composer
    [root@tutorial ~]# chmod +x /usr/bin/composer
    [root@tutorial ~]#

Membuat database codeigniter

    [root@tutorial ~]# mysql -u root -p
    Enter password:
    Welcome to the MariaDB monitor. Commands end with ; or \g.
    Your MariaDB connection id is 11
    Server version: 10.3.17-MariaDB MariaDB Server
    
    Copyright (c) 2000, 2018, Oracle, MariaDB Corporation Ab and others.
    
    Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.
    
    MariaDB [(none)]> create database ci_db;
    Query OK, 1 row affected (0.001 sec)
    
    MariaDB [(none)]> grant all privileges on cidb.* to ci_db@'localhost' identified by 'secret-ci';
    Query OK, 0 rows affected (0.001 sec)
    
    MariaDB [(none)]> flush privileges;
    Query OK, 0 rows affected (0.001 sec)
    
    MariaDB [(none)]> quit
    Bye
    [root@tutorial ~]#

Menentukan path root direktori codeigniter dan membuat direktori codeigniter

    [root@tutorial ~]#
    [root@tutorial ~]# cd /usr/share/nginx/
    [root@tutorial nginx]#
    [root@tutorial nginx]# mkdir ci
    [root@tutorial nginx]# cd ci/
    [root@tutorial ci]#

Cloning file codeigniter menggunakan git

    [root@tutorial ci]# git clone https://github.com/bcit-ci/CodeIgniter.git .
    Cloning into '.'...
    remote: Enumerating objects: 320, done.
    remote: Counting objects: 100% (320/320), done.
    remote: Compressing objects: 100% (296/296), done.
    remote: Total 85001 (delta 184), reused 71 (delta 24), pack-reused 84681
    Receiving objects: 100% (85001/85001), 52.55 MiB | 10.18 MiB/s, done.
    Resolving deltas: 100% (68480/68480), done.
    [root@tutorial ci]#

_Noted: Jika belum ada git silakan install terlebih dahulu jalankan perintah berikut **dnf install git -y** _

Jalankan _composer install_ untuk melakukan proses instalasi codeigniter

    [root@tutorial ci]#
    [root@tutorial ci]# composer install
    Do not run Composer as root/super user! See https://getcomposer.org/root for details
    Loading composer repositories with package information
    Updating dependencies (including require-dev)
    Package operations: 27 installs, 0 updates, 0 removals
      - Installing mikey179/vfsstream (v1.1.0): Downloading (100%)
      - Installing myclabs/deep-copy (1.10.1): Loading from cache
      - Installing sebastian/version (2.0.1): Loading from cache
      - Installing sebastian/resource-operations (1.0.0): Downloading (100%)
      - Installing sebastian/recursion-context (2.0.0): Downloading (100%)
    
    ...
    ...
    ...
    
    Writing lock file
    Generating autoload files
    4 packages you are using are looking for funding.
    Use the `composer fund` command to find out more!
    [root@tutorial ci]#

Berikan hak akses dan owner pada direktori ci yang kita buat sebelumnya

    [root@tutorial ci]# chown -R nginx:nginx /usr/share/nginx/ci/
    [root@tutorial ci]# chmod -R 755 /usr/share/nginx/ci/

Konfiguraasi URL codeigniter Anda

    [root@tutorial ci]# vim application/config/config.php

Isi URL Anda bisa menggunakan IP atau nama domain contohnya : http://ci.nurhamim.my.id

<figure class="wp-block-image size-large"><img loading="lazy" width="658" height="416" src="/content/images/wordpress/2020/08/image-79.png" alt="" class="wp-image-292" srcset="/content/images/wordpress/2020/08/image-79.png 658w, /content/images/wordpress/2020/08/image-79-300x190.png 300w" sizes="(max-width: 658px) 100vw, 658px"></figure>

Konfigurasi database codeigniter

    [root@tutorial ci]# vim application/config/database.php

Silakan input username, password dan nama database yang telah kita buat sebelumnya

<figure class="wp-block-image size-large"><img loading="lazy" width="608" height="381" src="/content/images/wordpress/2020/08/image-80.png" alt="" class="wp-image-293" srcset="/content/images/wordpress/2020/08/image-80.png 608w, /content/images/wordpress/2020/08/image-80-300x188.png 300w" sizes="(max-width: 608px) 100vw, 608px"></figure>

Langkah selanjutnya membuat server block Nginx yang akan digunakan codeigniter

    [root@tutorial ci]# vim /etc/nginx/conf.d/ci.conf

Berikut isi server block Nginx nya

    server {
            listen 80;
            server_name ci.nurhamim.my.id;
            root /usr/share/nginx/ci;
            index index.php index.html index.htm;
    
            location / {
                    try_files $uri $uri/ /index.php?$query_string;
            }
    
            location ~ \.php {
                    include fastcgi.conf;
                    fastcgi_split_path_info ^(.+\.php)(/.+)$;
                    fastcgi_pass unix:/run/php-fpm/www.sock;
            }
            location ~ /\.ht {
                    deny all;
            }
    }

_Noted: Disini kami menggunakan unix socket jika ingin menggunakan port socket silakan disesuaikan di sisi php-fpm nya._

Pastikan tidak ada konfigurasi yang salah terhadap server block nginx

    [root@tutorial ci]# nginx -t
    nginx: the configuration file /etc/nginx/nginx.conf syntax is ok
    nginx: configuration file /etc/nginx/nginx.conf test is successful
    [root@tutorial ci]#

Reload Nginx dan php-fpm

    [root@tutorial ci]# systemctl reload nginx
    [root@tutorial ci]# systemctl reload php-fpm
    [root@tutorial ci]#

Pastikan Anda sudah menambahkan A record pada subdomain atau domain Anda

<figure class="wp-block-image size-large"><img loading="lazy" width="1020" height="204" src="/content/images/wordpress/2020/08/image-81.png" alt="" class="wp-image-294" srcset="/content/images/wordpress/2020/08/image-81.png 1020w, /content/images/wordpress/2020/08/image-81-300x60.png 300w, /content/images/wordpress/2020/08/image-81-768x154.png 768w" sizes="(max-width: 1020px) 100vw, 1020px"></figure>

Verifikasi dapat dilakukan menggunakan ping

<figure class="wp-block-image size-large"><img loading="lazy" width="605" height="95" src="/content/images/wordpress/2020/08/image-82.png" alt="" class="wp-image-295" srcset="/content/images/wordpress/2020/08/image-82.png 605w, /content/images/wordpress/2020/08/image-82-300x47.png 300w" sizes="(max-width: 605px) 100vw, 605px"></figure>

Akses subdomain atau domain Anda melalui browser

<figure class="wp-block-image size-large"><img loading="lazy" width="1024" height="344" src="/content/images/wordpress/2020/08/image-83-1024x344.png" alt="" class="wp-image-296" srcset="/content/images/wordpress/2020/08/image-83-1024x344.png 1024w, /content/images/wordpress/2020/08/image-83-300x101.png 300w, /content/images/wordpress/2020/08/image-83-768x258.png 768w, /content/images/wordpress/2020/08/image-83.png 1365w" sizes="(max-width: 1024px) 100vw, 1024px"></figure>

Selamat Anda telah berhasil melakukan instalasi codeigniter di CentOS 8.

Selamat mencoba 😁

Please follow and like us:

[![error](/wp-content/plugins/ultimate-social-media-icons/images/follow_subscribe.png)](https://api.follow.it/widgets/icon/VHc3d1lpVGdwRnE5QnV0eERCNUx5RCtvTTVoUkNYS3NNRmd5eVhlQW9tNXRHS3VTbGh6Y0NybkRJRS8zSGpjRDVZb1ZGMlNTSEpJYUpuZzZqNzdnd3VSN3dwM2VlQTF6ejJEaGV5UGRUbnlEcHFNd3luYTV4ZTZtUGowVWI2Q2x8M2kzdnBEeUIrUk5xOFI5TXZ3cHF3bFNQRkRJSGhUNGdrRFd0TlNtdE1OWT0=/OA==/)

[![fb-share-icon](/wp-content/plugins/ultimate-social-media-icons/images/visit_icons/fbshare_bck.png "Facebook Share")](https://www.facebook.com/sharer/sharer.php?u=https%3A%2F%2Fbelajarlinux.id%2F%3Fp%3D290%26ghostexport%3Dtrue%26submit%3DDownload+Ghost+File)

[![Tweet](/wp-content/plugins/ultimate-social-media-icons/images/visit_icons/en_US_Tweet.svg "Tweet")](https://twitter.com/intent/tweet?text=Cara+Instalasi+CodeIgniter+Menggunakan+Nginx+di+CentOS+8+https://belajarlinux.id/?p=290&ghostexport=true&submit=Download Ghost File)

[![fb-share-icon](/wp-content/plugins/ultimate-social-media-icons/images/share_icons/Pinterest_Save/en_US_save.svg "Pin Share")](#)

<!--kg-card-end: html-->
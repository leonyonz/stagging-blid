---
layout: post
title: Cara Instalasi Drupal Menggunakan Nginx di CentOS 8
featured: true
date: '2020-08-25 14:54:53'
tags:
- centos
- cms
---

**[Drupal](https://www.drupal.org/)**salah satu dari sekian banyak nya CMS (content management system) yang open source (bebas) digunakan, dikembangkan dan di customisasi sesuai kebutuhan. Drupal di tulis menggunakan PHP dan didistribusikan di bawah GNU General Public License.

**[Drupal](https://www.drupal.org/)**dapat digunakan untuk perbagai jenis kebutuhan mulai dari blog pribadi, company perusahaan dan yang lainnya.

**[Drupal](https://www.drupal.org/)** juga menyediakan lebih dari 2 ribu themes yang dapat Anda gunakan secara gratis, detailnya dapat di lihat pada link berikut: https://www.drupal.org/project/project\_theme

Untuk mengikuti tutorial instalasi Drupal kali ini pastikan Anda sudah melakukan instalasi web server Nginx, php 7.x (beserta module yang dibutuhkan), dan tentunya database server bisa menggunakan mariadb/mysql, selengkapnya dapat merujuk pada beberapa tautan berikut:

- **_[Cara Instalasi Nginx Di CentOS 8](/cara-instalasi-nginx-di-centos-8/)_**
- **_[Cara Instalasi PHP 7 di CentOS 8](/cara-instalasi-php-7-di-centos-8/)_**
- **_[Cara Instalasi Database MariaDB di CentOS 8](/cara-instalasi-database-mariadb-di-centos-8/)_**

Memastikan service nginx, php-fpm dan mariadb telah running

    [root@tutorial ~]# systemctl status nginx |grep Active
       Active: active (running) since Tue 2020-08-25 07:37:07 UTC; 1min 51s ago
    [root@tutorial ~]# systemctl status php-fpm |grep Active
       Active: active (running) since Tue 2020-08-25 07:38:48 UTC; 16s ago
    [root@tutorial ~]# systemctl status mariadb |grep Active
       Active: active (running) since Tue 2020-08-25 07:37:13 UTC; 1min 56s ago
    [root@tutorial ~]#

Disini kami menggunakan PHP 7.4, silakan install beberapa module php yang dibutuhkan

    [root@tutorial ~]# php --version
    PHP 7.4.9 (cli) (built: Aug 4 2020 08:28:13) ( NTS )
    Copyright (c) The PHP Group
    Zend Engine v3.4.0, Copyright (c) Zend Technologies
        with Zend OPcache v7.4.9, Copyright (c), by Zend Technologies
    [root@tutorial ~]#
    [root@tutorial ~]#
    [root@tutorial ~]# dnf install php-curl php-mbstring php-gd php-xml php-pear php-fpm php-mysql php-pdo php-opcache php-json php-zip -y

Menentukan path direktori root Drupal dan untuk Drupal

    [root@tutorial ~]#
    [root@tutorial ~]# cd /usr/share/nginx/
    [root@tutorial nginx]#
    [root@tutorial nginx]# wget https://www.drupal.org/download-latest/zip
    --2020-08-24 19:52:15-- https://www.drupal.org/download-latest/zip
    Resolving www.drupal.org (www.drupal.org)... 151.101.2.217, 151.101.66.217, 151.101.130.217, ...
    Connecting to www.drupal.org (www.drupal.org)|151.101.2.217|:443... connected.
    HTTP request sent, awaiting response... 302 Moved Temporarily
    Location: https://ftp.drupal.org/files/projects/drupal-9.0.3.zip [following]
    --2020-08-24 19:52:16-- https://ftp.drupal.org/files/projects/drupal-9.0.3.zip
    Resolving ftp.drupal.org (ftp.drupal.org)... 151.101.2.217, 151.101.66.217, 151.101.130.217, ...
    Connecting to ftp.drupal.org (ftp.drupal.org)|151.101.2.217|:443... connected.
    HTTP request sent, awaiting response... 200 OK
    Length: 28325753 (27M) [application/zip]
    Saving to: ‘zip’
    
    zip 100%[===============================================>] 27.01M 31.9MB/s in 0.8s
    
    2020-08-24 19:52:17 (31.9 MB/s) - ‘zip’ saved [28325753/28325753]
    
    [root@tutorial nginx]#

_Noted: Disini kami menggunakan Drupal versi latest yang dapat di lihat pada link berikut:_ https://www.drupal.org/download

Unzip file Drupal yang baru saja di unduh

    [root@tutorial nginx]#
    [root@tutorial nginx]# unzip zip

Ubah penamaan Drupal sesuai keinginan Anda

    [root@tutorial nginx]#
    [root@tutorial nginx]# mv drupal-9.0.3/ drupal

Berikan hak akses dan owner untuk direktori Drupal

    [root@tutorial nginx]#
    [root@tutorial nginx]# chown -R nginx:nginx drupal/
    [root@tutorial nginx]# chmod -R 755 drupal/

Membuat direktori _files_ dan copy pengaturan _(settings.conf)_ default dari Drupal

    [root@tutorial nginx]#
    [root@tutorial nginx]# mkdir drupal/sites/default/files
    [root@tutorial nginx]# cd drupal/sites/default/
    [root@tutorial default]# cp -p default.settings.php setting.php
    [root@tutorial default]#

Membuat database Drupal

    [root@tutorial default]#
    [root@tutorial default]# mysql -u root -p
    Enter password:
    Welcome to the MariaDB monitor. Commands end with ; or \g.
    Your MariaDB connection id is 496
    Server version: 10.3.17-MariaDB MariaDB Server
    
    Copyright (c) 2000, 2018, Oracle, MariaDB Corporation Ab and others.
    
    Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.
    
    MariaDB [(none)]> CREATE DATABASE drupal;
    Query OK, 1 row affected (0.001 sec)
    
    MariaDB [(none)]> GRANT ALL ON drupal.* TO 'user_drupal'@'localhost' IDENTIFIED BY 'password_drupal';
    Query OK, 0 rows affected (0.002 sec)
    
    MariaDB [(none)]> FLUSH PRIVILEGES;
    Query OK, 0 rows affected (0.001 sec)
    
    MariaDB [(none)]> quit
    Bye
    [root@tutorial default]#

_Noted: Harap dicatat untuk nama database, user dan password karena dibutuhkan pada saat instalasi_

Jika sudah selanjutnya membuat server block Nginx

    [root@tutorial default]#
    [root@tutorial default]# vim /etc/nginx/conf.d/drupal.conf

Berikut full konfigurasi server block nya

    server {
            listen 80;
            server_name drupal.nurhamim.my.id;
            root /usr/share/nginx/drupal;
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

_Noted: Silakan disesuaikan path direktori dan server\_name nya, dan disini kami menggunakan unix socket untuk komunikasi nginx ke php-fpm._

Jika sudah, silakan reload php-fpm dan nginx

    [root@tutorial default]#
    [root@tutorial default]# systemctl reload nginx
    [root@tutorial default]# systemctl reload php-fpm

Selanjutnya menambahkan A record pada domain atau subdomain dan di arahkan ke IP Public VM atau VPS contohnya

<figure class="wp-block-image size-large"><img loading="lazy" width="1024" height="205" src="/content/images/wordpress/2020/08/1-1024x205.png" alt="" class="wp-image-259" srcset="/content/images/wordpress/2020/08/1-1024x205.png 1024w, /content/images/wordpress/2020/08/1-300x60.png 300w, /content/images/wordpress/2020/08/1-768x154.png 768w, /content/images/wordpress/2020/08/1.png 1027w" sizes="(max-width: 1024px) 100vw, 1024px"></figure>

Verifikasi bisa menggunakan ping

<figure class="wp-block-image size-large"><img loading="lazy" width="617" height="102" src="/content/images/wordpress/2020/08/2.png" alt="" class="wp-image-260" srcset="/content/images/wordpress/2020/08/2.png 617w, /content/images/wordpress/2020/08/2-300x50.png 300w" sizes="(max-width: 617px) 100vw, 617px"></figure>

Akses subdomain atau domain Anda melalui browser untuk melanjutkan proses instalasi.

<figure class="wp-block-image size-large"><img loading="lazy" width="1024" height="740" src="/content/images/wordpress/2020/08/3-1024x740.png" alt="" class="wp-image-261" srcset="/content/images/wordpress/2020/08/3-1024x740.png 1024w, /content/images/wordpress/2020/08/3-300x217.png 300w, /content/images/wordpress/2020/08/3-768x555.png 768w, /content/images/wordpress/2020/08/3.png 1055w" sizes="(max-width: 1024px) 100vw, 1024px"></figure>

Gambar diatas Anda diminta untuk memilih Bahasa yang ingin digunakan lalu _Save and continue_

<figure class="wp-block-image size-large"><img loading="lazy" width="1024" height="759" src="/content/images/wordpress/2020/08/4-1024x759.png" alt="" class="wp-image-262" srcset="/content/images/wordpress/2020/08/4-1024x759.png 1024w, /content/images/wordpress/2020/08/4-300x222.png 300w, /content/images/wordpress/2020/08/4-768x569.png 768w, /content/images/wordpress/2020/08/4.png 1057w" sizes="(max-width: 1024px) 100vw, 1024px"></figure>

Pilih profile instalasi, disini kami menggunakan _Standard_ silakan disesuaikan dengan kebutuhan, _Save and continue_

<figure class="wp-block-image size-large"><img loading="lazy" width="1024" height="934" src="/content/images/wordpress/2020/08/5-1024x934.png" alt="" class="wp-image-263" srcset="/content/images/wordpress/2020/08/5-1024x934.png 1024w, /content/images/wordpress/2020/08/5-300x274.png 300w, /content/images/wordpress/2020/08/5-768x700.png 768w, /content/images/wordpress/2020/08/5.png 1054w" sizes="(max-width: 1024px) 100vw, 1024px"></figure>

Silakan input nama, username, dan password database yang sudah dibuat sebelumny, _Save and continue_

<figure class="wp-block-image size-large"><img loading="lazy" width="1024" height="746" src="/content/images/wordpress/2020/08/6-1024x746.png" alt="" class="wp-image-264" srcset="/content/images/wordpress/2020/08/6-1024x746.png 1024w, /content/images/wordpress/2020/08/6-300x219.png 300w, /content/images/wordpress/2020/08/6-768x560.png 768w, /content/images/wordpress/2020/08/6.png 1055w" sizes="(max-width: 1024px) 100vw, 1024px"></figure>

Menunggu proses instalasi Drupal sampai selesai

<figure class="wp-block-image size-large"><img loading="lazy" width="1024" height="1012" src="/content/images/wordpress/2020/08/7-1024x1012.png" alt="" class="wp-image-265" srcset="/content/images/wordpress/2020/08/7-1024x1012.png 1024w, /content/images/wordpress/2020/08/7-300x297.png 300w, /content/images/wordpress/2020/08/7-768x759.png 768w, /content/images/wordpress/2020/08/7.png 1034w" sizes="(max-width: 1024px) 100vw, 1024px"></figure>

Set-up profile dan menentukan username dan password login ke administrator Drupal, _Save and continue_

<figure class="wp-block-image size-large"><img loading="lazy" width="1024" height="711" src="/content/images/wordpress/2020/08/8-1024x711.png" alt="" class="wp-image-266" srcset="/content/images/wordpress/2020/08/8-1024x711.png 1024w, /content/images/wordpress/2020/08/8-300x208.png 300w, /content/images/wordpress/2020/08/8-768x533.png 768w, /content/images/wordpress/2020/08/8.png 1038w" sizes="(max-width: 1024px) 100vw, 1024px"></figure>

Selamat CMS Drupal sudah berhasil terinstall, berikut tampilan default dari Drupal.

<figure class="wp-block-image size-large"><img loading="lazy" width="1024" height="578" src="/content/images/wordpress/2020/08/9-1024x578.png" alt="" class="wp-image-267" srcset="/content/images/wordpress/2020/08/9-1024x578.png 1024w, /content/images/wordpress/2020/08/9-300x169.png 300w, /content/images/wordpress/2020/08/9-768x434.png 768w, /content/images/wordpress/2020/08/9.png 1061w" sizes="(max-width: 1024px) 100vw, 1024px"></figure>

Selamat mencoba 😁

Please follow and like us:

[![error](/wp-content/plugins/ultimate-social-media-icons/images/follow_subscribe.png)](https://api.follow.it/widgets/icon/VHc3d1lpVGdwRnE5QnV0eERCNUx5RCtvTTVoUkNYS3NNRmd5eVhlQW9tNXRHS3VTbGh6Y0NybkRJRS8zSGpjRDVZb1ZGMlNTSEpJYUpuZzZqNzdnd3VSN3dwM2VlQTF6ejJEaGV5UGRUbnlEcHFNd3luYTV4ZTZtUGowVWI2Q2x8M2kzdnBEeUIrUk5xOFI5TXZ3cHF3bFNQRkRJSGhUNGdrRFd0TlNtdE1OWT0=/OA==/)

[![fb-share-icon](/wp-content/plugins/ultimate-social-media-icons/images/visit_icons/fbshare_bck.png "Facebook Share")](https://www.facebook.com/sharer/sharer.php?u=https%3A%2F%2Fbelajarlinux.id%2F%3Fp%3D258%26ghostexport%3Dtrue%26submit%3DDownload+Ghost+File)

[![Tweet](/wp-content/plugins/ultimate-social-media-icons/images/visit_icons/en_US_Tweet.svg "Tweet")](https://twitter.com/intent/tweet?text=Cara+Instalasi+Drupal+Menggunakan+Nginx+di+CentOS+8+https://belajarlinux.id/?p=258&ghostexport=true&submit=Download Ghost File)

[![fb-share-icon](/wp-content/plugins/ultimate-social-media-icons/images/share_icons/Pinterest_Save/en_US_save.svg "Pin Share")](#)

<!--kg-card-end: html-->
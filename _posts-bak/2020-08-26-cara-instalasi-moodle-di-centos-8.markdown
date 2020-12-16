---
layout: post
title: Cara Instalasi Moodle Menggunakan Nginx di CentOS 8
featured: true
date: '2020-08-26 12:14:12'
tags:
- centos
- cms
- framework
---

**[Moodle](https://moodle.org/)** salah satu platform yang biasa digunakan untuk membangun _Learning Management System (LMS)_, moodle cukup power full dan bahkan saat ini sangat banyak institusi pendidikan yang menggunakan moodle sebagai platform belajar mengajar secara daring.

Moodle sendiri open source artinya Anda dapat dengan bebas untuk menggunakan, melakukan kustomisasi dan yang lainnya.

Moodle juga sudah tersedia di applikasi android maupun iOS dengan begitu sistem pembelajaran daring dapat dilakukan melalui Apps dengan simple dan mudah digunakan tentunya.

Untuk mengetahui system requirement hardware software moodle silakan klik link berikut ini: **[Requirements](https://docs.moodle.org/39/en/Installing_Moodle#Requirements)**.

Untuk mengikuti tutorial ini pastikan Anda sudah melakukan instalasi web server nginx, database mariadb/mysql dan php 7.x, jika belum Anda dapat mengikuti tutorial berikut, terlebih dahulu.

- **_[Cara Instalasi Nginx Di CentOS 8](/cara-instalasi-nginx-di-centos-8/)_**
- **_[Cara Instalasi Database MariaDB di CentOS 8](/cara-instalasi-database-mariadb-di-centos-8/)_**
- **_[Cara Instalasi PHP 7 di CentOS 8](/cara-instalasi-php-7-di-centos-8/)_**

Jika Anda sudah melakukan instalasi, selanjutnya pastikan semua service nya running

    [root@tutorial ~]#
    [root@tutorial ~]# systemctl status nginx |grep active
       Active: active (running) since Tue 2020-08-25 15:01:08 UTC; 12h ago
    [root@tutorial ~]# systemctl status php-fpm |grep active
       Active: active (running) since Wed 2020-08-26 03:54:44 UTC; 31s ago
       Status: "Processes active: 0, idle: 5, Requests: 0, slow: 0, Traffic: 0req/sec"
    [root@tutorial ~]# systemctl status mariadb |grep active
       Active: active (running) since Tue 2020-08-25 07:37:13 UTC; 20h ago
    [root@tutorial ~]#

Disini kami menggunakan php versi 7.4 silakan install beberapa module berikut

    [root@tutorial ~]#
    [root@tutorial ~]# php --version
    PHP 7.4.9 (cli) (built: Aug 4 2020 08:28:13) ( NTS )
    Copyright (c) The PHP Group
    Zend Engine v3.4.0, Copyright (c) Zend Technologies
        with Zend OPcache v7.4.9, Copyright (c), by Zend Technologies
    [root@tutorial ~]
    
    [root@tutorial ~]#
    [root@tutorial ~]# dnf install php php-ldap php-xml php-soap php-xmlrpc php-mbstring php-json php-gd php-mcrypt php-curl php-pspell php-zip php-common -y

Selanjutnya membuat database Moodle

    [root@tutorial nginx]#
    [root@tutorial nginx]# mysql -u root -p
    Enter password:
    Welcome to the MariaDB monitor. Commands end with ; or \g.
    Your MariaDB connection id is 186
    Server version: 10.3.17-MariaDB MariaDB Server
    
    Copyright (c) 2000, 2018, Oracle, MariaDB Corporation Ab and others.
    
    Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.
    
    MariaDB [(none)]> CREATE DATABASE moodle DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
    Query OK, 1 row affected (0.000 sec)
    
    MariaDB [(none)]> GRANT SELECT,INSERT,UPDATE,DELETE,CREATE,CREATE TEMPORARY TABLES,DROP,INDEX,ALTER ON moodle.* TO 'moodleuser'@'localhost' IDENTIFIED BY 'passwordmoodle';
    Query OK, 0 rows affected (0.001 sec)
    
    MariaDB [(none)]> FLUSH PRIVILEGES;
    Query OK, 0 rows affected (0.000 sec)
    
    MariaDB [(none)]> exit
    Bye
    [root@tutorial nginx]#

_Noted: Harap di catat nama, user dan password database diatas, nantinya informasi tersebut digunakan pada saat ini instalasi_.

Selanjutnya menentukan direktori root moodle dan unduh moodle versi latest (stabil) melalui website resmi moodle berikut: **[Latest release](https://download.moodle.org/releases/latest/)**

    [root@tutorial ~]#
    [root@tutorial ~]# cd /usr/share/nginx/
    [root@tutorial nginx]#
    [root@tutorial nginx]# wget https://download.moodle.org/download.php/direct/stable39/moodle-latest-39.zip
    --2020-08-26 03:58:56-- https://download.moodle.org/download.php/direct/stable39/moodle-latest-39.zip
    Resolving download.moodle.org (download.moodle.org)... 104.22.65.81, 104.22.64.81, 172.67.26.233, ...
    Connecting to download.moodle.org (download.moodle.org)|104.22.65.81|:443... connected.
    HTTP request sent, awaiting response... 200 OK
    Length: 74036903 (71M) [application/zip]
    Saving to: ‘moodle-latest-39.zip’
    
    moodle-latest-39.zip 100%[=================================================>] 70.61M 113MB/s in 0.6s
    
    2020-08-26 03:58:58 (113 MB/s) - ‘moodle-latest-39.zip’ saved [74036903/74036903]
    
    [root@tutorial nginx]#

Unzip file moodle yang sudah di unduh

    [root@tutorial nginx]#
    [root@tutorial nginx]# unzip moodle-latest-39.zip

Berikan hak akses dan owner ke direktori moodle

    [root@tutorial nginx]# chown -R nginx:nginx moodle
    [root@tutorial nginx]# chmod -R 755 moodle

Selanjutnya membuat moodledata dan berikan hak akses 777

    [root@tutorial nginx]#
    [root@tutorial nginx]# mkdir moodledata
    [root@tutorial nginx]# chmod 777 moodledata/
    [root@tutorial nginx]# chown -R nginx:nginx moodledata/

Selanjutnya membuat server block nginx moodle

    [root@tutorial nginx]#
    [root@tutorial nginx]# vim /etc/nginx/conf.d/moodle.conf

Berikut full konfigurasi server block moodle

    server {
            listen 80;
            server_name e-learning.nurhamim.my.id;
            root /usr/share/nginx/moodle;
            index index.php index.html index.htm;
    
            location / {
                    try_files $uri $uri/ /index.php?$query_string;
            }
    
            location ~ [^/]\.php(/|$) {
                    root /usr/share/nginx/moodle;
                    fastcgi_split_path_info ^(.+\.php)(/.+)$;
                    fastcgi_index index.php;
                    fastcgi_pass unix:/run/php-fpm/www.sock;
                    include fastcgi_params;
                    fastcgi_param PATH_INFO $fastcgi_path_info;
                    fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
            }
    
            location ~ /\.ht {
                    deny all;
            }
    }

_Noted: Disini kami menggunakan unix socket tidak menggunakan tcp socket._

Jika sudah selanjutnya pastikan konfigurasi nginx tidak ada yang salah

    [root@tutorial nginx]#
    [root@tutorial nginx]# nginx -t
    nginx: the configuration file /etc/nginx/nginx.conf syntax is ok
    nginx: configuration file /etc/nginx/nginx.conf test is successful
    [root@tutorial nginx]#

Jika sudah silakan reload nginx dan php-fpm

    [root@tutorial nginx]#
    [root@tutorial nginx]# systemctl reload nginx
    [root@tutorial nginx]# systemctl reload php-fpm

Disini kami menggunakan subdomain e-elearning.nurhamim.my.id untuk URL moodle pastikan Anda telah membuat A record di DNS management domain

<figure class="wp-block-image size-large"><img loading="lazy" width="1025" height="203" src="/content/images/wordpress/2020/08/1-4.png" alt="" class="wp-image-300" srcset="/content/images/wordpress/2020/08/1-4.png 1025w, /content/images/wordpress/2020/08/1-4-300x59.png 300w, /content/images/wordpress/2020/08/1-4-768x152.png 768w" sizes="(max-width: 1025px) 100vw, 1025px"></figure>

Verifikasi bisa menggunakan ping

<figure class="wp-block-image size-large"><img loading="lazy" width="718" height="125" src="/content/images/wordpress/2020/08/2-4.png" alt="" class="wp-image-301" srcset="/content/images/wordpress/2020/08/2-4.png 718w, /content/images/wordpress/2020/08/2-4-300x52.png 300w" sizes="(max-width: 718px) 100vw, 718px"></figure>

Silakan akses URL diatas melalui browser

<figure class="wp-block-image size-large"><img loading="lazy" width="1024" height="421" src="/content/images/wordpress/2020/08/3-3-1024x421.png" alt="" class="wp-image-302" srcset="/content/images/wordpress/2020/08/3-3-1024x421.png 1024w, /content/images/wordpress/2020/08/3-3-300x123.png 300w, /content/images/wordpress/2020/08/3-3-768x316.png 768w, /content/images/wordpress/2020/08/3-3.png 1363w" sizes="(max-width: 1024px) 100vw, 1024px"></figure>

Pilih Bahasa instalasi yang ingin digunakan, _Next_

<figure class="wp-block-image size-large"><img loading="lazy" width="1024" height="541" src="/content/images/wordpress/2020/08/4-4-1024x541.png" alt="" class="wp-image-303" srcset="/content/images/wordpress/2020/08/4-4-1024x541.png 1024w, /content/images/wordpress/2020/08/4-4-300x158.png 300w, /content/images/wordpress/2020/08/4-4-768x405.png 768w, /content/images/wordpress/2020/08/4-4.png 1347w" sizes="(max-width: 1024px) 100vw, 1024px"></figure>

Pastikan direktori _moodledata_ sudah sesuai, _Next_

<figure class="wp-block-image size-large"><img loading="lazy" width="1024" height="400" src="/content/images/wordpress/2020/08/5-3-1024x400.png" alt="" class="wp-image-304" srcset="/content/images/wordpress/2020/08/5-3-1024x400.png 1024w, /content/images/wordpress/2020/08/5-3-300x117.png 300w, /content/images/wordpress/2020/08/5-3-768x300.png 768w, /content/images/wordpress/2020/08/5-3.png 1366w" sizes="(max-width: 1024px) 100vw, 1024px"></figure>

Pilih database yang Anda gunakan, disini kami menggunakan MariaDB, _Next_

<figure class="wp-block-image size-large"><img loading="lazy" width="1024" height="536" src="/content/images/wordpress/2020/08/6-3-1024x536.png" alt="" class="wp-image-305" srcset="/content/images/wordpress/2020/08/6-3-1024x536.png 1024w, /content/images/wordpress/2020/08/6-3-300x157.png 300w, /content/images/wordpress/2020/08/6-3-768x402.png 768w, /content/images/wordpress/2020/08/6-3.png 1353w" sizes="(max-width: 1024px) 100vw, 1024px"></figure>

Konfigurasi database Anda, _Next_

<figure class="wp-block-image size-large"><img loading="lazy" width="1024" height="534" src="/content/images/wordpress/2020/08/7-2-1024x534.png" alt="" class="wp-image-306" srcset="/content/images/wordpress/2020/08/7-2-1024x534.png 1024w, /content/images/wordpress/2020/08/7-2-300x156.png 300w, /content/images/wordpress/2020/08/7-2-768x400.png 768w, /content/images/wordpress/2020/08/7-2.png 1347w" sizes="(max-width: 1024px) 100vw, 1024px"></figure>

Klik _Continue_ untuk lanjut ke tahap selanjutnya

<figure class="wp-block-image size-large"><img loading="lazy" width="1024" height="513" src="/content/images/wordpress/2020/08/8-2-1024x513.png" alt="" class="wp-image-307" srcset="/content/images/wordpress/2020/08/8-2-1024x513.png 1024w, /content/images/wordpress/2020/08/8-2-300x150.png 300w, /content/images/wordpress/2020/08/8-2-768x385.png 768w, /content/images/wordpress/2020/08/8-2.png 1345w" sizes="(max-width: 1024px) 100vw, 1024px"></figure>

verifikasi module php, diatas terdapat fambar warning dapat diabaikan karena saat ini instalasi tanpa menggunakan SSL (HTTPS), _Continue_

<figure class="wp-block-image size-large"><img loading="lazy" width="1024" height="511" src="/content/images/wordpress/2020/08/9-2-1024x511.png" alt="" class="wp-image-308" srcset="/content/images/wordpress/2020/08/9-2-1024x511.png 1024w, /content/images/wordpress/2020/08/9-2-300x150.png 300w, /content/images/wordpress/2020/08/9-2-768x383.png 768w, /content/images/wordpress/2020/08/9-2.png 1348w" sizes="(max-width: 1024px) 100vw, 1024px"></figure>

Tunggu proses instalasi sampai selesai, jika sudah silakan klik _Continue_

<figure class="wp-block-image size-large"><img loading="lazy" width="1024" height="547" src="/content/images/wordpress/2020/08/10-1024x547.png" alt="" class="wp-image-309" srcset="/content/images/wordpress/2020/08/10-1024x547.png 1024w, /content/images/wordpress/2020/08/10-300x160.png 300w, /content/images/wordpress/2020/08/10-768x410.png 768w, /content/images/wordpress/2020/08/10.png 1364w" sizes="(max-width: 1024px) 100vw, 1024px"></figure><figure class="wp-block-image size-large"><img loading="lazy" width="1024" height="526" src="/content/images/wordpress/2020/08/11-1024x526.png" alt="" class="wp-image-310" srcset="/content/images/wordpress/2020/08/11-1024x526.png 1024w, /content/images/wordpress/2020/08/11-300x154.png 300w, /content/images/wordpress/2020/08/11-768x394.png 768w, /content/images/wordpress/2020/08/11.png 1346w" sizes="(max-width: 1024px) 100vw, 1024px"></figure>

Isi General informasi dari E-Learning Moodle Anda, dan input juga username dan password Admin Moodle, _Update profile_

<figure class="wp-block-image size-large"><img loading="lazy" width="1024" height="551" src="/content/images/wordpress/2020/08/12-1024x551.png" alt="" class="wp-image-312" srcset="/content/images/wordpress/2020/08/12-1024x551.png 1024w, /content/images/wordpress/2020/08/12-300x162.png 300w, /content/images/wordpress/2020/08/12-768x414.png 768w, /content/images/wordpress/2020/08/12.png 1365w" sizes="(max-width: 1024px) 100vw, 1024px"></figure>

Disini Anda dapat isi name sesuai keinginan Anda , _Save changes_

<figure class="wp-block-image size-large"><img loading="lazy" width="1024" height="551" src="/content/images/wordpress/2020/08/13-1024x551.png" alt="" class="wp-image-313" srcset="/content/images/wordpress/2020/08/13-1024x551.png 1024w, /content/images/wordpress/2020/08/13-300x162.png 300w, /content/images/wordpress/2020/08/13-768x414.png 768w, /content/images/wordpress/2020/08/13.png 1363w" sizes="(max-width: 1024px) 100vw, 1024px"></figure>

Selamat Moodle Anda sudah berhasil diinstall, klik menu _Dashboard_ untuk melihat _Dashboard Admin Moodle_

<figure class="wp-block-image size-large"><img loading="lazy" width="1024" height="553" src="/content/images/wordpress/2020/08/14-1024x553.png" alt="" class="wp-image-314" srcset="/content/images/wordpress/2020/08/14-1024x553.png 1024w, /content/images/wordpress/2020/08/14-300x162.png 300w, /content/images/wordpress/2020/08/14-768x414.png 768w, /content/images/wordpress/2020/08/14.png 1362w" sizes="(max-width: 1024px) 100vw, 1024px"></figure>

Berikut contoh home page default moodle

<figure class="wp-block-image size-large"><img loading="lazy" width="1024" height="263" src="/content/images/wordpress/2020/08/15-1024x263.png" alt="" class="wp-image-315" srcset="/content/images/wordpress/2020/08/15-1024x263.png 1024w, /content/images/wordpress/2020/08/15-300x77.png 300w, /content/images/wordpress/2020/08/15-768x197.png 768w, /content/images/wordpress/2020/08/15.png 1364w" sizes="(max-width: 1024px) 100vw, 1024px"></figure>

Dan Berikut contoh home page login moodle

<figure class="wp-block-image size-large"><img loading="lazy" width="1024" height="388" src="/content/images/wordpress/2020/08/16-1024x388.png" alt="" class="wp-image-316" srcset="/content/images/wordpress/2020/08/16-1024x388.png 1024w, /content/images/wordpress/2020/08/16-300x114.png 300w, /content/images/wordpress/2020/08/16-768x291.png 768w, /content/images/wordpress/2020/08/16.png 1357w" sizes="(max-width: 1024px) 100vw, 1024px"></figure>

Selamat mencoba 😁

Please follow and like us:

[![error](/wp-content/plugins/ultimate-social-media-icons/images/follow_subscribe.png)](https://api.follow.it/widgets/icon/VHc3d1lpVGdwRnE5QnV0eERCNUx5RCtvTTVoUkNYS3NNRmd5eVhlQW9tNXRHS3VTbGh6Y0NybkRJRS8zSGpjRDVZb1ZGMlNTSEpJYUpuZzZqNzdnd3VSN3dwM2VlQTF6ejJEaGV5UGRUbnlEcHFNd3luYTV4ZTZtUGowVWI2Q2x8M2kzdnBEeUIrUk5xOFI5TXZ3cHF3bFNQRkRJSGhUNGdrRFd0TlNtdE1OWT0=/OA==/)

[![fb-share-icon](/wp-content/plugins/ultimate-social-media-icons/images/visit_icons/fbshare_bck.png "Facebook Share")](https://www.facebook.com/sharer/sharer.php?u=https%3A%2F%2Fbelajarlinux.id%2F%3Fp%3D299%26ghostexport%3Dtrue%26submit%3DDownload+Ghost+File)

[![Tweet](/wp-content/plugins/ultimate-social-media-icons/images/visit_icons/en_US_Tweet.svg "Tweet")](https://twitter.com/intent/tweet?text=Cara+Instalasi+Moodle+Menggunakan+Nginx+di+CentOS+8+https://belajarlinux.id/?p=299&ghostexport=true&submit=Download Ghost File)

[![fb-share-icon](/wp-content/plugins/ultimate-social-media-icons/images/share_icons/Pinterest_Save/en_US_save.svg "Pin Share")](#)

<!--kg-card-end: html-->
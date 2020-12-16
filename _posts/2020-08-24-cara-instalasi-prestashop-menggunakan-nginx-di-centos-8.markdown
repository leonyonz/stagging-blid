---
layout: post
title: Cara Instalasi Prestashop Menggunakan Nginx di CentOS 8
featured: true
date: '2020-08-24 22:01:54'
tags:
- centos
- cms
---

**[Prestashop](https://www.prestashop.com)** adalah sebuah CMS yang diperuntukan untuk e-commerce, prestashop sendiri open source (bebas) dalam artian semua orang dapat menggunakan, mengembangkan dan berpartisipasi sehingga CMS ini tetap up to date.

**[Prestashop](https://www.prestashop.com)** sudah menyediakan berbagai macam themes dan addons yang dapat Anda gunakan secara free dan dapat disesuaikan dengan produk yang ingin Anda jual tentunya.

Sangat banyak fitur – fitur e-commerce yang dapat Anda gunakan jika Anda menggunakan Prestashop.

Untuk mengetahui system requirement prestashop Anda dapat klik pada tautan berikut: **[PrestaShop System Requirements](https://www.prestashop.com/en/system-requirements)**

Sedangkan untuk mengikuti tutorial kali ini pastikan Anda sudah melakukan instalasi service web server (nginx), database (mariadb/mysql), dan php versi 7.x (beserta module) yang dibutuhkan.

Jika belum silakan mengikuti panduan berikut, terlebih dahulu:

- _**[Cara Instalasi Nginx Di CentOS 8](/cara-instalasi-nginx-di-centos-8/)**_
- _**[Cara Instalasi PHP 7 di CentOS 8](/cara-instalasi-php-7-di-centos-8/)**_
- _**[Cara Instalasi Database MariaDB di CentOS 8](/cara-instalasi-database-mariadb-di-centos-8/)**_

Pastikan service nginx, php-fpm dan database Anda running

    [root@tutorial ~]#
    [root@tutorial ~]# systemctl status nginx |grep Active
       Active: active (running) since Mon 2020-08-24 07:38:54 UTC; 6h ago
    [root@tutorial ~]# systemctl status php-fpm |grep Active
       Active: active (running) since Mon 2020-08-24 11:22:29 UTC; 3h 16min ago
    [root@tutorial ~]# systemctl status mariadb |grep Active
       Active: active (running) since Sun 2020-08-23 04:11:36 UTC; 1 day 10h ago
    [root@tutorial ~]#

Kemudian, install beberapa module php tambahan sebagai persyaratan instalasi prestashop

    [root@tutorial ~]#
    [root@tutorial ~]# dnf install php-{spl,hash,ctype,json,mbstring,zip,gd,curl,xml,common} -y

Jika sudah, selanjutnya menentukan root direktori prestashop dan unduh file prestashop, disini kami menggunakan prestashop version 1.7.6.4 jika ingin menggunakan atau ingin tahu versi latest dapat dilihat pada link berikut: **[Download PrestaShop](https://www.prestashop.com/en/download?ab=1)**

    [root@tutorial ~]#
    [root@tutorial ~]# cd /usr/share/nginx/
    [root@tutorial nginx]#
    [root@tutorial nginx]# mkdir prestashop
    [root@tutorial nginx]#
    [root@tutorial nginx]# wget wget https://download.prestashop.com/download/releases/prestashop_1.7.6.4.zip
    --2020-08-24 13:54:43-- http://wget/
    Resolving wget (wget)... failed: Name or service not known.
    wget: unable to resolve host address ‘wget’
    --2020-08-24 13:54:43-- https://download.prestashop.com/download/releases/prestashop_1.7.6.4.zip
    Resolving download.prestashop.com (download.prestashop.com)... 23.74.228.148
    Connecting to download.prestashop.com (download.prestashop.com)|23.74.228.148|:443... connected.
    HTTP request sent, awaiting response... 200 OK
    Length: unspecified [application/zip]
    Saving to: ‘prestashop_1.7.6.4.zip’
    
    prestashop_1.7.6.4.zip [<=>] 59.47M 14.7MB/s in 5.3s
    
    2020-08-24 13:54:56 (11.2 MB/s) - ‘prestashop_1.7.6.4.zip’ saved [62358828]
    
    FINISHED --2020-08-24 13:54:56--
    Total wall clock time: 13s
    Downloaded: 1 files, 59M in 5.3s (11.2 MB/s)
    [root@tutorial nginx]#

Unzip file prestashop yang baru saja kita unduh

    [root@tutorial nginx]#
    [root@tutorial nginx]# unzip prestashop_1.7.6.4.zip -d prestashop/
    Archive: prestashop_1.7.6.4.zip
      inflating: prestashop/prestashop.zip
      inflating: prestashop/index.php
      inflating: prestashop/Install_PrestaShop.html
    [root@tutorial nginx]#

Berikan hak akses dan owner terhadap direktori prestashop

    [root@tutorial nginx]# chown -R nginx:nginx prestashop
    [root@tutorial nginx]# chmod -R 777 prestashop

_Noted: permission 777 hanya untuk instalasi saja, diakhir tutorial akan diubah menjadi 755 setelah instalasi dilakukan_

Selanjutnya membuat database prestashop

    [root@tutorial nginx]#
    [root@tutorial nginx]# mysql -u root -p
    Enter password:
    Welcome to the MariaDB monitor. Commands end with ; or \g.
    Your MariaDB connection id is 198
    Server version: 10.3.17-MariaDB MariaDB Server
    
    Copyright (c) 2000, 2018, Oracle, MariaDB Corporation Ab and others.
    
    Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.
    
    MariaDB [(none)]> CREATE DATABASE prestashop;
    Query OK, 1 row affected (0.001 sec)
    
    MariaDB [(none)]> CREATE USER 'userpresta'@'localhost' IDENTIFIED BY 'passwordpresta';
    Query OK, 0 rows affected (0.001 sec)
    
    MariaDB [(none)]> GRANT ALL PRIVILEGES ON prestashop.* TO 'userpresta'@'localhost';
    Query OK, 0 rows affected (0.002 sec)
    
    MariaDB [(none)]> FLUSH PRIVILEGES;
    Query OK, 0 rows affected (0.001 sec)
    
    MariaDB [(none)]> exit
    Bye
    [root@tutorial nginx]#

_Noted: silakan di catat nama database, username dan password database_

Jika sudah silakan membuat server block Nginx untuk prestashop

    [root@tutorial nginx]#
    [root@tutorial nginx]# vim /etc/nginx/conf.d/prestashop.conf

Berikut isi full konfigurasi prestashop, silakan disesuaikan saja

    server {
            listen 80;
            server_name prestashop.nurhamim.my.id;
            root /usr/share/nginx/prestashop;
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

_Noted: disini kami menggunakan unix socket untuk komunikasi nginx ke php-fpm nya jika ingin menggunakan tcp/port silakan ubah koneksinya referensinya dapat dilihat pada link berikut:_ [_Komunikasi Nginx dan PHP-FPM Menggunakan Unix atau TCP/IP Socket_](/komunikasi-nginx-dan-php-fpm-menggunakan-unix-atau-tcp-ip-socket/)

Selanjutnya verifikasi konfigurasi nginx pastikan ada kesalahan konfigurasi pada server block Nginx

    [root@tutorial nginx]#
    [root@tutorial nginx]# nginx -t
    nginx: the configuration file /etc/nginx/nginx.conf syntax is ok
    nginx: configuration file /etc/nginx/nginx.conf test is successful
    [root@tutorial nginx]#

Reload nginx dan php-fpm

    [root@tutorial nginx]#
    [root@tutorial nginx]# systemctl reload nginx
    [root@tutorial nginx]# systemctl reload php-fpm

Selanjutnya pastikan subdomain atau domain Anda sudah diarahkan ke IP Public VM/VPS Anda dengan cara menambahkan A record contohnya

<figure class="wp-block-image size-large"><img loading="lazy" width="1024" height="216" src="/content/images/wordpress/2020/08/presta02-1024x216.png" alt="" class="wp-image-241" srcset="/content/images/wordpress/2020/08/presta02-1024x216.png 1024w, /content/images/wordpress/2020/08/presta02-300x63.png 300w, /content/images/wordpress/2020/08/presta02-768x162.png 768w, /content/images/wordpress/2020/08/presta02.png 1027w" sizes="(max-width: 1024px) 100vw, 1024px"></figure>

Verifikasi dapat menggunakan ping

<figure class="wp-block-image size-large"><img loading="lazy" width="540" height="99" src="/content/images/wordpress/2020/08/presta01.png" alt="" class="wp-image-242" srcset="/content/images/wordpress/2020/08/presta01.png 540w, /content/images/wordpress/2020/08/presta01-300x55.png 300w" sizes="(max-width: 540px) 100vw, 540px"></figure>

Jika sudah silakan akses sub domain atau domain Anda melalui browser

<figure class="wp-block-image size-large"><img loading="lazy" width="1024" height="472" src="/content/images/wordpress/2020/08/presta03-1024x472.png" alt="" class="wp-image-243" srcset="/content/images/wordpress/2020/08/presta03-1024x472.png 1024w, /content/images/wordpress/2020/08/presta03-300x138.png 300w, /content/images/wordpress/2020/08/presta03-768x354.png 768w, /content/images/wordpress/2020/08/presta03.png 1357w" sizes="(max-width: 1024px) 100vw, 1024px"></figure>

Gambar diatas klik _No thanks_, dan tunggu proses instalasi prestashop

<figure class="wp-block-image size-large"><img loading="lazy" width="1024" height="522" src="/content/images/wordpress/2020/08/presta04-1024x522.png" alt="" class="wp-image-244" srcset="/content/images/wordpress/2020/08/presta04-1024x522.png 1024w, /content/images/wordpress/2020/08/presta04-300x153.png 300w, /content/images/wordpress/2020/08/presta04-768x391.png 768w, /content/images/wordpress/2020/08/presta04.png 1362w" sizes="(max-width: 1024px) 100vw, 1024px"></figure>

Jika sudah Anda akan melihat tampilan seperti berikut ini

<figure class="wp-block-image size-large"><img loading="lazy" width="1024" height="530" src="/content/images/wordpress/2020/08/presta05-1024x530.png" alt="" class="wp-image-245" srcset="/content/images/wordpress/2020/08/presta05-1024x530.png 1024w, /content/images/wordpress/2020/08/presta05-300x155.png 300w, /content/images/wordpress/2020/08/presta05-768x397.png 768w, /content/images/wordpress/2020/08/presta05.png 1349w" sizes="(max-width: 1024px) 100vw, 1024px"></figure>

Gambar diatas meminta Anda untuk memilih bahasa yang ingin Anda gunakan klik _Next_

<figure class="wp-block-image size-large"><img loading="lazy" width="1024" height="534" src="/content/images/wordpress/2020/08/presta06-1024x534.png" alt="" class="wp-image-246" srcset="/content/images/wordpress/2020/08/presta06-1024x534.png 1024w, /content/images/wordpress/2020/08/presta06-300x157.png 300w, /content/images/wordpress/2020/08/presta06-768x401.png 768w, /content/images/wordpress/2020/08/presta06.png 1345w" sizes="(max-width: 1024px) 100vw, 1024px"></figure>

Centang pada _License Agreements_ lalu _klik Next_

<figure class="wp-block-image size-large"><img loading="lazy" width="1024" height="507" src="/content/images/wordpress/2020/08/presta07-1024x507.png" alt="" class="wp-image-248" srcset="/content/images/wordpress/2020/08/presta07-1024x507.png 1024w, /content/images/wordpress/2020/08/presta07-300x149.png 300w, /content/images/wordpress/2020/08/presta07-768x381.png 768w, /content/images/wordpress/2020/08/presta07.png 1348w" sizes="(max-width: 1024px) 100vw, 1024px"></figure><figure class="wp-block-image size-large"><img loading="lazy" width="1024" height="424" src="/content/images/wordpress/2020/08/presta08-1024x424.png" alt="" class="wp-image-249" srcset="/content/images/wordpress/2020/08/presta08-1024x424.png 1024w, /content/images/wordpress/2020/08/presta08-300x124.png 300w, /content/images/wordpress/2020/08/presta08-768x318.png 768w, /content/images/wordpress/2020/08/presta08.png 1356w" sizes="(max-width: 1024px) 100vw, 1024px"></figure>

Isikan informasi toko online Anda secara detail dan **catat** email beserta password yang Anda input yang nantinya akan digunakan sebagai username dan password login ke Administrator, _klik Next_

<figure class="wp-block-image size-large"><img loading="lazy" width="1024" height="520" src="/content/images/wordpress/2020/08/presta09-1024x520.png" alt="" class="wp-image-250" srcset="/content/images/wordpress/2020/08/presta09-1024x520.png 1024w, /content/images/wordpress/2020/08/presta09-300x152.png 300w, /content/images/wordpress/2020/08/presta09-768x390.png 768w, /content/images/wordpress/2020/08/presta09.png 1350w" sizes="(max-width: 1024px) 100vw, 1024px"></figure>

Konfigurasi dan verifikasi database, silakan input database, username dan password database yang sudah dibuat diawal, _klik Next_

<figure class="wp-block-image size-large"><img loading="lazy" width="1024" height="517" src="/content/images/wordpress/2020/08/presta10-1024x517.png" alt="" class="wp-image-251" srcset="/content/images/wordpress/2020/08/presta10-1024x517.png 1024w, /content/images/wordpress/2020/08/presta10-300x151.png 300w, /content/images/wordpress/2020/08/presta10-768x388.png 768w, /content/images/wordpress/2020/08/presta10.png 1351w" sizes="(max-width: 1024px) 100vw, 1024px"></figure>

Tunggu proses instalasi sampai selesai yang membutuhkan waktu, jika sudah hasilnya akan seperti berikut ini

<figure class="wp-block-image size-large"><img loading="lazy" width="1024" height="501" src="/content/images/wordpress/2020/08/presta11-1024x501.png" alt="" class="wp-image-252" srcset="/content/images/wordpress/2020/08/presta11-1024x501.png 1024w, /content/images/wordpress/2020/08/presta11-300x147.png 300w, /content/images/wordpress/2020/08/presta11-768x376.png 768w, /content/images/wordpress/2020/08/presta11.png 1348w" sizes="(max-width: 1024px) 100vw, 1024px"></figure>

Perhatikan gambar diatas untuk keamanan Anda perlu hapus folder **install**

    [root@tutorial nginx]#
    [root@tutorial nginx]# cd prestashop
    [root@tutorial prestashop]# rm -rf install/
    [root@tutorial prestashop]#

Kemudian, akses administrator prestashop dengan cara ketikan subdomain atau domain Anda di browser contoh: http://prestashop.nurhamim.my.id/admin nantinya Anda akan diarahkan (redirect otomatis) ke URL Admin contohnya

<figure class="wp-block-image size-large"><img loading="lazy" width="1024" height="546" src="/content/images/wordpress/2020/08/presta12-1024x546.png" alt="" class="wp-image-253" srcset="/content/images/wordpress/2020/08/presta12-1024x546.png 1024w, /content/images/wordpress/2020/08/presta12-300x160.png 300w, /content/images/wordpress/2020/08/presta12-768x409.png 768w, /content/images/wordpress/2020/08/presta12.png 1366w" sizes="(max-width: 1024px) 100vw, 1024px"></figure>

Silakan di catat URL Admin diatas, dan input email dan password sebelumnya, jika berhasil akan nampak seperti berikut ini tampilan Administrator prestashop

<figure class="wp-block-image size-large"><img loading="lazy" width="1024" height="555" src="/content/images/wordpress/2020/08/presta13-1024x555.png" alt="" class="wp-image-254" srcset="/content/images/wordpress/2020/08/presta13-1024x555.png 1024w, /content/images/wordpress/2020/08/presta13-300x163.png 300w, /content/images/wordpress/2020/08/presta13-768x416.png 768w, /content/images/wordpress/2020/08/presta13.png 1366w" sizes="(max-width: 1024px) 100vw, 1024px"></figure>

Klik **Start**

<figure class="wp-block-image size-large"><img loading="lazy" width="1024" height="554" src="/content/images/wordpress/2020/08/presta14-1024x554.png" alt="" class="wp-image-255" srcset="/content/images/wordpress/2020/08/presta14-1024x554.png 1024w, /content/images/wordpress/2020/08/presta14-300x162.png 300w, /content/images/wordpress/2020/08/presta14-768x415.png 768w, /content/images/wordpress/2020/08/presta14.png 1363w" sizes="(max-width: 1024px) 100vw, 1024px"></figure>

Berikut tampilan themes default dari prestashop

<figure class="wp-block-image size-large"><img loading="lazy" width="1024" height="561" src="/content/images/wordpress/2020/08/presta15-1024x561.png" alt="" class="wp-image-256" srcset="/content/images/wordpress/2020/08/presta15-1024x561.png 1024w, /content/images/wordpress/2020/08/presta15-300x164.png 300w, /content/images/wordpress/2020/08/presta15-768x421.png 768w, /content/images/wordpress/2020/08/presta15.png 1351w" sizes="(max-width: 1024px) 100vw, 1024px"></figure>

Langkah terakhir sesuaikan permission sesuai informasi diawal dan reload nginx

    [root@tutorial nginx]#
    [root@tutorial nginx]# chmod -R 755 prestashop
    [root@tutorial nginx]# systemctl reload nginx

Selamat, instalasi prestashop sudah selesai dilakukan.

Selamat mencoba 😁

Please follow and like us:

[![error](/wp-content/plugins/ultimate-social-media-icons/images/follow_subscribe.png)](https://api.follow.it/widgets/icon/VHc3d1lpVGdwRnE5QnV0eERCNUx5RCtvTTVoUkNYS3NNRmd5eVhlQW9tNXRHS3VTbGh6Y0NybkRJRS8zSGpjRDVZb1ZGMlNTSEpJYUpuZzZqNzdnd3VSN3dwM2VlQTF6ejJEaGV5UGRUbnlEcHFNd3luYTV4ZTZtUGowVWI2Q2x8M2kzdnBEeUIrUk5xOFI5TXZ3cHF3bFNQRkRJSGhUNGdrRFd0TlNtdE1OWT0=/OA==/)

[![fb-share-icon](/wp-content/plugins/ultimate-social-media-icons/images/visit_icons/fbshare_bck.png "Facebook Share")](https://www.facebook.com/sharer/sharer.php?u=https%3A%2F%2Fbelajarlinux.id%2F%3Fp%3D240%26ghostexport%3Dtrue%26submit%3DDownload+Ghost+File)

[![Tweet](/wp-content/plugins/ultimate-social-media-icons/images/visit_icons/en_US_Tweet.svg "Tweet")](https://twitter.com/intent/tweet?text=Cara+Instalasi+Prestashop+Menggunakan+Nginx+di+CentOS+8+https://belajarlinux.id/?p=240&ghostexport=true&submit=Download Ghost File)

[![fb-share-icon](/wp-content/plugins/ultimate-social-media-icons/images/share_icons/Pinterest_Save/en_US_save.svg "Pin Share")](#)

<!--kg-card-end: html-->
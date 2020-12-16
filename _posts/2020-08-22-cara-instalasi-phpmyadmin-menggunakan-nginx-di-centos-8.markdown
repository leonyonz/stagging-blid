---
layout: post
title: Cara Instalasi phpMyAdmin Menggunakan Nginx di CentOS 8
featured: true
date: '2020-08-22 19:22:36'
tags:
- centos
- database
---

phpMyAdmin salah satu aplikasi open source (bebas) yang dapat Anda gunakan untuk mengelola database server MariaDB atau MySQL melalui web base. phpMyAdmin ditulis menggunakan PHP.

Dengan phpMyAdmin Anda dapat dengan mudah melakukan dan membuat database, tables, columns, relations, indexes, useres, permissions, dan lainnya.

Sebelum mengikuti tutorial ini pastikan Anda sudah install terlebih dahulu web server nginx, database (mariadb atau mysql) dan module php, jika belum dapat melihat tutorial berikut:

- **_[Cara Instalasi Nginx Di CentOS 8](/cara-instalasi-nginx-di-centos-8/)_**
- **_[Cara Instalasi PHP 7 di CentOS 8](/cara-instalasi-php-7-di-centos-8/)_**
- **_[Cara Instalasi Database MariaDB di CentOS 8](/cara-instalasi-database-mariadb-di-centos-8/)_**

Pertama kali yang harus Anda pastikan yakni module php _mysqlnd_ sudah terpasang

    [root@tutorial ~]# php -m |grep mysqlnd
    mysqlnd
    [root@tutorial ~]#

Selanjutnya memastikan php-fpm sudah listen atau terinstall

    [root@tutorial ~]# netstat -pl |grep php
    unix 2 [ACC] STREAM LISTENING 91072 15170/php-fpm: mast /run/php-fpm/www.sock
    [root@tutorial ~]#

Selanjutnya unduh phpMyAdmin versi latest

    [root@tutorial ~]#
    [root@tutorial ~]# wget https://files.phpmyadmin.net/phpMyAdmin/5.0.2/phpMyAdmin-5.0.2-all-languages.zip
    --2020-08-22 11:58:14-- https://files.phpmyadmin.net/phpMyAdmin/5.0.2/phpMyAdmin-5.0.2-all-languages.zip
    Resolving files.phpmyadmin.net (files.phpmyadmin.net)... 89.187.162.57
    Connecting to files.phpmyadmin.net (files.phpmyadmin.net)|89.187.162.57|:443... connected.
    HTTP request sent, awaiting response... 200 OK
    Length: 14199213 (14M) [application/zip]
    Saving to: ‘phpMyAdmin-5.0.2-all-languages.zip’
    
    phpMyAdmin-5.0.2-all-languages.zip 100%[========================================================================>] 13.54M 55.4MB/s in 0.2s
    
    2020-08-22 11:58:15 (55.4 MB/s) - ‘phpMyAdmin-5.0.2-all-languages.zip’ saved [14199213/14199213]
    
    [root@tutorial ~]#

Unzip file phpMyAdmin

    [root@tutorial ~]#
    [root@tutorial ~]# ls
    anaconda-ks.cfg original-ks.cfg phpMyAdmin-5.0.2-all-languages.zip
    [root@tutorial ~]#
    [root@tutorial ~]# unzip phpMyAdmin-5.0.2-all-languages.zip

Ubah penamaan direktori phpMyAdmin untuk mempermudah dan cp ke direktori root nginx di _/usr/share/nginx_ seperti berikut

    [root@tutorial ~]#
    [root@tutorial ~]# mv phpMyAdmin-5.0.2-all-languages phpmyadmin
    [root@tutorial ~]#
    [root@tutorial ~]# cp -R phpmyadmin/ /usr/share/nginx/
    [root@tutorial ~]#

Selanjutnya copy sample konfigurasi phpMyAdmin

    [root@tutorial ~]# cp /usr/share/nginx/phpmyadmin/config{.sample,}.inc.php
    [root@tutorial ~]#

Kemudian membuat **_blowfish secret_** yang digunakan sebagai otentikasi berbasis _ **cookie** _ untuk enkripsi kata sandi dalam _ **cookie** _.

Anda dapat membuatnya pada link berikut: **[phpMyAdmin blowfish secret generator](https://phpsolved.com/phpmyadmin-blowfish-secret-generator/?g=[insert_php]echo%20$code;[/insert_php])**.

Jika sudah generate Anda akan mendapatkan secret seperti berikut

<figure class="wp-block-image size-large"><img loading="lazy" width="765" height="214" src="/content/images/wordpress/2020/08/image-41.png" alt="" class="wp-image-163" srcset="/content/images/wordpress/2020/08/image-41.png 765w, /content/images/wordpress/2020/08/image-41-300x84.png 300w" sizes="(max-width: 765px) 100vw, 765px"></figure>

Silahkan tambahkan pada konfigurasi phpMyAdmin

<figure class="wp-block-image size-large"><img loading="lazy" width="815" height="385" src="/content/images/wordpress/2020/08/image-42.png" alt="" class="wp-image-164" srcset="/content/images/wordpress/2020/08/image-42.png 815w, /content/images/wordpress/2020/08/image-42-300x142.png 300w, /content/images/wordpress/2020/08/image-42-768x363.png 768w" sizes="(max-width: 815px) 100vw, 815px"></figure>

Jika sudah silakan simpan file konfigurasi phpMyAdmin dan selanjutnya membuat server block untuk phpMyAdmin

    [root@tutorial ~]# vim /etc/nginx/conf.d/phpmyadmin.conf

Isikan server block seperti berikut

    server {
            listen 80;
            server_name phpmyadmin.nurhamim.my.id;
            root /usr/share/nginx/phpmyadmin;
            access_log /var/log/nginx/phpmyadmin.nurhamim_access.log;
            error_log /var/log/nginx/phpmyadmin.nurhamim_error.log;
            index index.php;
            location / {
                try_files $uri $uri/ /index.php?$args;
            }
            location ~ \.php$ {
                 try_files $uri =404;
                 fastcgi_intercept_errors on;
                 include fastcgi_params;
                 fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
                 fastcgi_pass unix:/run/php-fpm/www.sock;
             }
        }

_Noted: Silakan disesuaikan **server\_name** dengan domain atau subdomain Anda pastikan domain atau subdomainnya sudah di pointing ke VPS atau VM._

Jika sudah silakan simpan dan pastikan tidak ada miss atau kesalahan konfigurasi dan silakan reload nginx beserta php-fpm

    [root@tutorial ~]#
    [root@tutorial ~]# nginx -t
    nginx: the configuration file /etc/nginx/nginx.conf syntax is ok
    nginx: configuration file /etc/nginx/nginx.conf test is successful
    [root@tutorial ~]#
    [root@tutorial ~]# nginx -s reload
    [root@tutorial ~]#
    [root@tutorial ~]# systemctl reload php-fpm
    [root@tutorial ~]#

Jika sudah pastikan subdomain atau domain Anda sudah mengarah ke public IP VPS atau VM Anda masing – masing, contohnya disini kami menggunakan subdomain _phpyadmin.nurhamim.my.id_

<figure class="wp-block-image size-large"><img loading="lazy" width="892" height="153" src="/content/images/wordpress/2020/08/image-43.png" alt="" class="wp-image-165" srcset="/content/images/wordpress/2020/08/image-43.png 892w, /content/images/wordpress/2020/08/image-43-300x51.png 300w, /content/images/wordpress/2020/08/image-43-768x132.png 768w" sizes="(max-width: 892px) 100vw, 892px"></figure>

Apabila sudah mengarah ke IP Public VM atau VPS, silakan akses phpMyAdmin melalui browser dan isikan username dan password login ke database server Anda

<figure class="wp-block-image size-large"><img loading="lazy" width="1024" height="399" src="/content/images/wordpress/2020/08/image-45-1024x399.png" alt="" class="wp-image-167" srcset="/content/images/wordpress/2020/08/image-45-1024x399.png 1024w, /content/images/wordpress/2020/08/image-45-300x117.png 300w, /content/images/wordpress/2020/08/image-45-768x300.png 768w, /content/images/wordpress/2020/08/image-45.png 1364w" sizes="(max-width: 1024px) 100vw, 1024px"></figure>

Jika berhasil Anda akan melihat dashboard phpMyAdmin

<figure class="wp-block-image size-large"><img loading="lazy" width="1024" height="530" src="/content/images/wordpress/2020/08/image-46-1024x530.png" alt="" class="wp-image-168" srcset="/content/images/wordpress/2020/08/image-46-1024x530.png 1024w, /content/images/wordpress/2020/08/image-46-300x155.png 300w, /content/images/wordpress/2020/08/image-46-768x397.png 768w, /content/images/wordpress/2020/08/image-46.png 1363w" sizes="(max-width: 1024px) 100vw, 1024px"></figure>

Saat ini phpMyAdmin sudah terinstall.

Selamat mencoba 😁

Please follow and like us:

[![error](/wp-content/plugins/ultimate-social-media-icons/images/follow_subscribe.png)](https://api.follow.it/widgets/icon/VHc3d1lpVGdwRnE5QnV0eERCNUx5RCtvTTVoUkNYS3NNRmd5eVhlQW9tNXRHS3VTbGh6Y0NybkRJRS8zSGpjRDVZb1ZGMlNTSEpJYUpuZzZqNzdnd3VSN3dwM2VlQTF6ejJEaGV5UGRUbnlEcHFNd3luYTV4ZTZtUGowVWI2Q2x8M2kzdnBEeUIrUk5xOFI5TXZ3cHF3bFNQRkRJSGhUNGdrRFd0TlNtdE1OWT0=/OA==/)

[![fb-share-icon](/wp-content/plugins/ultimate-social-media-icons/images/visit_icons/fbshare_bck.png "Facebook Share")](https://www.facebook.com/sharer/sharer.php?u=https%3A%2F%2Fbelajarlinux.id%2F%3Fp%3D162%26ghostexport%3Dtrue%26submit%3DDownload+Ghost+File)

[![Tweet](/wp-content/plugins/ultimate-social-media-icons/images/visit_icons/en_US_Tweet.svg "Tweet")](https://twitter.com/intent/tweet?text=Cara+Instalasi+phpMyAdmin+Menggunakan+Nginx+di+CentOS+8+https://belajarlinux.id/?p=162&ghostexport=true&submit=Download Ghost File)

[![fb-share-icon](/wp-content/plugins/ultimate-social-media-icons/images/share_icons/Pinterest_Save/en_US_save.svg "Pin Share")](#)

<!--kg-card-end: html-->
---
layout: post
title: Cara Instalasi WordPress menggunakan Nginx di CentOS 8
featured: true
date: '2020-08-24 15:08:01'
tags:
- centos
- cms
---

**[CMS WordPress](https://wordpress.org/)** salah satu CMS yang open source ditulis menggunakan PHP dan bisa dibilang CMS yang multiguna karena dapat digunakan di berbagai jenis contohnya bisa digunakan sebagai website e-commerce, blog pribadi, company dan masih banyak lainnya.

Untuk system requirements WordPress dapat Anda lihat pada link berikut: **[Requirements](https://wordpress.org/about/requirements/)**

Sebelum mengikuti tutorial ini pastikan Anda sudah install web server nginx dan php 7.x (sesuai keinginan) dan database (disini kami menggunakan mariadb), detailnya dapat merujuk pada link berikut

- [**_Cara Instalasi Nginx Di CentOS 8_**](/cara-instalasi-nginx-di-centos-8/)
- [**_Cara Instalasi PHP 7 di CentOS 8_**](/cara-instalasi-php-7-di-centos-8/)
- [_ **Cara Instalasi Database MariaDB di CentOS 8** _](/cara-instalasi-database-mariadb-di-centos-8/)

Pastikan Nginx dan php-fpm Anda sudah running

    [root@tutorial ~]# systemctl status nginx |grep Active
       Active: active (running) since Mon 2020-08-24 07:38:54 UTC; 44s ago
    [root@tutorial ~]#
    [root@tutorial ~]# systemctl status php-fpm |grep Active
       Active: active (running) since Mon 2020-08-24 07:10:20 UTC; 29min ago
    [root@tutorial ~]#
    [root@tutorial ~]# systemctl status mariadb |grep Active
       Active: active (running) since Sun 2020-08-23 04:11:36 UTC; 1 day 3h ago
    [root@tutorial ~]#

Kemudian pastikan Anda sudah install module – module php yang diperlukan berikut beberapa modulu php yang diperlukan

    [root@tutorial ~]#
    [root@tutorial ~]# dnf install php php-mysqlnd php-gd php-ldap php-odbc php-pear php-xml php-xmlrpc php-mbstring php-snmp php-soap -y

Disini kami menggunakan php 7.4 untuk cek versi php sebagai berikut

    [root@tutorial ~]#
    [root@tutorial ~]# php --version
    PHP 7.4.9 (cli) (built: Aug 4 2020 08:28:13) ( NTS )
    Copyright (c) The PHP Group
    Zend Engine v3.4.0, Copyright (c) Zend Technologies
        with Zend OPcache v7.4.9, Copyright (c), by Zend Technologies
    [root@tutorial ~]#

Untuk melihat module php gunakan perintah berikut

    [root@tutorial ~]#
    [root@tutorial ~]# php -m
    [PHP Modules]
    bz2
    calendar
    Core
    ctype
    curl
    date
    dom
    exif

Selanjutnya membuat database wordpress

    [root@tutorial ~]# mysql -u root -p
    Enter password:
    Welcome to the MariaDB monitor. Commands end with ; or \g.
    Your MariaDB connection id is 13
    Server version: 10.3.17-MariaDB MariaDB Server
    
    Copyright (c) 2000, 2018, Oracle, MariaDB Corporation Ab and others.
    
    Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.
    
    MariaDB [(none)]> create database wordpress;
    Query OK, 1 row affected (0.001 sec)
    
    MariaDB [(none)]> create user 'user_wordpress'@'localhost' identified by 'password_wordpress';
    Query OK, 0 rows affected (0.002 sec)
    
    MariaDB [(none)]> grant all privileges on wordpress.* to 'user_wordpress'@'localhost';
    Query OK, 0 rows affected (0.000 sec)
    
    MariaDB [(none)]> flush privileges;
    Query OK, 0 rows affected (0.001 sec)
    
    MariaDB [(none)]> exit;
    Bye
    [root@tutorial ~]#

Unduh wordpress dan menentukan letak root direktori wordpress

    [root@tutorial ~]#
    [root@tutorial ~]# cd /usr/share/nginx/
    [root@tutorial nginx]#
    [root@tutorial nginx]# wget https://wordpress.org/latest.zip
    --2020-08-24 07:46:55-- https://wordpress.org/latest.zip
    Resolving wordpress.org (wordpress.org)... 198.143.164.252
    Connecting to wordpress.org (wordpress.org)|198.143.164.252|:443... connected.
    HTTP request sent, awaiting response... 200 OK
    Length: 13999011 (13M) [application/zip]
    Saving to: ‘latest.zip’
    
    latest.zip 100%[============================================================>] 13.35M 5.73MB/s in 2.3s
    
    2020-08-24 07:47:04 (5.73 MB/s) - ‘latest.zip’ saved [13999011/13999011]
    
    [root@tutorial nginx]#

Unzip file WordPress

    [root@tutorial nginx]#
    [root@tutorial nginx]# dnf install unzip; unzip latest.zip

Konfigurasi WordPress

    [root@tutorial nginx]#
    [root@tutorial nginx]# cd wordpress/
    [root@tutorial wordpress]# cp wp-config-sample.php wp-config.php

Sesuaikan koneksi database WordPress yang sudah dibuat sebelumnya, seperti berikut ini

<figure class="wp-block-image size-large"><img loading="lazy" width="725" height="344" src="/content/images/wordpress/2020/08/image-59.png" alt="" class="wp-image-214" srcset="/content/images/wordpress/2020/08/image-59.png 725w, /content/images/wordpress/2020/08/image-59-300x142.png 300w" sizes="(max-width: 725px) 100vw, 725px"></figure>

Berikan hak owner dan hak akses WordPress

    [root@tutorial wordpress]#
    [root@tutorial wordpress]# chown -R nginx:nginx /usr/share/nginx/wordpress/
    [root@tutorial wordpress]# chmod -R 755 /usr/share/nginx/wordpress/

Selanjutnya konfigurasi php-fpm

    [root@tutorial wordpress]#
    [root@tutorial wordpress]# vim /etc/php-fpm.d/www.conf

Untuk koneksi nginx ke php-fpm disini kami akan menggunakan unix socket

    ; The address on which to accept FastCGI requests.
    ; Valid syntaxes are:
    ; 'ip.add.re.ss:port' - to listen on a TCP socket to a specific IPv4 address on
    ; a specific port;
    ; '[ip:6:addr:ess]:port' - to listen on a TCP socket to a specific IPv6 address on
    ; a specific port;
    ; 'port' - to listen on a TCP socket to all addresses
    ; (IPv6 and IPv4-mapped) on a specific port;
    ; '/path/to/unix/socket' - to listen on a unix socket.
    ; Note: This value is mandatory.
    listen = /run/php-fpm/www.sock
    
    ; Set listen(2) backlog.
    ; Default Value: 511
    ;listen.backlog = 511
    
    ; Set permissions for unix socket, if one is used. In Linux, read/write
    ; permissions must be set in order to allow connections from a web server.
    ; Default Values: user and group are set as the running user
    ; mode is set to 0660
    listen.owner = nginx
    listen.group = nginx
    listen.mode = 0660

Jika sudah silakan buat server block Nginx WordPress

    [root@tutorial wordpress]#
    [root@tutorial wordpress]# vim /etc/nginx/conf.d/wordpress.conf

Berikut isi dari server block Nginx

    server {
            listen 80;
            server_name wordpress.nurhamim.my.id;
            root /usr/share/nginx/wordpress;
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

Jika sudah pastikan konfigurasi nginx tidak ada yang salah

    [root@tutorial wordpress]#
    [root@tutorial wordpress]# nginx -t
    nginx: the configuration file /etc/nginx/nginx.conf syntax is ok
    nginx: configuration file /etc/nginx/nginx.conf test is successful
    [root@tutorial wordpress]#

Reload php-fpm dan Nginx

    [root@tutorial wordpress]#
    [root@tutorial wordpress]# systemctl reload php-fpm; systemctl reload nginx
    [root@tutorial wordpress]#

Pastikan subdomain atau domain yang Anda isikan di _server\_name_ di server block sudah mengarah ke IP Public VM atau VPS Anda contohnya

    [root@tutorial wordpress]#
    [root@tutorial wordpress]# ping wordpress.nurhamim.my.id -c3 |grep icmp
    64 bytes from 103.89.7.26 (103.89.7.26): icmp_seq=1 ttl=63 time=0.441 ms
    64 bytes from 103.89.7.26 (103.89.7.26): icmp_seq=2 ttl=63 time=0.465 ms
    64 bytes from 103.89.7.26 (103.89.7.26): icmp_seq=3 ttl=63 time=0.424 ms
    [root@tutorial wordpress]#

Jika belum mengarah silakan menambahkan A record terlebih dahulu contohnya

<figure class="wp-block-image size-large"><img loading="lazy" width="1024" height="204" src="/content/images/wordpress/2020/08/image-60-1024x204.png" alt="" class="wp-image-215" srcset="/content/images/wordpress/2020/08/image-60-1024x204.png 1024w, /content/images/wordpress/2020/08/image-60-300x60.png 300w, /content/images/wordpress/2020/08/image-60-768x153.png 768w, /content/images/wordpress/2020/08/image-60.png 1030w" sizes="(max-width: 1024px) 100vw, 1024px"></figure>

Jika sudah silakan akses subdomain atau domain Anda melalui browser, apabila berhasil Anda akan diminta untuk konfigurasi WordPress

<figure class="wp-block-image size-large"><img loading="lazy" width="1024" height="552" src="/content/images/wordpress/2020/08/image-62-1024x552.png" alt="" class="wp-image-217" srcset="/content/images/wordpress/2020/08/image-62-1024x552.png 1024w, /content/images/wordpress/2020/08/image-62-300x162.png 300w, /content/images/wordpress/2020/08/image-62-768x414.png 768w, /content/images/wordpress/2020/08/image-62.png 1359w" sizes="(max-width: 1024px) 100vw, 1024px"></figure>

Instalasi sudah berhasil

<figure class="wp-block-image size-large"><img loading="lazy" width="1024" height="327" src="/content/images/wordpress/2020/08/image-64-1024x327.png" alt="" class="wp-image-219" srcset="/content/images/wordpress/2020/08/image-64-1024x327.png 1024w, /content/images/wordpress/2020/08/image-64-300x96.png 300w, /content/images/wordpress/2020/08/image-64-768x245.png 768w, /content/images/wordpress/2020/08/image-64.png 1364w" sizes="(max-width: 1024px) 100vw, 1024px"></figure>

Silakan login ke WP Admin Anda

<figure class="wp-block-image size-large"><img loading="lazy" width="1024" height="532" src="/content/images/wordpress/2020/08/image-65-1024x532.png" alt="" class="wp-image-220" srcset="/content/images/wordpress/2020/08/image-65-1024x532.png 1024w, /content/images/wordpress/2020/08/image-65-300x156.png 300w, /content/images/wordpress/2020/08/image-65-768x399.png 768w, /content/images/wordpress/2020/08/image-65.png 1361w" sizes="(max-width: 1024px) 100vw, 1024px"></figure>

Berikut tampilan dashboard WordPress yang sudah berhasil terinstall

<figure class="wp-block-image size-large"><img loading="lazy" width="1024" height="550" src="/content/images/wordpress/2020/08/image-66-1024x550.png" alt="" class="wp-image-221" srcset="/content/images/wordpress/2020/08/image-66-1024x550.png 1024w, /content/images/wordpress/2020/08/image-66-300x161.png 300w, /content/images/wordpress/2020/08/image-66-768x412.png 768w, /content/images/wordpress/2020/08/image-66.png 1364w" sizes="(max-width: 1024px) 100vw, 1024px"></figure>

Selamat mencoba 😁

Please follow and like us:

[![error](/wp-content/plugins/ultimate-social-media-icons/images/follow_subscribe.png)](https://api.follow.it/widgets/icon/VHc3d1lpVGdwRnE5QnV0eERCNUx5RCtvTTVoUkNYS3NNRmd5eVhlQW9tNXRHS3VTbGh6Y0NybkRJRS8zSGpjRDVZb1ZGMlNTSEpJYUpuZzZqNzdnd3VSN3dwM2VlQTF6ejJEaGV5UGRUbnlEcHFNd3luYTV4ZTZtUGowVWI2Q2x8M2kzdnBEeUIrUk5xOFI5TXZ3cHF3bFNQRkRJSGhUNGdrRFd0TlNtdE1OWT0=/OA==/)

[![fb-share-icon](/wp-content/plugins/ultimate-social-media-icons/images/visit_icons/fbshare_bck.png "Facebook Share")](https://www.facebook.com/sharer/sharer.php?u=https%3A%2F%2Fbelajarlinux.id%2F%3Fp%3D208%26ghostexport%3Dtrue%26submit%3DDownload+Ghost+File)

[![Tweet](/wp-content/plugins/ultimate-social-media-icons/images/visit_icons/en_US_Tweet.svg "Tweet")](https://twitter.com/intent/tweet?text=Cara+Instalasi+WordPress+menggunakan+Nginx+di+CentOS+8+https://belajarlinux.id/?p=208&ghostexport=true&submit=Download Ghost File)

[![fb-share-icon](/wp-content/plugins/ultimate-social-media-icons/images/share_icons/Pinterest_Save/en_US_save.svg "Pin Share")](#)

<!--kg-card-end: html-->
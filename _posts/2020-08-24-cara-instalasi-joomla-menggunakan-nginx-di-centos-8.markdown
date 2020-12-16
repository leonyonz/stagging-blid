---
layout: post
title: Cara Instalasi Joomla Menggunakan Nginx di CentOS 8
featured: true
date: '2020-08-24 19:33:31'
tags:
- centos
- cms
---

**[Joomla](https://www.joomla.org/)** merupakan sebuah CMS (content management system) yang open source (bebas) digunakan untuk kebutuhan website baik untuk pribadi, company profile dan masih banyak lagi lainnya karena joomla sudah mempunyai ribuan extensi dan tema yang dapat Anda gunakan secara free.

Ratusan pengembang telah meningkatkan Joomla! sejak versi pertama yang dirilis pada tahun 2005. Upaya besar ini telah membuat Joomla! sangat populer, mudah digunakan, stabil dan aman.

Untuk melihat requirements untuk instalasi Joomla dapat di lihat dapat link berikut: **[Technical Requirements](https://downloads.joomla.org/technical-requirements)**.

Untuk mengikuti tutorial ini pastikan Anda sudah melakukan instalasi web server nginx, database mariadb/mysql dan tentunya php.

Jika belum silakan mengikuti panduan berikut:

- [**_Cara Instalasi PHP 7 di CentOS 8_**](/cara-instalasi-php-7-di-centos-8/)
- [**_Cara Instalasi Nginx Di CentOS 8_**](/cara-instalasi-nginx-di-centos-8/)
- [**_Cara Instalasi Database MariaDB di CentOS 8_**](/cara-instalasi-database-mariadb-di-centos-8/)

Selanjutnya pastikan service nginx, php-fpm dan database Anda running

    [root@tutorial ~]# systemctl status nginx |grep Active
       Active: active (running) since Mon 2020-08-24 07:38:54 UTC; 3h 56min ago
    [root@tutorial ~]# systemctl status php-fpm |grep Active
       Active: active (running) since Mon 2020-08-24 11:22:29 UTC; 13min ago
    [root@tutorial ~]# systemctl status mariadb |grep Active
       Active: active (running) since Sun 2020-08-23 04:11:36 UTC; 1 day 7h ago
    [root@tutorial ~]#

Insall beberapa module php yang dibutuhkan Joomla

    [root@tutorial ~]#
    [root@tutorial ~]# dnf install php-curl php-xml php-zip php-mysqlnd php-intl php-gd php-json php-ldap php-mbstring php-opcache 

Unduh Joomla dan menentukan root direktori Joomla

    [root@tutorial nginx]#
    [root@tutorial nginx]# wget https://downloads.joomla.org/cms/joomla3/3-9-20/Joomla_3-9-20-Stable-Full_Package.zip?format=zip
    --2020-08-24 11:37:12-- https://downloads.joomla.org/cms/joomla3/3-9-20/Joomla_3-9-20-Stable-Full_Package.zip?format=zip
    Resolving downloads.joomla.org (downloads.joomla.org)... 72.29.124.146
    Connecting to downloads.joomla.org (downloads.joomla.org)|72.29.124.146|:443... connected.
    HTTP request sent, awaiting response... 303 See Other
    Location: https://s3-us-west-2.amazonaws.com/joomla-official-downloads/joomladownloads/joomla3/Joomla_3.9.20-Stable-Full_Package.zip?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=AKIAIZ6S3Q3YQHG57ZRA%2F20200824%2Fus-west-2%2Fs3%2Faws4_request&X-Amz-Date=20200824T113706Z&X-Amz-Expires=60&X-Amz-SignedHeaders=host&X-Amz-Signature=577cd6c2074ecf48e53c3cd5ed5bfd473d537d51dd057d60ce0301b44a9fbbda [following]
    --2020-08-24 11:37:13-- https://s3-us-west-2.amazonaws.com/joomla-official-downloads/joomladownloads/joomla3/Joomla_3.9.20-Stable-Full_Package.zip?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=AKIAIZ6S3Q3YQHG57ZRA%2F20200824%2Fus-west-2%2Fs3%2Faws4_request&X-Amz-Date=20200824T113706Z&X-Amz-Expires=60&X-Amz-SignedHeaders=host&X-Amz-Signature=577cd6c2074ecf48e53c3cd5ed5bfd473d537d51dd057d60ce0301b44a9fbbda
    Resolving s3-us-west-2.amazonaws.com (s3-us-west-2.amazonaws.com)... 52.218.235.72
    Connecting to s3-us-west-2.amazonaws.com (s3-us-west-2.amazonaws.com)|52.218.235.72|:443... connected.
    HTTP request sent, awaiting response... 200 OK
    Length: 13969565 (13M) [application/zip]
    Saving to: ‘Joomla_3-9-20-Stable-Full_Package.zip?format=zip’
    
    Joomla_3-9-20-Stable-Full_Package.zip? 100%[==========================================================================>] 13.32M 6.24MB/s in 2.1s
    
    2020-08-24 11:37:16 (6.24 MB/s) - ‘Joomla_3-9-20-Stable-Full_Package.zip?format=zip’ saved [13969565/13969565]
    
    [root@tutorial nginx]#

Pada tutorial kali ini kami menggunakan Joomla versi latest saat ini yaitu 3.9.20 versi ini akan berubah ke versi yang lebih tinggi bergantung dari pihak Joomla untuk itu jika Anda ingin mengetahui rilis latest Joomla silakan akses link berikut: https://downloads.joomla.org/latest

Selanjutnya unzip file Joomla yang baru saja di unduh.

    [root@tutorial nginx]# mkdir joomla
    [root@tutorial nginx]# unzip Joomla_3-9-20-Stable-Full_Package.zip\?format\=zip -d joomla/

Memberikan hak akses dan owner ke direkori Joomla

    [root@tutorial nginx]# chown -R nginx:nginx joomla/
    [root@tutorial nginx]# chmod -R 755 joomla/

Selanjutnya membuat database Joomla

    [root@tutorial nginx]# mysql -u root -p
    Enter password:
    Welcome to the MariaDB monitor. Commands end with ; or \g.
    Your MariaDB connection id is 91
    Server version: 10.3.17-MariaDB MariaDB Server
    
    Copyright (c) 2000, 2018, Oracle, MariaDB Corporation Ab and others.
    
    Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.
    
    MariaDB [(none)]> create database joomla;
    Query OK, 1 row affected (0.000 sec)
    
    MariaDB [(none)]> create user 'user_joomla'@'localhost' identified by 'password_joomla';
    Query OK, 0 rows affected (0.001 sec)
    
    MariaDB [(none)]> grant all privileges on joomla.* to 'user_joomla'@'localhost';
    Query OK, 0 rows affected (0.001 sec)
    
    MariaDB [(none)]> flush privileges;
    Query OK, 0 rows affected (0.001 sec)
    
    MariaDB [(none)]> quit
    Bye
    [root@tutorial nginx]#

Selanjutnya membuat server block Nginx

    [root@tutorial nginx]#
    [root@tutorial nginx]# vim /etc/nginx/conf.d/joomla.conf

Berikut isi dari server block Joomal

    server {
            listen 80;
            server_name joomla.nurhamim.my.id;
            root /usr/share/nginx/joomla;
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

Server block diatas mengguankan unix socket untuk koneksi nginx ke php-fpm jika Anda ingin menggunakan socket tcp/port silakan ubah di sisi php-fpm listennya menjadi tcp/port.

Jika sudah pastikan tidak ada warning ataupun kesalahan konfigurasi di server block Nginx

    [root@tutorial nginx]# nginx -t
    nginx: the configuration file /etc/nginx/nginx.conf syntax is ok
    nginx: configuration file /etc/nginx/nginx.conf test is successful
    [root@tutorial nginx]#

Reload nginx dan php-fpm

    [root@tutorial nginx]#
    [root@tutorial nginx]# systemctl reload nginx
    [root@tutorial nginx]# systemctl reload php-fpm

Pastikan sub domain atau domain Anda sudah diarahkan ke IP Public VM atau VPS Anda contohnya

<figure class="wp-block-image size-large"><img loading="lazy" width="645" height="106" src="/content/images/wordpress/2020/08/image-67.png" alt="" class="wp-image-225" srcset="/content/images/wordpress/2020/08/image-67.png 645w, /content/images/wordpress/2020/08/image-67-300x49.png 300w" sizes="(max-width: 645px) 100vw, 645px"></figure>

Jika belum pastikan Anda sudah menambahkan A record pada sub domain atau domain Anda di sisi DNS management domain Anda

<figure class="wp-block-image size-large"><img loading="lazy" width="1024" height="90" src="/content/images/wordpress/2020/08/image-68-1024x90.png" alt="" class="wp-image-226" srcset="/content/images/wordpress/2020/08/image-68-1024x90.png 1024w, /content/images/wordpress/2020/08/image-68-300x26.png 300w, /content/images/wordpress/2020/08/image-68-768x68.png 768w, /content/images/wordpress/2020/08/image-68.png 1035w" sizes="(max-width: 1024px) 100vw, 1024px"></figure>

Apabila sudah sesuai semua silakan akses melalui browser untuk proses instalasi, jika berhasil akan seperti berikut

<figure class="wp-block-image size-large"><img loading="lazy" width="1024" height="554" src="/content/images/wordpress/2020/08/image-69-1024x554.png" alt="" class="wp-image-227" srcset="/content/images/wordpress/2020/08/image-69-1024x554.png 1024w, /content/images/wordpress/2020/08/image-69-300x162.png 300w, /content/images/wordpress/2020/08/image-69-768x416.png 768w, /content/images/wordpress/2020/08/image-69.png 1363w" sizes="(max-width: 1024px) 100vw, 1024px"></figure>

Silakan isi semua field yang ada tanda (_\*)_ nya lalu _Next_

Selanjutnya konfigurasi database Joomla, silakan isikan username, password dan nama database yang sudah dibuat sebelumnya lalu _Next_

<figure class="wp-block-image size-large"><img loading="lazy" width="1024" height="559" src="/content/images/wordpress/2020/08/image-70-1024x559.png" alt="" class="wp-image-228" srcset="/content/images/wordpress/2020/08/image-70-1024x559.png 1024w, /content/images/wordpress/2020/08/image-70-300x164.png 300w, /content/images/wordpress/2020/08/image-70-768x419.png 768w, /content/images/wordpress/2020/08/image-70.png 1345w" sizes="(max-width: 1024px) 100vw, 1024px"></figure>

Selanjutnya konfigurasi FTP, untuk step ini bisa di skip silakan klik _Next_

<figure class="wp-block-image size-large"><img loading="lazy" width="1024" height="542" src="/content/images/wordpress/2020/08/image-71-1024x542.png" alt="" class="wp-image-229" srcset="/content/images/wordpress/2020/08/image-71-1024x542.png 1024w, /content/images/wordpress/2020/08/image-71-300x159.png 300w, /content/images/wordpress/2020/08/image-71-768x407.png 768w, /content/images/wordpress/2020/08/image-71.png 1362w" sizes="(max-width: 1024px) 100vw, 1024px"></figure>

Langkah terakhir ayitu overview disini Anda dapat memilih apakah ingin install sample data atau tidak lalu scroll ke bawah untuk pre-check instalasi

<figure class="wp-block-image size-large"><img loading="lazy" width="1024" height="549" src="/content/images/wordpress/2020/08/image-72-1024x549.png" alt="" class="wp-image-230" srcset="/content/images/wordpress/2020/08/image-72-1024x549.png 1024w, /content/images/wordpress/2020/08/image-72-300x161.png 300w, /content/images/wordpress/2020/08/image-72-768x412.png 768w, /content/images/wordpress/2020/08/image-72.png 1363w" sizes="(max-width: 1024px) 100vw, 1024px"></figure><figure class="wp-block-image size-large"><img loading="lazy" width="963" height="610" src="/content/images/wordpress/2020/08/image-75.png" alt="" class="wp-image-234" srcset="/content/images/wordpress/2020/08/image-75.png 963w, /content/images/wordpress/2020/08/image-75-300x190.png 300w, /content/images/wordpress/2020/08/image-75-768x486.png 768w" sizes="(max-width: 963px) 100vw, 963px"></figure>

Gambar diatas terdapat warning _configuration.php Writeable_ untuk mengatasi hal ini silakan ubah permission installation pada folder joomla menjadi 777

    [root@tutorial joomla]#
    [root@tutorial joomla]# chmod -R 777 installation/

Jika sudah silakan klik _Install_ dan tunggu proses instalasi sampai selesai

<figure class="wp-block-image size-large"><img loading="lazy" width="1024" height="394" src="/content/images/wordpress/2020/08/image-73-1024x394.png" alt="" class="wp-image-231" srcset="/content/images/wordpress/2020/08/image-73-1024x394.png 1024w, /content/images/wordpress/2020/08/image-73-300x116.png 300w, /content/images/wordpress/2020/08/image-73-768x296.png 768w, /content/images/wordpress/2020/08/image-73.png 1361w" sizes="(max-width: 1024px) 100vw, 1024px"></figure>

Jika sudah selesai akan nampak seperti berikut

<figure class="wp-block-image size-large"><img loading="lazy" width="1024" height="540" src="/content/images/wordpress/2020/08/image-74-1024x540.png" alt="" class="wp-image-232" srcset="/content/images/wordpress/2020/08/image-74-1024x540.png 1024w, /content/images/wordpress/2020/08/image-74-300x158.png 300w, /content/images/wordpress/2020/08/image-74-768x405.png 768w, /content/images/wordpress/2020/08/image-74.png 1366w" sizes="(max-width: 1024px) 100vw, 1024px"></figure>

Selamat Joomla sudah berhasil di install, silakan klik _ **Remove “Installation” Folder** _ untuk menghapus folder instalasi atau dapat langsung dihapus dari terminal saja

    [root@tutorial nginx]# cd joomla/
    [root@tutorial joomla]#
    [root@tutorial joomla]# rm -rf installation/
    [root@tutorial joomla]#

Jika sudah silakan akses Administator Joomla Anda

<figure class="wp-block-image size-large"><img loading="lazy" width="1024" height="553" src="/content/images/wordpress/2020/08/image-76-1024x553.png" alt="" class="wp-image-235" srcset="/content/images/wordpress/2020/08/image-76-1024x553.png 1024w, /content/images/wordpress/2020/08/image-76-300x162.png 300w, /content/images/wordpress/2020/08/image-76-768x415.png 768w, /content/images/wordpress/2020/08/image-76.png 1366w" sizes="(max-width: 1024px) 100vw, 1024px"></figure>

Apabila berhasil akan nampak seperti berikut ini

<figure class="wp-block-image size-large"><img loading="lazy" width="1024" height="554" src="/content/images/wordpress/2020/08/image-77-1024x554.png" alt="" class="wp-image-236" srcset="/content/images/wordpress/2020/08/image-77-1024x554.png 1024w, /content/images/wordpress/2020/08/image-77-300x162.png 300w, /content/images/wordpress/2020/08/image-77-768x415.png 768w, /content/images/wordpress/2020/08/image-77.png 1366w" sizes="(max-width: 1024px) 100vw, 1024px"></figure>

Berikut tampilan default dari Joomla

<figure class="wp-block-image size-large"><img loading="lazy" width="1024" height="506" src="/content/images/wordpress/2020/08/image-78-1024x506.png" alt="" class="wp-image-237" srcset="/content/images/wordpress/2020/08/image-78-1024x506.png 1024w, /content/images/wordpress/2020/08/image-78-300x148.png 300w, /content/images/wordpress/2020/08/image-78-768x380.png 768w, /content/images/wordpress/2020/08/image-78.png 1366w" sizes="(max-width: 1024px) 100vw, 1024px"></figure>

Selamat mencoba 😁

Please follow and like us:

[![error](/wp-content/plugins/ultimate-social-media-icons/images/follow_subscribe.png)](https://api.follow.it/widgets/icon/VHc3d1lpVGdwRnE5QnV0eERCNUx5RCtvTTVoUkNYS3NNRmd5eVhlQW9tNXRHS3VTbGh6Y0NybkRJRS8zSGpjRDVZb1ZGMlNTSEpJYUpuZzZqNzdnd3VSN3dwM2VlQTF6ejJEaGV5UGRUbnlEcHFNd3luYTV4ZTZtUGowVWI2Q2x8M2kzdnBEeUIrUk5xOFI5TXZ3cHF3bFNQRkRJSGhUNGdrRFd0TlNtdE1OWT0=/OA==/)

[![fb-share-icon](/wp-content/plugins/ultimate-social-media-icons/images/visit_icons/fbshare_bck.png "Facebook Share")](https://www.facebook.com/sharer/sharer.php?u=https%3A%2F%2Fbelajarlinux.id%2F%3Fp%3D224%26ghostexport%3Dtrue%26submit%3DDownload+Ghost+File)

[![Tweet](/wp-content/plugins/ultimate-social-media-icons/images/visit_icons/en_US_Tweet.svg "Tweet")](https://twitter.com/intent/tweet?text=Cara+Instalasi+Joomla+Menggunakan+Nginx+di+CentOS+8+https://belajarlinux.id/?p=224&ghostexport=true&submit=Download Ghost File)

[![fb-share-icon](/wp-content/plugins/ultimate-social-media-icons/images/share_icons/Pinterest_Save/en_US_save.svg "Pin Share")](#)

<!--kg-card-end: html-->
---
layout: post
title: Cara Instalasi Typo3 Menggunakan Nginx di CentOS 8
featured: true
date: '2020-08-25 15:20:05'
tags:
- centos
- cms
---

**[TYPO3](https://typo3.org/)** salah satu dari sekian banyak CMS (content management system) yang dapat Anda gunakan secara free dalam artian open source (bebas) di kembangkan, di kustomisasi. TYPO3 hampir sama dengan Drupal dirilis dibawah naungan GNU General Public License.

**[TYPO3](https://typo3.org/)** ditulis menggunakan PHP dan dapat berjalan di beberapa web server seperti Apache, Nginx atau IIS dan yang menarik TYPO3 dapat di jalankan di berbagai macam sistem operasi mulai dari Linux, Microsoft Windows, FreeBSD, MacOS dan OS/2.

Untuk mengikuti tutorial instalasi typo3 ini pastikan Anda sudah instalasi LEMP Stack yang terdiri dari Web Server Nginx, PHP 7.x dan Database MariaDB, bagi yang belum melakukan instalasinya silakan mengikuti beberapa tautan berikut:

- **_[Cara Instalasi Nginx Di CentOS 8](/cara-instalasi-nginx-di-centos-8/)_**
- **_[Cara Instalasi PHP 7 di CentOS 8](/cara-instalasi-php-7-di-centos-8/)_**
- **_[Cara Instalasi Database MariaDB di CentOS 8](/cara-instalasi-database-mariadb-di-centos-8/)_**

Seperti biasa pastikan service Nginx, php-fpm dan database Anda sudah running

    [root@tutorial ~]#
    [root@tutorial ~]# systemctl status mariadb |grep Active
       Active: active (running) since Tue 2020-08-25 07:37:13 UTC; 27min ago
    [root@tutorial ~]# systemctl status php-fpm |grep Active
       Active: active (running) since Tue 2020-08-25 07:38:48 UTC; 25min ago
    [root@tutorial ~]# systemctl status nginx |grep Active
       Active: active (running) since Tue 2020-08-25 07:37:07 UTC; 27min ago
    [root@tutorial ~]#

Instalasi beberapa module php yang dibutuhkan

    [root@tutorial ~]#
    [root@tutorial ~]# dnf install php-zip php-intl php-gd php-json php-mysqli php-curl php-intl php-cli php-apcu php-soap php-xml php-zip php-mbstring freetype php-bcmath php-fileinfo ImageMagick -y

Menyesuaikan _max\_execution\_time dan max\_input\_vars_ di php.ini

    [root@tutorial ~]#
    [root@tutorial ~]# vim /etc/php.ini

Cari baris line _max\_execution\_time dan max\_input\_vars_ ubah value (nilai) nya seperti berikut

    max_execution_time = 30 >> max_execution_time = 240
    max_input_vars = 1000 >> max_input_vars = 1500

Jika sudah, selanjutnya menentukan path direktori dan unduh file typo3 terbaru yang dapat Anda lihat dan dapatkan pada link berikut:**[Current Versions](https://get.typo3.org/#download)**

    [root@tutorial ~]#
    [root@tutorial ~]# cd /usr/share/nginx/
    [root@tutorial nginx]#
    [root@tutorial nginx]# wget --content-disposition https://get.typo3.org/10.4.6
    --2020-08-24 21:19:01-- https://get.typo3.org/10.4.6
    Resolving get.typo3.org (get.typo3.org)... 185.17.71.134, 2a04:503:0:1019::134
    Connecting to get.typo3.org (get.typo3.org)|185.17.71.134|:443... connected.
    HTTP request sent, awaiting response... 302 Found
    Location: https://typo3.azureedge.net/typo3/10.4.6/typo3_src-10.4.6.tar.gz [following]
    --2020-08-24 21:19:02-- https://typo3.azureedge.net/typo3/10.4.6/typo3_src-10.4.6.tar.gz
    Resolving typo3.azureedge.net (typo3.azureedge.net)... 117.18.232.200, 2606:2800:147:120f:30c:1ba0:fc6:265a
    Connecting to typo3.azureedge.net (typo3.azureedge.net)|117.18.232.200|:443... connected.
    HTTP request sent, awaiting response... 200 OK
    Length: 28467603 (27M) [application/octet-stream]
    Saving to: ‘typo3_src-10.4.6.tar.gz’
    
    typo3_src-10.4.6.tar.gz 100%[===============================================>] 27.15M 61.4MB/s in 0.4s
    
    2020-08-24 21:19:02 (61.4 MB/s) - ‘typo3_src-10.4.6.tar.gz’ saved [28467603/28467603]
    
    [root@tutorial nginx]#

Extrak file typo3 yang baru saja di unduh

    [root@tutorial nginx]#
    [root@tutorial nginx]# tar -zxvf typo3_src-10.4.6.tar.gz

Ubah penamaan direktori sesuai keinginan tujuannya untuk mempermudah dan simple saja.

    [root@tutorial nginx]#
    [root@tutorial nginx]# mv typo3_src-10.4.6 typo3

Membuat file _FIRS\_INSTALL_ di dalam direktori typo3

    [root@tutorial nginx]#
    [root@tutorial nginx]# touch typo3/FIRST_INSTALL

Memberikan hak akses dan owner direktori typo3

    [root@tutorial nginx]# chown -R nginx:nginx typo3
    [root@tutorial nginx]# chmod -R 755 typo3

Membuat database typo3

    [root@tutorial nginx]# mysql -u root -p
    Enter password:
    Welcome to the MariaDB monitor. Commands end with ; or \g.
    Your MariaDB connection id is 17
    Server version: 10.3.17-MariaDB MariaDB Server
    
    Copyright (c) 2000, 2018, Oracle, MariaDB Corporation Ab and others.
    
    Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.
    
    MariaDB [(none)]>
    MariaDB [(none)]> CREATE DATABASE typo3 CHARACTER SET utf8 COLLATE utf8_general_ci;
    Query OK, 1 row affected (0.000 sec)
    
    MariaDB [(none)]> CREATE USER 'typo3user'@'localhost' IDENTIFIED BY 'password';
    Query OK, 0 rows affected (0.000 sec)
    
    MariaDB [(none)]> GRANT ALL PRIVILEGES ON typo3.* TO 'typo3user'@'localhost';
    Query OK, 0 rows affected (0.000 sec)
    
    MariaDB [(none)]> FLUSH PRIVILEGES;
    Query OK, 0 rows affected (0.001 sec)
    
    MariaDB [(none)]> exit
    Bye
    [root@tutorial nginx]#

_Noted: Silakan disimpan informasi nama, username, password database karena akan digunakan pada saat proses instalasi nantinya._

Membuat server block Nginx

    [root@tutorial nginx]#
    [root@tutorial nginx]# vim /etc/nginx/conf.d/typo3.conf

Berikut isi full dari konfigurasi server block Nginx

    server {
            listen 80;
            server_name typo3.nurhamim.my.id;
            root /usr/share/nginx/typo3;
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

_Noted: Sesuaikan path direktori, server\_name sesuai keinginan Anda dan disini kami menggunakan unic-socket untuk komunikasi nginx ke php-fpm nya._

Reload Nginx dan php-fpm

    [root@tutorial nginx]# systemctl reload nginx
    [root@tutorial nginx]# systemctl reload php-fpm

Membuat A record pada subdomain atau domain dan diarahkan ke IP Public VM atau VPS Anda contohnya

<figure class="wp-block-image size-large"><img loading="lazy" width="1025" height="210" src="/content/images/wordpress/2020/08/1-2.png" alt="" class="wp-image-273" srcset="/content/images/wordpress/2020/08/1-2.png 1025w, /content/images/wordpress/2020/08/1-2-300x61.png 300w, /content/images/wordpress/2020/08/1-2-768x157.png 768w" sizes="(max-width: 1025px) 100vw, 1025px"></figure>

Verifikasi bisa menggunakan ping

<figure class="wp-block-image size-large"><img loading="lazy" width="578" height="90" src="/content/images/wordpress/2020/08/2-2.png" alt="" class="wp-image-274" srcset="/content/images/wordpress/2020/08/2-2.png 578w, /content/images/wordpress/2020/08/2-2-300x47.png 300w" sizes="(max-width: 578px) 100vw, 578px"></figure>

Jika sudah silakan akses melalui browser

<figure class="wp-block-image size-large"><img loading="lazy" width="1024" height="479" src="/content/images/wordpress/2020/08/3-1-1024x479.png" alt="" class="wp-image-272" srcset="/content/images/wordpress/2020/08/3-1-1024x479.png 1024w, /content/images/wordpress/2020/08/3-1-300x140.png 300w, /content/images/wordpress/2020/08/3-1-768x359.png 768w, /content/images/wordpress/2020/08/3-1.png 1054w" sizes="(max-width: 1024px) 100vw, 1024px"></figure>

Klik _No problems, continue with installation_

<figure class="wp-block-image size-large"><img loading="lazy" width="1024" height="701" src="/content/images/wordpress/2020/08/4-1-1024x701.png" alt="" class="wp-image-275" srcset="/content/images/wordpress/2020/08/4-1-1024x701.png 1024w, /content/images/wordpress/2020/08/4-1-300x205.png 300w, /content/images/wordpress/2020/08/4-1-768x526.png 768w, /content/images/wordpress/2020/08/4-1.png 1052w" sizes="(max-width: 1024px) 100vw, 1024px"></figure>

Konfigurasi database, silakan input username dan password yang telah dibuat sebelumnya, _Continue_

<figure class="wp-block-image size-large"><img loading="lazy" width="1024" height="627" src="/content/images/wordpress/2020/08/5-1-1024x627.png" alt="" class="wp-image-276" srcset="/content/images/wordpress/2020/08/5-1-1024x627.png 1024w, /content/images/wordpress/2020/08/5-1-300x184.png 300w, /content/images/wordpress/2020/08/5-1-768x470.png 768w, /content/images/wordpress/2020/08/5-1.png 1055w" sizes="(max-width: 1024px) 100vw, 1024px"></figure>

Pilih database yang sudah dibuat dengan user yang sudah ditentukan sebelumnya, _Continue_

<figure class="wp-block-image size-large"><img loading="lazy" width="1024" height="865" src="/content/images/wordpress/2020/08/6-1-1024x865.png" alt="" class="wp-image-277" srcset="/content/images/wordpress/2020/08/6-1-1024x865.png 1024w, /content/images/wordpress/2020/08/6-1-300x254.png 300w, /content/images/wordpress/2020/08/6-1-768x649.png 768w, /content/images/wordpress/2020/08/6-1.png 1053w" sizes="(max-width: 1024px) 100vw, 1024px"></figure>

Membuat username dan password login ke sisi Administrator typo3, _Continue_

<figure class="wp-block-image size-large"><img loading="lazy" width="1024" height="683" src="/content/images/wordpress/2020/08/7-1-1024x683.png" alt="" class="wp-image-278" srcset="/content/images/wordpress/2020/08/7-1-1024x683.png 1024w, /content/images/wordpress/2020/08/7-1-300x200.png 300w, /content/images/wordpress/2020/08/7-1-768x512.png 768w, /content/images/wordpress/2020/08/7-1.png 1055w" sizes="(max-width: 1024px) 100vw, 1024px"></figure>

Instalasi typo3 sudah selesai dilakukan, _Open the Typo3 Backend_

<figure class="wp-block-image size-large"><img loading="lazy" width="1024" height="760" src="/content/images/wordpress/2020/08/8-1-1024x760.png" alt="" class="wp-image-279" srcset="/content/images/wordpress/2020/08/8-1-1024x760.png 1024w, /content/images/wordpress/2020/08/8-1-300x223.png 300w, /content/images/wordpress/2020/08/8-1-768x570.png 768w, /content/images/wordpress/2020/08/8-1.png 1045w" sizes="(max-width: 1024px) 100vw, 1024px"></figure>

Input username dan password yang telah dibuat sebelumnya, jika berhasil seperti berikut tampilan backend dari TYPO3

<figure class="wp-block-image size-large"><img loading="lazy" width="1024" height="982" src="/content/images/wordpress/2020/08/9-1-1024x982.png" alt="" class="wp-image-280" srcset="/content/images/wordpress/2020/08/9-1-1024x982.png 1024w, /content/images/wordpress/2020/08/9-1-300x288.png 300w, /content/images/wordpress/2020/08/9-1-768x737.png 768w, /content/images/wordpress/2020/08/9-1.png 1057w" sizes="(max-width: 1024px) 100vw, 1024px"></figure>

Selamat Anda sudah berhasil melakukan instalasi TYPO3.

Selamat mencoba 😁

Please follow and like us:

[![error](/wp-content/plugins/ultimate-social-media-icons/images/follow_subscribe.png)](https://api.follow.it/widgets/icon/VHc3d1lpVGdwRnE5QnV0eERCNUx5RCtvTTVoUkNYS3NNRmd5eVhlQW9tNXRHS3VTbGh6Y0NybkRJRS8zSGpjRDVZb1ZGMlNTSEpJYUpuZzZqNzdnd3VSN3dwM2VlQTF6ejJEaGV5UGRUbnlEcHFNd3luYTV4ZTZtUGowVWI2Q2x8M2kzdnBEeUIrUk5xOFI5TXZ3cHF3bFNQRkRJSGhUNGdrRFd0TlNtdE1OWT0=/OA==/)

[![fb-share-icon](/wp-content/plugins/ultimate-social-media-icons/images/visit_icons/fbshare_bck.png "Facebook Share")](https://www.facebook.com/sharer/sharer.php?u=https%3A%2F%2Fbelajarlinux.id%2F%3Fp%3D269%26ghostexport%3Dtrue%26submit%3DDownload+Ghost+File)

[![Tweet](/wp-content/plugins/ultimate-social-media-icons/images/visit_icons/en_US_Tweet.svg "Tweet")](https://twitter.com/intent/tweet?text=Cara+Instalasi+Typo3+Menggunakan+Nginx+di+CentOS+8+https://belajarlinux.id/?p=269&ghostexport=true&submit=Download Ghost File)

[![fb-share-icon](/wp-content/plugins/ultimate-social-media-icons/images/share_icons/Pinterest_Save/en_US_save.svg "Pin Share")](#)

<!--kg-card-end: html-->
---
layout: post
title: Cara Instalasi Laravel Menggunakan Nginx di CentOS 8
featured: true
date: '2020-08-25 20:34:52'
tags:
- centos
- framework
---

**[Laravel](https://laravel.com/)** merupakan salah satu framework PHP yang sangat populer dan bisa di bilang terbaik. Sudah sangat banyak para web developer menggunakan framework ini. Laravel sendiri open source dimana Anda dapat menggunakannya secara bebas.

Laravel sendiri mempunyai komunitas yang sangat besar, oleh karena itu sangat banyak yang merekomendasikan atau pertimbangan dalam memilih framework.

Pada tutorial kali akan dibahas bagaimana cara instalasi laravel di CentOS 8 menggunakan webserver Nginx, PHP versi 7.x dan database MariaDB/MySQL.

Untuk instalasi LEMP stack dapat mengikuti tautan berikut:

- [Cara Instalasi Nginx Di CentOS 8](/cara-instalasi-nginx-di-centos-8/)
- [Cara Instalasi PHP 7 di CentOS 8](/cara-instalasi-php-7-di-centos-8/)
- [Cara Instalasi Database MariaDB di CentOS 8](/cara-instalasi-database-mariadb-di-centos-8/)

Jika Anda sudah melakukan instalasi diatas, pastikan web server nginx, php-fpm dan database Anda running

    [root@tutorial ~]# systemctl status nginx |grep Active
       Active: active (running) since Tue 2020-08-25 07:37:07 UTC; 5h 45min ago
    [root@tutorial ~]# systemctl status php-fpm |grep Active
       Active: active (running) since Tue 2020-08-25 07:38:48 UTC; 5h 43min ago
    [root@tutorial ~]# systemctl status mariadb |grep Active
       Active: active (running) since Tue 2020-08-25 07:37:13 UTC; 5h 45min ago
    [root@tutorial ~]#

Php yang kami gunakan disini yaitu versi 7.4, silakan install module php berikut

    [root@tutorial ~]# php --version
    PHP 7.4.9 (cli) (built: Aug 4 2020 08:28:13) ( NTS )
    Copyright (c) The PHP Group
    Zend Engine v3.4.0, Copyright (c) Zend Technologies
        with Zend OPcache v7.4.9, Copyright (c), by Zend Technologies
    [root@tutorial ~]#
    [root@tutorial ~]#
    [root@tutorial ~]# dnf install php-curl php-common php-cli php-mysql php-mbstring php-xml php-zip -y

Melakukan instalasi composer, nantinya kita dapat mengunduh file atau project laravel menggunakan composer

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

Menenutukan root direktori laravel dan install laravel

    [root@tutorial ~]#
    [root@tutorial ~]# cd /usr/share/nginx/
    [root@tutorial nginx]#
    [root@tutorial nginx]# composer create-project --prefer-dist laravel/laravel laravel
    
    ....
    ....
    ....
    
    Writing lock file
    Generating optimized autoload files
    > Illuminate\Foundation\ComposerScripts::postAutoloadDump
    > @php artisan package:discover --ansi
    Discovered Package: facade/ignition
    Discovered Package: fideloper/proxy
    Discovered Package: fruitcake/laravel-cors
    Discovered Package: laravel/tinker
    Discovered Package: nesbot/carbon
    Discovered Package: nunomaduro/collision
    Package manifest generated successfully.
    48 packages you are using are looking for funding.
    Use the `composer fund` command to find out more!
    > @php artisan key:generate --ansi
    Application key set successfully.
    [root@tutorial nginx]#

Jika instalasi sudah selesai dilakukan, silakan set permission dan owner laravel projek seperti berikut

    [root@tutorial nginx]# chown -R nginx:nginx laravel/storage/
    [root@tutorial nginx]# chown -R nginx:nginx laravel/bootstrap/cache/
    [root@tutorial nginx]# chmod -R 0775 laravel/bootstrap/cache/
    [root@tutorial nginx]#

Selanjutnya membuat database laravel

    [root@tutorial nginx]#
    [root@tutorial nginx]# mysql -u root -p
    Enter password:
    Welcome to the MariaDB monitor. Commands end with ; or \g.
    Your MariaDB connection id is 10
    Server version: 10.3.17-MariaDB MariaDB Server
    
    Copyright (c) 2000, 2018, Oracle, MariaDB Corporation Ab and others.
    
    Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.
    
    MariaDB [(none)]> CREATE DATABASE laravel;
    Query OK, 1 row affected (0.001 sec)
    
    MariaDB [(none)]> GRANT ALL ON laravel.* to 'user_laravel'@'localhost' IDENTIFIED BY 'new_password';
    Query OK, 0 rows affected (0.001 sec)
    
    MariaDB [(none)]> FLUSH PRIVILEGES;
    Query OK, 0 rows affected (0.001 sec)
    
    MariaDB [(none)]> quit
    Bye
    [root@tutorial nginx]#

Konfigurasi database laravel, silakan akses fil _.env_

    [root@tutorial nginx]#
    [root@tutorial nginx]# ls -lah laravel/ |grep .env
    -rw-r--r-- 1 root root 849 Aug 25 08:52 .env
    -rw-r--r-- 1 root root 778 Aug 11 17:44 .env.example
    [root@tutorial nginx]#
    
    [root@tutorial nginx]# vim laravel/.env
    [root@tutorial nginx]#

- Before
<figure class="wp-block-image size-large"><img loading="lazy" width="704" height="266" src="/content/images/wordpress/2020/08/2-3.png" alt="" class="wp-image-284" srcset="/content/images/wordpress/2020/08/2-3.png 704w, /content/images/wordpress/2020/08/2-3-300x113.png 300w" sizes="(max-width: 704px) 100vw, 704px"></figure>
- After
<figure class="wp-block-image size-large"><img loading="lazy" width="639" height="263" src="/content/images/wordpress/2020/08/3-2.png" alt="" class="wp-image-285" srcset="/content/images/wordpress/2020/08/3-2.png 639w, /content/images/wordpress/2020/08/3-2-300x123.png 300w" sizes="(max-width: 639px) 100vw, 639px"></figure>

Pastikan Anda mengisikan nama db, username dan password dengan benar.

Jika sudah silakan membuat server block Nginx

    [root@tutorial nginx]#
    [root@tutorial nginx]# vim /etc/nginx/conf.d/laravel.conf

Berikut isi file server block Nginx Laravel

    server {
            listen 80;
            server_name laravel.nurhamim.my.id;
            root /usr/share/nginx/laravel/public;
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

Mengatur php.ini

    [root@tutorial nginx]#
    [root@tutorial nginx]# vim /etc/php.ini

Uncoment pada _date.timezone dan cgi.fix\_pathinfo_

    date.timezone = Asia/Jakarta
    cgi.fix_pathinfo=1 >> cgi.fix_pathinfo=0

Selanjutnya pastikan tidak ada konfigurasi yang salah untuk server block nginx laravel

    [root@tutorial nginx]#
    [root@tutorial nginx]# nginx -t
    nginx: the configuration file /etc/nginx/nginx.conf syntax is ok
    nginx: configuration file /etc/nginx/nginx.conf test is successful
    [root@tutorial nginx]#

Reload Nginx dan php-fpm

    [root@tutorial nginx]#
    [root@tutorial nginx]# systemctl reload nginx
    [root@tutorial nginx]# systemctl reload php-fpm

Pastikan Anda sudah membuat A record untuk domain atau subdomain Anda yang diarahkan ke IP Public VPS/VM Anda, sebagai contoh

<figure class="wp-block-image size-large"><img loading="lazy" width="1025" height="208" src="/content/images/wordpress/2020/08/4-2.png" alt="" class="wp-image-286" srcset="/content/images/wordpress/2020/08/4-2.png 1025w, /content/images/wordpress/2020/08/4-2-300x61.png 300w, /content/images/wordpress/2020/08/4-2-768x156.png 768w" sizes="(max-width: 1025px) 100vw, 1025px"></figure>

Verifikasi dapat dilakukan dengan ping

<figure class="wp-block-image size-large"><img loading="lazy" width="634" height="115" src="/content/images/wordpress/2020/08/5-2.png" alt="" class="wp-image-287" srcset="/content/images/wordpress/2020/08/5-2.png 634w, /content/images/wordpress/2020/08/5-2-300x54.png 300w" sizes="(max-width: 634px) 100vw, 634px"></figure>

Jika sudah silakan akses subdomain atau domain Anda melalui browser

<figure class="wp-block-image size-large"><img loading="lazy" width="1024" height="465" src="/content/images/wordpress/2020/08/6-2-1024x465.png" alt="" class="wp-image-288" srcset="/content/images/wordpress/2020/08/6-2-1024x465.png 1024w, /content/images/wordpress/2020/08/6-2-300x136.png 300w, /content/images/wordpress/2020/08/6-2-768x349.png 768w, /content/images/wordpress/2020/08/6-2.png 1365w" sizes="(max-width: 1024px) 100vw, 1024px"></figure>

Selamat Anda telah berhasil melakukan instalasi Laravel

Selamat mencoba 😁

Please follow and like us:

[![error](/wp-content/plugins/ultimate-social-media-icons/images/follow_subscribe.png)](https://api.follow.it/widgets/icon/VHc3d1lpVGdwRnE5QnV0eERCNUx5RCtvTTVoUkNYS3NNRmd5eVhlQW9tNXRHS3VTbGh6Y0NybkRJRS8zSGpjRDVZb1ZGMlNTSEpJYUpuZzZqNzdnd3VSN3dwM2VlQTF6ejJEaGV5UGRUbnlEcHFNd3luYTV4ZTZtUGowVWI2Q2x8M2kzdnBEeUIrUk5xOFI5TXZ3cHF3bFNQRkRJSGhUNGdrRFd0TlNtdE1OWT0=/OA==/)

[![fb-share-icon](/wp-content/plugins/ultimate-social-media-icons/images/visit_icons/fbshare_bck.png "Facebook Share")](https://www.facebook.com/sharer/sharer.php?u=https%3A%2F%2Fbelajarlinux.id%2F%3Fp%3D282%26ghostexport%3Dtrue%26submit%3DDownload+Ghost+File)

[![Tweet](/wp-content/plugins/ultimate-social-media-icons/images/visit_icons/en_US_Tweet.svg "Tweet")](https://twitter.com/intent/tweet?text=Cara+Instalasi+Laravel+Menggunakan+Nginx+di+CentOS+8+https://belajarlinux.id/?p=282&ghostexport=true&submit=Download Ghost File)

[![fb-share-icon](/wp-content/plugins/ultimate-social-media-icons/images/share_icons/Pinterest_Save/en_US_save.svg "Pin Share")](#)

<!--kg-card-end: html-->
---
layout: post
title: Cara Menggunakan Load Balancer Nginx di CentOS 8
featured: true
date: '2020-08-28 23:37:55'
tags:
- centos
- load-balancer
- nginx
---

Pada kesempatan sebelumnya kita pernah membahas tentang _Nginx Reverse Proxy_ dimana salah satu keuntungannya dapat menggunakan _Load Balacing_ detailnya dapat di lihat pada link berikut: **_[Memahami Cara Kerja Nginx Reverse Proxy](/memahami-cara-kerja-nginx-reverse-proxy/)_**

Web server Nginx mungkin bisa dibilang sebagai web server yang multi guna, karena Nginx dapat digunakan sebagai reverse proxy, caching, bahkan Load Balancer.

Load Balancer salah satu cara atau mekanisme untuk membagi atau mendistribusikan trafik ke beberapa server dan ini salah satu dari solusi high availability.

Load Balancer di Nginx terdapat 3 pilihan algoritma yang dapat Anda gunakan diantaranya:

#### **_Round Robin_** :

> _Jika Anda menggunakan algoritma Round Robin maka instance yang dijadikan sebagai Load Balancer akan mendistribusikan trafik ke setiap server (web server) secara bergantian._

#### **_Least Connections:_**

> _Jika Anda menggunakan algoritma Least Connection maka instance yang dijadikan sebagai load blancer akan mendristribusikan traffik ke server (web server) yang sedikit menerima koneksi aktif_

#### _ **IP Hash:** _

> _Jika Anda menggunakan algoritma IP Hash maka instance yang dijadikan sebagai load balancer akan mendristribusikan traffi ke server (web server) yang sama ketika user atau visitor pertama kali request akses ke website._

Berikut topologi yang akan digunakan pada tutorial kali ini

<figure class="aligncenter size-large"><img loading="lazy" width="466" height="182" src="/content/images/wordpress/2020/08/LB-Nginx1.png" alt="" class="wp-image-362" srcset="/content/images/wordpress/2020/08/LB-Nginx1.png 466w, /content/images/wordpress/2020/08/LB-Nginx1-300x117.png 300w" sizes="(max-width: 466px) 100vw, 466px"></figure>

Berikut keterangan dari topologi diatas:

    - Instance LB Nginx: Digunakan sebagai Load Balancer Nginx
      IP Local: 192.168.10.2
      IP Public: 103.93.52.117
    
    - Instance Apps01 dan Apps02: Digunakan sebagai web server
      IP Local Apps01: 192.168.10.9
      IP Local Apps02: 192.168.10.18

Untuk set up LB di tutorial kali ini kami akan membagikan 3 tahapan diantaranya:

##### # Tahapan Pertama – Install Nginx dan Php-fpm di Apps01 dan Apps02

Tahapan pertama kami akan melakukan setup web server nginx di 2 instance web server sebagai berikut

Login ke VM/instance _Apps01_ install web server nginx

    [root@apps01 ~]#
    [root@apps01 ~]# dnf install nginx -y
    [root@apps01 ~]#

Start dan enable Nginx pastikan statusnya running

    [root@apps01 ~]# systemctl start nginx
    [root@apps01 ~]# systemctl enable nginx
    Created symlink /etc/systemd/system/multi-user.target.wants/nginx.service → /usr/lib/systemd/system/nginx.service.
    [root@apps01 ~]# systemctl status nginx
    ● nginx.service - The nginx HTTP and reverse proxy server
       Loaded: loaded (/usr/lib/systemd/system/nginx.service; enabled; vendor preset: disabled)
       Active: active (running) since Fri 2020-08-28 06:16:13 UTC; 3min 46s ago
     Main PID: 6178 (nginx)
        Tasks: 2 (limit: 11328)
       Memory: 3.9M
       CGroup: /system.slice/nginx.service
               ├─6178 nginx: master process /usr/sbin/nginx
               └─6179 nginx: worker process
    
    Aug 28 06:16:13 apps01.nurhamim.my.id systemd[1]: Starting The nginx HTTP and reverse proxy server...
    Aug 28 06:16:13 apps01.nurhamim.my.id nginx[6175]: nginx: the configuration file /etc/nginx/nginx.conf syntax is ok
    Aug 28 06:16:13 apps01.nurhamim.my.id nginx[6175]: nginx: configuration file /etc/nginx/nginx.conf test is successful
    Aug 28 06:16:13 apps01.nurhamim.my.id systemd[1]: nginx.service: Failed to parse PID from file /run/nginx.pid: Invalid argument
    Aug 28 06:16:13 apps01.nurhamim.my.id systemd[1]: Started The nginx HTTP and reverse proxy server.
    [root@apps01 ~]#

Selanjutnya install php-fpm di _Apps01_, silakan install repositori remi terlebih dahulu

    [root@apps01 ~]#
    [root@apps01 ~]# dnf install dnf-utils http://rpms.remirepo.net/enterprise/remi-release-8.rpm

Jika sudah silakan install php module nya

    [root@apps01 ~]#
    [root@apps01 ~]# dnf install php php-opcache php-gd php-curl php-mysqlnd php-fpm -y

Untuk melihat versi php gunakan perintah berikut

    [root@apps01 ~]#
    [root@apps01 ~]# php --version
    PHP 7.2.24 (cli) (built: Oct 22 2019 08:28:36) ( NTS )
    Copyright (c) 1997-2018 The PHP Group
    Zend Engine v3.2.0, Copyright (c) 1998-2018 Zend Technologies
        with Zend OPcache v7.2.24, Copyright (c) 1999-2018, by Zend Technologies
    [root@apps01 ~]#

Silakan start, enable dan pastikan status php-fpm running

    [root@apps01 ~]# systemctl start php-fpm
    [root@apps01 ~]# systemctl enable php-fpm
    Created symlink /etc/systemd/system/multi-user.target.wants/php-fpm.service → /usr/lib/systemd/system/php-fpm.service.
    [root@apps01 ~]# systemctl status php-fpm
    ● php-fpm.service - The PHP FastCGI Process Manager
       Loaded: loaded (/usr/lib/systemd/system/php-fpm.service; enabled; vendor preset: disabled)
       Active: active (running) since Fri 2020-08-28 06:26:05 UTC; 14s ago
     Main PID: 6713 (php-fpm)
       Status: "Processes active: 0, idle: 5, Requests: 0, slow: 0, Traffic: 0req/sec"
        Tasks: 6 (limit: 11328)
       Memory: 23.8M
       CGroup: /system.slice/php-fpm.service
               ├─6713 php-fpm: master process (/etc/php-fpm.conf)
               ├─6714 php-fpm: pool www
               ├─6715 php-fpm: pool www
               ├─6716 php-fpm: pool www
               ├─6717 php-fpm: pool www
               └─6718 php-fpm: pool www
    
    Aug 28 06:26:05 apps01.nurhamim.my.id systemd[1]: Starting The PHP FastCGI Process Manager...
    Aug 28 06:26:05 apps01.nurhamim.my.id systemd[1]: Started The PHP FastCGI Process Manager.
    [root@apps01 ~]#

Login ke VM/instance _Apps02_ install web server nginx dan start serta enable nginx, pastikan statusnya running

    [root@apps02 ~]#
    [root@apps02 ~]# dnf install nginx -y
    [root@apps02 ~]# systemctl start nginx
    [root@apps02 ~]# systemctl enable nginx
    Created symlink /etc/systemd/system/multi-user.target.wants/nginx.service → /usr/lib/systemd/system/nginx.service.
    [root@apps02 ~]# systemctl status nginx
    ● nginx.service - The nginx HTTP and reverse proxy server
       Loaded: loaded (/usr/lib/systemd/system/nginx.service; enabled; vendor preset: disabled)
       Active: active (running) since Fri 2020-08-28 06:09:02 UTC; 55s ago
     Main PID: 6454 (nginx)
        Tasks: 2 (limit: 11328)
       Memory: 3.9M
       CGroup: /system.slice/nginx.service
               ├─6454 nginx: master process /usr/sbin/nginx
               └─6455 nginx: worker process
    
    Aug 28 06:09:02 apps02.nurhamim.my.id systemd[1]: Starting The nginx HTTP and reverse proxy server...
    Aug 28 06:09:02 apps02.nurhamim.my.id nginx[6451]: nginx: the configuration file /etc/nginx/nginx.conf syntax is ok
    Aug 28 06:09:02 apps02.nurhamim.my.id nginx[6451]: nginx: configuration file /etc/nginx/nginx.conf test is successful

Kemudian sama seperti di _Apps01_ silalan install php-fpm terlebih dahulu silakan install repository remi

    [root@apps02 ~]#
    [root@apps02 ~]# dnf install dnf-utils http://rpms.remirepo.net/enterprise/remi-release-8.rpm

Install php

    [root@apps02 ~]#
    [root@apps02 ~]# dnf install php php-opcache php-gd php-curl php-mysqlnd php-fpm -y

Untuk melihat versi php jalankan perintah berikut

    [root@apps02 ~]#
    [root@apps02 ~]# php --version
    PHP 7.2.24 (cli) (built: Oct 22 2019 08:28:36) ( NTS )
    Copyright (c) 1997-2018 The PHP Group
    Zend Engine v3.2.0, Copyright (c) 1998-2018 Zend Technologies
        with Zend OPcache v7.2.24, Copyright (c) 1999-2018, by Zend Technologies
    [root@apps02 ~]#

Silakan start, enable dan pastikan statusnya running

    [root@apps02 ~]#
    [root@apps02 ~]# systemctl start php-fpm
    [root@apps02 ~]# systemctl enable php-fpm
    Created symlink /etc/systemd/system/multi-user.target.wants/php-fpm.service → /usr/lib/systemd/system/php-fpm.service.
    [root@apps02 ~]# systemctl status php-fpm
    ● php-fpm.service - The PHP FastCGI Process Manager
       Loaded: loaded (/usr/lib/systemd/system/php-fpm.service; enabled; vendor preset: disabled)
       Active: active (running) since Fri 2020-08-28 06:27:01 UTC; 7s ago
     Main PID: 7025 (php-fpm)
       Status: "Ready to handle connections"
        Tasks: 6 (limit: 11328)
       Memory: 23.8M
       CGroup: /system.slice/php-fpm.service
               ├─7025 php-fpm: master process (/etc/php-fpm.conf)
               ├─7026 php-fpm: pool www
               ├─7027 php-fpm: pool www
               ├─7028 php-fpm: pool www
               ├─7029 php-fpm: pool www
               └─7030 php-fpm: pool www
    
    Aug 28 06:27:01 apps02.nurhamim.my.id systemd[1]: Starting The PHP FastCGI Process Manager...
    Aug 28 06:27:01 apps02.nurhamim.my.id systemd[1]: Started The PHP FastCGI Process Manager.
    [root@apps02 ~]#

##### # Tahapan Kedua – Buat Website sederhana di Apps01 dan Apps02

Login ke Instance _Apps01_ tentukan direktori root website Anda dan buat website serderhana misalnya menggunakan html seperti berikut

    [root@apps01 ~]# mkdir -p /usr/share/nginx/belajarlinux
    [root@apps01 ~]# echo "<h1>Apps01 | Belajar Linux ID</h1>" > /usr/share/nginx/belajarlinux/index.php
    [root@apps01 ~]#

Selanjutnya membuat server block website Anda

    [root@apps01 ~]#
    [root@apps01 ~]# vim /etc/nginx/conf.d/belajarlinux.conf

Berikut isi dari konfigurasi server block nya

    server {
        listen 80;
    
        server_name belajarlinux.nurhamim.my.id;
        root /usr/share/nginx/belajarlinux/;
    
        access_log /var/log/nginx/belajarlinux.access.log;
        error_log /var/log/nginx/belajarlinux.error.log warn;
    
        index index.php index.html index.htm;
    
        location / {
            try_files $uri $uri/ /index.php?$query_string;
        }
    
        location ~ \.php$ {
            try_files $fastcgi_script_name =404;
            include fastcgi_params;
            fastcgi_pass unix:/run/php-fpm/www.sock;
            fastcgi_index index.php;
            fastcgi_param DOCUMENT_ROOT $realpath_root;
            fastcgi_param SCRIPT_FILENAME $realpath_root$fastcgi_script_name;
        }
    
    }

_Noted: Silakan disesuaikan untuk server\_name dan root direktorinya_

Pastikan tidak ada konfigurasi yang salah di sisi server block dan silakan reload nginx

    [root@apps01 ~]# nginx -t
    nginx: the configuration file /etc/nginx/nginx.conf syntax is ok
    nginx: configuration file /etc/nginx/nginx.conf test is successful
    [root@apps01 ~]#
    [root@apps01 ~]# nginx -s reload
    [root@apps01 ~]#

Login ke Instance _Apps02_ tentukan direktori root website Anda dan buat website serderhana misalnya menggunakan html seperti berikut

    [root@apps02 ~]# mkdir -p /usr/share/nginx/belajarlinux
    [root@apps02 ~]# echo "<h1>Apps02 | Belajar Linux ID</h1>" > /usr/share/nginx/belajarlinux/index.php

Selanjutnya membuat server block website Anda

    [root@apps02 ~]#
    [root@apps02 ~]# vim /etc/nginx/conf.d/belajarlinux.conf

Berikut isi dari konfigurasi server block nya

    server {
        listen 80;
    
        server_name belajarlinux.nurhamim.my.id;
        root /usr/share/nginx/belajarlinux/;
    
        access_log /var/log/nginx/belajarlinux.access.log;
        error_log /var/log/nginx/belajarlinux.error.log warn;
    
        index index.php index.html index.htm;
    
        location / {
            try_files $uri $uri/ /index.php?$query_string;
        }
    
        location ~ \.php$ {
            try_files $fastcgi_script_name =404;
            include fastcgi_params;
            fastcgi_pass unix:/run/php-fpm/www.sock;
            fastcgi_index index.php;
            fastcgi_param DOCUMENT_ROOT $realpath_root;
            fastcgi_param SCRIPT_FILENAME $realpath_root$fastcgi_script_name;
        }
    
    }

_Noted: Silakan disesuaikan untuk server\_name dan root direktorinya_

Pastikan tidak ada konfigurasi yang salah di sisi server block dan silakan reload nginx

    [root@apps02 ~]# nginx -t
    nginx: the configuration file /etc/nginx/nginx.conf syntax is ok
    nginx: configuration file /etc/nginx/nginx.conf test is successful
    [root@apps02 ~]#
    [root@apps02 ~]# nginx -s reload

##### # Tahap Ketiga – Set up Load Balancer Nginx

Silakan login ke instance Load balancer, dan install nginx

    [root@lb-nginx ~]#
    [root@lb-nginx ~]# dnf install epel-release -y
    
    [root@lb-nginx ~]#
    [root@lb-nginx ~]# dnf install nginx -y

Silakan start, enable dan pastikan nginx running

    [root@lb-nginx ~]#
    [root@lb-nginx ~]# systemctl start nginx
    [root@lb-nginx ~]# systemctl enable nginx
    Created symlink /etc/systemd/system/multi-user.target.wants/nginx.service → /usr/lib/systemd/system/nginx.service.
    [root@lb-nginx ~]#
    [root@lb-nginx ~]# systemctl status nginx
    ● nginx.service - The nginx HTTP and reverse proxy server
       Loaded: loaded (/usr/lib/systemd/system/nginx.service; enabled; vendor preset: disabled)
       Active: active (running) since Fri 2020-08-28 06:42:20 UTC; 8s ago
     Main PID: 6990 (nginx)
        Tasks: 2 (limit: 11326)
       Memory: 3.9M
       CGroup: /system.slice/nginx.service
               ├─6990 nginx: master process /usr/sbin/nginx
               └─6991 nginx: worker process
    
    Aug 28 06:42:20 lb-nginx.nurhamim.my.id systemd[1]: Starting The nginx HTTP and reverse proxy server...
    Aug 28 06:42:20 lb-nginx.nurhamim.my.id nginx[6987]: nginx: the configuration file /etc/nginx/nginx.conf syntax is ok
    Aug 28 06:42:20 lb-nginx.nurhamim.my.id nginx[6987]: nginx: configuration file /etc/nginx/nginx.conf test is successful
    Aug 28 06:42:20 lb-nginx.nurhamim.my.id systemd[1]: nginx.service: Failed to parse PID from file /run/nginx.pid: Invalid argument
    Aug 28 06:42:20 lb-nginx.nurhamim.my.id systemd[1]: Started The nginx HTTP and reverse proxy server.
    [root@lb-nginx ~]#

Membuat konfigurasi Load Balancer Nginx

    [root@lb-nginx ~]#
    [root@lb-nginx ~]# vim /etc/nginx/conf.d/lb-belajarlinux.conf

Berikut full konfigurasi Nginx Load Balancer nya

    upstream backendapps {
        server 192.168.10.9; #apps01
        server 192.168.10.18; #apps02
    }
    
    server {
        listen 80;
        server_name belajarlinux.nurhamim.my.id;
    
        location / {
            proxy_redirect off;
            proxy_set_header X-Real-IP $remote_addr;
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
            proxy_set_header Host $http_host;
            proxy_pass http://backendapps;
        }
    }

_Noted: Silahkan sesuai IP setiap backend/node/apps01 dan apps02 nya._

Secara default algoritma yang digunakan diatas yaitu round robin, jika Anda ingin menggunakan algortima _last connection atau ip hash_ Anda hanya perlu menambahkan satu baris perintah dibawah _upstream_ contohnya:

    # LEAST CONNECTION
    
    upstream backendapps {
        least_conn;
        server 192.168.10.9; #apps01
        server 192.168.10.18; #apps02
    }
    
    # IP HASH
    
    upstream backendapps {
        ip_hash;
        server 192.168.10.9; #apps01
        server 192.168.10.18; #apps02
    }

Jika sudah silakan simpan konfigurasinya, dan pastikan tidak terdapat kesalahan di konfigurasi server block dan silakan reload nginx

    [root@lb-nginx ~]#
    [root@lb-nginx ~]# nginx -t
    nginx: the configuration file /etc/nginx/nginx.conf syntax is ok
    nginx: configuration file /etc/nginx/nginx.conf test is successful
    [root@lb-nginx ~]#
    [root@lb-nginx ~]# nginx -s reload
    [root@lb-nginx ~]#

Langkah terakhir pastikan subdomain _belajarlinux.nurhamim.my.id_ sudah diarahkan ke public IP Load Balancer

<figure class="wp-block-image size-large"><img loading="lazy" width="916" height="185" src="/content/images/wordpress/2020/08/a-record-lb-nginx.png" alt="" class="wp-image-363" srcset="/content/images/wordpress/2020/08/a-record-lb-nginx.png 916w, /content/images/wordpress/2020/08/a-record-lb-nginx-300x61.png 300w, /content/images/wordpress/2020/08/a-record-lb-nginx-768x155.png 768w" sizes="(max-width: 916px) 100vw, 916px"></figure>

Test Load Balancer dengan cara akses subdomain tersebut

<figure class="wp-block-image size-large"><img loading="lazy" width="1024" height="335" src="/content/images/wordpress/2020/08/lb-nginx-1024x335.png" alt="" class="wp-image-364" srcset="/content/images/wordpress/2020/08/lb-nginx-1024x335.png 1024w, /content/images/wordpress/2020/08/lb-nginx-300x98.png 300w, /content/images/wordpress/2020/08/lb-nginx-768x251.png 768w, /content/images/wordpress/2020/08/lb-nginx.png 1363w" sizes="(max-width: 1024px) 100vw, 1024px"></figure>

Selamat Load Balancer Nginx Anda sudah berjalan.

Selamat mencoba.

Please follow and like us:

[![error](/wp-content/plugins/ultimate-social-media-icons/images/follow_subscribe.png)](https://api.follow.it/widgets/icon/VHc3d1lpVGdwRnE5QnV0eERCNUx5RCtvTTVoUkNYS3NNRmd5eVhlQW9tNXRHS3VTbGh6Y0NybkRJRS8zSGpjRDVZb1ZGMlNTSEpJYUpuZzZqNzdnd3VSN3dwM2VlQTF6ejJEaGV5UGRUbnlEcHFNd3luYTV4ZTZtUGowVWI2Q2x8M2kzdnBEeUIrUk5xOFI5TXZ3cHF3bFNQRkRJSGhUNGdrRFd0TlNtdE1OWT0=/OA==/)

[![fb-share-icon](/wp-content/plugins/ultimate-social-media-icons/images/visit_icons/fbshare_bck.png "Facebook Share")](https://www.facebook.com/sharer/sharer.php?u=https%3A%2F%2Fbelajarlinux.id%2F%3Fp%3D361%26ghostexport%3Dtrue%26submit%3DDownload+Ghost+File)

[![Tweet](/wp-content/plugins/ultimate-social-media-icons/images/visit_icons/en_US_Tweet.svg "Tweet")](https://twitter.com/intent/tweet?text=Cara+Menggunakan+Load+Balancer+Nginx+di+CentOS+8+https://belajarlinux.id/?p=361&ghostexport=true&submit=Download Ghost File)

[![fb-share-icon](/wp-content/plugins/ultimate-social-media-icons/images/share_icons/Pinterest_Save/en_US_save.svg "Pin Share")](#)

<!--kg-card-end: html-->
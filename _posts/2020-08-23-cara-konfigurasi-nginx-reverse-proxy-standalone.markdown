---
layout: post
title: Cara Konfigurasi Nginx Reverse Proxy (Standalone)
featured: true
date: '2020-08-23 21:53:38'
tags:
- apache
- centos
- nginx
---

Pada tutorial sebelumnya kita sudah membahas tentang pengertian, cara kerja, fungsi dan keuntungan jika menggunakan Nginx Reverse Proxy berikut: _**[Memahami Cara Kerja Nginx Reverse Proxy](/memahami-cara-kerja-nginx-reverse-proxy/)**_

Untuk mengikuti tutorial ini pastikan Anda sudah mengikuti tutorial berikut, karena pada tutorial kali ini akan dibahas langsung inti dan tahapan melakukan Nginx Reverse Proxy

- _**[Cara Instalasi Nginx Di CentOS 8](/cara-instalasi-nginx-di-centos-8/)**_
- **_[Cara Instalasi Apache di CentOS 8](/cara-instalasi-apache-di-centos-8/)_**
- **_[Cara Menjalankan Apache dan Nginx Secara Bersama di CentOS 8](/cara-menjalankan-apache-dan-nginx-secara-bersama-di-centos-8/)_**

Berikut skema topologi yang akan digunakan pada tutorial kali ini

<figure class="aligncenter size-large"><img loading="lazy" width="490" height="111" src="/content/images/wordpress/2020/08/Topologi-Reverse-proxy-Nginx-1.png" alt="" class="wp-image-191" srcset="/content/images/wordpress/2020/08/Topologi-Reverse-proxy-Nginx-1.png 490w, /content/images/wordpress/2020/08/Topologi-Reverse-proxy-Nginx-1-300x68.png 300w" sizes="(max-width: 490px) 100vw, 490px"></figure>

Topologi diatas hanya menggunakan 1 server/VM/VPS (standalone) dengan demikian pastikan Anda sudah running ke dua webser Apache dan Nginx dalam satu server.

Disini kami set Nginx berjalan di port default web server **80** dan untuk backend (Apache) berjalan di port **8080**.

Pastikan status masing – masing web server running sebagai berikut

    # Nginx 
    [root@tutorial ~]#
    [root@tutorial ~]# systemctl status nginx
    ● nginx.service - The nginx HTTP and reverse proxy server
       Loaded: loaded (/usr/lib/systemd/system/nginx.service; enabled; vendor preset: disabled)
      Drop-In: /usr/lib/systemd/system/nginx.service.d
               └─php-fpm.conf
       Active: active (running) since Sun 2020-08-23 04:56:25 UTC; 8h ago
      Process: 14723 ExecReload=/bin/kill -s HUP $MAINPID (code=exited, status=0/SUCCESS)
      Process: 14755 ExecStart=/usr/sbin/nginx (code=exited, status=0/SUCCESS)
      Process: 14752 ExecStartPre=/usr/sbin/nginx -t (code=exited, status=0/SUCCESS)
      Process: 14743 ExecStartPre=/usr/bin/rm -f /run/nginx.pid (code=exited, status=0/SUCCESS)
     Main PID: 14756 (nginx)
        Tasks: 5 (limit: 23813)
       Memory: 8.6M
       CGroup: /system.slice/nginx.service
               ├─14756 nginx: master process /usr/sbin/nginx
               ├─14757 nginx: worker process
               ├─14758 nginx: worker process
               ├─14759 nginx: worker process
               └─14760 nginx: worker process
    
    Aug 23 04:56:24 tutorial.nurhamim.my.id systemd[1]: Starting The nginx HTTP and reverse proxy server...
    Aug 23 04:56:25 tutorial.nurhamim.my.id nginx[14752]: nginx: the configuration file /etc/nginx/nginx.conf syntax is ok
    Aug 23 04:56:25 tutorial.nurhamim.my.id nginx[14752]: nginx: configuration file /etc/nginx/nginx.conf test is successful
    Aug 23 04:56:25 tutorial.nurhamim.my.id systemd[1]: Started The nginx HTTP and reverse proxy server.
    [root@tutorial ~]#
    
    # Apache
    [root@tutorial httpd]# systemctl status httpd
    ● httpd.service - The Apache HTTP Server
       Loaded: loaded (/usr/lib/systemd/system/httpd.service; enabled; vendor preset: disabled)
      Drop-In: /usr/lib/systemd/system/httpd.service.d
               └─php-fpm.conf
       Active: active (running) since Sun 2020-08-23 13:49:08 UTC; 4s ago
         Docs: man:httpd.service(8)
      Process: 14707 ExecReload=/usr/sbin/httpd $OPTIONS -k graceful (code=exited, status=0/SUCCESS)
     Main PID: 16332 (httpd)
       Status: "Started, listening on: port 8080"
        Tasks: 213 (limit: 23813)
       Memory: 37.4M
       CGroup: /system.slice/httpd.service
               ├─16332 /usr/sbin/httpd -DFOREGROUND
               ├─16333 /usr/sbin/httpd -DFOREGROUND
               ├─16334 /usr/sbin/httpd -DFOREGROUND
               ├─16335 /usr/sbin/httpd -DFOREGROUND
               └─16336 /usr/sbin/httpd -DFOREGROUND
    
    Aug 23 13:49:08 tutorial.nurhamim.my.id systemd[1]: Starting The Apache HTTP Server...
    Aug 23 13:49:08 tutorial.nurhamim.my.id systemd[1]: Started The Apache HTTP Server.
    Aug 23 13:49:08 tutorial.nurhamim.my.id httpd[16332]: Server configured, listening on: port 8080
    [root@tutorial httpd]#

Disini kami akan mencoba membuat file website sederhana menggunakan HTML saja, silakan pindah ke direktori _/var/www/_ dan buat direktori website Anda

    [root@tutorial ~]#
    [root@tutorial ~]# cd /var/www/
    [root@tutorial www]# mkdir belajarlinux
    [root@tutorial www]# cd belajarlinux/
    [root@tutorial belajarlinux]#
    [root@tutorial belajarlinux]# echo "<h1>Belajar Reverse Proxy Nginx di @BelajarLinuxID</h1>" > index.html
    [root@tutorial belajarlinux]#

Membuat _vhost (Virtual Host)_ untuk website _belajarlinux_

    [root@tutorial belajarlinux]#
    [root@tutorial belajarlinux]# vim /etc/httpd/conf.d/vhost-belajarlinux.conf

Berikut isi dari vhost nya

    <VirtualHost *:8080>
      ServerName vhost.nurhamim.my.id
      DocumentRoot /var/www/belajarlinux
    
      <Directory /var/www/belajarlinux>
        Require all granted
      </Directory>
    </VirtualHost>

Jika sudah silakan reload web server Apache Anda

    [root@tutorial belajarlinux]#
    [root@tutorial belajarlinux]# systemctl reload httpd

Verifikasi domain atau subdomain yang Anda gunakan, silakan akses menggunakan port 8080

<figure class="wp-block-image size-large"><img loading="lazy" width="1024" height="241" src="/content/images/wordpress/2020/08/image-53-1024x241.png" alt="" class="wp-image-193" srcset="/content/images/wordpress/2020/08/image-53-1024x241.png 1024w, /content/images/wordpress/2020/08/image-53-300x71.png 300w, /content/images/wordpress/2020/08/image-53-768x181.png 768w, /content/images/wordpress/2020/08/image-53.png 1354w" sizes="(max-width: 1024px) 100vw, 1024px"></figure>

Selanjutnya mengubah _LogFormat_ dari _Access\_Log_ Apache untuk mempermudah melihat access log dan membedakan menggunakan Reverse Proxy Nginx dengan tidak menggunakan Reverse Proxy Nginx.

Sebelum mengubah silakan backup terlebih dahulu file original apache Anda

    [root@tutorial belajarlinux]#
    [root@tutorial belajarlinux]# cp /etc/httpd/conf/httpd.conf{,-orig}

Jika sudah silakan edit access log apache

    [root@tutorial belajarlinux]# vim /etc/httpd/conf/httpd.conf

Kemudian tambahkan _ **%v** _ pada _LogFormat_ seperti berikut

- Before

        #
        # The following directives define some format nicknames for use with
        # a CustomLog directive (see below).
        #
        LogFormat "%h %l %u %t \"%r\" %>s %b \"%{Referer}i\" \"%{User-Agent}i\"" combined
        LogFormat "%h %l %u %t \"%r\" %>s %b" common

- After

        #
        # The following directives define some format nicknames for use with
        # a CustomLog directive (see below).
        #
        LogFormat "%v %a %l %u %t \"%r\" %>s %b \"%{Referer}i\" \"%{User-Agent}i\"" combined
        LogFormat "%h %l %u %t \"%r\" %>s %b" common

_Noted:_

- _%v : Digunakan untuk mencatat informasi virtualhost Anda_
- _%a : Digunakan untuk merekam (capture) IP klien yang bukan IP Reverse Proxy Nginx nantinya dan kita perlu menambahkan header di sisi vhost nantinya supaya dapat terekan IP klien._

Kemudian cek log access nya seperti menggunakan perintah berikut

    # tail -f /var/log/httpd/access_log

- Before

    103.58.102.219 - - [23/Aug/2020:13:58:36 +0000] "GET /noindex/common/images/pb-apache.png HTTP/1.1" 200 103267 "http://vhost.nurhamim.my.id:8080/" "Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:79.0) Gecko/20100101 Firefox/79.0"
    103.58.102.219 - - [23/Aug/2020:13:58:51 +0000] "GET / HTTP/1.1" 200 56 "-" "Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:79.0) Gecko/20100101 Firefox/79.0"
    103.58.102.219 - - [23/Aug/2020:13:58:51 +0000] "GET /robots.txt?1598191115128 HTTP/1.1" 404 208 "-" "Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:79.0) Gecko/20100101 Firefox/79.0"
    103.58.102.219 - - [23/Aug/2020:13:58:51 +0000] "GET /favicon.ico HTTP/1.1" 404 209 "-" "Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:79.0) Gecko/20100101 Firefox/79.0"

- After

    vhost.nurhamim.my.id 127.0.0.1 - - [23/Aug/2020:14:16:07 +0000] "GET / HTTP/1.0" 304 - "-" "Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:79.0) Gecko/20100101 Firefox/79.0"
    vhost.nurhamim.my.id 127.0.0.1 - - [23/Aug/2020:14:16:07 +0000] "GET /robots.txt?1598192151211 HTTP/1.0" 404 208 "-" "Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:79.0) Gecko/20100101 Firefox/79.0"
    vhost.nurhamim.my.id 127.0.0.1 - - [23/Aug/2020:14:16:09 +0000] "GET / HTTP/1.0" 304 - "-" "Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:79.0) Gecko/20100101 Firefox/79.0"
    vhost.nurhamim.my.id 127.0.0.1 - - [23/Aug/2020:14:16:09 +0000] "GET /robots.txt?1598192153302 HTTP/1.0" 404 208 "-" "Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:79.0) Gecko/20100101 Firefox/79.0"
    vhost.nurhamim.my.id 127.0.0.1 - - [23/Aug/2020:14:16:10 +0000] "GET / HTTP/1.0" 304 - "-" "Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:79.0) Gecko/20100101 Firefox/79.0"
    vhost.nurhamim.my.id 127.0.0.1 - - [23/Aug/2020:14:16:11 +0000] "GET /robots.txt?1598192154846 HTTP/1.0" 404 208 "-" "Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:79.0) Gecko/20100101 Firefox/79.0"
    vhost.nurhamim.my.id 127.0.0.1 - - [23/Aug/2020:14:16:14 +0000] "GET / HTTP/1.0" 304 - "-" "Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:79.0) Gecko/20100101 Firefox/79.0"
    vhost.nurhamim.my.id 127.0.0.1 - - [23/Aug/2020:14:16:14 +0000] "GET /robots.txt?1598192158142 HTTP/1.0" 404 208 "-" "Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:79.0) Gecko/20100101 Firefox/79.0"

Menentukan port listen konfigurasi apache dan virtual host apache di sini akan menggunakan port 8080 listen 127.0.0.2

    #### Konfigurasi Apache
    [root@tutorial belajarlinux]#
    [root@tutorial belajarlinux]# vim /etc/httpd/conf/httpd.conf
    
    #Listen 12.34.56.78:80
    #Listen 80
    Listen 127.0.0.2:8080

    ### Konfigurasi Vhost Apache
    [root@tutorial belajarlinux]# vim /etc/httpd/conf.d/vhost-belajarlinux.conf
    
    <VirtualHost 127.0.0.2:8080>
      ServerName vhost.nurhamim.my.id
      DocumentRoot /var/www/belajarlinux
    
      <Directory /var/www/belajarlinux>
        Require all granted
      </Directory>
    </VirtualHost>

Jika sudah, selanjutnya membuat konfigurasi Nginx Reverse Proxy

    [root@tutorial belajarlinux]#
    [root@tutorial belajarlinux]# vim /etc/nginx/conf.d/proxy-belajarlinux.conf

Berikut isi dari file Nginx Reverse Proxy nya

    upstream belajarlinux8080 {
        server 127.0.0.2:8080;
    }
    
    server {
        listen 80;
        server_name vhost.nurhamim.my.id;
    
        location / {
            proxy_pass http://belajarlinux8080;
            proxy_set_header Host $host;
            proxy_set_header X-Forwarded-Proto $scheme;
            proxy_set_header X-Forwarded-Port $server_port;
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        }
    }

_Catatan:_

- Disini kami menggunakan _upstream, kita perlu mendifine ip dan port yang sudah kita tentukan di konfigurasi apache sebelumnya_
- _Server Name: isikan sub domain atau domain sesuai dengan yang ada di vhost_
- _Proxy\_pass: Merupakan konfigurasi reverse proxy nya, pastikan sama dengan yang ada di upstream_

Selanjutnya reload nginx dan apache dan pastikan tidak ada miss atau kesalahan konfigurasi dari ke dua web server tersebut

    [root@tutorial belajarlinux]#
    [root@tutorial belajarlinux]# nginx -t
    nginx: the configuration file /etc/nginx/nginx.conf syntax is ok
    nginx: configuration file /etc/nginx/nginx.conf test is successful
    [root@tutorial belajarlinux]#
    [root@tutorial belajarlinux]# systemctl reload httpd
    [root@tutorial belajarlinux]# systemctl reload nginx
    [root@tutorial belajarlinux]#

Jika sudah silakan akses sub domain Anda tanpa port 8080 karena sudah menggunakan reverse proxy

<figure class="wp-block-image size-large"><img loading="lazy" width="1024" height="147" src="/content/images/wordpress/2020/08/image-54-1024x147.png" alt="" class="wp-image-194" srcset="/content/images/wordpress/2020/08/image-54-1024x147.png 1024w, /content/images/wordpress/2020/08/image-54-300x43.png 300w, /content/images/wordpress/2020/08/image-54-768x110.png 768w, /content/images/wordpress/2020/08/image-54.png 1366w" sizes="(max-width: 1024px) 100vw, 1024px"></figure>

Baik saat ini website sudah dapat diakses tanpa port dan artinya reverse proxy sudah berjalan, silakan cek log access apache Anda

    vhost.nurhamim.my.id 127.0.0.1 - - [23/Aug/2020:14:38:38 +0000] "GET / HTTP/1.0" 304 - "-" "Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:79.0) Gecko/20100101 Firefox/79.0"
    vhost.nurhamim.my.id 127.0.0.1 - - [23/Aug/2020:14:40:30 +0000] "GET / HTTP/1.0" 304 - "-" "Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:79.0) Gecko/20100101 Firefox/79.0"
    vhost.nurhamim.my.id 127.0.0.1 - - [23/Aug/2020:14:40:31 +0000] "GET / HTTP/1.0" 304 - "-" "Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:79.0) Gecko/20100101 Firefox/79.0"
    vhost.nurhamim.my.id 127.0.0.1 - - [23/Aug/2020:14:40:31 +0000] "GET / HTTP/1.0" 304 - "-" "Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:79.0) Gecko/20100101 Firefox/79.0"

Di log access saat ini IP Klien belum terekan hanya IP localhost untuk itu kita perlu menambahkan beberapa konfigurasi header disisi vhost seperti berikut

    [root@tutorial belajarlinux]#
    [root@tutorial belajarlinux]# vim /etc/httpd/conf.d/vhost-belajarlinux.conf

Berikut isi dari vhost terbaru

    <VirtualHost 127.0.0.2:8080>
      ServerName vhost.nurhamim.my.id
      DocumentRoot /var/www/belajarlinux
    
      RemoteIPHeader X-Forwarded-For
      RemoteIPInternalProxy 127.0.0.1/8
    
      <Directory /var/www/belajarlinux>
        Require all granted
      </Directory>
    </VirtualHost>

Jika sudah silakan reload kembali nginx dan apache Anda lalu akses kembai subdomain atau domain Anda dan lihat kembali log access nya akan seperti berikut

    vhost.nurhamim.my.id 103.58.102.219 - - [23/Aug/2020:14:43:08 +0000] "GET / HTTP/1.0" 304 - "-" "Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:79.0) Gecko/20100101 Firefox/79.0"
    vhost.nurhamim.my.id 103.58.102.219 - - [23/Aug/2020:14:43:08 +0000] "GET /robots.txt?1598193772224 HTTP/1.0" 404 208 "-" "Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:79.0) Gecko/20100101 Firefox/79.0"
    vhost.nurhamim.my.id 103.58.102.219 - - [23/Aug/2020:14:43:17 +0000] "GET / HTTP/1.0" 304 - "-" "Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:79.0) Gecko/20100101 Firefox/79.0"
    vhost.nurhamim.my.id 103.58.102.219 - - [23/Aug/2020:14:43:17 +0000] "GET /robots.txt?1598193781007 HTTP/1.0" 404 208 "-" "Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:79.0) Gecko/20100101 Firefox/79.0"
    vhost.nurhamim.my.id 103.58.102.219 - - [23/Aug/2020:14:43:17 +0000] "GET / HTTP/1.0" 304 - "-" "Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:79.0) Gecko/20100101 Firefox/79.0"
    vhost.nurhamim.my.id 103.58.102.219 - - [23/Aug/2020:14:43:18 +0000] "GET /robots.txt?1598193782512 HTTP/1.0" 404 208 "-" "Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:79.0) Gecko/20100101 Firefox/79.0"

Dari Accesss Log diatas kita dapat melihat IP 103.58.102.219 (client) sedang mengakses website vhost.nurhamim.my.id dan berikut detail untuk informasi reverse proxy nya

<figure class="wp-block-image size-large"><img loading="lazy" width="1024" height="325" src="/content/images/wordpress/2020/08/image-55-1024x325.png" alt="" class="wp-image-195" srcset="/content/images/wordpress/2020/08/image-55-1024x325.png 1024w, /content/images/wordpress/2020/08/image-55-300x95.png 300w, /content/images/wordpress/2020/08/image-55-768x244.png 768w, /content/images/wordpress/2020/08/image-55.png 1363w" sizes="(max-width: 1024px) 100vw, 1024px"></figure>

Selamat mencoba 😁

Please follow and like us:

[![error](/wp-content/plugins/ultimate-social-media-icons/images/follow_subscribe.png)](https://api.follow.it/widgets/icon/VHc3d1lpVGdwRnE5QnV0eERCNUx5RCtvTTVoUkNYS3NNRmd5eVhlQW9tNXRHS3VTbGh6Y0NybkRJRS8zSGpjRDVZb1ZGMlNTSEpJYUpuZzZqNzdnd3VSN3dwM2VlQTF6ejJEaGV5UGRUbnlEcHFNd3luYTV4ZTZtUGowVWI2Q2x8M2kzdnBEeUIrUk5xOFI5TXZ3cHF3bFNQRkRJSGhUNGdrRFd0TlNtdE1OWT0=/OA==/)

[![fb-share-icon](/wp-content/plugins/ultimate-social-media-icons/images/visit_icons/fbshare_bck.png "Facebook Share")](https://www.facebook.com/sharer/sharer.php?u=https%3A%2F%2Fbelajarlinux.id%2F%3Fp%3D190%26ghostexport%3Dtrue%26submit%3DDownload+Ghost+File)

[![Tweet](/wp-content/plugins/ultimate-social-media-icons/images/visit_icons/en_US_Tweet.svg "Tweet")](https://twitter.com/intent/tweet?text=Cara+Konfigurasi+Nginx+Reverse+Proxy+%28Standalone%29+https://belajarlinux.id/?p=190&ghostexport=true&submit=Download Ghost File)

[![fb-share-icon](/wp-content/plugins/ultimate-social-media-icons/images/share_icons/Pinterest_Save/en_US_save.svg "Pin Share")](#)

<!--kg-card-end: html-->
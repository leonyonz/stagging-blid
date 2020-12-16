---
layout: post
title: Cara Menjalankan Apache dan Nginx Secara Bersama di CentOS 8
featured: true
date: '2020-08-22 06:49:47'
tags:
- apache
- centos
- nginx
---

Apache dan Nginx sama – sama Web Server dimana ke dua service tersebut berjalan di port 80. Lalu bagaimana cara menjalankan ke dua web server tersebut secara bersamaan?.

Untuk menjalankan ke dua web server tersebut dapat di lakukan dengan cara mengubah salah satu port dari web server misalnya nginx berjalan di port 80 dan apache dijalankan di port 8080.

Sebelum mengikuti tutorial ini pastikan Anda sudah install apache dan nginx, jika belum silakan merujuk pada tutorial berikut:

- **_[Cara Instalasi Apache di CentOS 8](/cara-instalasi-apache-di-centos-8/)_**
- **_[Cara Instalasi Nginx Di CentOS 8](/cara-instalasi-nginx-di-centos-8/)_**

Langkah pertama yang akan kita lakukan yaitu start web server nginx dan pastikan statusnya running.

    [root@tutorial ~]#
    [root@tutorial ~]# systemctl start nginx
    [root@tutorial ~]# systemctl status nginx
    ● nginx.service - The nginx HTTP and reverse proxy server
       Loaded: loaded (/usr/lib/systemd/system/nginx.service; disabled; vendor preset: disabled)
      Drop-In: /usr/lib/systemd/system/nginx.service.d
               └─php-fpm.conf
       Active: active (running) since Fri 2020-08-21 23:34:27 UTC; 3s ago
      Process: 32347 ExecStart=/usr/sbin/nginx (code=exited, status=0/SUCCESS)
      Process: 32345 ExecStartPre=/usr/sbin/nginx -t (code=exited, status=0/SUCCESS)
      Process: 32343 ExecStartPre=/usr/bin/rm -f /run/nginx.pid (code=exited, status=0/SUCCESS)
     Main PID: 32348 (nginx)
        Tasks: 5 (limit: 23996)
       Memory: 8.2M
       CGroup: /system.slice/nginx.service
               ├─32348 nginx: master process /usr/sbin/nginx
               ├─32349 nginx: worker process
               ├─32350 nginx: worker process
               ├─32351 nginx: worker process
               └─32352 nginx: worker process
    
    Aug 21 23:34:27 tutorial.nurhamim.my.id systemd[1]: Starting The nginx HTTP and reverse proxy server...
    Aug 21 23:34:27 tutorial.nurhamim.my.id nginx[32345]: nginx: the configuration file /etc/nginx/nginx.conf syntax is ok
    Aug 21 23:34:27 tutorial.nurhamim.my.id nginx[32345]: nginx: configuration file /etc/nginx/nginx.conf test is successful
    Aug 21 23:34:27 tutorial.nurhamim.my.id systemd[1]: Started The nginx HTTP and reverse proxy server.
    [root@tutorial ~]#

Kondisi saat ini web server apache dalam keadaan nonaktif

    [root@tutorial ~]#
    [root@tutorial ~]# systemctl status httpd |grep Active
       Active: inactive (dead) since Fri 2020-08-21 23:34:21 UTC; 1min 11s ago
    [root@tutorial ~]#

Sekarang kita ubah port apache menjadi 8080, untuk mengubah nya dilakukan di _/etc/httpd/conf/httpd.conf_ seperti berikut

    [root@tutorial ~]#
    [root@tutorial ~]# vim /etc/httpd/conf/httpd.conf

- Before
<figure class="wp-block-image size-large"><img loading="lazy" width="653" height="186" src="/content/images/wordpress/2020/08/image-30.png" alt="" class="wp-image-134" srcset="/content/images/wordpress/2020/08/image-30.png 653w, /content/images/wordpress/2020/08/image-30-300x85.png 300w" sizes="(max-width: 653px) 100vw, 653px"></figure>
- After
<figure class="wp-block-image size-large"><img loading="lazy" width="713" height="194" src="/content/images/wordpress/2020/08/image-31.png" alt="" class="wp-image-135" srcset="/content/images/wordpress/2020/08/image-31.png 713w, /content/images/wordpress/2020/08/image-31-300x82.png 300w" sizes="(max-width: 713px) 100vw, 713px"></figure>

Jika sudah silakan simpan dan silakan start web server apache Anda, jika berhasil hasilnya seperti berikut

    [root@tutorial ~]#
    [root@tutorial ~]# systemctl start httpd
    [root@tutorial ~]# systemctl status httpd
    ● httpd.service - The Apache HTTP Server
       Loaded: loaded (/usr/lib/systemd/system/httpd.service; enabled; vendor preset: disabled)
      Drop-In: /usr/lib/systemd/system/httpd.service.d
               └─php-fpm.conf
       Active: active (running) since Fri 2020-08-21 23:39:59 UTC; 3s ago
         Docs: man:httpd.service(8)
      Process: 30954 ExecReload=/usr/sbin/httpd $OPTIONS -k graceful (code=exited, status=0/SUCCESS)
     Main PID: 32371 (httpd)
       Status: "Started, listening on: port 8080"
        Tasks: 213 (limit: 23996)
       Memory: 41.5M
       CGroup: /system.slice/httpd.service
               ├─32371 /usr/sbin/httpd -DFOREGROUND
               ├─32372 /usr/sbin/httpd -DFOREGROUND
               ├─32373 /usr/sbin/httpd -DFOREGROUND
               ├─32374 /usr/sbin/httpd -DFOREGROUND
               └─32375 /usr/sbin/httpd -DFOREGROUND
    
    Aug 21 23:39:59 tutorial.nurhamim.my.id systemd[1]: Starting The Apache HTTP Server...
    Aug 21 23:39:59 tutorial.nurhamim.my.id systemd[1]: Started The Apache HTTP Server.
    Aug 21 23:39:59 tutorial.nurhamim.my.id httpd[32371]: Server configured, listening on: port 8080
    [root@tutorial ~]#

Untuk memastikan apakah web server nya sudah listen ke port 8080 (apache) dan 80 (nginx) gunakan perintah berikut:

    [root@tutorial ~]# netstat -talpn |grep 80
    tcp 0 0 0.0.0.0:80 0.0.0.0:* LISTEN 32348/nginx: master
    tcp6 0 0 :::8080 :::* LISTEN 32371/httpd
    tcp6 0 0 :::80 :::* LISTEN 32348/nginx: master
    [root@tutorial ~]#

Untuk menjalankan vhost yang telah dibuat sebelumnya pada tutorial berikut: _[Cara Membuat Virtual Host Apache di CentOS 8](/cara-membuat-virtual-host-apache-di-centos-8/)_ perlu di lakukan perubahan port nya menjadi 8080 sebagai berikut:

    [root@tutorial ~]#
    [root@tutorial ~]# vim /etc/httpd/conf.d/vhost01.nurhamim.my.id.conf

Ubah port pada vhost menjadi 8080

<figure class="wp-block-image size-large"><img loading="lazy" width="694" height="224" src="/content/images/wordpress/2020/08/image-32.png" alt="" class="wp-image-136" srcset="/content/images/wordpress/2020/08/image-32.png 694w, /content/images/wordpress/2020/08/image-32-300x97.png 300w" sizes="(max-width: 694px) 100vw, 694px"></figure>

Jika sudah silakan disimpan dan di reload apache nya lalu akses domain atau subdomainnya menggunakan port 8080

    [root@tutorial ~]# systemctl reload httpd
    [root@tutorial ~]# httpd -t
    Syntax OK
    [root@tutorial ~]#

Jika berhasil hasilnya seperti berikut

<figure class="wp-block-image size-large"><img loading="lazy" width="1024" height="161" src="/content/images/wordpress/2020/08/image-33-1024x161.png" alt="" class="wp-image-137" srcset="/content/images/wordpress/2020/08/image-33-1024x161.png 1024w, /content/images/wordpress/2020/08/image-33-300x47.png 300w, /content/images/wordpress/2020/08/image-33-768x120.png 768w, /content/images/wordpress/2020/08/image-33.png 1365w" sizes="(max-width: 1024px) 100vw, 1024px"></figure>

Dan server block nginx juga berjalan dengan normal

<figure class="wp-block-image size-large"><img loading="lazy" width="1024" height="115" src="/content/images/wordpress/2020/08/image-34-1024x115.png" alt="" class="wp-image-138" srcset="/content/images/wordpress/2020/08/image-34-1024x115.png 1024w, /content/images/wordpress/2020/08/image-34-300x34.png 300w, /content/images/wordpress/2020/08/image-34-768x87.png 768w, /content/images/wordpress/2020/08/image-34.png 1358w" sizes="(max-width: 1024px) 100vw, 1024px"></figure>

Selamat mencoba 😄

Please follow and like us:

[![error](/wp-content/plugins/ultimate-social-media-icons/images/follow_subscribe.png)](https://api.follow.it/widgets/icon/VHc3d1lpVGdwRnE5QnV0eERCNUx5RCtvTTVoUkNYS3NNRmd5eVhlQW9tNXRHS3VTbGh6Y0NybkRJRS8zSGpjRDVZb1ZGMlNTSEpJYUpuZzZqNzdnd3VSN3dwM2VlQTF6ejJEaGV5UGRUbnlEcHFNd3luYTV4ZTZtUGowVWI2Q2x8M2kzdnBEeUIrUk5xOFI5TXZ3cHF3bFNQRkRJSGhUNGdrRFd0TlNtdE1OWT0=/OA==/)

[![fb-share-icon](/wp-content/plugins/ultimate-social-media-icons/images/visit_icons/fbshare_bck.png "Facebook Share")](https://www.facebook.com/sharer/sharer.php?u=https%3A%2F%2Fbelajarlinux.id%2F%3Fp%3D133%26ghostexport%3Dtrue%26submit%3DDownload+Ghost+File)

[![Tweet](/wp-content/plugins/ultimate-social-media-icons/images/visit_icons/en_US_Tweet.svg "Tweet")](https://twitter.com/intent/tweet?text=Cara+Menjalankan+Apache+dan+Nginx+Secara+Bersama+di+CentOS+8+https://belajarlinux.id/?p=133&ghostexport=true&submit=Download Ghost File)

[![fb-share-icon](/wp-content/plugins/ultimate-social-media-icons/images/share_icons/Pinterest_Save/en_US_save.svg "Pin Share")](#)

<!--kg-card-end: html-->
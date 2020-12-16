---
layout: post
title: Cara Membuat Server Block Nginx di CentOS 8
featured: true
date: '2020-08-21 08:39:44'
tags:
- centos
- nginx
---

Nginx saat ini menjadi salah satu pemilihan yang tepat bagi Anda yang ingin mencoba dan menggunakan web server dengan performa yang bagus, cepat dan handal tentunya.

Di Nginx terdapat server block. Apa itu _Server Block?._

Server Block merupakan metode yang dapat digunakan untuk menjalankan lebih dari satu domain atau sub domain pada sebuah web server.

Dengan server block ini Anda dapat meng hosting banyak domain atau bisa dibilang multi domain dalam 1 web server.

Disini kami akan berikan contoh cara membuat server block nginx dengan case menjalankan 2 sub domain diantaranya

1. Subdomain: block01.nurhamim.my.id
2. Subdomain: block02.nurhamim.my.id

Ke 2 subdomain diatas nantinya akan menampilkan simple page yang menggunakan html sebagai contohnya saja.

Sebelum membuat server block nginx, pastikan Anda sudah melakukan instalasi Nginx, Anda dapat mengikuti tutorial berikut: _[Cara Instalasi Nginx Di CentOS 8](/cara-instalasi-nginx-di-centos-8/)_ untuk instalasi Nginx di CentOS 8.

Secara default root web server nginx berada di _/usr/share/nginx/html_ untuk membuat server block sebenarnya bebas ingin dibuat di direktori mana saja sesuai kebutuhan.

Disini kami akan menyimpan file subdomain diatas di direktori _/usr/share/nginx/_ sebagai berikut

    [root@tutorial ~]# cd /usr/share/nginx/
    [root@tutorial nginx]#
    [root@tutorial nginx]# mkdir block01.nurhamim.my.id
    [root@tutorial nginx]# mkdir block02.nurhamim.my.id
    [root@tutorial nginx]#

Silakan membuat file html sederhana di dalam folder subdomain Anda masing – masing

    [root@tutorial nginx]#
    [root@tutorial nginx]# cd block01.nurhamim.my.id/
    [root@tutorial block01.nurhamim.my.id]#
    [root@tutorial block01.nurhamim.my.id]# vim index.html

Isi simple page html seperti berikut

    <!DOCTYPE html>
    <html lang="en" dir="ltr">
    <head>
    <meta charset="utf-8">
    <title>Server Block Nginx | BelajarLinux.ID</title>
    </head>
    <body>
    <h1>Test Page block01.nurhamim.my.id</h1>
    </body>
    </html>

Silakan disesuaikan untuk sub domain _block02.nurhamim.my.id_, jika sudah semua silakan atur owner dan permission direktori nya sebagai berikut

    [root@tutorial nginx]# chown -R nginx:nginx block01.nurhamim.my.id/
    [root@tutorial nginx]# chown -R nginx:nginx block02.nurhamim.my.id/
    [root@tutorial nginx]# chmod -R 755 block01.nurhamim.my.id/
    [root@tutorial nginx]# chmod -R 755 block02.nurhamim.my.id/

Selanjutnya membuat konfigurasi server block nya letak direktorinya berada di _/etc/nginx/conf.d_ disitu Anda dapat membuat banyak server block sesuai kebutuhan Anda.

    [root@tutorial nginx]# cd /etc/nginx/conf.d/
    [root@tutorial conf.d]#
    [root@tutorial conf.d]# vim block01.nurhamim.conf

Berikut sample konfigurasi server block nya

    server {
            listen 80; #Port Listen
            root /usr/share/nginx/block01.nurhamim.my.id; #Letak direktori website
            server_name block01.nurhamim.my.id; # Nama domain atau subdomain
    
            index index.html;
            access_log /var/log/nginx/block01.nurhamim-access.log; #Letak direktori Access Log
            error_log /var/log/nginx/block01.nurhamim-error.log; #Letak direktori Error Log
    
            location / {
            try_files $uri $uri/ =404;
            }
    }

Silakan ulangi dan sesuaikan untuk subdomain _block02.nurhamim.my.id_

Jika sudah semua silakan reload nginx. Kenapa tidak di restart?

Perbedaan restart dengan reload di nginx sebagai berikut

_ **Reload Nginx:** _ Jika di reload maka tidak akan ada downtime pada web server kare web server akan memperbaharui perubahannya saja.

**_Restart Nginx:_** Jika di restart, setiap melakukan perubahan konfigurasi nginx akan downtime.

Dengan demikian sebelum melakukan reload atau restart nginx pastikan tidak ada mis atau kesalahan konfigurasi di nginx dengan cara menjalankan perintah berikut

    [root@tutorial conf.d]# nginx -t
    nginx: the configuration file /etc/nginx/nginx.conf syntax is ok
    nginx: configuration file /etc/nginx/nginx.conf test is successful
    [root@tutorial conf.d]#

Jika hasilnya seperti diatas maka nginx sudah dapat di reload

    [root@tutorial conf.d]# nginx -s reload
    [root@tutorial conf.d]#

Silakan akses ke 2 sub domain Anda, pastikan subdomainnya sudah diarahkan A record ke IP VM atau VPS nya, contoh membuat A record pada sub domain

<figure class="wp-block-image size-large"><img loading="lazy" width="1024" height="240" src="/content/images/wordpress/2020/08/image-19-1024x240.png" alt="" class="wp-image-98" srcset="/content/images/wordpress/2020/08/image-19-1024x240.png 1024w, /content/images/wordpress/2020/08/image-19-300x70.png 300w, /content/images/wordpress/2020/08/image-19-768x180.png 768w, /content/images/wordpress/2020/08/image-19.png 1035w" sizes="(max-width: 1024px) 100vw, 1024px"></figure>

Verifikasi subdomain telah diarahkan ke IP Public VM atau VPS Anda bisa menggunakan ping

<figure class="wp-block-image size-large"><img loading="lazy" width="838" height="225" src="/content/images/wordpress/2020/08/image-20.png" alt="" class="wp-image-99" srcset="/content/images/wordpress/2020/08/image-20.png 838w, /content/images/wordpress/2020/08/image-20-300x81.png 300w, /content/images/wordpress/2020/08/image-20-768x206.png 768w" sizes="(max-width: 838px) 100vw, 838px"></figure>

Jika sudah reply berarti subdomain sudah mengarah, silakan akses di browser pastikan hasilnya seperti berikut ini

- **Subdomain: block01.nurhamim.my.id**
<figure class="wp-block-image size-large"><img loading="lazy" width="1024" height="210" src="/content/images/wordpress/2020/08/image-21-1024x210.png" alt="" class="wp-image-100" srcset="/content/images/wordpress/2020/08/image-21-1024x210.png 1024w, /content/images/wordpress/2020/08/image-21-300x62.png 300w, /content/images/wordpress/2020/08/image-21-768x158.png 768w, /content/images/wordpress/2020/08/image-21.png 1363w" sizes="(max-width: 1024px) 100vw, 1024px"></figure>
- **Subdomain: block02.nurhamim.my.id**
<figure class="wp-block-image size-large"><img loading="lazy" width="1024" height="197" src="/content/images/wordpress/2020/08/image-22-1024x197.png" alt="" class="wp-image-101" srcset="/content/images/wordpress/2020/08/image-22-1024x197.png 1024w, /content/images/wordpress/2020/08/image-22-300x58.png 300w, /content/images/wordpress/2020/08/image-22-768x148.png 768w, /content/images/wordpress/2020/08/image-22.png 1366w" sizes="(max-width: 1024px) 100vw, 1024px"></figure>

Saat ini server block Anda sudah berjalan.

Selamat mencoba 😄

Please follow and like us:

[![error](/wp-content/plugins/ultimate-social-media-icons/images/follow_subscribe.png)](https://api.follow.it/widgets/icon/VHc3d1lpVGdwRnE5QnV0eERCNUx5RCtvTTVoUkNYS3NNRmd5eVhlQW9tNXRHS3VTbGh6Y0NybkRJRS8zSGpjRDVZb1ZGMlNTSEpJYUpuZzZqNzdnd3VSN3dwM2VlQTF6ejJEaGV5UGRUbnlEcHFNd3luYTV4ZTZtUGowVWI2Q2x8M2kzdnBEeUIrUk5xOFI5TXZ3cHF3bFNQRkRJSGhUNGdrRFd0TlNtdE1OWT0=/OA==/)

[![fb-share-icon](/wp-content/plugins/ultimate-social-media-icons/images/visit_icons/fbshare_bck.png "Facebook Share")](https://www.facebook.com/sharer/sharer.php?u=https%3A%2F%2Fbelajarlinux.id%2F%3Fp%3D96%26ghostexport%3Dtrue%26submit%3DDownload+Ghost+File)

[![Tweet](/wp-content/plugins/ultimate-social-media-icons/images/visit_icons/en_US_Tweet.svg "Tweet")](https://twitter.com/intent/tweet?text=Cara+Membuat+Server+Block+Nginx+di+CentOS+8+https://belajarlinux.id/?p=96&ghostexport=true&submit=Download Ghost File)

[![fb-share-icon](/wp-content/plugins/ultimate-social-media-icons/images/share_icons/Pinterest_Save/en_US_save.svg "Pin Share")](#)

<!--kg-card-end: html-->
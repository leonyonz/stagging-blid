---
layout: post
title: Cara Enable Gzip Compression pada Nginx di CentOS 8
featured: true
date: '2020-08-27 13:17:49'
tags:
- centos
- linux
- nginx
---

Gzip compression salah satu cara yang dapat kita gunakan untuk mengoptimalisasi website dynamic ataupun static.

Misalnya Anda menggunakan CMS WordPress untuk kebutuhan website Anda tentunya di CMS WordPress banyak sekali file – file html, css, javascript baik dari themes dan plugin dari CMS WordPress itu sendiri.

Dengan begitu akses ke sisi CMS WordPress kita akan membutuhkan waktu dan bandwith yang lebih besar oleh karena itu gzip ada sebagai solusinya.

Fungsi gzip sendiri yaitu mengecilkan ukuran file yang akan ditransfer, dengan kecilnya ukuran file maka berdampak pada semakin cepatnya waktu loading website serta hemat bandwith. Seperti meng-compress file biasa menjadi file zip.

Disini kami akan mencontohkannya pada website yang menggunakan CMS WordPress, jika Anda ingin melihat cara instalasi WordPress di Nginx dapat merujuk pada link berikut: _**[Cara Instalasi WordPress menggunakan Nginx di CentOS 8](/cara-instalasi-wordpress-menggunakan-nginx-di-centos-8/)**_

Berikut URL website yang akan dijadikan sebagai contoh: https://wordpress.nurhamim.my.id/ jika di curl, saat ini website tidak memiliki gzip

<figure class="wp-block-image size-large"><img loading="lazy" width="1008" height="292" src="/content/images/wordpress/2020/08/image-97.png" alt="" class="wp-image-345" srcset="/content/images/wordpress/2020/08/image-97.png 1008w, /content/images/wordpress/2020/08/image-97-300x87.png 300w, /content/images/wordpress/2020/08/image-97-768x222.png 768w" sizes="(max-width: 1008px) 100vw, 1008px"></figure>

Lalu, untuk aktivasi gzip di Nginx sangatlah mudah Anda hanya perlu menambahkan beberapa script berikut ke dalam server block Nginx WordPress Anda contohnya:

    [root@tutorial ~]#
    [root@tutorial ~]# vim /etc/nginx/conf.d/wordpress.conf

Tambahkan beberapa script gzip berikut

    gzip on;
    gzip_comp_level 5;
    gzip_min_length 256;
    gzip_proxied any;
    gzip_vary on;
    gzip_types
       	application/atom+xml
        	application/javascript
    	application/json
        	application/ld+json
        	application/manifest+json
        	application/rss+xml
       	application/vnd.geo+json
        	application/vnd.ms-fontobject
        	application/x-font-ttf
        	application/x-web-app-manifest+json
        	application/xhtml+xml
        	application/xml
        	font/opentype
        	image/bmp
       	image/svg+xml
        	image/x-icon
        	text/cache-manifest
        	text/css
       	text/plain
        	text/vcard
        	text/vnd.rim.location.xloc
        	text/vtt
        	text/x-component
        	text/x-cross-domain-policy;

Berikut full konfigurasi server block Nginx nya

    server {
            listen 80;
            listen 443 ssl http2;
            server_name wordpress.nurhamim.my.id;
            root /usr/share/nginx/wordpress;
    
            index index.php index.html index.htm;
    
            ssl_certificate /etc/letsencrypt/live/wordpress.nurhamim.my.id/fullchain.pem;
            ssl_certificate_key /etc/letsencrypt/live/wordpress.nurhamim.my.id/privkey.pem;
            ssl_trusted_certificate /etc/letsencrypt/live/wordpress.nurhamim.my.id/chain.pem;
            include snippets/ssl.conf;
            include snippets/letsencrypt.conf;
    
            gzip on;
            gzip_comp_level 5;
            gzip_min_length 256;
            gzip_proxied any;
            gzip_vary on;
            gzip_types
                    application/atom+xml
                    application/javascript
                    application/json
                    application/ld+json
                    application/manifest+json
                    application/rss+xml
                    application/vnd.geo+json
                    application/vnd.ms-fontobject
                    application/x-font-ttf
                    application/x-web-app-manifest+json
                    application/xhtml+xml
                    application/xml
                    font/opentype
                    image/bmp
                    image/svg+xml
                    image/x-icon
                    text/cache-manifest
                    text/css
                    text/plain
                    text/vcard
                    text/vnd.rim.location.xloc
                    text/vtt
                    text/x-component
                    text/x-cross-domain-policy;
    
    
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

Sebagai tambahan informasi server block di Atas sudah di sertai konfigurasi SSL dari Letsencrypt yang dapat Anda lihat cara nya pada tutorial berikut: [**_Cara Instalasi SSL Letsencrypt pada WordPress Menggunakan Nginx di CentOS 8_**](/cara-instalasi-ssl-letsencrypt-pada-wordpress-menggunakan-nginx-di-centos-8/)

Selanjutnya pastikan tidak ada konfigurasi yang salah di Nginx dan silakan reload nginx

    [root@tutorial ~]#
    [root@tutorial ~]# nginx -t
    nginx: the configuration file /etc/nginx/nginx.conf syntax is ok
    nginx: configuration file /etc/nginx/nginx.conf test is successful
    [root@tutorial ~]#
    [root@tutorial ~]# nginx -s reload
    [root@tutorial ~]#

Silakan dicoba kembali curl seperti diawah seharusnya akan tampil gzip seperti berikut ini

<figure class="wp-block-image size-large"><img loading="lazy" width="940" height="562" src="/content/images/wordpress/2020/08/image-98.png" alt="" class="wp-image-346" srcset="/content/images/wordpress/2020/08/image-98.png 940w, /content/images/wordpress/2020/08/image-98-300x179.png 300w, /content/images/wordpress/2020/08/image-98-768x459.png 768w" sizes="(max-width: 940px) 100vw, 940px"></figure>

Jika di cek menggunakan tools gzip online berikut: https://varvy.com/tools/gzip/ hasilnya akan seperti berikut ini

<figure class="wp-block-image size-large"><img loading="lazy" width="1024" height="365" src="/content/images/wordpress/2020/08/image-99-1024x365.png" alt="" class="wp-image-347" srcset="/content/images/wordpress/2020/08/image-99-1024x365.png 1024w, /content/images/wordpress/2020/08/image-99-300x107.png 300w, /content/images/wordpress/2020/08/image-99-768x273.png 768w, /content/images/wordpress/2020/08/image-99.png 1236w" sizes="(max-width: 1024px) 100vw, 1024px"></figure>

Dari data diatas dapat di lihat terbanyak file original sebesar _26150 (uncomppressed gzip)_ dan di compressed menggunakan gzip menjadi _703_5.

Saat ini Anda sudah enable gzip di Nginx.

Selamat mencoba 😁

Please follow and like us:

[![error](/wp-content/plugins/ultimate-social-media-icons/images/follow_subscribe.png)](https://api.follow.it/widgets/icon/VHc3d1lpVGdwRnE5QnV0eERCNUx5RCtvTTVoUkNYS3NNRmd5eVhlQW9tNXRHS3VTbGh6Y0NybkRJRS8zSGpjRDVZb1ZGMlNTSEpJYUpuZzZqNzdnd3VSN3dwM2VlQTF6ejJEaGV5UGRUbnlEcHFNd3luYTV4ZTZtUGowVWI2Q2x8M2kzdnBEeUIrUk5xOFI5TXZ3cHF3bFNQRkRJSGhUNGdrRFd0TlNtdE1OWT0=/OA==/)

[![fb-share-icon](/wp-content/plugins/ultimate-social-media-icons/images/visit_icons/fbshare_bck.png "Facebook Share")](https://www.facebook.com/sharer/sharer.php?u=https%3A%2F%2Fbelajarlinux.id%2F%3Fp%3D342%26ghostexport%3Dtrue%26submit%3DDownload+Ghost+File)

[![Tweet](/wp-content/plugins/ultimate-social-media-icons/images/visit_icons/en_US_Tweet.svg "Tweet")](https://twitter.com/intent/tweet?text=Cara+Enable+Gzip+Compression+pada+Nginx+di+CentOS+8+https://belajarlinux.id/?p=342&ghostexport=true&submit=Download Ghost File)

[![fb-share-icon](/wp-content/plugins/ultimate-social-media-icons/images/share_icons/Pinterest_Save/en_US_save.svg "Pin Share")](#)

<!--kg-card-end: html-->
---
layout: post
title: Cara Instalasi SSL Letsencrypt pada WordPress Menggunakan Nginx di CentOS 8
featured: true
date: '2020-08-26 15:19:21'
tags:
- centos
- ssl
---

Tutorial kali ini hampir sama dengan tutorial sebelum terkait instalasi SSL free di Laravel dimana Anda perlu install terlebih dahulu certbot dan membuat konfigurasi SSL yang akan disimpan di direktori _snippets_ sebagai berikut

Instalasi certbot

    [root@tutorial ~]#
    [root@tutorial ~]# wget -P /usr/local/bin https://dl.eff.org/certbot-auto

Memberikan hak akses execute pada certbot

    [root@tutorial ~]#
    [root@tutorial ~]# chmod +x /usr/local/bin/certbot-auto

Generate OpenSSL

    [root@tutorial ~]#
    [root@tutorial ~]# openssl dhparam -out /etc/ssl/certs/dhparam.pem 2048

Membuat direktori letsencypt dan juga berikan akses nya

    [root@tutorial ~]# mkdir -p /var/lib/letsencrypt/.well-known
    [root@tutorial ~]# chgrp nginx /var/lib/letsencrypt
    [root@tutorial ~]# chmod g+s /var/lib/letsencrypt
    [root@tutorial ~]# chmod g+s /var/lib/letsencrypt
    [root@tutorial ~]#
    [root@tutorial ~]# mkdir /etc/nginx/snippets

Membuat direktori _snippets_ yang akan digunakan untuk menyimpan _configuration SSL_ nya

    [root@tutorial ~]#
    [root@tutorial ~]# mkdir /etc/nginx/snippets

Konfigurasi file letsencypt untuk kebutuhan verifikasi

    [root@tutorial ~]# vim /etc/nginx/snippets/letsencrypt.conf

Berikut isi konfigurasinya

    location ^~ /.well-known/acme-challenge/ {
      allow all;
      root /var/lib/letsencrypt/;
      default_type "text/plain";
      try_files $uri =404;
    }

Membuat file konfigurasi ssl letsencypt

    [root@tutorial ~]# vim /etc/nginx/snippets/ssl.conf

Berikut isi konfigurasi ssl nya, pada file ini Anda dapat mengubah atau menyesuaikan sesuai keinginan sepertihalnya header, protokol etc untuk SSL Anda.

    ssl_dhparam /etc/ssl/certs/dhparam.pem;
    
    ssl_session_timeout 1d;
    ssl_session_cache shared:SSL:10m;
    ssl_session_tickets off;
    
    ssl_protocols TLSv1.2 TLSv1.3;
    ssl_ciphers ECDHE-ECDSA-AES128-GCM-SHA256:ECDHE-RSA-AES128-GCM-SHA256:ECDHE-ECDSA-AES256-GCM-SHA384:ECDHE-RSA-AES256-GCM-SHA384:ECDHE-ECDSA-CHACHA20-POLY1305:ECDHE-RSA-CHACHA20-POLY1305:DHE-RSA-AES128-GCM-SHA256:DHE-RSA-AES256-GCM-SHA384;
    ssl_prefer_server_ciphers off;
    
    ssl_stapling on;
    ssl_stapling_verify on;
    resolver 8.8.8.8 8.8.4.4 valid=300s;
    resolver_timeout 30s;
    
    add_header Strict-Transport-Security "max-age=63072000" always;
    add_header X-Frame-Options SAMEORIGIN;
    add_header X-Content-Type-Options nosniff;

Edit dan tambahkan _file snippets_ di server block Anda

    [root@tutorial ~]#
    [root@tutorial ~]# vim /etc/nginx/conf.d/wordpress.conf

Seperti berikut ini

    server {
      listen 80;
      server_name laravel.nurhamim.my.id;
    
      include snippets/letsencrypt.conf;
    }

Jika sudah reload Nginx

    [root@tutorial ~]#
    [root@tutorial ~]# systemctl reload nginx

Jalankan satu baris perintah berikut untuk mendapatkan SSL letsencypt

    [root@tutorial ~]# /usr/local/bin/certbot-auto certonly --agree-tos --email me@nurhamim.my.id --webroot -w /var/lib/letsencrypt/ -d wordpress.nurhamim.my.id
    Saving debug log to /var/log/letsencrypt/letsencrypt.log
    Plugins selected: Authenticator webroot, Installer None
    Obtaining a new certificate
    Performing the following challenges:
    http-01 challenge for wordpress.nurhamim.my.id
    Using the webroot path /var/lib/letsencrypt for all unmatched domains.
    Waiting for verification...
    Cleaning up challenges
    
    IMPORTANT NOTES:
     - Congratulations! Your certificate and chain have been saved at:
       /etc/letsencrypt/live/wordpress.nurhamim.my.id/fullchain.pem
       Your key file has been saved at:
       /etc/letsencrypt/live/wordpress.nurhamim.my.id/privkey.pem
       Your cert will expire on 2020-11-24. To obtain a new or tweaked
       version of this certificate in the future, simply run certbot-auto
       again. To non-interactively renew *all* of your certificates, run
       "certbot-auto renew"
     - If you like Certbot, please consider supporting our work by:
    
       Donating to ISRG / Let's Encrypt: https://letsencrypt.org/donate
       Donating to EFF: https://eff.org/donate-le
    
    [root@tutorial ~]#

_Noted: Ubah email dan sub domain atau domain Anda_

Letak file CRT, KEY CA berada di _/etc/letsencrypt/live_

    [root@tutorial ~]#
    [root@tutorial ~]# cd /etc/letsencrypt/live/
    [root@tutorial live]# ls -lah
    total 4.0K
    drwx------ 4 root root 82 Aug 26 07:25 .
    drwxr-xr-x 9 root root 108 Aug 26 07:25 ..
    -rw-r--r-- 1 root root 740 Aug 26 06:32 README
    drwxr-xr-x 2 root root 93 Aug 26 06:32 laravel.nurhamim.my.id
    drwxr-xr-x 2 root root 93 Aug 26 07:25 wordpress.nurhamim.my.id
    [root@tutorial live]#

Selanjutnya menambahkan konfigurasi SSL di server block

    [root@tutorial ~]#
    [root@tutorial ~]# vim /etc/nginx/conf.d/wordpress.conf

Ubah dan edit server block menjadi seperti berikut:

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

Pastikan konfigurasi nginx Anda benar

    [root@tutorial live]# nginx -t
    nginx: the configuration file /etc/nginx/nginx.conf syntax is ok
    nginx: configuration file /etc/nginx/nginx.conf test is successful
    [root@tutorial live]#

Jika sudah silakan reload Nginx dan php-fpm

    [root@tutorial ~]#
    [root@tutorial ~]# systemctl reload nginx
    [root@tutorial ~]# systemctl reload php-fpm

Pastikan port 443 (HTTPS) listen

    [root@tutorial ~]# netstat -tulpn |grep nginx
    tcp 0 0 0.0.0.0:80 0.0.0.0:* LISTEN 74743/nginx: master
    tcp 0 0 0.0.0.0:443 0.0.0.0:* LISTEN 74743/nginx: master
    tcp6 0 0 :::80 :::* LISTEN 74743/nginx: master
    [root@tutorial ~]#

Pastikan Anda menambahkan firewall juga di sisi VM. Disini kami menggunakan openstack dengan begitu untuk firewall dapat diallow di security group, silakan disesuaikan di sisi Anda.

<figure class="wp-block-image size-large"><img loading="lazy" width="1024" height="45" src="/content/images/wordpress/2020/08/image-87-1024x45.png" alt="" class="wp-image-325" srcset="/content/images/wordpress/2020/08/image-87-1024x45.png 1024w, /content/images/wordpress/2020/08/image-87-300x13.png 300w, /content/images/wordpress/2020/08/image-87-768x34.png 768w, /content/images/wordpress/2020/08/image-87.png 1131w" sizes="(max-width: 1024px) 100vw, 1024px"></figure>

Akses URL wordpress Anda dari browser, hasilnya akan seperti berikut ini

<figure class="wp-block-image size-large"><img loading="lazy" width="1024" height="404" src="/content/images/wordpress/2020/08/image-88-1024x404.png" alt="" class="wp-image-326" srcset="/content/images/wordpress/2020/08/image-88-1024x404.png 1024w, /content/images/wordpress/2020/08/image-88-300x118.png 300w, /content/images/wordpress/2020/08/image-88-768x303.png 768w, /content/images/wordpress/2020/08/image-88.png 1352w" sizes="(max-width: 1024px) 100vw, 1024px"></figure>

Untuk test score SSL dapat menggunakan **[SSLLAB](https://www.ssllabs.com/ssltes)**, berikut hasilnya

<figure class="wp-block-image size-large"><img loading="lazy" width="855" height="492" src="/content/images/wordpress/2020/08/image-89.png" alt="" class="wp-image-327" srcset="/content/images/wordpress/2020/08/image-89.png 855w, /content/images/wordpress/2020/08/image-89-300x173.png 300w, /content/images/wordpress/2020/08/image-89-768x442.png 768w" sizes="(max-width: 855px) 100vw, 855px"></figure>

Selamat SSL Letsencypt WordPress Anda sudah terinstall.

Selamat mencoba 😁

Please follow and like us:

[![error](/wp-content/plugins/ultimate-social-media-icons/images/follow_subscribe.png)](https://api.follow.it/widgets/icon/VHc3d1lpVGdwRnE5QnV0eERCNUx5RCtvTTVoUkNYS3NNRmd5eVhlQW9tNXRHS3VTbGh6Y0NybkRJRS8zSGpjRDVZb1ZGMlNTSEpJYUpuZzZqNzdnd3VSN3dwM2VlQTF6ejJEaGV5UGRUbnlEcHFNd3luYTV4ZTZtUGowVWI2Q2x8M2kzdnBEeUIrUk5xOFI5TXZ3cHF3bFNQRkRJSGhUNGdrRFd0TlNtdE1OWT0=/OA==/)

[![fb-share-icon](/wp-content/plugins/ultimate-social-media-icons/images/visit_icons/fbshare_bck.png "Facebook Share")](https://www.facebook.com/sharer/sharer.php?u=https%3A%2F%2Fbelajarlinux.id%2F%3Fp%3D324%26ghostexport%3Dtrue%26submit%3DDownload+Ghost+File)

[![Tweet](/wp-content/plugins/ultimate-social-media-icons/images/visit_icons/en_US_Tweet.svg "Tweet")](https://twitter.com/intent/tweet?text=Cara+Instalasi+SSL+Letsencrypt+pada+WordPress+Menggunakan+Nginx+di+CentOS+8+https://belajarlinux.id/?p=324&ghostexport=true&submit=Download Ghost File)

[![fb-share-icon](/wp-content/plugins/ultimate-social-media-icons/images/share_icons/Pinterest_Save/en_US_save.svg "Pin Share")](#)

<!--kg-card-end: html-->
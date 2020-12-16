---
layout: post
title: Komunikasi Nginx dan PHP-FPM Menggunakan Unix atau TCP/IP Socket
featured: true
date: '2020-08-24 14:12:15'
tags:
- centos
- nginx
- php
---

Seperti yang sudah dibahas pada tutorial – tutorial sebelumnya, web server Nginx dapat digunakan sebagai reverse proxy dan Nginx dapat melayani aplikasi PHP melalui protokol FastCGI (sebagai server backend).

Terdapat 2 cara komunikasi antara Nginx dengan PHP-FPM diantaranya

1. Menggunakan Unix Socket
2. Menggunakan TCP/IP

Secara default di CentOS 8 jika dilihat konfigurasi default PHP-FPM listen menggunakana Unix Socket

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

Lalu apa bedanya Unix socket dengan TCP/IP?.

Berikut perbedannya.

- Unix Socket

> _Jika menggunakan unix socket komunikasi Nginx ke PHP-FPM menggunakan 1 file yang sama (nginx.sock). Jika Anda menggunakan unix socket, maka dari segi proses kecepatan performa sangat baik, namun perlu diperhatikan juga resource IO dan CPU serta Memory nya semakin banyak beban server maka proses nya juga akan menurun_. _Perlu di garis bawahi unix socket tidak fleksibel misalnya Anda mempunyai website belajarlinux.id di CentOS menggunakan unix socket dan Anda migrate belajarlinux.id ke OS Ubuntu, tentunya Anda perlu melakukan perubahan konfigurasi karena antara OS Ubuntu dan CentOS berbeda._

- TCP/IP

> _Jika menggunakan TCP/IP maka komunikasi Nginx ke PHP-FPM menggunakan Network Address (alamat IP) walaupun dalam localhost (127.0.0.1), lalu dari segi portabilitas TCP/IP socket sangat bagus karena jika kita ingin memindahkan website ke server yang baru kita hanya permu menyesuaikan alamat IP nya saja tanpa perlu mengubah konfigurasi yang lainnya._ _Dengan menggunakan TCP/IP dari segi proses sangat cocok bagi Anda yang tidak terlalu membutuhkan performance yang cepat namun stabil dalam menghandle ribuan request terlebih server Anda standalone (1 server saja)._

Kesimpulannya adalah jika menggunakan unix socket tidak sama dengan menggunakan socket TCP/IP terkait kinerja, beberapa pengujian dan tolok ukur telah membuktikan unix socket lebih cepat. Kelemahan utama dari unix socket adalah dari segi fleksibilitas karena Anda perlu memindahkan file (.sock) dari server lama ke server baru jika misalnya melakukan migrasi website ke OS yang berbeda, website tersebut masih bisa diakses oleh OS apapun dengan syarat OS tersebut sudah support socket.

Selanjutya kita akan mencoba konfigurasi nginx supaya dapat terhubung dengan php-fpm baik menggunakan Unix socket ataupun TCP/IP socket.

### # Menggunakan Unix Socket

Pertama Anda perlu konfigurasi php-fpm terlebih dahulu, seperti yang sudah disampaikan diawal default konfigurasi php-fpm CentOS 8 berada di _/etc/php-fpm.d/www.conf_ contohnya sebagai berikut

<figure class="wp-block-image size-large"><img loading="lazy" width="828" height="242" src="/content/images/wordpress/2020/08/image-56.png" alt="" class="wp-image-204" srcset="/content/images/wordpress/2020/08/image-56.png 828w, /content/images/wordpress/2020/08/image-56-300x88.png 300w, /content/images/wordpress/2020/08/image-56-768x224.png 768w" sizes="(max-width: 828px) 100vw, 828px"></figure>

Kemudian, atur listener owner dan group php-fpm menjadi nginx seperti berikut

<figure class="wp-block-image size-large"><img loading="lazy" width="807" height="146" src="/content/images/wordpress/2020/08/image-57.png" alt="" class="wp-image-205" srcset="/content/images/wordpress/2020/08/image-57.png 807w, /content/images/wordpress/2020/08/image-57-300x54.png 300w, /content/images/wordpress/2020/08/image-57-768x139.png 768w" sizes="(max-width: 807px) 100vw, 807px"></figure>

Jika sudah selanjutnya Anda perlu mengatur server block nginx menggunakan unix socket konfigurasinya seperti berikut

    fastcgi_pass unix:/run/php-fpm/www.sock;

Detail server block nya seperti berikut

    server {
            listen 80;
            server_name unix-socket.nurhamim.my.id;
            root /var/www/belajarlinux;
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

Dari kode diatas perhatikan bagian _location ~ \.php { ._

### # Menggunakan TCP/IP Socket

Sama halnya dengan unix socket pertama kita perlu menambahkan listen IP yang kita inginkan terlebih dahulu contohnya seperti berikut

<figure class="wp-block-image size-large"><img loading="lazy" width="860" height="246" src="/content/images/wordpress/2020/08/image-58.png" alt="" class="wp-image-206" srcset="/content/images/wordpress/2020/08/image-58.png 860w, /content/images/wordpress/2020/08/image-58-300x86.png 300w, /content/images/wordpress/2020/08/image-58-768x220.png 768w" sizes="(max-width: 860px) 100vw, 860px"></figure>

_Noted: Pengalamatan IP Address dapat disesuaikan dengan keinginan Anda_

Selanjutnya sesuaikan server block Nginx, Anda hanya perlu mengubah _fastcgi\_pass_ nya saja dari

    fastcgi_pass unix:/run/php-fpm/www.sock;

ke

    fastcgi_pass 127.0.0.3:9001;

Berikut full server block nya

    server {
            listen 80;
            server_name unix-socket.nurhamim.my.id;
            root /var/www/belajarlinux;
            index index.php index.html index.htm;
    
            location / {
                    try_files $uri $uri/ /index.php?$query_string;
            }
    
            location ~ \.php {
                    include fastcgi.conf;
                    fastcgi_split_path_info ^(.+\.php)(/.+)$;
                    #fastcgi_pass unix:/run/php-fpm/www.sock;
                    fastcgi_pass 127.0.0.3:9001;
            }
            location ~ /\.ht {
                    deny all;
            }
    }

Jika sudah bisa di simpan dan pastikan tidak ada miss atau kesalahan konfigurasi gunakan perintah _nginx -t_

    [root@tutorial conf.d]#
    [root@tutorial conf.d]# nginx -t
    nginx: the configuration file /etc/nginx/nginx.conf syntax is ok
    nginx: configuration file /etc/nginx/nginx.conf test is successful
    [root@tutorial conf.d]#

Lalu reload php-fpm dan nginx Anda

    [root@tutorial conf.d]#
    [root@tutorial conf.d]# systemctl reload nginx
    [root@tutorial conf.d]# systemctl reload php-fpm
    [root@tutorial conf.d]#

Pastikan status php-fpm dan nginx running

    [root@tutorial conf.d]# systemctl status php-fpm; systemctl status nginx
    ● php-fpm.service - The PHP FastCGI Process Manager
       Loaded: loaded (/usr/lib/systemd/system/php-fpm.service; enabled; vendor preset: disabled)
       Active: active (running) since Mon 2020-08-24 07:10:20 UTC; 12s ago
      Process: 24712 ExecReload=/bin/kill -USR2 $MAINPID (code=exited, status=0/SUCCESS)
     Main PID: 24680 (php-fpm)
       Status: "Ready to handle connections"
        Tasks: 6 (limit: 23813)
       Memory: 24.7M
       CGroup: /system.slice/php-fpm.service
               ├─24680 php-fpm: master process (/etc/php-fpm.conf)
               ├─24720 php-fpm: pool www
               ├─24721 php-fpm: pool www
               ├─24722 php-fpm: pool www
               ├─24723 php-fpm: pool www
               └─24724 php-fpm: pool www
    
    Aug 24 07:10:20 tutorial.nurhamim.my.id systemd[1]: Starting The PHP FastCGI Process Manager...
    Aug 24 07:10:20 tutorial.nurhamim.my.id systemd[1]: Started The PHP FastCGI Process Manager.
    Aug 24 07:10:30 tutorial.nurhamim.my.id systemd[1]: Reloading The PHP FastCGI Process Manager.
    Aug 24 07:10:30 tutorial.nurhamim.my.id systemd[1]: Reloaded The PHP FastCGI Process Manager.
    ● nginx.service - The nginx HTTP and reverse proxy server
       Loaded: loaded (/usr/lib/systemd/system/nginx.service; enabled; vendor preset: disabled)
      Drop-In: /usr/lib/systemd/system/nginx.service.d
               └─php-fpm.conf
       Active: active (running) since Mon 2020-08-24 07:10:20 UTC; 12s ago
      Process: 24715 ExecReload=/bin/kill -s HUP $MAINPID (code=exited, status=0/SUCCESS)
      Process: 24699 ExecStart=/usr/sbin/nginx (code=exited, status=0/SUCCESS)
      Process: 24697 ExecStartPre=/usr/sbin/nginx -t (code=exited, status=0/SUCCESS)
      Process: 24694 ExecStartPre=/usr/bin/rm -f /run/nginx.pid (code=exited, status=0/SUCCESS)
     Main PID: 24700 (nginx)
        Tasks: 5 (limit: 23813)
       Memory: 11.2M
       CGroup: /system.slice/nginx.service
               ├─24700 nginx: master process /usr/sbin/nginx
               ├─24716 nginx: worker process
               ├─24717 nginx: worker process
               ├─24718 nginx: worker process
               └─24719 nginx: worker process
    
    Aug 24 07:10:20 tutorial.nurhamim.my.id systemd[1]: Starting The nginx HTTP and reverse proxy server...
    Aug 24 07:10:20 tutorial.nurhamim.my.id nginx[24697]: nginx: the configuration file /etc/nginx/nginx.conf syntax is ok
    Aug 24 07:10:20 tutorial.nurhamim.my.id nginx[24697]: nginx: configuration file /etc/nginx/nginx.conf test is successful
    Aug 24 07:10:20 tutorial.nurhamim.my.id systemd[1]: Started The nginx HTTP and reverse proxy server.
    Aug 24 07:10:30 tutorial.nurhamim.my.id systemd[1]: Reloading The nginx HTTP and reverse proxy server.
    Aug 24 07:10:30 tutorial.nurhamim.my.id systemd[1]: Reloaded The nginx HTTP and reverse proxy server.
    [root@tutorial conf.d]#

Selamat mencoba 😁

Please follow and like us:

[![error](/wp-content/plugins/ultimate-social-media-icons/images/follow_subscribe.png)](https://api.follow.it/widgets/icon/VHc3d1lpVGdwRnE5QnV0eERCNUx5RCtvTTVoUkNYS3NNRmd5eVhlQW9tNXRHS3VTbGh6Y0NybkRJRS8zSGpjRDVZb1ZGMlNTSEpJYUpuZzZqNzdnd3VSN3dwM2VlQTF6ejJEaGV5UGRUbnlEcHFNd3luYTV4ZTZtUGowVWI2Q2x8M2kzdnBEeUIrUk5xOFI5TXZ3cHF3bFNQRkRJSGhUNGdrRFd0TlNtdE1OWT0=/OA==/)

[![fb-share-icon](/wp-content/plugins/ultimate-social-media-icons/images/visit_icons/fbshare_bck.png "Facebook Share")](https://www.facebook.com/sharer/sharer.php?u=https%3A%2F%2Fbelajarlinux.id%2F%3Fp%3D202%26ghostexport%3Dtrue%26submit%3DDownload+Ghost+File)

[![Tweet](/wp-content/plugins/ultimate-social-media-icons/images/visit_icons/en_US_Tweet.svg "Tweet")](https://twitter.com/intent/tweet?text=Komunikasi+Nginx+dan+PHP-FPM+Menggunakan+Unix+atau+TCP%2FIP+Socket+https://belajarlinux.id/?p=202&ghostexport=true&submit=Download Ghost File)

[![fb-share-icon](/wp-content/plugins/ultimate-social-media-icons/images/share_icons/Pinterest_Save/en_US_save.svg "Pin Share")](#)

<!--kg-card-end: html-->
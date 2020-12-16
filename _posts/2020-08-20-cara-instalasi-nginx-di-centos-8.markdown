---
layout: post
title: Cara Instalasi Nginx Di CentOS 8
featured: true
date: '2020-08-20 22:54:56'
tags:
- centos
- nginx
---

**[Nginx](https://www.nginx.com/)** adalah salah satu web server yang powerfull dan berbasis open source (bebas dan Free), dapat Anda gunakan untuk reverse proxy untuk mendukung web server apache serta dapat digunakan sebagai server proxy IMAP/POP3.

Web server Nginx terkenal karena performanya yang tinggi, stabil, memiliki banyak fitur, mudah dikonfigurasi, dan menggunakan hanya sedikit sumberdaya pada server. Nginx adalah salah satu dari sebagian kecil perangkat lunak untuk server yang diciptakan untuk mengatasi Problem **[C10K](https://en.wikipedia.org/wiki/C10k_problem)**.

Nginx juga salah satu web server yang dapat digunakan untuk website yang membutuhkan trafik dan beban yang tinggi.

## # Instalasi Nginx

Untuk memulai instalasi Nginx di CentOS 8 jalankan perintah berikut

    [root@tutorial ~]#
    [root@tutorial ~]# dnf install nginx -y

Enable Nginx dengan cara menjalankan perintah

    [root@tutorial ~]# systemctl enable nginx
    Created symlink /etc/systemd/system/multi-user.target.wants/nginx.service → /usr/lib/systemd/system/nginx.service.
    [root@tutorial ~]#

Silakan start Nginx dan pastikan statusnya running

    [root@tutorial ~]#
    [root@tutorial ~]# systemctl start nginx
    [root@tutorial ~]# systemctl status nginx
    ● nginx.service - The nginx HTTP and reverse proxy server
       Loaded: loaded (/usr/lib/systemd/system/nginx.service; enabled; vendor preset: disabled)
       Active: active (running) since Thu 2020-08-20 15:23:18 UTC; 5s ago
      Process: 7262 ExecStart=/usr/sbin/nginx (code=exited, status=0/SUCCESS)
      Process: 7260 ExecStartPre=/usr/sbin/nginx -t (code=exited, status=0/SUCCESS)
      Process: 7258 ExecStartPre=/usr/bin/rm -f /run/nginx.pid (code=exited, status=0/SUCCESS)
     Main PID: 7263 (nginx)
        Tasks: 5 (limit: 23539)
       Memory: 8.5M
       CGroup: /system.slice/nginx.service
               ├─7263 nginx: master process /usr/sbin/nginx
               ├─7264 nginx: worker process
               ├─7265 nginx: worker process
               ├─7266 nginx: worker process
               └─7267 nginx: worker process
    
    Aug 20 15:23:18 tutorial.nurhamim.my.id systemd[1]: Starting The nginx HTTP and reverse proxy server...
    Aug 20 15:23:18 tutorial.nurhamim.my.id nginx[7260]: nginx: the configuration file /etc/nginx/nginx.conf syntax is ok
    Aug 20 15:23:18 tutorial.nurhamim.my.id nginx[7260]: nginx: configuration file /etc/nginx/nginx.conf test is successful
    Aug 20 15:23:18 tutorial.nurhamim.my.id systemd[1]: Started The nginx HTTP and reverse proxy server.
    [root@tutorial ~]#

Jika sudah running Anda dapat akses IP VM atau domain yang sudah diarahkan ke IP VM Anda, hasilnya seperti berikut

<figure class="wp-block-image size-large"><img loading="lazy" width="1024" height="435" src="/content/images/wordpress/2020/08/image-16-1024x435.png" alt="" class="wp-image-89" srcset="/content/images/wordpress/2020/08/image-16-1024x435.png 1024w, /content/images/wordpress/2020/08/image-16-300x127.png 300w, /content/images/wordpress/2020/08/image-16-768x326.png 768w, /content/images/wordpress/2020/08/image-16.png 1365w" sizes="(max-width: 1024px) 100vw, 1024px"></figure>

Default direktori root nginx berada di _/usr/share/nginx/html_, untuk validasi apakah Anda dapat membuat file .html contohnya sebagai berikut

    [root@tutorial ~]# touch /usr/share/nginx/html/hi.html
    [root@tutorial ~]# vim /usr/share/nginx/html/hi.html

Isi file HTML sederhana contohnya

<figure class="wp-block-image size-large"><img loading="lazy" width="886" height="194" src="/content/images/wordpress/2020/08/image-17.png" alt="" class="wp-image-90" srcset="/content/images/wordpress/2020/08/image-17.png 886w, /content/images/wordpress/2020/08/image-17-300x66.png 300w, /content/images/wordpress/2020/08/image-17-768x168.png 768w" sizes="(max-width: 886px) 100vw, 886px"></figure>

Reload Nginx menggunakan perintah berikut

    [root@tutorial ~]# nginx -s reload
    [root@tutorial ~]#

Silakan akses IP\_VM/hi.html atau domain yang sudah diarahkan ke IP VM Anda contohnya

<figure class="wp-block-image size-large"><img loading="lazy" width="1024" height="160" src="/content/images/wordpress/2020/08/image-18-1024x160.png" alt="" class="wp-image-91" srcset="/content/images/wordpress/2020/08/image-18-1024x160.png 1024w, /content/images/wordpress/2020/08/image-18-300x47.png 300w, /content/images/wordpress/2020/08/image-18-768x120.png 768w, /content/images/wordpress/2020/08/image-18-1536x240.png 1536w, /content/images/wordpress/2020/08/image-18.png 1917w" sizes="(max-width: 1024px) 100vw, 1024px"></figure>

Saat ini instalasi Nginx sudah berjalan dengan normal.

Selamat mencoba 😄

Please follow and like us:

[![error](/wp-content/plugins/ultimate-social-media-icons/images/follow_subscribe.png)](https://api.follow.it/widgets/icon/VHc3d1lpVGdwRnE5QnV0eERCNUx5RCtvTTVoUkNYS3NNRmd5eVhlQW9tNXRHS3VTbGh6Y0NybkRJRS8zSGpjRDVZb1ZGMlNTSEpJYUpuZzZqNzdnd3VSN3dwM2VlQTF6ejJEaGV5UGRUbnlEcHFNd3luYTV4ZTZtUGowVWI2Q2x8M2kzdnBEeUIrUk5xOFI5TXZ3cHF3bFNQRkRJSGhUNGdrRFd0TlNtdE1OWT0=/OA==/)

[![fb-share-icon](/wp-content/plugins/ultimate-social-media-icons/images/visit_icons/fbshare_bck.png "Facebook Share")](https://www.facebook.com/sharer/sharer.php?u=https%3A%2F%2Fbelajarlinux.id%2F%3Fp%3D88%26ghostexport%3Dtrue%26submit%3DDownload+Ghost+File)

[![Tweet](/wp-content/plugins/ultimate-social-media-icons/images/visit_icons/en_US_Tweet.svg "Tweet")](https://twitter.com/intent/tweet?text=Cara+Instalasi+Nginx+Di+CentOS+8+https://belajarlinux.id/?p=88&ghostexport=true&submit=Download Ghost File)

[![fb-share-icon](/wp-content/plugins/ultimate-social-media-icons/images/share_icons/Pinterest_Save/en_US_save.svg "Pin Share")](#)

<!--kg-card-end: html-->
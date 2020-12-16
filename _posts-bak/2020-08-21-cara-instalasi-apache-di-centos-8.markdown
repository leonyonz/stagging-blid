---
layout: post
title: Cara Instalasi Apache di CentOS 8
featured: true
date: '2020-08-21 14:42:13'
tags:
- apache
- centos
---

Apache merupakan web server yang dapat dijalankan di berbagai macam sistem operasi yang berbeda seperti Unix, BSD, Linux, Windows dan Novell Netware yang bertugas untuk melayani fasilitas web dengan menggunakan protokol http ataupun https. Apache bersifat open source, yang artinya dapat digunakan secara bebas oleh semua pengguna atau kalangan.

Web server Apache akan bekerja jika pengguna atau user meminta atau request melalui protokol http atau https untuk membuka suatu halaman. Apache akan menjawab request yang diminta oleh pengguna kemudian akan diproses oleh Apache sampai menampilkan sebuah halaman yang diminta atau yang diminta.

Untuk instalasi Apache di CentOS 8 jalankan perintah berikut

    [root@tutorial ~]# dnf install httpd -y

Supaya apache dapat running secara otomatis pada saat VM atau VPS Anda reboot jalankan perintah berikut

    [root@tutorial ~]#
    [root@tutorial ~]# systemctl enable httpd
    Created symlink /etc/systemd/system/multi-user.target.wants/httpd.service → /usr/lib/systemd/system/httpd.service.
    [root@tutorial ~]#

Start dan pastikan service apache Anda running

    [root@tutorial ~]#
    [root@tutorial ~]# systemctl start httpd; systemctl status httpd
    ● httpd.service - The Apache HTTP Server
       Loaded: loaded (/usr/lib/systemd/system/httpd.service; enabled; vendor preset: disabled)
      Drop-In: /usr/lib/systemd/system/httpd.service.d
               └─php-fpm.conf
       Active: active (running) since Fri 2020-08-21 07:34:29 UTC; 16ms ago
         Docs: man:httpd.service(8)
     Main PID: 29397 (httpd)
       Status: "Configuration loaded."
        Tasks: 1 (limit: 23996)
       Memory: 3.4M
       CGroup: /system.slice/httpd.service
               └─29397 /usr/sbin/httpd -DFOREGROUND
    
    Aug 21 07:34:28 tutorial.nurhamim.my.id systemd[1]: Starting The Apache HTTP Server...
    Aug 21 07:34:29 tutorial.nurhamim.my.id systemd[1]: Started The Apache HTTP Server.
    [root@tutorial ~]#

Saat ini apache sudah running, untuk melihat versi apache gunakan perintah berikut:

    [root@tutorial ~]#
    [root@tutorial ~]# httpd -v
    Server version: Apache/2.4.37 (centos)
    Server built: Jun 8 2020 20:14:33
    [root@tutorial ~]#

Untuk memastikan apache sudah listen ke public 0.0.0.0/0 gunakan perintah netstat seperti berikut

    [root@tutorial ~]#
    [root@tutorial ~]# netstat -tulpn |grep 80
    tcp6 0 0 :::80 :::* LISTEN 29397/httpd
    [root@tutorial ~]#

Jika belum listen silakan di cek firewall Anda, disini kami menggunakan openstack sebagai virtualisasi untuk firewall di openstack dapat di lihat di horizon \>\> network \>\> security group.

Jika sudah silakan akses IP VM atau VPS atau domain yang sudah diarahkan ke IP Public VM atau VPS Anda, jika berhasil akan seperti berikut

<figure class="wp-block-image size-large"><img loading="lazy" width="1024" height="546" src="/content/images/wordpress/2020/08/image-24-1024x546.png" alt="" class="wp-image-120" srcset="/content/images/wordpress/2020/08/image-24-1024x546.png 1024w, /content/images/wordpress/2020/08/image-24-300x160.png 300w, /content/images/wordpress/2020/08/image-24-768x410.png 768w, /content/images/wordpress/2020/08/image-24.png 1365w" sizes="(max-width: 1024px) 100vw, 1024px"></figure>

Selamat mencoba 😁

Please follow and like us:

[![error](/wp-content/plugins/ultimate-social-media-icons/images/follow_subscribe.png)](https://api.follow.it/widgets/icon/VHc3d1lpVGdwRnE5QnV0eERCNUx5RCtvTTVoUkNYS3NNRmd5eVhlQW9tNXRHS3VTbGh6Y0NybkRJRS8zSGpjRDVZb1ZGMlNTSEpJYUpuZzZqNzdnd3VSN3dwM2VlQTF6ejJEaGV5UGRUbnlEcHFNd3luYTV4ZTZtUGowVWI2Q2x8M2kzdnBEeUIrUk5xOFI5TXZ3cHF3bFNQRkRJSGhUNGdrRFd0TlNtdE1OWT0=/OA==/)

[![fb-share-icon](/wp-content/plugins/ultimate-social-media-icons/images/visit_icons/fbshare_bck.png "Facebook Share")](https://www.facebook.com/sharer/sharer.php?u=https%3A%2F%2Fbelajarlinux.id%2F%3Fp%3D119%26ghostexport%3Dtrue%26submit%3DDownload+Ghost+File)

[![Tweet](/wp-content/plugins/ultimate-social-media-icons/images/visit_icons/en_US_Tweet.svg "Tweet")](https://twitter.com/intent/tweet?text=Cara+Instalasi+Apache+di+CentOS+8+https://belajarlinux.id/?p=119&ghostexport=true&submit=Download Ghost File)

[![fb-share-icon](/wp-content/plugins/ultimate-social-media-icons/images/share_icons/Pinterest_Save/en_US_save.svg "Pin Share")](#)

<!--kg-card-end: html-->
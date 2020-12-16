---
layout: post
title: Cara Mengubah Port Database MariaDB di CentOS 8
featured: true
date: '2020-08-23 11:17:48'
tags:
- centos
- database
---

Seperti yang kita ketahui bersama port database secara default berjalan di port 3306 jika kita allow remote akses ke public tentunya kita perlu ekspost port tersebut ke public dan hal ini sangat riskan dari segi security.

Dengan demikian jika Anda ingin allow remote connection database dari public Anda dapat mencoba custom atau ubah port database default Anda dari port 3306 ke 12345 contohnya.

Untuk mengikuti tutorial ini pastikan Anda sudah membaca tutorial berikut ya:

- **_[Cara Instalasi Database MariaDB di CentOS 8](/cara-instalasi-database-mariadb-di-centos-8/)_**
- **_[Cara Remote Database MariaDB di CentOS 8](/cara-remote-database-mariadb-di-centos-8/)_**

Saat ini database masih listen ke port 3306 sebagai berikut

    [root@tutorial ~]# netstat -ant | grep 3306
    tcp 0 0 0.0.0.0:3306 0.0.0.0:* LISTEN
    [root@tutorial ~]#

Untuk mengubah port database Anda hanya perlu menambahkan satu baris perintah simple di konfigurasi mariadb / mysql server Anda

    [root@tutorial ~]# vim /etc/my.cnf.d/mariadb-server.cnf

Tambahkan _port=12345_ dibawah _[mysqld]_

    # If you need to run mysqld under a different user or group,
    # customize your systemd unit file for mysqld/mariadb according to the
    # instructions in http://fedoraproject.org/wiki/Systemd
    [mysqld]
    port=12345
    datadir=/var/lib/mysql
    socket=/var/lib/mysql/mysql.sock
    log-error=/var/log/mariadb/mariadb.log
    pid-file=/run/mariadb/mariadb.pid

Jika sudah silakan restar mariadb / mysql Anda, dan pastikan juga di sisi firewall Anda sudah allow port 12345, disini VM kami berjalan di openstack dengan begitu untuk allow port dapat melalui security group

<figure class="wp-block-image size-large"><img loading="lazy" width="1024" height="46" src="/content/images/wordpress/2020/08/image-49-1024x46.png" alt="" class="wp-image-176" srcset="/content/images/wordpress/2020/08/image-49-1024x46.png 1024w, /content/images/wordpress/2020/08/image-49-300x13.png 300w, /content/images/wordpress/2020/08/image-49-768x34.png 768w, /content/images/wordpress/2020/08/image-49.png 1143w" sizes="(max-width: 1024px) 100vw, 1024px"></figure>

Pastikan port 12345 sudah listen ke _0.0.0.0_

    [root@tutorial ~]# netstat -tlpn | grep mysql
    tcp 0 0 0.0.0.0:12345 0.0.0.0:* LISTEN 14350/mysqld
    [root@tutorial ~]#

Jika sudah silakan coba akses database menggunakan port 12345, jika menggunakan teminal ubuntu Anda hanya perlu menambahkan _-P (Port)_ seperti berikut

    ubuntu@my-jumper:~$
    ubuntu@my-jumper:~$ mysql -u belajarlinux -h 103.89.7.26 -p -P 12345
    Enter password:
    Welcome to the MySQL monitor. Commands end with ; or \g.
    Your MySQL connection id is 8
    Server version: 5.5.5-10.3.17-MariaDB MariaDB Server
    
    Copyright (c) 2000, 2020, Oracle and/or its affiliates. All rights reserved.
    
    Oracle is a registered trademark of Oracle Corporation and/or its
    affiliates. Other names may be trademarks of their respective
    owners.
    
    Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.
    
    mysql>

Jika akses dari _Heidi SQL_ Anda hanya perlu menyesuaikan port nya saja, berikut konfigurasinya

<figure class="wp-block-image size-large"><img loading="lazy" width="865" height="413" src="/content/images/wordpress/2020/08/image-50.png" alt="" class="wp-image-177" srcset="/content/images/wordpress/2020/08/image-50.png 865w, /content/images/wordpress/2020/08/image-50-300x143.png 300w, /content/images/wordpress/2020/08/image-50-768x367.png 768w" sizes="(max-width: 865px) 100vw, 865px"></figure>

Jika berhasil berikut hasilnya

<figure class="wp-block-image size-large"><img loading="lazy" width="934" height="592" src="/content/images/wordpress/2020/08/image-51.png" alt="" class="wp-image-178" srcset="/content/images/wordpress/2020/08/image-51.png 934w, /content/images/wordpress/2020/08/image-51-300x190.png 300w, /content/images/wordpress/2020/08/image-51-768x487.png 768w" sizes="(max-width: 934px) 100vw, 934px"></figure>

Jika kita _ **nmap** _ port database kita tidak listen

    Starting Nmap 7.60 ( https://nmap.org ) at 2055-04-20 05:02 UTC
    Nmap scan report for 103.89.7.26
    Host is up (0.0021s latency).
    Not shown: 995 filtered ports
    PORT STATE SERVICE
    22/tcp open ssh
    53/tcp closed domain
    80/tcp open http
    8080/tcp open http-proxy
    12345/tcp open netbus
    
    Nmap done: 1 IP address (1 host up) scanned in 4.29 seconds
    ubuntu@my-jumper:~$

Selamat mencoba 😁

Please follow and like us:

[![error](/wp-content/plugins/ultimate-social-media-icons/images/follow_subscribe.png)](https://api.follow.it/widgets/icon/VHc3d1lpVGdwRnE5QnV0eERCNUx5RCtvTTVoUkNYS3NNRmd5eVhlQW9tNXRHS3VTbGh6Y0NybkRJRS8zSGpjRDVZb1ZGMlNTSEpJYUpuZzZqNzdnd3VSN3dwM2VlQTF6ejJEaGV5UGRUbnlEcHFNd3luYTV4ZTZtUGowVWI2Q2x8M2kzdnBEeUIrUk5xOFI5TXZ3cHF3bFNQRkRJSGhUNGdrRFd0TlNtdE1OWT0=/OA==/)

[![fb-share-icon](/wp-content/plugins/ultimate-social-media-icons/images/visit_icons/fbshare_bck.png "Facebook Share")](https://www.facebook.com/sharer/sharer.php?u=https%3A%2F%2Fbelajarlinux.id%2F%3Fp%3D175%26ghostexport%3Dtrue%26submit%3DDownload+Ghost+File)

[![Tweet](/wp-content/plugins/ultimate-social-media-icons/images/visit_icons/en_US_Tweet.svg "Tweet")](https://twitter.com/intent/tweet?text=Cara+Mengubah+Port+Database+MariaDB+di+CentOS+8+https://belajarlinux.id/?p=175&ghostexport=true&submit=Download Ghost File)

[![fb-share-icon](/wp-content/plugins/ultimate-social-media-icons/images/share_icons/Pinterest_Save/en_US_save.svg "Pin Share")](#)

<!--kg-card-end: html-->
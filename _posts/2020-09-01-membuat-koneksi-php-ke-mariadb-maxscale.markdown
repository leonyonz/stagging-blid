---
layout: post
title: Membuat Koneksi PHP ke MariaDB MaxScale
featured: true
date: '2020-09-01 21:24:52'
tags:
- centos
- cms
- database
- load-balancer
- php
---

Saat ini sangat banyak bahasa pemrograman yang dapat digunakan untuk membuat sebuah website statis ataupun dinamis dan salah satu pemrograman yang paling populer bahkan bisa dibilang bahas pemrograman yang paling banyak digunakan untuk membuat sebuah website yaitu bahasa pemoragraman PHP.

PHP singkatan dari Hypertext Preprocessor. PHP sebuah bahasa pemrograman server-side biasanya digunakan bersama dengan CSS dan HTML.

Untuk membuat sebuah website dinamis kita perlu yang namanya database, database disini yang berperan untuk menyimpan data atau query dari sebuah website.

Tutorial kali ini merupakan kelanjutan dari tutorial sebelumnya, kami sudah membangun database galera cluster dan sudah di proxy atau load balancing menggunakan MariaDB MaxScale.

Kali ini kita akan mencoba bagaimana cara menghubungkan website yang berbasis PHP misalnya CMS Joomla, WordPress dan yang lainnya ke proxy atau load balancing MariaDB MaxScale.

Oleh karena itu sebelum mengikuti tutorial ini pastikan Anda sudah mencoba dan membuat database nya terlebih dahulu seperti pada tutorial kami berikut: [**_Memanfaatkan MariaDB MaxScale Sebagai Load Balancing Untuk Galera Cluster pada CentOS 8_**](/memanfaatkan-mariadb-maxscale-sebagai-load-balancing-untuk-galera-cluster-pada-centos-8/)

Berikut topologi yang akan digunakan

<figure class="aligncenter size-large"><img loading="lazy" width="720" height="275" src="/content/images/wordpress/2020/09/galera-maxscale3.png" alt="" class="wp-image-409" srcset="/content/images/wordpress/2020/09/galera-maxscale3.png 720w, /content/images/wordpress/2020/09/galera-maxscale3-300x115.png 300w" sizes="(max-width: 720px) 100vw, 720px"></figure>

Berikut detail informasi dari topologi diatas:  
  
**Node 01, 02, 03** : Digunakan untuk galera cluster, Selengkapnya: **[Klik Disini](http://Cara Instalasi dan Konfigurasi MariaDB Galera Cluster di CentOS 8)**  
**Node 04** : Digunakan untuk LB Mariadb MaxScale  
– Hostname: mariadb-maxscale.nurhamim.my.id  
– IP: 192.168.10.15  
**Node 05** : Digunakan untuk CMS Joomla  
– Hostname: my-apps.nurhamim.my.id  
– IP: 192.168.10.2

Pertama yang harus kita lakukan yaitu membuat database, username dan password Joomla melalui salah satu node galera cluster (node01, node02, atau node03). Disini kami akan buat di node01 silakan login ke database nya terlebih dahulu.

    [root@galera01 ~]#
    [root@galera01 ~]# mysql -u root -p
    Enter password:
    Welcome to the MariaDB monitor. Commands end with ; or \g.
    Your MariaDB connection id is 125
    Server version: 10.3.17-MariaDB MariaDB Server
    
    Copyright (c) 2000, 2018, Oracle, MariaDB Corporation Ab and others.
    
    Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.
    
    MariaDB [(none)]>

Create database, username dan password Joomla,

    MariaDB [(none)]>
    MariaDB [(none)]> create database joomla;
    Query OK, 1 row affected (0.522 sec)
    
    MariaDB [(none)]> GRANT ALL ON joomla.* TO userjoomla@192.168.10.2 IDENTIFIED BY 'secret';
    Query OK, 0 rows affected (0.025 sec)
    
    MariaDB [(none)]> GRANT ALL ON joomla.* TO userjoomla@192.168.10.15 IDENTIFIED BY 'secret';
    Query OK, 0 rows affected (0.035 sec)
    
    MariaDB [(none)]> flush privileges;
    Query OK, 0 rows affected (0.024 sec)
    
    MariaDB [(none)]> exit
    Bye
    [root@galera01 ~]#

Diatas user joomla di allow atau grant ke 2 IP ((node04 – LB MaxScale) dan (node05 – CMS Joomla)).

IP yang digunakan dan yang dikonfigurasi di sisi Joomla yaitu IP node04 – LB MaxScale (192.168.10.15).

Silakan test koneksi database dari node05

    [root@my-apps joomla]#
    [root@my-apps joomla]# mysql -u userjoomla -h 192.168.10.15 -p
    Enter password:
    Welcome to the MariaDB monitor. Commands end with ; or \g.
    Your MariaDB connection id is 54
    Server version: 10.3.17-MariaDB MariaDB Server
    
    Copyright (c) 2000, 2018, Oracle, MariaDB Corporation Ab and others.
    
    Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.
    
    MariaDB [(none)]>
    MariaDB [(none)]> show databases;
    +--------------------+
    | Database |
    +--------------------+
    | information_schema |
    | joomla |
    +--------------------+
    2 rows in set (0.002 sec)
    
    MariaDB [(none)]>

Selanjutnya kita akan mencoba membuat script PHP sederhana untuk mencoba koneksi ke database yang sudah kita buat sebelumnya. Silakan buat file dengan akhiran .php seperti berikut

    [root@my-apps ~]# cd /usr/share/nginx/html/
    [root@my-apps html]#
    [root@my-apps html]# vim test-db.php

Berikut contoh script php untuk koneksi database

    <?php
    $servername = "192.168.10.15:3306";
    $database = "joomla";
    $username = "userjoomla";
    $password = "secret";
    
    // untuk tulisan bercetak tebal silakan sesuaikan dengan detail database Anda
    // membuat koneksi
    $conn = mysqli_connect($servername, $username, $password, $database);
    // mengecek koneksi
    if (!$conn) {
        die("Koneksi gagal: " . mysqli_connect_error());
    }
    echo "Koneksi Joomla berhasil";
    mysqli_close($conn);
    ?>

Jika sudah silakan akses IP VM Anda /test-db.php

<figure class="wp-block-image size-large"><img loading="lazy" width="680" height="183" src="/content/images/wordpress/2020/09/image.png" alt="" class="wp-image-410" srcset="/content/images/wordpress/2020/09/image.png 680w, /content/images/wordpress/2020/09/image-300x81.png 300w" sizes="(max-width: 680px) 100vw, 680px"></figure>

Saat ini koneksi php ke database sudah berhasil. Selanjutnya kita akan mencoba melakukan instalasi CMS Joomla, disini kami tidak membahas installasi secara detail, untuk detail instalasi CMS Joomla Anda dapat merujuk pada link berikut: **_[Cara Instalasi Joomla Menggunakan Nginx di CentOS 8](/cara-instalasi-joomla-menggunakan-nginx-di-centos-8/)_**

Pada saat ini instalasi CMS Joomla tepatnya pada saat konfigurasi database, Anda input IP Node04 – LB MariaDB MaxScale contohnya seprti capture berikut

<figure class="wp-block-image size-large"><img loading="lazy" width="1024" height="622" src="/content/images/wordpress/2020/09/joomla-test-1024x622.png" alt="" class="wp-image-411" srcset="/content/images/wordpress/2020/09/joomla-test-1024x622.png 1024w, /content/images/wordpress/2020/09/joomla-test-300x182.png 300w, /content/images/wordpress/2020/09/joomla-test-768x467.png 768w, /content/images/wordpress/2020/09/joomla-test.png 1043w" sizes="(max-width: 1024px) 100vw, 1024px"></figure>

Tunggu proses instalasi sampai selesai

<figure class="wp-block-image size-large"><img loading="lazy" width="1024" height="400" src="/content/images/wordpress/2020/09/joomla-test-test-1024x400.png" alt="" class="wp-image-412" srcset="/content/images/wordpress/2020/09/joomla-test-test-1024x400.png 1024w, /content/images/wordpress/2020/09/joomla-test-test-300x117.png 300w, /content/images/wordpress/2020/09/joomla-test-test-768x300.png 768w, /content/images/wordpress/2020/09/joomla-test-test.png 1361w" sizes="(max-width: 1024px) 100vw, 1024px"></figure>

Saat ini instalasi Joomla sudah berhasil dan berikut tampilan home page admin CMS Joomla

<figure class="wp-block-image size-large"><img loading="lazy" width="1024" height="407" src="/content/images/wordpress/2020/09/admin-joomla-1024x407.png" alt="" class="wp-image-413" srcset="/content/images/wordpress/2020/09/admin-joomla-1024x407.png 1024w, /content/images/wordpress/2020/09/admin-joomla-300x119.png 300w, /content/images/wordpress/2020/09/admin-joomla-768x306.png 768w, /content/images/wordpress/2020/09/admin-joomla.png 1362w" sizes="(max-width: 1024px) 100vw, 1024px"></figure>

Berikut tampilan default home page Joomla

<figure class="wp-block-image size-large"><img loading="lazy" width="1024" height="481" src="/content/images/wordpress/2020/09/joomla-max-1024x481.png" alt="" class="wp-image-414" srcset="/content/images/wordpress/2020/09/joomla-max-1024x481.png 1024w, /content/images/wordpress/2020/09/joomla-max-300x141.png 300w, /content/images/wordpress/2020/09/joomla-max-768x361.png 768w, /content/images/wordpress/2020/09/joomla-max.png 1364w" sizes="(max-width: 1024px) 100vw, 1024px"></figure>

Selanjutnya kita akan memastikan di masing – masing node database apakah sudah tereplikasi atau belum

**Node01**

<figure class="wp-block-image size-large"><img loading="lazy" width="1024" height="395" src="/content/images/wordpress/2020/09/image-1-1024x395.png" alt="" class="wp-image-415" srcset="/content/images/wordpress/2020/09/image-1-1024x395.png 1024w, /content/images/wordpress/2020/09/image-1-300x116.png 300w, /content/images/wordpress/2020/09/image-1-768x297.png 768w, /content/images/wordpress/2020/09/image-1-1536x593.png 1536w, /content/images/wordpress/2020/09/image-1.png 1883w" sizes="(max-width: 1024px) 100vw, 1024px"></figure>

**Node02**

<figure class="wp-block-image size-large"><img loading="lazy" width="1024" height="390" src="/content/images/wordpress/2020/09/image-2-1024x390.png" alt="" class="wp-image-416" srcset="/content/images/wordpress/2020/09/image-2-1024x390.png 1024w, /content/images/wordpress/2020/09/image-2-300x114.png 300w, /content/images/wordpress/2020/09/image-2-768x292.png 768w, /content/images/wordpress/2020/09/image-2-1536x585.png 1536w, /content/images/wordpress/2020/09/image-2.png 1888w" sizes="(max-width: 1024px) 100vw, 1024px"></figure>

**Node03**

<figure class="wp-block-image size-large"><img loading="lazy" width="1024" height="388" src="/content/images/wordpress/2020/09/image-3-1024x388.png" alt="" class="wp-image-417" srcset="/content/images/wordpress/2020/09/image-3-1024x388.png 1024w, /content/images/wordpress/2020/09/image-3-300x114.png 300w, /content/images/wordpress/2020/09/image-3-768x291.png 768w, /content/images/wordpress/2020/09/image-3-1536x582.png 1536w, /content/images/wordpress/2020/09/image-3.png 1888w" sizes="(max-width: 1024px) 100vw, 1024px"></figure>

Saat ini database CMS Joomla sudah tereplikasi di masing – masing node galera.

Selanjutnya kita akan mencoba melihat koneksi di sisi proxy atau load balancing MariaDB MaxScale di node04

<figure class="wp-block-image size-large"><img loading="lazy" width="883" height="750" src="/content/images/wordpress/2020/09/image-4.png" alt="" class="wp-image-418" srcset="/content/images/wordpress/2020/09/image-4.png 883w, /content/images/wordpress/2020/09/image-4-300x255.png 300w, /content/images/wordpress/2020/09/image-4-768x652.png 768w" sizes="(max-width: 883px) 100vw, 883px"></figure>

Selamat saat ini CMS Joomla Anda sudah menggunakan Database high availability cluster.

Selamat mencoba 😁

Please follow and like us:

[![error](/wp-content/plugins/ultimate-social-media-icons/images/follow_subscribe.png)](https://api.follow.it/widgets/icon/VHc3d1lpVGdwRnE5QnV0eERCNUx5RCtvTTVoUkNYS3NNRmd5eVhlQW9tNXRHS3VTbGh6Y0NybkRJRS8zSGpjRDVZb1ZGMlNTSEpJYUpuZzZqNzdnd3VSN3dwM2VlQTF6ejJEaGV5UGRUbnlEcHFNd3luYTV4ZTZtUGowVWI2Q2x8M2kzdnBEeUIrUk5xOFI5TXZ3cHF3bFNQRkRJSGhUNGdrRFd0TlNtdE1OWT0=/OA==/)

[![fb-share-icon](/wp-content/plugins/ultimate-social-media-icons/images/visit_icons/fbshare_bck.png "Facebook Share")](https://www.facebook.com/sharer/sharer.php?u=https%3A%2F%2Fbelajarlinux.id%2F%3Fp%3D408%26ghostexport%3Dtrue%26submit%3DDownload+Ghost+File)

[![Tweet](/wp-content/plugins/ultimate-social-media-icons/images/visit_icons/en_US_Tweet.svg "Tweet")](https://twitter.com/intent/tweet?text=Membuat+Koneksi+PHP+ke+MariaDB+MaxScale+https://belajarlinux.id/?p=408&ghostexport=true&submit=Download Ghost File)

[![fb-share-icon](/wp-content/plugins/ultimate-social-media-icons/images/share_icons/Pinterest_Save/en_US_save.svg "Pin Share")](#)

<!--kg-card-end: html-->
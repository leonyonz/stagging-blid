---
layout: post
title: Memanfaatkan MariaDB MaxScale Sebagai Load Balancing Untuk Galera Cluster pada
  CentOS 8
featured: true
date: '2020-08-31 23:43:20'
tags:
- centos
- database
- galera-cluster
- load-balancer
---

MariaDB adalah sistem manajemen database relasional yang dikembangkan dari MySQL. MariaDB dikembangkan oleh komunitas pengembang yang sebelumnya berkontribusi untuk database MySQL.

MariaDB saat ini telah mempunyai MaxScale salah satu produk open source dibawah [Business Source License](https://mariadb.com/bsl-faq-mariadb/) (BSL). Mariadb MaxScale dirancang untuk meningkatkan scalability, high availability dan security serta mengakomodir infrastruktur database.

MariaDB MaxScale merupakan sebuah proxy yang duduk diantara database server dan client lalu meneruskan request client ke database server. Mariadb MaxScale juga dapat mengatur request routing, filter, tracing log, monitoring, bahkan dapat digunakan sebagai load balancing, autentikasi dan yang lainnya. Selengkapnya Anda dapat merujuk pada link berikut: [MariaDB-MaxScale](https://mariadb.com/products/mariadb-maxscale).

Sebenarnya terdapat beberapa pemilihan dalam menentukan load balancing database diantaranya

1. Menggunakan HAProxy
2. Menggunakan ProxySQL
3. Menggunakan MaxScale

Di tutorial kali ini kami tidak membahas kelebihan dan kekurangannya dan untuk komparasi diatas Anda dapat melihat nya pada link berikut: **[StackShare – HAProxy vs MaxScale vs ProxySQL](https://stackshare.io/stackups/maxscale-vs-proxysql-vs-haproxy)**.

Pada tutorial ini akan dibahas cara instalasi dan konfigurasi MariaDB MaxScale sebagai load Balancing MariaDB Galera Cluster, oleh karena itu pastikan Anda sudah melakukan instalasi MariaDB Galera Cluster terlebih dahulu.

Berikut topologi yang akan digunakan.

<figure class="aligncenter size-large"><img loading="lazy" width="733" height="322" src="/content/images/wordpress/2020/08/galera-maxscale2.png" alt="" class="wp-image-395" srcset="/content/images/wordpress/2020/08/galera-maxscale2.png 733w, /content/images/wordpress/2020/08/galera-maxscale2-300x132.png 300w" sizes="(max-width: 733px) 100vw, 733px"></figure>

Berikut detail keterangan dari topologi diatas:

1. Galera Cluster Menggunakan 3 node dengan detail IP dan Hostname sebagai berikut:  
**Node01:**  
– Hostname: galera01.nurhamim.my.id  
– IP: 192.168.10.9  
**Node02:**  
– Hostname: galera02.nurhamim.my.id  
– IP: 192.168.10.18  
**Node03**  
– Hostname: galera03.nurhamim.my.id  
– IP: 192.168.10.21
2. Load Balancing MariaDB MaxScale akan diinstall di node04 dengan detail sebagai berikut  
– Hostaname: mariadb-maxscale.nurhamim.my.id  
– IP: 192.168.10.15 

Disini untuk Galera Cluster sudah kami install sebelumnya, jika Anda belum melakukan instalasi Galera Cluster silakan merujuk pada link berikut: [_ **Cara Instalasi dan Konfigurasi MariaDB Galera Cluster di CentOS 8** _](/cara-instalasi-dan-konfigurasi-mariadb-galera-cluster-di-centos-8/).

Untuk melakukan instalasi MariaDB MaxScale di node04 langkah pertama yaitu mengunduh dan menambahkan repository MariaDB

    [root@mariadb-maxscale ~]#
    [root@mariadb-maxscale ~]# curl -sS https://downloads.mariadb.com/MariaDB/mariadb_repo_setup | bash
    [info] Repository file successfully written to /etc/yum.repos.d/mariadb.repo
    [info] Adding trusted package signing keys...
    [info] Successfully added trusted package signing keys
    [root@mariadb-maxscale ~]#

Jika sudah silakan install MariaDB MaxScale menggunakan command berikut

    [root@mariadb-maxscale ~]#
    [root@mariadb-maxscale ~]# dnf install maxscale -y

Tunggu proses instalasi yang membutuhkan beberapa waktu sampai selesai, apabila sudah selesai langkah selanjutnya membuat user database MaxScale di sisi node01 galera cluster, user tersebut digunakan untuk menghububungkan node galera cluster _(node01)_ dengan MaxScale untuk kebutuhan authentikasi, monitoring dan yang lainnya.

    [root@galera01 ~]#
    [root@galera01 ~]# mysql -u root -p
    Enter password:
    Welcome to the MariaDB monitor. Commands end with ; or \g.
    Your MariaDB connection id is 24
    Server version: 10.3.17-MariaDB MariaDB Server
    
    Copyright (c) 2000, 2018, Oracle, MariaDB Corporation Ab and others.
    
    Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.
    
    MariaDB [(none)]>
    
    MariaDB [(none)]>
    MariaDB [(none)]> create user 'belajarlinux'@'192.168.10.15' identified by 'secret';
    Query OK, 0 rows affected (0.024 sec)
    
    MariaDB [(none)]> grant select on mysql.user to 'belajarlinux'@'192.168.10.15';
    Query OK, 0 rows affected (0.019 sec)
    
    MariaDB [(none)]> grant select on mysql.db to 'belajarlinux'@'192.168.10.15';
    Query OK, 0 rows affected (0.012 sec)
    
    MariaDB [(none)]> grant select on mysql.tables_priv to 'belajarlinux'@'192.168.10.15';
    Query OK, 0 rows affected (0.021 sec)
    
    MariaDB [(none)]> grant show databases on *.* to 'belajarlinux'@'192.168.10.15';
    Query OK, 0 rows affected (0.015 sec)
    
    MariaDB [(none)]> flush privileges;
    Query OK, 0 rows affected (0.013 sec)
    
    MariaDB [(none)]>

_Noted: IP yang diinput merupakan IP node04 (lb-mariadb-maxscale) dan silakan sesuaikan username dan password user sesuai keinginan_

Selanjutnya buat user baru dengan hak istimewa untuk terhubung secara remote dari instance manapun. User ini akan digunakan oleh aplikasi kita untuk terhubung ke cluster MariaDB Galera.

    MariaDB [(none)]>
    MariaDB [(none)]> create user hamim@'%' identified by 'secret';
    Query OK, 0 rows affected (0.027 sec)
    
    MariaDB [(none)]> grant show databases on *.* to hamim@'%';
    Query OK, 0 rows affected (0.034 sec)
    
    MariaDB [(none)]> flush privileges;
    Query OK, 0 rows affected (0.027 sec)
    
    MariaDB [(none)]> exit
    Bye
    [root@galera01 ~]#

_Noted: Silakan sesuaikan nama user dengan keinginan Anda._

Selanjutnya konfigurasi MaxScale di node04. Sebenarnya secara default sudah ada konfigurasi yang dapat Anda gunakan, namun kali ini kami akan membuat konfigurasi yang baru _(from scratch_).

Silakan simpan default konfigurasi dari MaxScale

    [root@mariadb-maxscale ~]#
    [root@mariadb-maxscale ~]# mv /etc/maxscale.cnf /etc/maxscale.cnf.old

Buat konfigurasi baru MaxScale

    [root@mariadb-maxscale ~]#
    [root@mariadb-maxscale ~]# vim /etc/maxscale.cnf

Berikut full konfigurasi dari MaxScale

    #Global MaxScale Settings
    [maxscale]
    threads=auto
    
    #Define Server Nodes
    [galera01]
    type=server
    address=192.168.10.9
    port=3306
    protocol=MariaDBBackend
    
    [galera02]
    type=server
    address=192.168.10.18
    port=3306
    protocol=MariaDBBackend
    
    [galera03]
    type=server
    address=192.168.10.21
    port=3306
    protocol=MariaDBBackend
    
    #Define Monitoring Service
    [Galera-Monitor]
    type=monitor
    module=galeramon
    servers=galera01,galera02,galera03
    user=belajarlinux
    password=secret
    monitor_interval=1000
    
    #Define Galera Service
    [Galera-Service]
    type=service
    router=readconnroute
    router_options=synced
    servers=galera01,galera02,galera03
    user=belajarlinux
    password=secret
    
    #Define Galera Listener
    [Galera-Listener]
    type=listener
    service=Galera-Service
    protocol=MariaDBClient
    port=4306
    
    #Define Administration Service
    [MaxAdmin-Service]
    type=service
    router=cli
    
    #Define Administration Listener
    [MaxAdmin-Listener]
    type=listener
    service=MaxAdmin-Service
    protocol=maxscaled
    socket=default

_ **Penjelasan beberapa rule konfigurasi MaxScale:** _

- **_Global MaxScale Settings_**  
_Secara default konfigurasi Global MaxScale yaitu 1, namun Anda dapat menyesuaikan dengan kebutuhan ini, dalam case ini kami set menjadi auto_
- _ **Define Server Nodes** _  
_Disini Anda dapat menentukan berapa node atau server yang ingin Anda gunakan beserta IP, Port dari masing – masing node yang Anda gunakan._ 
- _ **Define Monitoring Service** _  
_MaxScale akan menganalisis node atau server yang diberikan secara internal secara berkala berdasarkan modul monitor yang diberikan. Modul dasar diantaranya:_   
– _ **“** Mysqlmon **“** – Periksa kesehatan replikasi asli dan status server (Master atau Slave)._  
– **_“_** _Galeramon_ **_”_** _– Kesehatan cluster Galera dan status node dipantau dengan modul._
- _ **Define Galera Service** _  
_MaxScale bisa dibilang sebagai router untuk koneksi yang akan digunakan. MaxScale mempunyai beberapa algoritma router yang ditentukan diantaranya:_   
– _“readwritesplit” : Digunakan untuk membagi incoming write ke satu master dan read ke sejumlah slave yang diberikan._  
– _“readconnroute” – Ini akan membagi koneksi masuk dengan mekanisme round robin. Pada tutorial kali kami menggunakan readconncoute._
- _ **Define Galera Listener** _  
_MaxScale membutuhkan listener untuk menerima koneksi masuk untuk setiap layanan yang ditentukan_
- _ **Define Administration Service** _  
_MaxScale monitoring console._

Jika sudah selanjutnya start dan enabl MaxScale service

    [root@mariadb-maxscale ~]# systemctl start maxscale.service
    [root@mariadb-maxscale ~]# systemctl enable maxscale.service
    [root@mariadb-maxscale ~]#

Cek status service MaxScale

    [root@mariadb-maxscale ~]#
    [root@mariadb-maxscale ~]# systemctl status maxscale.service
    ● maxscale.service - MariaDB MaxScale Database Proxy
       Loaded: loaded (/usr/lib/systemd/system/maxscale.service; enabled; vendor preset: disabled)
       Active: active (running) since Sun 2020-08-30 19:32:03 UTC; 13min ago
     Main PID: 4749 (maxscale)
        Tasks: 5 (limit: 11328)
       Memory: 3.7M
       CGroup: /system.slice/maxscale.service
               └─4749 /usr/bin/maxscale
    
    Aug 30 19:32:03 mariadb-maxscale.nurhamim.my.id maxscale[4749]: Listening for connections at [::]:4306
    Aug 30 19:32:03 mariadb-maxscale.nurhamim.my.id maxscale[4749]: Service 'Galera-Service' started (1/2)
    Aug 30 19:32:03 mariadb-maxscale.nurhamim.my.id maxscale[4749]: Listening for connections at [/var/run/maxscale/maxadmin.sock]:0
    Aug 30 19:32:03 mariadb-maxscale.nurhamim.my.id maxscale[4749]: Service 'MaxAdmin-Service' started (2/2)
    Aug 30 19:32:03 mariadb-maxscale.nurhamim.my.id maxscale[4749]: Removing stale journal file for monitor 'Galera-Monitor'.
    Aug 30 19:32:03 mariadb-maxscale.nurhamim.my.id maxscale[4749]: Server 'galera03' charset: latin1
    Aug 30 19:32:03 mariadb-maxscale.nurhamim.my.id maxscale[4749]: Server 'galera03' version: 10.3.17-MariaDB
    Aug 30 19:32:03 mariadb-maxscale.nurhamim.my.id maxscale[4749]: Server changed state: galera01[192.168.10.9:3306]: new_master. [Running] -> [Master, Synced, Running]
    Aug 30 19:32:03 mariadb-maxscale.nurhamim.my.id maxscale[4749]: Server changed state: galera02[192.168.10.18:3306]: new_slave. [Running] -> [Slave, Synced, Running]
    Aug 30 19:32:03 mariadb-maxscale.nurhamim.my.id maxscale[4749]: Server changed state: galera03[192.168.10.21:3306]: new_slave. [Running] -> [Slave, Synced, Running]
    [root@mariadb-maxscale ~]#

Distatus diatas sudah terlihat untuk node01, node02, node03 sudah berada di MaxScale.

Selanjutnya verifikasi, untuk memverifikasi dapat mengguankan _ **maxadmin** atau **maxcrl** _ kita coba menggunakan **_maxadmin_** terlebih dahulu

    [root@mariadb-maxscale ~]#
    [root@mariadb-maxscale ~]# maxadmin
    MaxScale> list servers
    Servers.
    -------------------+-----------------+-------+-------------+--------------------
    Server | Address | Port | Connections | Status
    -------------------+-----------------+-------+-------------+--------------------
    galera01 | 192.168.10.9 | 3306 | 0 | Master, Synced, Running
    galera02 | 192.168.10.18 | 3306 | 0 | Slave, Synced, Running
    galera03 | 192.168.10.21 | 3306 | 0 | Slave, Synced, Running
    -------------------+-----------------+-------+-------------+--------------------
    MaxScale>

<figure class="wp-block-image size-large"><img loading="lazy" width="717" height="196" src="/content/images/wordpress/2020/08/1-8.png" alt="" class="wp-image-396" srcset="/content/images/wordpress/2020/08/1-8.png 717w, /content/images/wordpress/2020/08/1-8-300x82.png 300w" sizes="(max-width: 717px) 100vw, 717px"></figure>

Berikut perintah dan output jika menggunakan _ **maxctrl** _

    [root@mariadb-maxscale ~]#
    [root@mariadb-maxscale ~]# maxctrl list servers
    ┌──────────┬───────────────┬──────┬─────────────┬─────────────────────────┬──────┐
    │ Server │ Address │ Port │ Connections │ State │ GTID │
    ├──────────┼───────────────┼──────┼─────────────┼─────────────────────────┼──────┤
    │ galera01 │ 192.168.10.9 │ 3306 │ 0 │ Master, Synced, Running │ │
    ├──────────┼───────────────┼──────┼─────────────┼─────────────────────────┼──────┤
    │ galera02 │ 192.168.10.18 │ 3306 │ 0 │ Slave, Synced, Running │ │
    ├──────────┼───────────────┼──────┼─────────────┼─────────────────────────┼──────┤
    │ galera03 │ 192.168.10.21 │ 3306 │ 0 │ Slave, Synced, Running │ │
    └──────────┴───────────────┴──────┴─────────────┴─────────────────────────┴──────┘
    [root@mariadb-maxscale ~]#

<figure class="wp-block-image size-large"><img loading="lazy" width="986" height="261" src="/content/images/wordpress/2020/08/3-6.png" alt="" class="wp-image-398" srcset="/content/images/wordpress/2020/08/3-6.png 986w, /content/images/wordpress/2020/08/3-6-300x79.png 300w, /content/images/wordpress/2020/08/3-6-768x203.png 768w" sizes="(max-width: 986px) 100vw, 986px"></figure>

Anda juga dapat melihat users, dan services yang ada menggunakan _maxctl contohnya_

<figure class="wp-block-image size-large"><img loading="lazy" width="954" height="311" src="/content/images/wordpress/2020/08/image-102.png" alt="" class="wp-image-400" srcset="/content/images/wordpress/2020/08/image-102.png 954w, /content/images/wordpress/2020/08/image-102-300x98.png 300w, /content/images/wordpress/2020/08/image-102-768x250.png 768w" sizes="(max-width: 954px) 100vw, 954px"></figure>

Anda dapat mempelajari command line dari _ **maxctrl** _ pada link berikut: **[MaxCtrl Commands](https://mariadb.com/kb/en/mariadb-maxscale-24-maxctrl/#commands)**

Selanjutnya kita akan menguji coba failover atau load balancer MaxScale

Test 01: Matikan service mariadb node01 dan lihat statusnya di node MaxScale seharusnya down

<figure class="wp-block-image size-large"><img loading="lazy" width="1024" height="295" src="/content/images/wordpress/2020/08/image-103-1024x295.png" alt="" class="wp-image-402" srcset="/content/images/wordpress/2020/08/image-103-1024x295.png 1024w, /content/images/wordpress/2020/08/image-103-300x87.png 300w, /content/images/wordpress/2020/08/image-103-768x222.png 768w, /content/images/wordpress/2020/08/image-103.png 1317w" sizes="(max-width: 1024px) 100vw, 1024px"></figure>

Test 02: Mastikan service mariadb node02 dan lihat status node02 di MaxScale akan down

<figure class="wp-block-image size-large"><img loading="lazy" width="1024" height="440" src="/content/images/wordpress/2020/08/image-104-1024x440.png" alt="" class="wp-image-403" srcset="/content/images/wordpress/2020/08/image-104-1024x440.png 1024w, /content/images/wordpress/2020/08/image-104-300x129.png 300w, /content/images/wordpress/2020/08/image-104-768x330.png 768w, /content/images/wordpress/2020/08/image-104.png 1290w" sizes="(max-width: 1024px) 100vw, 1024px"></figure>

Terlihat pada gambar diatas tersisa node03 yang secara otomatis menjadi master, disinilah proses failover atau load balancer berjalan, dimana ada node yang terdeteksi down maka node yang lain akan menghandle nya.

Test 03: Start mariadb node02

<figure class="wp-block-image size-large"><img loading="lazy" width="1024" height="302" src="/content/images/wordpress/2020/08/image-106-1024x302.png" alt="" class="wp-image-405" srcset="/content/images/wordpress/2020/08/image-106-1024x302.png 1024w, /content/images/wordpress/2020/08/image-106-300x89.png 300w, /content/images/wordpress/2020/08/image-106-768x227.png 768w, /content/images/wordpress/2020/08/image-106.png 1297w" sizes="(max-width: 1024px) 100vw, 1024px"></figure>

Test 04: Start mariadb node01

<figure class="wp-block-image size-large"><img loading="lazy" width="1024" height="430" src="/content/images/wordpress/2020/08/image-107-1024x430.png" alt="" class="wp-image-406" srcset="/content/images/wordpress/2020/08/image-107-1024x430.png 1024w, /content/images/wordpress/2020/08/image-107-300x126.png 300w, /content/images/wordpress/2020/08/image-107-768x323.png 768w, /content/images/wordpress/2020/08/image-107.png 1330w" sizes="(max-width: 1024px) 100vw, 1024px"></figure>

Saat ini semua node database sudah running semua secara real time dan tentunya otomatis.

Selamat mencoba 😁

Please follow and like us:

[![error](/wp-content/plugins/ultimate-social-media-icons/images/follow_subscribe.png)](https://api.follow.it/widgets/icon/VHc3d1lpVGdwRnE5QnV0eERCNUx5RCtvTTVoUkNYS3NNRmd5eVhlQW9tNXRHS3VTbGh6Y0NybkRJRS8zSGpjRDVZb1ZGMlNTSEpJYUpuZzZqNzdnd3VSN3dwM2VlQTF6ejJEaGV5UGRUbnlEcHFNd3luYTV4ZTZtUGowVWI2Q2x8M2kzdnBEeUIrUk5xOFI5TXZ3cHF3bFNQRkRJSGhUNGdrRFd0TlNtdE1OWT0=/OA==/)

[![fb-share-icon](/wp-content/plugins/ultimate-social-media-icons/images/visit_icons/fbshare_bck.png "Facebook Share")](https://www.facebook.com/sharer/sharer.php?u=https%3A%2F%2Fbelajarlinux.id%2F%3Fp%3D393%26ghostexport%3Dtrue%26submit%3DDownload+Ghost+File)

[![Tweet](/wp-content/plugins/ultimate-social-media-icons/images/visit_icons/en_US_Tweet.svg "Tweet")](https://twitter.com/intent/tweet?text=Memanfaatkan+MariaDB+MaxScale+Sebagai+Load+Balancing+Untuk+Galera+Cluster+pada+CentOS+8+https://belajarlinux.id/?p=393&ghostexport=true&submit=Download Ghost File)

[![fb-share-icon](/wp-content/plugins/ultimate-social-media-icons/images/share_icons/Pinterest_Save/en_US_save.svg "Pin Share")](#)

<!--kg-card-end: html-->
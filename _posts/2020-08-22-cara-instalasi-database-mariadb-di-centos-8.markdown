---
layout: post
title: Cara Instalasi Database MariaDB di CentOS 8
featured: true
date: '2020-08-22 07:24:02'
tags:
- centos
- database
---

MariaDB adalah sistem manajemen database relasional yang dikembangkan dari MySQL. MariaDB dikembangkan oleh komunitas pengembang yang sebelumnya berkontribusi untuk database MySQL.

Mengapa pengembang MySQL membangun MariaDB? Salah satu alasannya, MySQL telah diakuisisi oleh Oracle sehingga menyebabkan MySQL menjadi produk yang berlisensi proprietary. Dengan diakuisisinya MySQL oleh Oracle, maka pengembangan MySQL pun sudah tidak leluasa lagi. Hal ini yang menyebabkan pengembang MySQL sebelumnya mulai membangun MariaDB.

Untuk awal mula penomoran versi, MariaDB mengikuti skema penomoran MySQL yakni 5.5. Setelah versi 5.5, pengembang MariaDB memutuskan untuk ‘lompat jauh’ dengan memberi versi terbaru mereka dengan penomoran 10. Tidak hanya penomoran versinya saja, fitur-fitur major pun dibangun dalam MariaDB. Saat ini versi terbaru MariaDB yang stabil adalah MariaDB 10.5.5, sebagai berikut

<figure class="wp-block-image size-large"><img loading="lazy" width="708" height="474" src="/content/images/wordpress/2020/08/image-35.png" alt="" class="wp-image-141" srcset="/content/images/wordpress/2020/08/image-35.png 708w, /content/images/wordpress/2020/08/image-35-300x201.png 300w" sizes="(max-width: 708px) 100vw, 708px"></figure>

Di CentOS 8 secara default repository yang tersedia untuk MariaDB versi 10.3, jika kita ingin install latest version yang stabil di versi 10.5.5 Anda perlu menambahkan repository MariaDB terlebih dahulu caranya sebagai berikut:

Klik pada link berikut: _https://downloads.mariadb.org/mariadb/repositories/_ untuk melihat dan mengambil repository nya

<figure class="wp-block-image size-large"><img loading="lazy" width="898" height="625" src="/content/images/wordpress/2020/08/image-36.png" alt="" class="wp-image-142" srcset="/content/images/wordpress/2020/08/image-36.png 898w, /content/images/wordpress/2020/08/image-36-300x209.png 300w, /content/images/wordpress/2020/08/image-36-768x535.png 768w" sizes="(max-width: 898px) 100vw, 898px"></figure>

Buat repository MariaDB

    [root@tutorial ~]#
    [root@tutorial ~]# vim /etc/yum.repos.d/MariaDB.repo

Isi repository diatas

    # MariaDB 10.5 CentOS repository list - created 2020-08-21 23:57 UTC
    # http://downloads.mariadb.org/mariadb/repositories/
    [mariadb]
    name = MariaDB
    baseurl = http://yum.mariadb.org/10.5/centos8-amd64
    module_hotfixes=1
    gpgkey=https://yum.mariadb.org/RPM-GPG-KEY-MariaDB
    gpgcheck=1

Jika sudah silakan simpan dan jalankan perintah berikut, untuk instalasi MariaDB

    [root@tutorial ~]#
    [root@tutorial ~]# dnf install MariaDB-server -y

Apabila instalasi sudah selesai, silakan di start dan pastikan statusnya running

    [root@tutorial ~]#
    [root@tutorial ~]# systemctl start mariadb
    [root@tutorial ~]# systemctl status mariadb |grep Active
       Active: active (running) since Sat 2020-08-22 00:06:04 UTC; 42s ago
    [root@tutorial ~]#

Untuk melihat versi MariaDB gunakan perintah berikut

    [root@tutorial ~]#
    [root@tutorial ~]# mariadb --version
    mariadb Ver 15.1 Distrib 10.5.5-MariaDB, for Linux (x86_64) using readline 5.1
    [root@tutorial ~]#

Saat ini MariaDB sudah terinstall, jika kita menjalankan perintah _mariadb_ Anda akan langsung masuk ke shell MariaDB

<figure class="wp-block-image size-large"><img loading="lazy" width="651" height="189" src="/content/images/wordpress/2020/08/image-37.png" alt="" class="wp-image-143" srcset="/content/images/wordpress/2020/08/image-37.png 651w, /content/images/wordpress/2020/08/image-37-300x87.png 300w" sizes="(max-width: 651px) 100vw, 651px"></figure>

Selanjutnya kita akan mengatur password untuk login ke sisi MariaDB nya, mari kita atur password root MariaDB dengan cara menjalankan perintah berikut

    [root@tutorial ~]# mysql_secure_installation
    
    NOTE: RUNNING ALL PARTS OF THIS SCRIPT IS RECOMMENDED FOR ALL MariaDB
          SERVERS IN PRODUCTION USE! PLEASE READ EACH STEP CAREFULLY!
    
    In order to log into MariaDB to secure it, we'll need the current
    password for the root user. If you've just installed MariaDB, and
    haven't set the root password yet, you should just press enter here.
    
    Enter current password for root (enter for none):
    OK, successfully used password, moving on...
    
    Setting the root password or using the unix_socket ensures that nobody
    can log into the MariaDB root user without the proper authorisation.
    
    You already have your root account protected, so you can safely answer 'n'.
    
    Switch to unix_socket authentication [Y/n]
    Enabled successfully!
    Reloading privilege tables..
     ... Success!
    
    
    You already have your root account protected, so you can safely answer 'n'.
    
    Change the root password? [Y/n]
    New password: #INPUT PASSWORD MARIADB
    Re-enter new password: #KONFIRMASI PASSWORD ROOT MARIADB DIATAS
    Password updated successfully!
    Reloading privilege tables..
     ... Success!
    
    
    By default, a MariaDB installation has an anonymous user, allowing anyone
    to log into MariaDB without having to have a user account created for
    them. This is intended only for testing, and to make the installation
    go a bit smoother. You should remove them before moving into a
    production environment.
    
    Remove anonymous users? [Y/n]
     ... Success!
    
    Normally, root should only be allowed to connect from 'localhost'. This
    ensures that someone cannot guess at the root password from the network.
    
    Disallow root login remotely? [Y/n]
     ... Success!
    
    By default, MariaDB comes with a database named 'test' that anyone can
    access. This is also intended only for testing, and should be removed
    before moving into a production environment.
    
    Remove test database and access to it? [Y/n]
     - Dropping test database...
     ... Success!
     - Removing privileges on test database...
     ... Success!
    
    Reloading the privilege tables will ensure that all changes made so far
    will take effect immediately.
    
    Reload privilege tables now? [Y/n]
     ... Success!
    
    Cleaning up...
    
    All done! If you've completed all of the above steps, your MariaDB
    installation should now be secure.
    
    Thanks for using MariaDB!
    [root@tutorial ~]#

Jika sudah silakan coba kembali untuk login ke mariadb menggunakan user root seperti berikut

    [root@tutorial ~]#
    [root@tutorial ~]# mariadb -u root -p
    Enter password: #ISI Password Mariadb
    Welcome to the MariaDB monitor. Commands end with ; or \g.
    Your MariaDB connection id is 17
    Server version: 10.5.5-MariaDB MariaDB Server
    
    Copyright (c) 2000, 2018, Oracle, MariaDB Corporation Ab and others.
    
    Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.
    
    MariaDB [(none)]>

Kamia akan berikut contoh membuat database dan user serta assign user ke database, dengan skema sebagai berikut _ **testdb** _ adalah nama database, _ **testuser** _ adalah user/pengguna, _ **password** _ adalah kata sandi user/pengguna, Anda harus mengubah kata sandi dengan kata sandi yang aman atau sesuai keinginan:

    MariaDB [(none)]>
    MariaDB [(none)]> create database testdb;
    Query OK, 1 row affected (0.002 sec)
    
    MariaDB [(none)]> create user 'testuser'@localhost identified by 'password';
    Query OK, 0 rows affected (0.004 sec)
    
    MariaDB [(none)]> grant all on testdb.* to 'testuser' identified by 'password';
    Query OK, 0 rows affected (0.006 sec)
    
    MariaDB [(none)]> quit
    Bye
    [root@tutorial ~]#

Sekarang login menggunakan user _ **testuser** _

    [root@tutorial ~]#
    [root@tutorial ~]# mysql -u testuser -p
    Enter password:
    Welcome to the MariaDB monitor. Commands end with ; or \g.
    Your MariaDB connection id is 18
    Server version: 10.5.5-MariaDB MariaDB Server
    
    Copyright (c) 2000, 2018, Oracle, MariaDB Corporation Ab and others.
    
    Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.
    
    MariaDB [(none)]>

Sekarang kita akan mencoba membuat sample tabel (customer) di dalam database yang suda kita buat sebelumnya

    MariaDB [(none)]> use testdb;
    Database changed
    MariaDB [testdb]> CREATE TABLE customers (customer_id INT NOT NULL AUTO_INCREMENT PRIMARY KEY, first_name TEXT, last_name TEXT);
    Query OK, 0 rows affected (0.079 sec)
    
    MariaDB [testdb]>

Untuk melihat tabel berikut perintah nya

    MariaDB [testdb]> show tables;
    +------------------+
    | Tables_in_testdb |
    +------------------+
    | customers |
    +------------------+
    1 row in set (0.001 sec)
    
    MariaDB [testdb]>

Tambahkan data ke tabel customer

    MariaDB [testdb]> INSERT INTO customers (first_name, last_name) VALUES ('John', 'Doe');
    Query OK, 1 row affected (0.007 sec)
    
    MariaDB [testdb]>

Lihat data tabel customer

    MariaDB [testdb]> SELECT * FROM customers;
    +-------------+------------+-----------+
    | customer_id | first_name | last_name |
    +-------------+------------+-----------+
    | 1 | John | Doe |
    +-------------+------------+-----------+
    1 row in set (0.001 sec)
    
    MariaDB [testdb]>

Untuk keluar dari MariaDB bisa menggunakan _quit atau exit_

    MariaDB [testdb]> quit
    Bye
    [root@tutorial ~]#

Selamat mencoba 😄

Please follow and like us:

[![error](/wp-content/plugins/ultimate-social-media-icons/images/follow_subscribe.png)](https://api.follow.it/widgets/icon/VHc3d1lpVGdwRnE5QnV0eERCNUx5RCtvTTVoUkNYS3NNRmd5eVhlQW9tNXRHS3VTbGh6Y0NybkRJRS8zSGpjRDVZb1ZGMlNTSEpJYUpuZzZqNzdnd3VSN3dwM2VlQTF6ejJEaGV5UGRUbnlEcHFNd3luYTV4ZTZtUGowVWI2Q2x8M2kzdnBEeUIrUk5xOFI5TXZ3cHF3bFNQRkRJSGhUNGdrRFd0TlNtdE1OWT0=/OA==/)

[![fb-share-icon](/wp-content/plugins/ultimate-social-media-icons/images/visit_icons/fbshare_bck.png "Facebook Share")](https://www.facebook.com/sharer/sharer.php?u=https%3A%2F%2Fbelajarlinux.id%2F%3Fp%3D140%26ghostexport%3Dtrue%26submit%3DDownload+Ghost+File)

[![Tweet](/wp-content/plugins/ultimate-social-media-icons/images/visit_icons/en_US_Tweet.svg "Tweet")](https://twitter.com/intent/tweet?text=Cara+Instalasi+Database+MariaDB+di+CentOS+8+https://belajarlinux.id/?p=140&ghostexport=true&submit=Download Ghost File)

[![fb-share-icon](/wp-content/plugins/ultimate-social-media-icons/images/share_icons/Pinterest_Save/en_US_save.svg "Pin Share")](#)

<!--kg-card-end: html-->
---
layout: post
title: Cara Instalasi Database MySQL di CentOS 8
featured: true
date: '2020-08-22 11:34:08'
tags:
- centos
- database
---

MySQL adalah Sebuah program database server yang mampu menerima dan mengirimkandatanya sangat cepat, multi user serta menggunakan peintah dasar SQL (Structured Query Language).

MySQL merupakan dua bentuk lisensi, yaitu _free Software_ dan _Shareware_. MySQL yang biasa kita gunakan adalah MySQL _Free Software_ yang berada dibawah Lisensi GNU/GPL (General Public License).

MySQL Merupakan sebuah database server yang free, artinya kita bebas menggunakan database ini untuk keperluan pribadi atau usaha tanpa harus membeli atau membayar lisensinya. MySQL pertama kali dirintis oleh seorang programmer database bernama Michael Widenius .

Selain database server, MySQl juga merupakan program yang dapat mengakses suatu database MySQL yang berposisi sebagai Server, yang berarti program kita berposisi sebagai Client.

Jadi MySQL adalah sebuah database yang dapat digunakan sebagai Client mupun server. Database MySQL merupakan suatu perangkat lunak database yang berbentuk database relasional atau disebut Relational Database Management System (RDBMS) yang menggunakan suatu bahasa permintaan yang bernama SQL (Structured Query Language).

## # Kelebihan MySQL

Database MySQL memiliki beberapa kelebihan dibanding database lain, diantaranya:

- MySQL merupakan Database Management System (DBMS)
- MySQL sebagai Relation Database Management System (RDBMS) atau disebut dengandatabase Relational
- MySQL Merupakan sebuah database server yang free, artinya kita bebas menggunakandatabase ini untuk keperluan pribadi atau usaha tanpa harus membeli atau membayarlisensinya
- MySQL merupakan sebuah database client
- MySQL mampu menerima query yang bertupuk dalam satu permintaan atau Multi-Threading.

## # Instalasi MySQL

Secara default di repository Appstream CentOS 8 MySQL versi 8.0 sudah tersedia, jika Anda ingin menggunakan MySQL sesuai versi yang Anda inginkan Anda dapat install secara manual dari pengembang MySQL yang dapat Anda unduh repositorinya melalui link berikut: https://dev.mysql.com/downloads/repo/yum/

Untuk melihat repository yang tersedia di Appstream CentOS 8 gunakan perintah berikut

    [root@tutorial ~]#
    [root@tutorial ~]# dnf search mysql
    Last metadata expiration check: 0:10:31 ago on Sat Aug 22 03:58:05 2020.
    ============================================================= Name & Summary Matched: mysql ==============================================================
    mysql.x86_64 : MySQL client programs and shared libraries
    grafana-mysql.x86_64 : Grafana mysql datasource
    postfix-mysql.x86_64 : Postfix MySQL map support
    rsyslog-mysql.x86_64 : MySQL support for rsyslog
    dovecot-mysql.x86_64 : MySQL back end for dovecot
    perl-DBD-MySQL.x86_64 : A MySQL interface for Perl
    freeradius-mysql.x86_64 : MySQL support for freeradius
    mysql-server.x86_64 : The MySQL server and related files
    mysql-test.x86_64 : The test suite distributed with MySQL
    python2-PyMySQL.noarch : Pure-Python MySQL client library
    python3-PyMySQL.noarch : Pure-Python MySQL client library
    python38-PyMySQL.noarch : Pure-Python MySQL client library
    apr-util-mysql.x86_64 : APR utility library MySQL DBD driver
    qt5-qtbase-mysql.i686 : MySQL driver for Qt5's SQL classes
    qt5-qtbase-mysql.x86_64 : MySQL driver for Qt5's SQL classes
    rubygem-mysql2-doc.noarch : Documentation for rubygem-mysql2
    mysql-devel.x86_64 : Files for development of MySQL applications
    mysql-libs.x86_64 : The shared libraries required for MySQL clients
    pcp-pmda-mysql.x86_64 : Performance Co-Pilot (PCP) metrics for MySQL
    mysql-errmsg.x86_64 : The error messages files required by MySQL server
    mysql-common.x86_64 : The shared files required for MySQL server and client
    php-mysqlnd.x86_64 : A module for PHP applications that use MySQL databases
    rubygem-mysql2.x86_64 : A simple, fast Mysql library for Ruby, binding to libmysql
    ================================================================= Summary Matched: mysql =================================================================
    mariadb-devel.x86_64 : Files for development of MariaDB/MySQL applications
    mariadb-server-utils.x86_64 : Non-essential server utilities for MariaDB/MySQL applications
    mariadb-java-client.noarch : Connects applications developed in Java to MariaDB and MySQL databases
    [root@tutorial ~]#

Terliat diatas sudah tersedia dan Anda dapat langsung install MySQL dengan cara menjalankan perintah

    [root@tutorial ~]#
    [root@tutorial ~]# dnf install @mysql -y 

Silakan tunggu proses instalasi sampai selesai. Jika sudah silakan start dan pastikan MySQL running

    [root@tutorial ~]#
    [root@tutorial ~]# systemctl start mysqld
    [root@tutorial ~]# systemctl status mysqld
    ● mysqld.service - MySQL 8.0 database server
       Loaded: loaded (/usr/lib/systemd/system/mysqld.service; disabled; vendor preset: disabled)
       Active: active (running) since Sat 2020-08-22 04:18:37 UTC; 6s ago
      Process: 6928 ExecStartPost=/usr/libexec/mysql-check-upgrade (code=exited, status=0/SUCCESS)
      Process: 6799 ExecStartPre=/usr/libexec/mysql-prepare-db-dir mysqld.service (code=exited, status=0/SUCCESS)
      Process: 6775 ExecStartPre=/usr/libexec/mysql-check-socket (code=exited, status=0/SUCCESS)
     Main PID: 6886 (mysqld)
       Status: "Server is operational"
        Tasks: 39 (limit: 23814)
       Memory: 534.8M
       CGroup: /system.slice/mysqld.service
               └─6886 /usr/libexec/mysqld --basedir=/usr
    
    Aug 22 04:18:29 tutorial.nurhamim.my.id systemd[1]: Starting MySQL 8.0 database server...
    Aug 22 04:18:29 tutorial.nurhamim.my.id mysql-prepare-db-dir[6799]: Initializing MySQL database
    Aug 22 04:18:37 tutorial.nurhamim.my.id systemd[1]: Started MySQL 8.0 database server.
    [root@tutorial ~]#

Supaya service MySQL tetap running apabila VM di reboot silakan enable service MySQL.

    [root@tutorial ~]# systemctl enable mysqld
    Created symlink /etc/systemd/system/multi-user.target.wants/mysqld.service → /usr/lib/systemd/system/mysqld.service.
    [root@tutorial ~]#

Selanjutnya menentukan root password MySQL sebagai berikut

    [root@tutorial ~]#
    [root@tutorial ~]# mysql_secure_installation
    
    Securing the MySQL server deployment.
    
    Connecting to MySQL using a blank password.
    
    VALIDATE PASSWORD COMPONENT can be used to test passwords
    and improve security. It checks the strength of password
    and allows the users to set only those passwords which are
    secure enough. Would you like to setup VALIDATE PASSWORD component?
    
    Press y|Y for Yes, any other key for No: y
    
    There are three levels of password validation policy:
    
    LOW Length >= 8
    MEDIUM Length >= 8, numeric, mixed case, and special characters
    STRONG Length >= 8, numeric, mixed case, special characters and dictionary file
    
    Please enter 0 = LOW, 1 = MEDIUM and 2 = STRONG: 2
    Please set the password for root here.
    
    New password: #Isi password root MySQL
    
    Re-enter new password: #Konfirmasi password root MySQL
    
    Estimated strength of the password: 100
    Do you wish to continue with the password provided?(Press y|Y for Yes, any other key for No) : Y
    By default, a MySQL installation has an anonymous user,
    allowing anyone to log into MySQL without having to have
    a user account created for them. This is intended only for
    testing, and to make the installation go a bit smoother.
    You should remove them before moving into a production
    environment.
    
    Remove anonymous users? (Press y|Y for Yes, any other key for No) : Y
    Success.
    
    
    Normally, root should only be allowed to connect from
    'localhost'. This ensures that someone cannot guess at
    the root password from the network.
    
    Disallow root login remotely? (Press y|Y for Yes, any other key for No) : Y
    Success.
    
    By default, MySQL comes with a database named 'test' that
    anyone can access. This is also intended only for testing,
    and should be removed before moving into a production
    environment.
    
    
    Remove test database and access to it? (Press y|Y for Yes, any other key for No) : Y
     - Dropping test database...
    Success.
    
     - Removing privileges on test database...
    Success.
    
    Reloading the privilege tables will ensure that all changes
    made so far will take effect immediately.
    
    Reload privilege tables now? (Press y|Y for Yes, any other key for No) : Y
    Success.
    
    All done!
    [root@tutorial ~]#

Test login menggunakan user root MySQL dan password yang sudah dibuat baru saja

    [root@tutorial ~]#
    [root@tutorial ~]# mysql -u root -p
    Enter password:
    Welcome to the MySQL monitor. Commands end with ; or \g.
    Your MySQL connection id is 10
    Server version: 8.0.17 Source distribution
    
    Copyright (c) 2000, 2019, Oracle and/or its affiliates. All rights reserved.
    
    Oracle is a registered trademark of Oracle Corporation and/or its
    affiliates. Other names may be trademarks of their respective
    owners.
    
    Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.
    
    mysql>

Untuk mengetahui versi MySQL gunakan perintah berikut:

    [root@tutorial ~]#
    [root@tutorial ~]# mysql --version
    mysql Ver 8.0.17 for Linux on x86_64 (Source distribution)
    [root@tutorial ~]#

Saat ini MySQL sudah berhasil terinstall.

Selamat mencoba 😁

Please follow and like us:

[![error](/wp-content/plugins/ultimate-social-media-icons/images/follow_subscribe.png)](https://api.follow.it/widgets/icon/VHc3d1lpVGdwRnE5QnV0eERCNUx5RCtvTTVoUkNYS3NNRmd5eVhlQW9tNXRHS3VTbGh6Y0NybkRJRS8zSGpjRDVZb1ZGMlNTSEpJYUpuZzZqNzdnd3VSN3dwM2VlQTF6ejJEaGV5UGRUbnlEcHFNd3luYTV4ZTZtUGowVWI2Q2x8M2kzdnBEeUIrUk5xOFI5TXZ3cHF3bFNQRkRJSGhUNGdrRFd0TlNtdE1OWT0=/OA==/)

[![fb-share-icon](/wp-content/plugins/ultimate-social-media-icons/images/visit_icons/fbshare_bck.png "Facebook Share")](https://www.facebook.com/sharer/sharer.php?u=https%3A%2F%2Fbelajarlinux.id%2F%3Fp%3D147%26ghostexport%3Dtrue%26submit%3DDownload+Ghost+File)

[![Tweet](/wp-content/plugins/ultimate-social-media-icons/images/visit_icons/en_US_Tweet.svg "Tweet")](https://twitter.com/intent/tweet?text=Cara+Instalasi+Database+MySQL+di+CentOS+8+https://belajarlinux.id/?p=147&ghostexport=true&submit=Download Ghost File)

[![fb-share-icon](/wp-content/plugins/ultimate-social-media-icons/images/share_icons/Pinterest_Save/en_US_save.svg "Pin Share")](#)

<!--kg-card-end: html-->
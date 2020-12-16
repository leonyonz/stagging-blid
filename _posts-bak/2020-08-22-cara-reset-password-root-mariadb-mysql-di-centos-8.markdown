---
layout: post
title: Cara Reset Password Root MariaDB/MySQL di CentOS 8
featured: true
date: '2020-08-22 14:04:42'
tags:
- centos
- database
---

Sebagai manusia yang tidak luput dari kesempurnaan ini pasti kita akan mengalami yang namanya **_LUPA_ ,** ya lupa memang menjadi hal yang tidak diinginkan semua orang.

Jika Anda lupa password pada MariaDB atau MySQL Anda dapat mengikuti tutorial ini.

Untuk mengikuti tutorial ini pastikan Anda sudah melakukan instalasi MariaDB, jika belum silakan mengikuti referensi berikut: **_[Cara Instalasi Database MariaDB di CentOS 8](/cara-instalasi-database-mariadb-di-centos-8/)_**

Perlu di catat untuk reset password root database mariadb akan mengalami downtime pada mariadb Anda, karena kita perlu stop mariadb terlebih dahulu detailnya sebagai berikut

    [root@tutorial ~]#
    [root@tutorial ~]# systemctl stop mysqld
    [root@tutorial ~]# systemctl status mysqld |grep Active
       Active: inactive (dead) since Sat 2020-08-22 05:29:08 UTC; 39s ago
    [root@tutorial ~]#

Kemudian, login ke user mysql dengan cara berikut

    [root@tutorial ~]#
    [root@tutorial ~]# mysqld --skip-grant-tables --user=mysql &
    [1] 7361
    [root@tutorial ~]# mysql
    Welcome to the MySQL monitor. Commands end with ; or \g.
    Your MySQL connection id is 7
    Server version: 8.0.17 Source distribution
    
    Copyright (c) 2000, 2019, Oracle and/or its affiliates. All rights reserved.
    
    Oracle is a registered trademark of Oracle Corporation and/or its
    affiliates. Other names may be trademarks of their respective
    owners.
    
    Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.
    
    mysql>

Selanjutnya jalankan perintah berikut

    mysql> FLUSH PRIVILEGES;
    Query OK, 0 rows affected (0.01 sec)
    
    mysql>

Atur ulang password root MySQL

    mysql>
    mysql> ALTER USER 'root'@'localhost' IDENTIFIED BY 'your_preferred_password';
    ERROR 1819 (HY000): Your password does not satisfy the current policy requirements
    mysql>

Jika terdapat error seperti diatas silakan ubah _validasi password_ menjadi _low_ gunakan perintah berikut

    mysql>
    mysql> SET GLOBAL validate_password.policy=LOW
        -> ;
    Query OK, 0 rows affected (0.00 sec)
    
    mysql>

Jika sudah silakan jalankan kembali perintah untuk atur password root baru

    mysql> ALTER USER 'root'@'localhost' IDENTIFIED BY 'IsikanPasswordBaru';
    Query OK, 0 rows affected (0.03 sec)
    
    mysql> quit
    Bye
    [root@tutorial ~]#

Selanjutnya kill proses _–skip-grant-tables_

    [root@tutorial ~]#
    [root@tutorial ~]# ps aux | grep mysqld
    mysql 13591 0.5 10.5 2195896 407232 pts/1 Sl 06:55 0:01 mysqld --skip-grant-tables --user=mysql
    root 13784 0.0 0.0 229056 980 pts/1 S+ 06:59 0:00 grep --color=auto mysqld
    [root@tutorial ~]#
    [root@tutorial ~]# kill -9 13591
    [root@tutorial ~]#
    [1]+ Killed mysqld --skip-grant-tables --user=mysql
    [root@tutorial ~]#

Jika sudah silakan stop dan start kembali MySQL pastikan running

    [root@tutorial ~]# systemctl stop mysqld.service
    [root@tutorial ~]# systemctl start mysqld.service
    [root@tutorial ~]#
    [root@tutorial ~]# systemctl status mysqld.service
    ● mysqld.service - MySQL 8.0 database server
       Loaded: loaded (/usr/lib/systemd/system/mysqld.service; disabled; vendor preset: disabled)
       Active: active (running) since Sat 2020-08-22 07:00:40 UTC; 13s ago
      Process: 13722 ExecStopPost=/usr/libexec/mysql-wait-stop (code=exited, status=0/SUCCESS)
      Process: 13975 ExecStartPost=/usr/libexec/mysql-check-upgrade (code=exited, status=0/SUCCESS)
      Process: 13895 ExecStartPre=/usr/libexec/mysql-prepare-db-dir mysqld.service (code=exited, status=0/SUCCESS)
      Process: 13869 ExecStartPre=/usr/libexec/mysql-check-socket (code=exited, status=0/SUCCESS)
     Main PID: 13931 (mysqld)
       Status: "Server is operational"
        Tasks: 39 (limit: 23814)
       Memory: 394.9M
       CGroup: /system.slice/mysqld.service
               └─13931 /usr/libexec/mysqld --basedir=/usr
    
    Aug 22 07:00:39 tutorial.nurhamim.my.id systemd[1]: Starting MySQL 8.0 database server...
    Aug 22 07:00:39 tutorial.nurhamim.my.id mysql-check-socket[13869]: Socket file /var/lib/mysql/mysql.sock exists.
    Aug 22 07:00:39 tutorial.nurhamim.my.id mysql-check-socket[13869]: No process is using /var/lib/mysql/mysql.sock, which means it is a garbage, so it will>
    Aug 22 07:00:40 tutorial.nurhamim.my.id systemd[1]: Started MySQL 8.0 database server.

Uji coba login ke MySQL menggunakan password root yang baru

    [root@tutorial ~]#
    [root@tutorial ~]# mysql -u root -p
    Enter password:
    Welcome to the MySQL monitor. Commands end with ; or \g.
    Your MySQL connection id is 8
    Server version: 8.0.17 Source distribution
    
    Copyright (c) 2000, 2019, Oracle and/or its affiliates. All rights reserved.
    
    Oracle is a registered trademark of Oracle Corporation and/or its
    affiliates. Other names may be trademarks of their respective
    owners.
    
    Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.
    
    mysql>

Selamat password MySQL Anda sudah berhasil di reset.

Selamat mencoba 😁

Please follow and like us:

[![error](/wp-content/plugins/ultimate-social-media-icons/images/follow_subscribe.png)](https://api.follow.it/widgets/icon/VHc3d1lpVGdwRnE5QnV0eERCNUx5RCtvTTVoUkNYS3NNRmd5eVhlQW9tNXRHS3VTbGh6Y0NybkRJRS8zSGpjRDVZb1ZGMlNTSEpJYUpuZzZqNzdnd3VSN3dwM2VlQTF6ejJEaGV5UGRUbnlEcHFNd3luYTV4ZTZtUGowVWI2Q2x8M2kzdnBEeUIrUk5xOFI5TXZ3cHF3bFNQRkRJSGhUNGdrRFd0TlNtdE1OWT0=/OA==/)

[![fb-share-icon](/wp-content/plugins/ultimate-social-media-icons/images/visit_icons/fbshare_bck.png "Facebook Share")](https://www.facebook.com/sharer/sharer.php?u=https%3A%2F%2Fbelajarlinux.id%2F%3Fp%3D145%26ghostexport%3Dtrue%26submit%3DDownload+Ghost+File)

[![Tweet](/wp-content/plugins/ultimate-social-media-icons/images/visit_icons/en_US_Tweet.svg "Tweet")](https://twitter.com/intent/tweet?text=Cara+Reset+Password+Root+MariaDB%2FMySQL+di+CentOS+8+https://belajarlinux.id/?p=145&ghostexport=true&submit=Download Ghost File)

[![fb-share-icon](/wp-content/plugins/ultimate-social-media-icons/images/share_icons/Pinterest_Save/en_US_save.svg "Pin Share")](#)

<!--kg-card-end: html-->
---
layout: post
title: Cara Konfigurasi Replikasi MariaDB Master - Slave di CentOS 8
featured: true
date: '2020-08-30 21:02:23'
tags:
- centos
- database
---

MariaDB adalah sistem manajemen database relasional yang bersifat open source artinya dapat Anda gunakan secara bebas untuk kebutuhan database server.

Replikasi adalah fitur yang ada di MariaDB yang memungkinkan data di satu server di replikasi ke server yang lainnya. Ada beberapa jenis replikasi di MariaDB diantaranya:

- Master-slave replication
- Master-master replication
- Multi-source replication
- Circular replication

> **_Baca Juga: [Cara Konfigurasi Replikasi MariaDB Master – Master di CentOS 8](/cara-konfigurasi-replikasi-mariadb-master-master-di-centos-8/)_**

Replikasi Master – Slave adalah jenis replikasi dimana data direplikasi hanya satu arah, server yang mereplikasi data dari server lain disebut _slave,_ sedangkan server lain di sebut _master._

Perubahan data terjadi di server master, dan server slave secara otomatis mereplikasi perubahan dari server master, Anda masih dapat melakukan perubahan di server slave namun tidak akan ada perubahan (replikasi) di sisi server master itulah yang disebut dengan _**(satu arah).**_

Replikasi Master – Slave dapat digunakan untuk beberapa tujuannya diantaranya:

- _ **Scalability:** Dengan menggunakan replikasi master – slave Anda dapat menentukan operasi tulis (write database) dilakukan di sisi server master, sedangkan untuk operasi baca (read database) di sisi server slave dan dapat disebar ke seluruh server slave, tujuannya untuk meningkatkan kinerja database server_
- _ **High availability:** Dengan menggunakan replikasi master – slave Anda dapat meningkatkan redundansi data untuk meningkatkan toleransi kesalahan yang terjadi_
- _ **Dedicated Backup:** Dengan menggunakan replikasi master – slave Anda dapat membuat lebih dari satu slave, salah satu kegunaannya yaitu sebagai cadangan atau backup database master Anda, karena di sisi slave tidak akan ada perubahan atau query apapun, selain itu dapat juga di jadwalkan backup di sisi slave dan tidak akan mengganggu (interrupted) dari segi beban kerja baik di master dan slave._ 

Pada tutorial kali ini kami akan menggunakan 2 VM untuk kebutuhan Master – Slave detailnya sebagai berikut:

1. VM db-master, IP: 192.168.10.9
2. VM db-slave, IP: 192.168.10.21

Sebelum mengikuti tutorial kali ini pastikan Anda sudah melakukan instalasi mariadb di masing – masing VM db-master dan db-slave, jika belum melakukan instalasi silakan merujuk pada link berikut: _**[Cara Instalasi Database MariaDB di CentOS 8](/cara-instalasi-database-mariadb-di-centos-8/)**_

Pastikan mariadb telah running di masing – masing VM

    ## VM Master
    -------------
    [root@db-master ~]# systemctl status mariadb |grep Active
       Active: active (running) since Sat 2020-08-29 13:56:03 UTC; 23h ago
    [root@db-master ~]#
    
    ## VM Slave
    -------------
    [root@db-slave ~]# systemctl status mariadb |grep Active
       Active: active (running) since Sun 2020-08-30 12:58:31 UTC; 31min ago
    [root@db-slave ~]#

Selanjutnya konfigurasi dan menentukan server-id serta bin-log di masing – masing VM db-master dan db-slave

#### # VM Master

Buka file mariadb server di direktori _/etc/my.cnf.d_ seperti berikut

    [root@db-master ~]#
    [root@db-master ~]# vim /etc/my.cnf.d/mariadb-server.cnf

Selanjutnya tambahkan konfigurasi untuk mengaktifkan log binary, relay log dan replikasi master di bawah _[mysqld]_

    # this is read by the standalone daemon and embedded servers
    [server]
    
    # this is only for the mysqld standalone daemon
    # Settings user and group are ignored when systemd is used.
    # If you need to run mysqld under a different user or group,
    # customize your systemd unit file for mysqld/mariadb according to the
    # instructions in http://fedoraproject.org/wiki/Systemd
    [mysqld]
    server-id = 1
    report_host = master
    log_bin = /var/lib/mysql/mariadb-bin
    log_bin_index = /var/lib/mysql/mariadb-bin.index
    relay_log = /var/lib/mysql/relay-bin
    relay_log_index = /var/lib/mysql/relay-bin.index

Simpan dan lakukan restart mariadb Anda

    [root@db-master ~]#
    [root@db-master ~]# systemctl restart mariadb

#### # VM Slave

Buka file mariadb- server sama seperti langkah sebelumnya di VM master

    [root@db-slave ~]#
    [root@db-slave ~]# vim /etc/my.cnf.d/mariadb-server.cnf

Tambah dan edit konfigurasi di sisi slave sebagai berikut

    # this is read by the standalone daemon and embedded servers
    [server]
    
    # this is only for the mysqld standalone daemon
    # Settings user and group are ignored when systemd is used.
    # If you need to run mysqld under a different user or group,
    # customize your systemd unit file for mysqld/mariadb according to the
    # instructions in http://fedoraproject.org/wiki/Systemd
    [mysqld]
    server-id = 2
    report_host = slave
    log_bin = /var/lib/mysql/mariadb-bin
    log_bin_index = /var/lib/mysql/mariadb-bin.index
    relay_log = /var/lib/mysql/relay-bin
    relay_log_index = /var/lib/mysql/relay-bin.index

Restart mariadb server

    [root@db-slave ~]#
    [root@db-slave ~]# systemctl restart mariadb

Selanjutnya membuat user yang yang akan di replikasi atau hubungkan dari master ke slave.

#### # VM Master

Silakan akses mariadb Anda bisa menggunakan user root seperti berikut

    [root@db-master ~]#
    [root@db-master ~]# mysql -u root -p
    Enter password:
    Welcome to the MariaDB monitor. Commands end with ; or \g.
    Your MariaDB connection id is 23
    Server version: 10.3.17-MariaDB-log MariaDB Server
    
    Copyright (c) 2000, 2018, Oracle, MariaDB Corporation Ab and others.
    
    Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.
    
    MariaDB [(none)]>
    MariaDB [(none)]>

Buat user replikasi yang diarahkan ke ip VM slave

    MariaDB [(none)]>
    MariaDB [(none)]> GRANT REPLICATION SLAVE ON *.* TO 'test_master'@'192.168.10.21' IDENTIFIED BY 'test_master';
    Query OK, 0 rows affected (0.002 sec)
    
    MariaDB [(none)]> FLUSH PRIVILEGES;
    Query OK, 0 rows affected (0.001 sec)
    
    MariaDB [(none)]>

_Noted: Silakan catat username (test\_master) dan password (test\_master) diatas, lalu pastikan Anda sudah input IP VM slave dengan benar._

Selanjutnya lock operasi read di VM Master

    MariaDB [(none)]> FLUSH TABLES WITH READ LOCK;
    Query OK, 0 rows affected (0.001 sec)
    
    MariaDB [(none)]>

Cek status master

    MariaDB [(none)]>
    MariaDB [(none)]> SHOW MASTER STATUS\G
    ***************************1. row***************************
                File: mariadb-bin.000001
            Position: 1664
        Binlog_Do_DB:
    Binlog_Ignore_DB:
    1 row in set (0.000 sec)
    
    MariaDB [(none)]>

_Noted: Cata isi dari **File** dan **Position** yang akan digunakan nantinya untuk menghubungkan slave ke master._

Jika sudah silakan exit, dan lakukan dump database server master menggunakan command _mysqldump_ seperti berikut

    [root@db-master ~]#
    [root@db-master ~]# mysqldump --all-databases --user=root --password --master-data >> backupdbmaster.sql
    Enter password:
    [root@db-master ~]#

Jika sudah silakan login kembali ke sisi mariadb Master dan unlock tabel yang sudah di lock sebelumnya

    [root@db-master ~]# mysql -u root -p
    Enter password:
    Welcome to the MariaDB monitor. Commands end with ; or \g.
    Your MariaDB connection id is 23
    Server version: 10.3.17-MariaDB-log MariaDB Server
    
    Copyright (c) 2000, 2018, Oracle, MariaDB Corporation Ab and others.
    
    Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.
    
    MariaDB [(none)]> UNLOCK TABLES;
    Query OK, 0 rows affected (0.000 sec)
    
    MariaDB [(none)]> exit
    Bye
    [root@db-master ~]#

Berikutnya, copy file dump master ke VM slave Anda bisa menggunakan scp contohnya

    [root@db-master ~]#
    [root@db-master ~]# scp -i ~/.ssh/id_rsa backupdbmaster.sql centos@192.168.10.21:/home/centos/
    The authenticity of host '192.168.10.21 (192.168.10.21)' can't be established.
    ECDSA key fingerprint is SHA256:Tnzv0IX+t09N1MBi5MI8TlXj+Eo3oPrnzgCUhVYE6cE.
    Are you sure you want to continue connecting (yes/no/[fingerprint])? yes
    Warning: Permanently added '192.168.10.21' (ECDSA) to the list of known hosts.
    backupdbmaster.sql 100% 469KB 14.9MB/s 00:00
    [root@db-master ~]#

#### # VM Slave

Memastikan file dump sudah ada dan melakukan restore file dump tersebut seperti berikut

    [root@db-slave ~]#
    [root@db-slave ~]# cd /home/centos/
    [root@db-slave centos]#
    [root@db-slave centos]# mysql -u root -p < backupdbmaster.sql
    Enter password:
    [root@db-slave centos]# 

Jika sudah silakan restart mariadb Anda

    [root@db-slave centos]# systemctl restart mariadb
    [root@db-slave centos]#

Selanjutnya login ke mariadb dan create replikasi atau menghubungkan slave ke master

    [root@db-slave centos]#
    [root@db-slave centos]# mysql -u root -p
    Enter password:
    Welcome to the MariaDB monitor. Commands end with ; or \g.
    Your MariaDB connection id is 9
    Server version: 10.3.17-MariaDB-log MariaDB Server
    
    Copyright (c) 2000, 2018, Oracle, MariaDB Corporation Ab and others.
    
    Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.
    
    MariaDB [(none)]> 

Stop slave terlebih dahulu

    MariaDB [(none)]> stop slave;
    Query OK, 0 rows affected, 1 warning (0.000 sec)
    
    MariaDB [(none)]> 

Hubungkan dabatase slave ke database master

    MariaDB [(none)]> change master to master_host='192.168.10.9',master_user='test_master',master_password='test_master',master_log_file='mariadb-bin.000001',master_log_pos=1664;
    Query OK, 0 rows affected (0.016 sec)
    
    MariaDB [(none)]>

_ **Keterangan:** _

> _ **master-host:** Isikan IP VM master.  
> **master** – **master\_user:** Isi dengan user yang dibuat sebelumnya di **master\_password:** Isi dengan password yang telah dibuat sebelumnya di master.  
> **master\_log\_file:** Isi dengan file log yang didapatkan di status master.  
> **master-log\_pos:** Isi dengan number position yang didapatkan di status master._

Jika sudah silakan start kembali slave nya

    MariaDB [(none)]> start slave;
    Query OK, 0 rows affected (0.003 sec)
    
    MariaDB [(none)]>

Cek status slave pastikan tidak ada yang error seperti berikut:

    MariaDB [(none)]> show slave status \G
    ***************************1. row***************************
                    Slave_IO_State: NULL
                       Master_Host: 192.168.10.9
                       Master_User: test_master
                       Master_Port: 3306
                     Connect_Retry: 60
                   Master_Log_File: mariadb-bin.000001
               Read_Master_Log_Pos: 1664
                    Relay_Log_File: relay-bin.002800
                     Relay_Log_Pos: 557
             Relay_Master_Log_File: mariadb-bin.000001
                  Slave_IO_Running: Yes
                 Slave_SQL_Running: Yes
                   Replicate_Do_DB:
               Replicate_Ignore_DB:
                Replicate_Do_Table:
            Replicate_Ignore_Table:
           Replicate_Wild_Do_Table:
       Replicate_Wild_Ignore_Table:
                        Last_Errno: 0
                        Last_Error:
                      Skip_Counter: 0
               Exec_Master_Log_Pos: 1664
                   Relay_Log_Space: 1161
                   Until_Condition: None
                    Until_Log_File:
                     Until_Log_Pos: 0
                Master_SSL_Allowed: No
                Master_SSL_CA_File:
                Master_SSL_CA_Path:
                   Master_SSL_Cert:
                 Master_SSL_Cipher:
                    Master_SSL_Key:
             Seconds_Behind_Master: 0
     Master_SSL_Verify_Server_Cert: No
                     Last_IO_Errno: 0
                     Last_IO_Error:
                    Last_SQL_Errno: 0
                    Last_SQL_Error:
       Replicate_Ignore_Server_Ids:
                  Master_Server_Id: 1
                    Master_SSL_Crl:
                Master_SSL_Crlpath:
                        Using_Gtid: No
                       Gtid_IO_Pos:
           Replicate_Do_Domain_Ids:
       Replicate_Ignore_Domain_Ids:
                     Parallel_Mode: conservative
                         SQL_Delay: 0
               SQL_Remaining_Delay: NULL
           Slave_SQL_Running_State: Slave has read all relay log; waiting for the slave I/O thread to update it
                  Slave_DDL_Groups: 0
    Slave_Non_Transactional_Groups: 0
        Slave_Transactional_Groups: 0
    1 row in set (0.005 sec)
    
    MariaDB [(none)]>

#### # Percobaan Replikasi

Silakan membuat database di sisi master dan lihat di di sisi slave jika ada maka replikasi database master – slave sudah berjalan contohnya di gambar berikut

<figure class="wp-block-image size-large"><img loading="lazy" width="1024" height="514" src="/content/images/wordpress/2020/08/1-6-1024x514.png" alt="" class="wp-image-377" srcset="/content/images/wordpress/2020/08/1-6-1024x514.png 1024w, /content/images/wordpress/2020/08/1-6-300x151.png 300w, /content/images/wordpress/2020/08/1-6-768x386.png 768w, /content/images/wordpress/2020/08/1-6.png 1366w" sizes="(max-width: 1024px) 100vw, 1024px"></figure>

Sebaliknya silakan Anda buat database di slave seharusnya di master tidak akan tereplikasi seperti pada gambar berikut

<figure class="wp-block-image size-large"><img loading="lazy" width="1024" height="553" src="/content/images/wordpress/2020/08/2-6-1024x553.png" alt="" class="wp-image-378" srcset="/content/images/wordpress/2020/08/2-6-1024x553.png 1024w, /content/images/wordpress/2020/08/2-6-300x162.png 300w, /content/images/wordpress/2020/08/2-6-768x415.png 768w, /content/images/wordpress/2020/08/2-6.png 1366w" sizes="(max-width: 1024px) 100vw, 1024px"></figure>

Selamat saat ini Anda sudah berhasil melakukan konfigurasi database mariadb master – slave.

Selamat mencoba 😁

Please follow and like us:

[![error](/wp-content/plugins/ultimate-social-media-icons/images/follow_subscribe.png)](https://api.follow.it/widgets/icon/VHc3d1lpVGdwRnE5QnV0eERCNUx5RCtvTTVoUkNYS3NNRmd5eVhlQW9tNXRHS3VTbGh6Y0NybkRJRS8zSGpjRDVZb1ZGMlNTSEpJYUpuZzZqNzdnd3VSN3dwM2VlQTF6ejJEaGV5UGRUbnlEcHFNd3luYTV4ZTZtUGowVWI2Q2x8M2kzdnBEeUIrUk5xOFI5TXZ3cHF3bFNQRkRJSGhUNGdrRFd0TlNtdE1OWT0=/OA==/)

[![fb-share-icon](/wp-content/plugins/ultimate-social-media-icons/images/visit_icons/fbshare_bck.png "Facebook Share")](https://www.facebook.com/sharer/sharer.php?u=https%3A%2F%2Fbelajarlinux.id%2F%3Fp%3D375%26ghostexport%3Dtrue%26submit%3DDownload+Ghost+File)

[![Tweet](/wp-content/plugins/ultimate-social-media-icons/images/visit_icons/en_US_Tweet.svg "Tweet")](https://twitter.com/intent/tweet?text=Cara+Konfigurasi+Replikasi+MariaDB+Master+%26%238211%3B+Slave+di+CentOS+8+https://belajarlinux.id/?p=375&ghostexport=true&submit=Download Ghost File)

[![fb-share-icon](/wp-content/plugins/ultimate-social-media-icons/images/share_icons/Pinterest_Save/en_US_save.svg "Pin Share")](#)

<!--kg-card-end: html-->
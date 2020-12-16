---
layout: post
title: Cara Konfigurasi Replikasi MariaDB Master - Master di CentOS 8
featured: true
date: '2020-08-30 04:52:33'
tags:
- centos
- database
---

MariaDB adalah sistem manajemen database relasional yang dikembangkan dari MySQL. MariaDB dikembangkan oleh komunitas pengembang yang sebelumnya berkontribusi untuk database MySQL.

Di MariaDB terdapat beberapa macam metode replikasi yang dapat digunakan dan yang paling familiar yaitu replikasi database mariadb _ **master – slave** _ dan _ **master – master**._

Jika Anda ingin menggunakan master – master mariadb maka Anda perlu tahu terlebih dahulu kelebihan dan kekurangan diantaranya:

#### _# Kelebihan_

> _1. Aplikasi dapat membaca (read) dari semua node master_
> 
> _2. Mendistribusikan beban tulis (write) ke semua node master_
> 
> _3. Simple, automatic dan quick failover_

#### _# Kekurangan_

> _1. Konsisten secara longgar atau kurang kosisten._
> 
> _2. Tidak sesederhana replikasi master-slave dalam segi konfigurasi dan penerapannya._

Beberapa sumber menyebutkan penggunaan database master – master akan meningkatkan performa dari website Anda yang menggunakan database server.

Untuk mengikuti tutorial kali ini pastikan Anda sudah mempunyai 2 VM dan sudah melakukan instalasi database MariaDB, jika belum silakan mengikuti tutorial berikut: [_ **Cara Instalasi Database MariaDB di CentOS 8** _](/cara-instalasi-database-mariadb-di-centos-8/)

Berikut detail IP masing – masing VM yang akan digunakan

_IP Apps01(master): 192.168.10.9  
IP Apps02(master01): 192.168.10.18_

Pastikan semua service database di masing – masing VM Anda running

    ## Node Apps01 
    ---------------
    [root@apps01 ~]# systemctl status mariadb |grep Active
       Active: active (running) since Sat 2020-08-29 13:56:03 UTC; 7h ago
    [root@apps01 ~]#
    
    ## Node Apps02
    ---------------
    [root@apps02 ~]# systemctl status mariadb |grep Active
       Active: active (running) since Sat 2020-08-29 13:51:52 UTC; 7h ago
    [root@apps02 ~]#

Selanjutnya konfigurasi database mariadb di masing – masing VM

#### # Node Apps01 (Master)

Buka file _mariadb-server.conf_ untuk melakukan konfigurasi database mariadb

    [root@apps01 ~]#
    [root@apps01 ~]# vim /etc/my.cnf.d/mariadb-server.cnf

Tambahkan beberapa baris dibawah _[mysqld]_ detailnya seperti berikut

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
    
    #datadir=/var/lib/mysql
    #socket=/var/lib/mysql/mysql.sock
    #log-error=/var/log/mariadb/mariadb.log
    #pid-file=/run/mariadb/mariadb.pid

Simpan dan lakukan restart terhadap mariadb server

    [root@apps01 ~]#
    [root@apps01 ~]# systemctl restart mariadb
    [root@apps01 ~]#

#### # Node Apps02 (Master)

Tahapan ini sama dengan tahapan yang di VM Apps01 Anda hanya peru mengubah _server-id_ dan _repost\_host_ nya saja

    [root@apps02 ~]#
    [root@apps02 ~]# vim /etc/my.cnf.d/mariadb-server.cnf

Berikut full konfigurasinya

    # this is read by the standalone daemon and embedded servers
    [server]
    
    # this is only for the mysqld standalone daemon
    # Settings user and group are ignored when systemd is used.
    # If you need to run mysqld under a different user or group,
    # customize your systemd unit file for mysqld/mariadb according to the
    # instructions in http://fedoraproject.org/wiki/Systemd
    [mysqld]
    server-id = 2
    report_host = master2
    log_bin = /var/lib/mysql/mariadb-bin
    log_bin_index = /var/lib/mysql/mariadb-bin.index
    relay_log = /var/lib/mysql/relay-bin
    relay_log_index = /var/lib/mysql/relay-bin.index
    
    #datadir=/var/lib/mysql
    #socket=/var/lib/mysql/mysql.sock
    #log-error=/var/log/mariadb/mariadb.log
    #pid-file=/run/mariadb/mariadb.pid

Silakan simpan dan restart mariadb

    [root@apps02 ~]#
    [root@apps02 ~]# systemctl restart mariadb
    [root@apps02 ~]#

Selanjutnya silakan login ke masing – masing VM database mariadb dan membuat user untuk replikasi nya

#### # Node Apps01 (Master)

    [root@apps01 ~]#
    [root@apps01 ~]# mysql -u root -p
    Enter password:
    Welcome to the MariaDB monitor. Commands end with ; or \g.
    Your MariaDB connection id is 9
    Server version: 10.3.17-MariaDB-log MariaDB Server
    
    Copyright (c) 2000, 2018, Oracle, MariaDB Corporation Ab and others.
    
    Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.
    
    MariaDB [(none)]> create user 'test_master'@'%' identified by 'test_master';
    Query OK, 0 rows affected (0.002 sec)
    
    MariaDB [(none)]> grant replication slave on *.* to 'test_master'@'%';
    Query OK, 0 rows affected (0.000 sec)
    
    MariaDB [(none)]> show master status;
    +--------------------+----------+--------------+------------------+
    | File | Position | Binlog_Do_DB | Binlog_Ignore_DB |
    +--------------------+----------+--------------+------------------+
    | mariadb-bin.000001 | 664 | | |
    +--------------------+----------+--------------+------------------+
    1 row in set (0.000 sec)
    
    MariaDB [(none)]>

_Keterangan: User yang digunakan diatas yaitu test\_master dan password nya test\_master_

_Noted: Silakan dicatat hasil dari status master_

#### # Node Apps02 (Master)

Langkah ini sama dengan langkah sebelumnya, silakan login ke mysql dan membuat user untuk replikasi database nya

    [root@apps02 ~]#
    [root@apps02 ~]# mysql -u root -p
    Enter password:
    Welcome to the MariaDB monitor. Commands end with ; or \g.
    Your MariaDB connection id is 9
    Server version: 10.3.17-MariaDB-log MariaDB Server
    
    Copyright (c) 2000, 2018, Oracle, MariaDB Corporation Ab and others.
    
    Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.
    
    MariaDB [(none)]> create user 'test_master2'@'%' identified by 'test_master2';
    Query OK, 0 rows affected (0.001 sec)
    
    MariaDB [(none)]> grant replication slave on *.* to 'test_master2'@'%';
    Query OK, 0 rows affected (0.000 sec)
    
    MariaDB [(none)]> show master status;
    +--------------------+----------+--------------+------------------+
    | File | Position | Binlog_Do_DB | Binlog_Ignore_DB |
    +--------------------+----------+--------------+------------------+
    | mariadb-bin.000001 | 667 | | |
    +--------------------+----------+--------------+------------------+
    1 row in set (0.000 sec)
    
    MariaDB [(none)]>

_Keterangan: User yang digunakan diatas yaitu test\_master2 dan password nya test\_master2_

_Noted: Silakan dicatat hasil dari status master_

Selanjutnya menghubungkan dan melakukan replikasi master – master database Apps01 ke Apps02

#### # Hubungkan Apps01 ke Apps02

Pertama yang harus di lakukan yaitu stop slave

    MariaDB [(none)]>
    MariaDB [(none)]> STOP SLAVE;
    Query OK, 0 rows affected, 1 warning (0.000 sec)
    
    MariaDB [(none)]> 

Hubungkan Apps01 ke Apps02

    MariaDB [(none)]> CHANGE MASTER TO MASTER_HOST='192.168.10.18', MASTER_USER='test_master2', MASTER_PASSWORD='test_master2', MASTER_LOG_FILE='mariadb-bin.000001', MASTER_LOG_POS=667;
    Query OK, 0 rows affected (2.182 sec)
    
    MariaDB [(none)]> 

_Noted: Silakan sesuaikan username, password database apps02 yang sudah dibuat sebelumnya, untuk Master\_Host silakan isi IP Apps02_

Selanjutnya start slave

    MariaDB [(none)]> START SLAVE;
    Query OK, 0 rows affected (0.002 sec)
    
    MariaDB [(none)]>

#### # Hubungkan Apps02 ke Apps01

Langkah kali ini hampir sama dengan langkah sebelumnya, bedanya hanya pada penentuan IP, username dan password mariadb yang telah dibuat sebelumnya.

Silakan stop slave

    MariaDB [(none)]>
    MariaDB [(none)]> STOP SLAVE;
    Query OK, 0 rows affected, 1 warning (0.001 sec)
    
    MariaDB [(none)]>

Hubungkan Apps02 ke Apps01, pastikan informasi yang ada di apps01 diinput dengan benar

    MariaDB [(none)]> CHANGE MASTER TO MASTER_HOST='192.168.10.9', MASTER_USER='test_master', MASTER_PASSWORD='test_master', MASTER_LOG_FILE='mariadb-bin.000001', MASTER_LOG_POS=664;
    Query OK, 0 rows affected (0.038 sec)
    
    MariaDB [(none)]>

Start slave

    MariaDB [(none)]> START SLAVE;
    Query OK, 0 rows affected (0.002 sec)
    
    MariaDB [(none)]>

Berikutnya cek status dari replikasi di masing – masing VM database Apps01 dan Apps02

#### # Status Replikasi Master Apps01

    MariaDB [(none)]> show slave status \G
    ***************************1. row***************************
                    Slave_IO_State: Waiting for master to send event
                       Master_Host: 192.168.10.18
                       Master_User: test_master2
                       Master_Port: 3306
                     Connect_Retry: 60
                   Master_Log_File: mariadb-bin.000001
               Read_Master_Log_Pos: 667
                    Relay_Log_File: relay-bin.000002
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
               Exec_Master_Log_Pos: 667
                   Relay_Log_Space: 860
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
                  Master_Server_Id: 2
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
    1 row in set (0.001 sec)
    
    MariaDB [(none)]>

#### # Status Replikasi Master Apps02

    MariaDB [(none)]> show slave status \G
    ***************************1. row***************************
                    Slave_IO_State: Waiting for master to send event
                       Master_Host: 192.168.10.9
                       Master_User: test_master
                       Master_Port: 3306
                     Connect_Retry: 60
                   Master_Log_File: mariadb-bin.000001
               Read_Master_Log_Pos: 664
                    Relay_Log_File: relay-bin.000002
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
               Exec_Master_Log_Pos: 664
                   Relay_Log_Space: 860
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
    1 row in set (0.001 sec)
    
    MariaDB [(none)]>

Berikut detail capture dari status replikasi masing – masing VM Apps01 dan Apps02

<figure class="wp-block-image size-large"><img loading="lazy" width="1024" height="536" src="/content/images/wordpress/2020/08/status-slave-master-1024x536.png" alt="" class="wp-image-370" srcset="/content/images/wordpress/2020/08/status-slave-master-1024x536.png 1024w, /content/images/wordpress/2020/08/status-slave-master-300x157.png 300w, /content/images/wordpress/2020/08/status-slave-master-768x402.png 768w, /content/images/wordpress/2020/08/status-slave-master-1536x804.png 1536w, /content/images/wordpress/2020/08/status-slave-master.png 1919w" sizes="(max-width: 1024px) 100vw, 1024px"></figure>

Selanjutnya kita akan mencoba membuat database di Apps01 jika hasil yang dibuat di Apps01 tersimpan atau ada juga atau tereplikasi juga di Apps02 maka konfigurasi replikasi master – master sudah berhasil

<figure class="wp-block-image size-large"><img loading="lazy" width="1024" height="538" src="/content/images/wordpress/2020/08/apps01-to-apps02-1024x538.png" alt="" class="wp-image-371" srcset="/content/images/wordpress/2020/08/apps01-to-apps02-1024x538.png 1024w, /content/images/wordpress/2020/08/apps01-to-apps02-300x158.png 300w, /content/images/wordpress/2020/08/apps01-to-apps02-768x403.png 768w, /content/images/wordpress/2020/08/apps01-to-apps02-1536x807.png 1536w, /content/images/wordpress/2020/08/apps01-to-apps02.png 1904w" sizes="(max-width: 1024px) 100vw, 1024px"></figure>

Sebaliknya sekarang kita coba buat database di apps02 pastikan di apps01 ada atau tereplikasi

<figure class="wp-block-image size-large"><img loading="lazy" width="1024" height="538" src="/content/images/wordpress/2020/08/app02-to-apps01-1024x538.png" alt="" class="wp-image-372" srcset="/content/images/wordpress/2020/08/app02-to-apps01-1024x538.png 1024w, /content/images/wordpress/2020/08/app02-to-apps01-300x158.png 300w, /content/images/wordpress/2020/08/app02-to-apps01-768x404.png 768w, /content/images/wordpress/2020/08/app02-to-apps01-1536x808.png 1536w, /content/images/wordpress/2020/08/app02-to-apps01.png 1917w" sizes="(max-width: 1024px) 100vw, 1024px"></figure>

Selamat mencoba 😁

Please follow and like us:

[![error](/wp-content/plugins/ultimate-social-media-icons/images/follow_subscribe.png)](https://api.follow.it/widgets/icon/VHc3d1lpVGdwRnE5QnV0eERCNUx5RCtvTTVoUkNYS3NNRmd5eVhlQW9tNXRHS3VTbGh6Y0NybkRJRS8zSGpjRDVZb1ZGMlNTSEpJYUpuZzZqNzdnd3VSN3dwM2VlQTF6ejJEaGV5UGRUbnlEcHFNd3luYTV4ZTZtUGowVWI2Q2x8M2kzdnBEeUIrUk5xOFI5TXZ3cHF3bFNQRkRJSGhUNGdrRFd0TlNtdE1OWT0=/OA==/)

[![fb-share-icon](/wp-content/plugins/ultimate-social-media-icons/images/visit_icons/fbshare_bck.png "Facebook Share")](https://www.facebook.com/sharer/sharer.php?u=https%3A%2F%2Fbelajarlinux.id%2F%3Fp%3D369%26ghostexport%3Dtrue%26submit%3DDownload+Ghost+File)

[![Tweet](/wp-content/plugins/ultimate-social-media-icons/images/visit_icons/en_US_Tweet.svg "Tweet")](https://twitter.com/intent/tweet?text=Cara+Konfigurasi+Replikasi+MariaDB+Master+%26%238211%3B+Master+di+CentOS+8+https://belajarlinux.id/?p=369&ghostexport=true&submit=Download Ghost File)

[![fb-share-icon](/wp-content/plugins/ultimate-social-media-icons/images/share_icons/Pinterest_Save/en_US_save.svg "Pin Share")](#)

<!--kg-card-end: html-->
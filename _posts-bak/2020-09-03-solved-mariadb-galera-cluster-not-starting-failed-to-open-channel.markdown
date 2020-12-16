---
layout: post
title: "[SOLVED] MariaDB Galera Cluster not starting (failed to open channel)"
featured: true
date: '2020-09-03 22:29:54'
tags:
- centos
- database
---

Sebelumnya kami mencoba untuk memastikan semua node galera cluster dan di sisi proxy MariaDB MaxScale terindikasi down semua seperti berikut

<figure class="wp-block-image size-large"><img loading="lazy" width="688" height="193" src="/content/images/wordpress/2020/09/image-11.png" alt="" class="wp-image-444" srcset="/content/images/wordpress/2020/09/image-11.png 688w, /content/images/wordpress/2020/09/image-11-300x84.png 300w" sizes="(max-width: 688px) 100vw, 688px"></figure>

Selanjutnyaa kami mencoba untuk start manual semua node galera cluster akan tetapi node tidak dapat di start

    [root@galera01 ~]#
    [root@galera01 ~]# systemctl start mariadb
    Job for mariadb.service failed because the control process exited with error code.
    See "systemctl status mariadb.service" and "journalctl -xe" for details.
    [root@galera01 ~]#
    [root@galera01 ~]# systemctl status mariadb -l
    ● mariadb.service - MariaDB 10.3 database server
       Loaded: loaded (/usr/lib/systemd/system/mariadb.service; enabled; vendor preset: disabled)
       Active: failed (Result: exit-code) since Wed 2020-09-02 16:16:21 UTC; 9s ago
         Docs: man:mysqld(8)
               https://mariadb.com/kb/en/library/systemd/
      Process: 8631 ExecStartPost=/usr/libexec/mysql-check-upgrade (code=exited, status=0/SUCCESS)
      Process: 10179 ExecStart=/usr/libexec/mysqld --basedir=/usr $MYSQLD_OPTS $_WSREP_NEW_CLUSTER (code=exited, status=1/FAILURE)
      Process: 10141 ExecStartPre=/usr/libexec/mysql-prepare-db-dir mariadb.service (code=exited, status=0/SUCCESS)
      Process: 10117 ExecStartPre=/usr/libexec/mysql-check-socket (code=exited, status=0/SUCCESS)
     Main PID: 10179 (code=exited, status=1/FAILURE)
       Status: "MariaDB server is down"
    
    Sep 02 16:15:46 galera01.nurhamim.my.id systemd[1]: Starting MariaDB 10.3 database server...
    Sep 02 16:15:47 galera01.nurhamim.my.id mysql-prepare-db-dir[10141]: Database MariaDB is probably initialized in /var/lib/mysql already, nothing is done.
    Sep 02 16:15:47 galera01.nurhamim.my.id mysql-prepare-db-dir[10141]: If this is not the case, make sure the /var/lib/mysql is empty before running mysql-prepare-db-dir.
    Sep 02 16:15:47 galera01.nurhamim.my.id mysqld[10179]: 2020-09-02 16:15:47 0 [Note] /usr/libexec/mysqld (mysqld 10.3.17-MariaDB) starting as process 10179 ...
    Sep 02 16:16:21 galera01.nurhamim.my.id systemd[1]: mariadb.service: Main process exited, code=exited, status=1/FAILURE
    Sep 02 16:16:21 galera01.nurhamim.my.id systemd[1]: mariadb.service: Failed with result 'exit-code'.
    Sep 02 16:16:21 galera01.nurhamim.my.id systemd[1]: Failed to start MariaDB 10.3 database server.
    [root@galera01 ~]#

Lankah yang harus di lakukan yaitu mencari tahu log error yang terjadi, untuk melihat log mariadb jalankan perintah berikut

    [root@galera01 ~]#
    [root@galera01 ~]# tail -f /var/log/mariadb/mariadb.log

Kemudian kami menemukan error sebagai berikut

    2020-09-02 16:15:50 0 [Warning] WSREP: last inactive check more than PT1.5S ago (PT3.50297S), skipping check
    2020-09-02 16:16:20 0 [Note] WSREP: view((empty))
    2020-09-02 16:16:20 0 [ERROR] WSREP: failed to open gcomm backend connection: 110: failed to reach primary view: 110 (Connection timed out)
             at gcomm/src/pc.cpp:connect():158
    2020-09-02 16:16:20 0 [ERROR] WSREP: gcs/src/gcs_core.cpp:gcs_core_open():209: Failed to open backend connection: -110 (Connection timed out)
    2020-09-02 16:16:20 0 [ERROR] WSREP: gcs/src/gcs.cpp:gcs_open():1458: Failed to open channel 'belajarlinux-cluster' at 'gcomm://192.168.10.9,192.168.10.18,192.168.10.21': -110 (Connection timed out)
    2020-09-02 16:16:20 0 [ERROR] WSREP: gcs connect failed: Connection timed out
    2020-09-02 16:16:20 0 [ERROR] WSREP: wsrep::connect(gcomm://192.168.10.9,192.168.10.18,192.168.10.21) failed: 7
    2020-09-02 16:16:20 0 [ERROR] Aborting

Dari error diatas kami menemukan satu baris error yang perlu di ketahui berikut

    2020-09-02 16:16:20 0 [ERROR] WSREP: failed to open gcomm backend connection: 110: failed to reach primary view: 110 (Connection timed out)

Error tersebut menandakan node01 mencoba bergabung dengan cluster yang ada, tetapi karena dua node (node02 dan node03) juga down maka tidak ada node utama yang tersedia, referensi detail dapat dilihat pada link berikut: **_[mysql failed to start after reboot](https://groups.google.com/g/codership-team/c/a5S0aExW2oI/m/fY5yBGdSWUYJ)_**

Oleh karena itu untuk memulai galera cluster kita perlu menjalankan kembali _“wsrep-new-cluster”_ (sama seperti pada saat membuat cluster), jalankan perintah berikut:

    [root@galera01 ~]# service mysql start --wsrep-new-cluster
    Redirecting to /bin/systemctl start --wsrep-new-cluster mysql.service
    /bin/systemctl: unrecognized option '--wsrep-new-cluster'
    [root@galera01 ~]#
    [root@galera01 ~]#

Ternyata masih belum solved juga, selanjutnya kita coba lihat nilai boostrap galera cluster

    [root@galera01 ~]#
    [root@galera01 ~]# cat /var/lib/mysql/grastate.dat
    # GALERA saved state
    version: 2.1
    uuid: 2e4402c1-eae0-11ea-ac64-8b88004f6b7a
    seqno: -1
    safe_to_bootstrap: 0
     [root@galera01 ~]#

Terlihat di atas value atau nilai booststrap 0 silakan replace menjadi 1 menggunakan perintah berikut

    root@galera01 ~]# sed -i "/safe_to_bootstrap/s/0/1/" /var/lib/mysql/grastate.dat

Selanjutnya coba jalankan kembali galera cluster

    [root@galera01 ~]# galera_new_cluster
    [root@galera01 ~]#

Dan saat ini galera cluster sudah running kembali dan database di node01 juga sudah running

    [root@galera01 ~]#
    [root@galera01 ~]# systemctl status mariadb
    ● mariadb.service - MariaDB 10.3 database server
       Loaded: loaded (/usr/lib/systemd/system/mariadb.service; enabled; vendor preset: disabled)
       Active: active (running) since Wed 2020-09-02 17:19:31 UTC; 23s ago
         Docs: man:mysqld(8)
               https://mariadb.com/kb/en/library/systemd/
      Process: 10542 ExecStartPost=/usr/libexec/mysql-check-upgrade (code=exited, status=0/SUCCESS)
      Process: 10467 ExecStartPre=/usr/libexec/mysql-prepare-db-dir mariadb.service (code=exited, status=0/SUCCESS)
      Process: 10443 ExecStartPre=/usr/libexec/mysql-check-socket (code=exited, status=0/SUCCESS)
     Main PID: 10505 (mysqld)
       Status: "Taking your SQL requests now..."
        Tasks: 36 (limit: 11328)
       Memory: 105.7M
       CGroup: /system.slice/mariadb.service
               └─10505 /usr/libexec/mysqld --basedir=/usr --wsrep-new-cluster
    
    Sep 02 17:19:25 galera01.nurhamim.my.id systemd[1]: Starting MariaDB 10.3 database server...
    Sep 02 17:19:25 galera01.nurhamim.my.id mysql-prepare-db-dir[10467]: Database MariaDB is probably initialized in /var/lib/mysql already, nothing is done.
    Sep 02 17:19:25 galera01.nurhamim.my.id mysql-prepare-db-dir[10467]: If this is not the case, make sure the /var/lib/mysql is empty before running mysql-prepare-db-dir.
    Sep 02 17:19:25 galera01.nurhamim.my.id mysqld[10505]: 2020-09-02 17:19:25 0 [Note] /usr/libexec/mysqld (mysqld 10.3.17-MariaDB) starting as process 10505 ...
    Sep 02 17:19:31 galera01.nurhamim.my.id systemd[1]: Started MariaDB 10.3 database server.
    [root@galera01 ~]#

Silakan start di node02 dan node03

    [root@galera02 ~]#
    [root@galera02 ~]# systemctl start mariadb
    [root@galera02 ~]#
    
    [root@galera03 ~]#
    [root@galera03 ~]# systemctl start mariadb
    [root@galera03 ~]#

Sekarang jika kita pastikan di masing – masing node data – data database sebelumnya masih ada dan tidak hilang ataupun crash

    [root@galera03 ~]#
    [root@galera03 ~]# systemctl start mariadb
    [root@galera03 ~]# mysql -u root -p
    Enter password:
    Welcome to the MariaDB monitor. Commands end with ; or \g.
    Your MariaDB connection id is 11
    Server version: 10.3.17-MariaDB MariaDB Server
    
    Copyright (c) 2000, 2018, Oracle, MariaDB Corporation Ab and others.
    
    Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.
    
    MariaDB [(none)]> show databases;
    +--------------------+
    | Database |
    +--------------------+
    | galera_di_node_01 |
    | galera_di_node_02 |
    | galera_di_node_03 |
    | information_schema |
    | joomla |
    | mysql |
    | performance_schema |
    | playground |
    | wordpress |
    +--------------------+
    9 rows in set (0.001 sec)
    
    MariaDB [(none)]>
    
    [root@galera01 ~]#
    [root@galera01 ~]# mysql -u root -p
    Enter password:
    Welcome to the MariaDB monitor. Commands end with ; or \g.
    Your MariaDB connection id is 11
    Server version: 10.3.17-MariaDB MariaDB Server
    
    Copyright (c) 2000, 2018, Oracle, MariaDB Corporation Ab and others.
    
    Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.
    
    MariaDB [(none)]> show databases;
    +--------------------+
    | Database |
    +--------------------+
    | galera_di_node_01 |
    | galera_di_node_02 |
    | galera_di_node_03 |
    | information_schema |
    | joomla |
    | mysql |
    | performance_schema |
    | playground |
    | wordpress |
    +--------------------+
    9 rows in set (0.001 sec)
    
    MariaDB [(none)]>
    
    [root@galera02 ~]#
    [root@galera02 ~]# mysql -u root -p
    Enter password:
    Welcome to the MariaDB monitor. Commands end with ; or \g.
    Your MariaDB connection id is 11
    Server version: 10.3.17-MariaDB MariaDB Server
    
    Copyright (c) 2000, 2018, Oracle, MariaDB Corporation Ab and others.
    
    Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.
    
    MariaDB [(none)]> show databases;
    +--------------------+
    | Database |
    +--------------------+
    | galera_di_node_01 |
    | galera_di_node_02 |
    | galera_di_node_03 |
    | information_schema |
    | joomla |
    | mysql |
    | performance_schema |
    | playground |
    | wordpress |
    +--------------------+
    9 rows in set (0.001 sec)
    
    MariaDB [(none)]>
    MariaDB [(none)]>

Dan jika dilihat dari sisi log sudah tidak mendapati adanya error

    [root@galera01 ~]#
    [root@galera01 ~]# tail -f /var/log/mariadb/mariadb.log
    2020-09-02 17:21:23 0 [Note] WSREP: resuming provider at 10
    2020-09-02 17:21:23 0 [Note] WSREP: Provider resumed.
    2020-09-02 17:21:28 0 [Note] WSREP: 0.0 (galera01): State transfer to 2.0 (galera02.nurhamim.my.id) complete.
    2020-09-02 17:21:28 0 [Note] WSREP: Shifting DONOR/DESYNCED -> JOINED (TO: 0)
    2020-09-02 17:21:28 0 [Note] WSREP: Member 0.0 (galera01) synced with group.
    2020-09-02 17:21:28 0 [Note] WSREP: Shifting JOINED -> SYNCED (TO: 0)
    2020-09-02 17:21:28 2 [Note] WSREP: Synchronized with group, ready for connections
    2020-09-02 17:21:28 2 [Note] WSREP: wsrep_notify_cmd is not defined, skipping notification.
    2020-09-02 17:21:35 0 [Note] WSREP: 2.0 (galera02.nurhamim.my.id): State transfer from 0.0 (galera01) complete.
    2020-09-02 17:21:35 0 [Note] WSREP: Member 2.0 (galera02.nurhamim.my.id) synced with group.

Kemudian jika kami cek di sisi proxy MariaDB MaxScale semua node sudah running

<figure class="wp-block-image size-large"><img loading="lazy" width="810" height="422" src="/content/images/wordpress/2020/09/jancok-1.png" alt="" class="wp-image-445" srcset="/content/images/wordpress/2020/09/jancok-1.png 810w, /content/images/wordpress/2020/09/jancok-1-300x156.png 300w, /content/images/wordpress/2020/09/jancok-1-768x400.png 768w" sizes="(max-width: 810px) 100vw, 810px"></figure>

Dan saat ini kendala sudah SOLVED.   
  
Selamat mencoba 😀

Please follow and like us:

[![error](/wp-content/plugins/ultimate-social-media-icons/images/follow_subscribe.png)](https://api.follow.it/widgets/icon/VHc3d1lpVGdwRnE5QnV0eERCNUx5RCtvTTVoUkNYS3NNRmd5eVhlQW9tNXRHS3VTbGh6Y0NybkRJRS8zSGpjRDVZb1ZGMlNTSEpJYUpuZzZqNzdnd3VSN3dwM2VlQTF6ejJEaGV5UGRUbnlEcHFNd3luYTV4ZTZtUGowVWI2Q2x8M2kzdnBEeUIrUk5xOFI5TXZ3cHF3bFNQRkRJSGhUNGdrRFd0TlNtdE1OWT0=/OA==/)

[![fb-share-icon](/wp-content/plugins/ultimate-social-media-icons/images/visit_icons/fbshare_bck.png "Facebook Share")](https://www.facebook.com/sharer/sharer.php?u=https%3A%2F%2Fbelajarlinux.id%2F%3Fp%3D442%26ghostexport%3Dtrue%26submit%3DDownload+Ghost+File)

[![Tweet](/wp-content/plugins/ultimate-social-media-icons/images/visit_icons/en_US_Tweet.svg "Tweet")](https://twitter.com/intent/tweet?text=%5BSOLVED%5D+MariaDB+Galera+Cluster+not+starting+%28failed+to+open+channel%29+https://belajarlinux.id/?p=442&ghostexport=true&submit=Download Ghost File)

[![fb-share-icon](/wp-content/plugins/ultimate-social-media-icons/images/share_icons/Pinterest_Save/en_US_save.svg "Pin Share")](#)

<!--kg-card-end: html-->
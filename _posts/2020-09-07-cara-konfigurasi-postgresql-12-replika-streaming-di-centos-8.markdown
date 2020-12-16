---
layout: post
title: Cara Konfigurasi PostgreSQL 12 Replika Streaming di CentOS 8
featured: true
date: '2020-09-07 20:03:38'
tags:
- centos
- database
---

PostgreSQL salah satu databate yang power full yang dapat Anda gunakan sebagai pilihan yang tepat untuk database server.

PostgreSQL mempunyai beberapa solusi replikasi untuk support dan bangun aplikasi yang high-availability, scalable, fault-tolerant application, dan salah satunya Write Ahead Log (WAL) Shipping.

Untuk implementasi replikasi streaming di postgresql minimal ada 2 server/vm dimana satu server akan digunakan sebagai primary (master) dan satu server lagi digunakan sebagai standby (slave).

Secara default, replikasi streaming bersifat _asynchronous_ di mana data ditulis ke server standby setelah transaksi dilakukan di server master, artinya akan ada sedikit penundaan antara melakukan transaksi di server master dan perubahan yang terlihat di server standby . Satu kelemahan dari pendekatan ini adalah jika server master mengalami crash, setiap transaksi yang tidak terikat mungkin tidak dapat direplikasi dan ini dapat menyebabkan kehilangan data.

Pada tutorial kali ini kami akan konfigurasi replikasi streaming master-standby (master – slave) dengan 2 server/vm detailnya sebagai berikut:

<figure class="wp-block-table"><table><tbody>
<tr>
<td class="has-text-align-center" data-align="center">Name</td>
<td class="has-text-align-center" data-align="center">IP</td>
<td class="has-text-align-center" data-align="center">Kegunaan</td>
</tr>
<tr>
<td class="has-text-align-center" data-align="center">pg1.nurhamim.my.id</td>
<td class="has-text-align-center" data-align="center">192.168.10.21</td>
<td class="has-text-align-center" data-align="center">Postgresql Primary</td>
</tr>
<tr>
<td class="has-text-align-center" data-align="center">pg2.nurhamim.my.id</td>
<td class="has-text-align-center" data-align="center">192.168.10.24</td>
<td class="has-text-align-center" data-align="center">Postgresql Standby</td>
</tr>
</tbody></table></figure>

### # Instalasi PostgreSQL 12

Pertama yang harus Anda lakukan yaitu instalasi postgresql 12 di masing – masing node postgresql master dan standby.

Dikutip dari tutorial berikut: [Cara Install PostgreSQL di CentOS 8](/cara-install-postgresql-di-centos-8/) untuk instalasi postgreSQL 12 dapat mengguankan repository default yang sudah ada di CentOS 8 namun Anda juga dapat menambahkan repository manual postgreSQL di CentOS 8 seperti berikut.

Disable module postgresql default CentOS 8

    [root@pg1 ~]# dnf -qy module disable postgresql
    [root@pg1 ~]#

Install repository postgresql 12

    [root@pg1 ~]#
    [root@pg1 ~]# dnf install https://download.postgresql.org/pub/repos/yum/reporpms/EL-8-x86_64/pgdg-redhat-repo-latest.noarch.rpm

Install postgresql 12 menggunakan commmand berikut

    [root@pg1 ~]#
    [root@pg1 ~]# dnf install postgresql12 postgresql12-server -y

Inisiasi database postgresql

    [root@pg1 ~]#
    [root@pg1 ~]# /usr/pgsql-12/bin/postgresql-12-setup initdb
    Initializing database ... OK
    
    [root@pg1 ~]#

Start postgresql dan pastikan statusnya running

    [root@pg1 ~]#
    [root@pg1 ~]# systemctl start postgresql-12
    [root@pg1 ~]# systemctl status postgresql-12
    ● postgresql-12.service - PostgreSQL 12 database server
       Loaded: loaded (/usr/lib/systemd/system/postgresql-12.service; disabled; vendor preset: disabled)
       Active: active (running) since Sun 2020-09-06 12:39:58 UTC; 45s ago
         Docs: https://www.postgresql.org/docs/12/static/
      Process: 6429 ExecStartPre=/usr/pgsql-12/bin/postgresql-12-check-db-dir ${PGDATA} (code=exited, status=0/SUCCESS)
     Main PID: 6434 (postmaster)
        Tasks: 8 (limit: 11328)
       Memory: 17.0M
       CGroup: /system.slice/postgresql-12.service
               ├─6434 /usr/pgsql-12/bin/postmaster -D /var/lib/pgsql/12/data/
               ├─6436 postgres: logger
               ├─6438 postgres: checkpointer
               ├─6439 postgres: background writer
               ├─6440 postgres: walwriter
               ├─6441 postgres: autovacuum launcher
               ├─6442 postgres: stats collector
               └─6443 postgres: logical replication launcher
    
    Sep 06 12:39:58 pg1.nurhamim.my.id systemd[1]: Starting PostgreSQL 12 database server...
    Sep 06 12:39:58 pg1.nurhamim.my.id postmaster[6434]: 2020-09-06 12:39:58.878 UTC [6434] LOG: starting PostgreSQL 12.4 on x86_64-pc-linux-gnu, compiled by gcc (GCC) 8.3.1 20191121 (Red Hat 8.3.1-5), 64-bit
    Sep 06 12:39:58 pg1.nurhamim.my.id postmaster[6434]: 2020-09-06 12:39:58.879 UTC [6434] LOG: listening on IPv6 address "::1", port 5432
    Sep 06 12:39:58 pg1.nurhamim.my.id postmaster[6434]: 2020-09-06 12:39:58.879 UTC [6434] LOG: listening on IPv4 address "127.0.0.1", port 5432
    Sep 06 12:39:58 pg1.nurhamim.my.id postmaster[6434]: 2020-09-06 12:39:58.883 UTC [6434] LOG: listening on Unix socket "/var/run/postgresql/.s.PGSQL.5432"
    Sep 06 12:39:58 pg1.nurhamim.my.id postmaster[6434]: 2020-09-06 12:39:58.893 UTC [6434] LOG: listening on Unix socket "/tmp/.s.PGSQL.5432"
    Sep 06 12:39:58 pg1.nurhamim.my.id postmaster[6434]: 2020-09-06 12:39:58.913 UTC [6434] LOG: redirecting log output to logging collector process
    Sep 06 12:39:58 pg1.nurhamim.my.id postmaster[6434]: 2020-09-06 12:39:58.913 UTC [6434] HINT: Future log output will appear in directory "log".
    Sep 06 12:39:58 pg1.nurhamim.my.id systemd[1]: Started PostgreSQL 12 database server.
    [root@pg1 ~]#

Silakan ulangi langkah diatas di node standby (pg2).

### # Konfigurasi Replikasi Streaming

**# Node Master / Node pg1**

Login menggunakan user postgres dan set IP master dapat menerima koneksi dari client manapun seperti berikut

    [root@pg1 ~]#
    [root@pg1 ~]# su - postgres
    Last login: Sun Sep 6 12:41:23 UTC 2020 on pts/0
    [postgres@pg1 ~]$
    [postgres@pg1 ~]$ psql -c "ALTER SYSTEM SET listen_addresses TO '*';"
    ALTER SYSTEM
    [postgres@pg1 ~]$

Perintah _ALTER SYSTEM SET SQL_ sebuah fitur untuk mengubah parameter konfigurasi server langsung dengan kueri SQL. Konfigurasi disimpan di file _postgresql.conf.auto_ yang terletak di root folder data (misalnya _/var/lib/pgsql/12/data/_) dan membaca tambahan untuk disimpan di _postgresql.conf_.

    [postgres@pg1 ~]$ createuser --replication -P -e replicator
    Enter password for new role:
    Enter it again:
    SELECT pg_catalog.set_config('search_path', '', false);
    CREATE ROLE replicator PASSWORD 'md55c0c06847f1af7be7b811ce4cff39f72' NOSUPERUSER NOCREATEDB NOCREATEROLE INHERIT LOGIN REPLICATION;
    [postgres@pg1 ~]$

_Keterangan:_

_-P: Digunakan untuk generate password  
-e: Digunakan untuk membuat user_

Silakan exit dari shell postgres

    [postgres@pg1 ~]$
    [postgres@pg1 ~]$ exit
    logout
    [root@pg1 ~]#

Menambahkan rule **/var/lib/pgsql/12/data/pg\_hba.conf** dimana kita akan menambahkan IP server standy di sisi master

    [root@pg1 ~]#
    [root@pg1 ~]# vim /var/lib/pgsql/12/data/pg_hba.conf

Tambahkan satu rule replicator seperti dibawah ini

    # Allow replication connections from localhost, by a user with the
    # replication privilege.
    local replication all peer
    host replication all 127.0.0.1/32 ident
    host replication all ::1/128 ident
    
    host replication replicator 192.168.10.24/27 md5

_Noted: Silakan input IP server standby berseta prefix yang digunakan._

Jika sudah silakan simpan dan restart postgresql

    [root@pg1 ~]#
    [root@pg1 ~]# systemctl restart postgresql-12.service
    [root@pg1 ~]#

**# Node Stanby / Node pg2**

Selanjutnya kita akan konfigurasi di node standy, pertama silakan stop terlebih dahulu postgresql nya

    [root@pg2 ~]#
    [root@pg2 ~]# systemctl stop postgresql-12.service
    [root@pg2 ~]# su - postgres
    [postgres@pg2 ~]$

Copy default konfigurasi postgresql yang berada di ../data dan silakan hapus semua file yang ada di /data

    [postgres@pg2 ~]$
    [postgres@pg2 ~]$ cp -R /var/lib/pgsql/12/data /var/lib/pgsql/12/data_orig
    [postgres@pg2 ~]$ rm -rf /var/lib/pgsql/12/data/*
    [postgres@pg2 ~]$

Melakukan backup data yang ada di server master ke standy menggunakan _pg_\__basebackup_ seperti berikut

    [postgres@pg2 ~]$
    [postgres@pg2 ~]$ pg_basebackup -h 192.168.10.21 -D /var/lib/pgsql/12/data -U replicator -v -P -R -X stream -C -S pgstandby1
    Password:
    pg_basebackup: initiating base backup, waiting for checkpoint to complete
    pg_basebackup: checkpoint completed
    pg_basebackup: write-ahead log start point: 0/2000028 on timeline 1
    pg_basebackup: starting background WAL receiver
    pg_basebackup: created replication slot "pgstandby1"
    25553/25553 kB (100%), 1/1 tablespace
    pg_basebackup: write-ahead log end point: 0/2000100
    pg_basebackup: waiting for background process to finish streaming ...
    pg_basebackup: syncing data to disk ...
    pg_basebackup: base backup completed
    [postgres@pg2 ~]$

_Keterangan:_

_-h : Menentukan host yang merupakan server master.  
-D : Menentukan direktori data.  
-U : Menentukan pengguna koneksi.  
-P : Memungkinkan pelaporan kemajuan.  
-v : Mengaktifkan mode verbose.  
-R : Mengaktifkan pembuatan konfigurasi pemulihan: Membuat file standby.signal dan menambahkan pengaturan koneksi ke postgresql.auto.conf di bawah direktori data.  
-X : Digunakan untuk menyertakan file log depan tulis (file WAL) yang diperlukan dalam cadangan. Nilai aliran berarti mengalirkan WAL saat cadangan dibuat.  
-C : Memungkinkan pembuatan slot replikasi yang diberi nama oleh opsi -S sebelum memulai pencadangan.  
-S : Menentukan nama slot replikasi._

Ketika proses backup selesai, direktori data baru di server master akan terlihat di server standby seperti berikut:

    [postgres@pg2 ~]$
    [postgres@pg2 ~]$ ls -lah /var/lib/pgsql/12/data/
    total 64K
    drwx------ 20 postgres postgres 4.0K Sep 6 13:05 .
    drwx------ 5 postgres postgres 68 Sep 6 13:02 ..
    -rw------- 1 postgres postgres 224 Sep 6 13:05 backup_label
    drwx------ 5 postgres postgres 41 Sep 6 13:05 base
    -rw------- 1 postgres postgres 30 Sep 6 13:05 current_logfiles
    drwx------ 2 postgres postgres 4.0K Sep 6 13:05 global
    drwx------ 2 postgres postgres 32 Sep 6 13:05 log
    drwx------ 2 postgres postgres 6 Sep 6 13:05 pg_commit_ts
    drwx------ 2 postgres postgres 6 Sep 6 13:05 pg_dynshmem
    -rw------- 1 postgres postgres 4.5K Sep 6 13:05 pg_hba.conf
    -rw------- 1 postgres postgres 1.6K Sep 6 13:05 pg_ident.conf
    drwx------ 4 postgres postgres 68 Sep 6 13:05 pg_logical
    drwx------ 4 postgres postgres 36 Sep 6 13:05 pg_multixact
    drwx------ 2 postgres postgres 6 Sep 6 13:05 pg_notify
    drwx------ 2 postgres postgres 6 Sep 6 13:05 pg_replslot
    drwx------ 2 postgres postgres 6 Sep 6 13:05 pg_serial
    drwx------ 2 postgres postgres 6 Sep 6 13:05 pg_snapshots
    drwx------ 2 postgres postgres 6 Sep 6 13:05 pg_stat
    drwx------ 2 postgres postgres 6 Sep 6 13:05 pg_stat_tmp
    drwx------ 2 postgres postgres 6 Sep 6 13:05 pg_subtrans
    drwx------ 2 postgres postgres 6 Sep 6 13:05 pg_tblspc
    drwx------ 2 postgres postgres 6 Sep 6 13:05 pg_twophase
    -rw------- 1 postgres postgres 3 Sep 6 13:05 PG_VERSION
    drwx------ 3 postgres postgres 60 Sep 6 13:05 pg_wal
    drwx------ 2 postgres postgres 18 Sep 6 13:05 pg_xact
    -rw------- 1 postgres postgres 325 Sep 6 13:05 postgresql.auto.conf
    -rw------- 1 postgres postgres 26K Sep 6 13:05 postgresql.conf
    -rw------- 1 postgres postgres 0 Sep 6 13:05 standby.signal
    [postgres@pg2 ~]$

Jika di lihat di sisi master saat ini server slave sudah tereplikasi dan running dalam mode _“Hot Standby”_ dan silakan lihat slot replikasi di sisi server master akan ada menjadi pgstandby1

    [root@pg1 ~]#
    [root@pg1 ~]# su - postgres
    Last login: Sun Sep 6 12:59:31 UTC 2020 on pts/0
    [postgres@pg1 ~]$
    [postgres@pg1 ~]$ psql -c "SELECT * FROM pg_replication_slots;"
     slot_name | plugin | slot_type | datoid | database | temporary | active | active_pid | xmin | catalog_xmin | restart_lsn | confirmed_flush_lsn
    ------------+--------+-----------+--------+----------+-----------+--------+------------+------+--------------+-------------+---------------------
     pgstandby1 | | physical | | | f | f | | | | 0/2000000 |
    (1 row)
    
    [postgres@pg1 ~]$

<figure class="wp-block-image size-large"><img loading="lazy" width="1024" height="190" src="/content/images/wordpress/2020/09/1-5-1024x190.png" alt="" class="wp-image-473" srcset="/content/images/wordpress/2020/09/1-5-1024x190.png 1024w, /content/images/wordpress/2020/09/1-5-300x56.png 300w, /content/images/wordpress/2020/09/1-5-768x143.png 768w, /content/images/wordpress/2020/09/1-5.png 1188w" sizes="(max-width: 1024px) 100vw, 1024px"></figure>

Untuk melihat pengaturan koneksi yang ditambahkan di file postgresql.auto.conf, gunakan perintah cat seperti berikut

    [root@pg2 ~]#
    [root@pg2 ~]# cat /var/lib/pgsql/12/data/postgresql.auto.conf
    # Do not edit this file manually!
    # It will be overwritten by the ALTER SYSTEM command.
    listen_addresses = '*'
    primary_conninfo = 'user=replicator password=secret2020 host=192.168.10.21 port=5432 sslmode=prefer sslcompression=0 gssencmode=prefer krbsrvname=postgres target_session_attrs=any'
    primary_slot_name = 'pgstandby1'
    [root@pg2 ~]#

Selanjutnya silakan start kembali postgresql Anda

    [root@pg2 ~]#
    [root@pg2 ~]# systemctl start postgresql-12
    [root@pg2 ~]#

#### # Testing Replikasi Streaming 

Setelah koneksi berhasil dibuat antara master dan standby, Anda akan melihat proses penerima WAL di server master dengan status streaming, Anda dapat cek menggunakan menamolikan pg\_stat\_wal\_receiver.

    [root@pg2 ~]#
    [root@pg2 ~]# su - postgres
    Last login: Sun Sep 6 13:02:18 UTC 2020 on pts/0
    [postgres@pg2 ~]$
    [postgres@pg2 ~]$ psql -c "\x" -c "SELECT * FROM pg_stat_wal_receiver;"
    Expanded display is on.
    -[RECORD 1]---------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    pid | 6195
    status | streaming
    receive_start_lsn | 0/3000000
    receive_start_tli | 1
    received_lsn | 0/3000148
    received_tli | 1
    last_msg_send_time | 2020-09-06 13:11:01.147516+00
    last_msg_receipt_time | 2020-09-06 13:11:01.149703+00
    latest_end_lsn | 0/3000148
    latest_end_time | 2020-09-06 13:11:01.147516+00
    slot_name | pgstandby1
    sender_host | 192.168.10.21
    sender_port | 5432
    conninfo | user=replicator password= ******** dbname=replication host=192.168.10.21 port=5432 fallback_application_name=walreceiver sslmode=prefer sslcompression=0 gssencmode=prefer krbsrvname=postgres target_session_attrs=any
    
    [postgres@pg2 ~]$

<figure class="wp-block-image size-large"><img loading="lazy" width="1024" height="386" src="/content/images/wordpress/2020/09/2-5-1024x386.png" alt="" class="wp-image-475" srcset="/content/images/wordpress/2020/09/2-5-1024x386.png 1024w, /content/images/wordpress/2020/09/2-5-300x113.png 300w, /content/images/wordpress/2020/09/2-5-768x289.png 768w, /content/images/wordpress/2020/09/2-5.png 1182w" sizes="(max-width: 1024px) 100vw, 1024px"></figure>

Dan proses pengirim WAL yang sesuai di master / server utama dengan status _streaming_ dan _sync\_state async_, silakan cek hasil dari _pg\_stat\_replication_

    [postgres@pg1 ~]$
    [postgres@pg1 ~]$ psql -c "\x" -c "SELECT * FROM pg_stat_replication;"
    Expanded display is on.
    -[RECORD 1]----+------------------------------
    pid | 7323
    usesysid | 16384
    usename | replicator
    application_name | walreceiver
    client_addr | 192.168.10.24
    client_hostname |
    client_port | 59766
    backend_start | 2020-09-06 13:10:44.743067+00
    backend_xmin |
    state | streaming
    sent_lsn | 0/3000148
    write_lsn | 0/3000148
    flush_lsn | 0/3000148
    replay_lsn | 0/3000148
    write_lag |
    flush_lag |
    replay_lag |
    sync_priority | 0
    sync_state | async
    reply_time | 2020-09-06 13:12:01.308637+00
    
    [postgres@pg1 ~]$

<figure class="wp-block-image size-large"><img loading="lazy" width="834" height="487" src="/content/images/wordpress/2020/09/3-3.png" alt="" class="wp-image-476" srcset="/content/images/wordpress/2020/09/3-3.png 834w, /content/images/wordpress/2020/09/3-3-300x175.png 300w, /content/images/wordpress/2020/09/3-3-768x448.png 768w" sizes="(max-width: 834px) 100vw, 834px"></figure>

Selanjutnya test membuat database di master

    [postgres@pg1 ~]$
    [postgres@pg1 ~]$ psql
    psql (12.4)
    Type "help" for help.
    
    postgres=#
    postgres=# CREATE DATABASE belajarlinux;
    CREATE DATABASE
    postgres=#

Cek hasil nya di standby

    [postgres@pg2 ~]$
    [postgres@pg2 ~]$ psql
    psql (12.4)
    Type "help" for help.
    
    postgres=# \l
                                       List of databases
         Name | Owner | Encoding | Collate | Ctype | Access privileges
    --------------+----------+----------+-------------+-------------+-----------------------
     belajarlinux | postgres | UTF8 | en_US.UTF-8 | en_US.UTF-8 |
     postgres | postgres | UTF8 | en_US.UTF-8 | en_US.UTF-8 |
     template0 | postgres | UTF8 | en_US.UTF-8 | en_US.UTF-8 | =c/postgres +
                  | | | | | postgres=CTc/postgres
     template1 | postgres | UTF8 | en_US.UTF-8 | en_US.UTF-8 | =c/postgres +
                  | | | | | postgres=CTc/postgres
    (4 rows)
    
    postgres=#

Saat ini replikasi streaming sudah berjalan dengan semestinya, sebagai tambahan dan ini merupakan opsional jika Anda ingin set antara node master dan standy tidak menggunakan a_synchronous_melainkan _synchronous_ dapat di lakukan dengan cara mengatur nya di sisi master

    [postgres@pg1 ~]$
    [postgres@pg1 ~]$ psql -c "ALTER SYSTEM SET synchronous_standby_names TO '*';"
    ALTER SYSTEM
    [postgres@pg1 ~]$
    
    [root@pg1 ~]#
    [root@pg1 ~]# su - postgres
    Last login: Sun Sep 6 13:07:41 UTC 2020 on pts/0
    [postgres@pg1 ~]$
    [postgres@pg1 ~]$ psql -c "\x" -c "SELECT * FROM pg_stat_replication;"
    Expanded display is on.
    -[RECORD 1]----+------------------------------
    pid | 7323
    usesysid | 16384
    usename | replicator
    application_name | walreceiver
    client_addr | 192.168.10.24
    client_hostname |
    client_port | 59766
    backend_start | 2020-09-06 13:10:44.743067+00
    backend_xmin |
    state | streaming
    sent_lsn | 0/3000A08
    write_lsn | 0/3000A08
    flush_lsn | 0/3000A08
    replay_lsn | 0/3000A08
    write_lag |
    flush_lag |
    replay_lag |
    sync_priority | 1
    sync_state | sync
    reply_time | 2020-09-06 13:19:13.295971+00
    
    [postgres@pg1 ~]$

<figure class="wp-block-image size-large"><img loading="lazy" width="716" height="536" src="/content/images/wordpress/2020/09/4-3.png" alt="" class="wp-image-477" srcset="/content/images/wordpress/2020/09/4-3.png 716w, /content/images/wordpress/2020/09/4-3-300x225.png 300w" sizes="(max-width: 716px) 100vw, 716px"></figure>

Perhatikan gambar diatas saat ini _sync\_state_ nya sudah menjadi _sync_ .

Langkah terakhir reload postgresql

    [root@pg1 ~]#
    [root@pg1 ~]# systemctl reload postgresql-12.service
    [root@pg1 ~]#

Selamat mencoba 😁

Please follow and like us:

[![error](/wp-content/plugins/ultimate-social-media-icons/images/follow_subscribe.png)](https://api.follow.it/widgets/icon/VHc3d1lpVGdwRnE5QnV0eERCNUx5RCtvTTVoUkNYS3NNRmd5eVhlQW9tNXRHS3VTbGh6Y0NybkRJRS8zSGpjRDVZb1ZGMlNTSEpJYUpuZzZqNzdnd3VSN3dwM2VlQTF6ejJEaGV5UGRUbnlEcHFNd3luYTV4ZTZtUGowVWI2Q2x8M2kzdnBEeUIrUk5xOFI5TXZ3cHF3bFNQRkRJSGhUNGdrRFd0TlNtdE1OWT0=/OA==/)

[![fb-share-icon](/wp-content/plugins/ultimate-social-media-icons/images/visit_icons/fbshare_bck.png "Facebook Share")](https://www.facebook.com/sharer/sharer.php?u=https%3A%2F%2Fbelajarlinux.id%2F%3Fp%3D470%26ghostexport%3Dtrue%26submit%3DDownload+Ghost+File)

[![Tweet](/wp-content/plugins/ultimate-social-media-icons/images/visit_icons/en_US_Tweet.svg "Tweet")](https://twitter.com/intent/tweet?text=Cara+Konfigurasi+PostgreSQL+12+Replika+Streaming+di+CentOS+8+https://belajarlinux.id/?p=470&ghostexport=true&submit=Download Ghost File)

[![fb-share-icon](/wp-content/plugins/ultimate-social-media-icons/images/share_icons/Pinterest_Save/en_US_save.svg "Pin Share")](#)

<!--kg-card-end: html-->
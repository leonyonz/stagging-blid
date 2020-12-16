---
layout: post
title: Cara Install PostgreSQL di CentOS 8
featured: true
date: '2020-09-05 01:55:56'
tags:
- centos
- database
---

**[PostgreSQL](https://www.postgresql.org/)**, biasa di singkat dengan kata _postgres_ merupakan sistem manajemen basis data relasional yang open-source _(databases)_ yang dapat menekankan ekstensibilitas dan kepatuhan SQL. Awalnya bernama POSTGRES, merujuk pada asalnya sebagai penerus basis data Ingres yang dikembangkan di University of California. Selengkapnya dapat merujuk pada link berikut: **[Wiki PostgreSQL](https://en.wikipedia.org/wiki/PostgreSQL)**

Di CentOS 8 postgresql secara default sudah ada di repository default dan ada beberapa versi posgresql yang dapat Anda gunakna mulai dari versi 9.6, 10 dan 12, sebagai berikut

    [root@pg1 ~]#
    [root@pg1 ~]# dnf module list postgresql
    Last metadata expiration check: 2:37:44 ago on Fri 04 Sep 2020 04:00:54 PM UTC.
    CentOS-8 - AppStream
    Name Stream Profiles Summary postgresql 9.6 client, server [d] PostgreSQL server and client module postgresql 10 [d] client, server [d] PostgreSQL server and client module postgresql 12 [e] client, server [d] PostgreSQL server and client module                             
    Hint: [d]efault, [e]nabled, [x]disabled, [i]nstalled
    [root@pg1 ~]#

Secara default postgres di CentOS 8 yaitu versi 10, jika Anda ingin menggunakan versi 9.6 atau 12 Anda hanya perlu enable saja.

Disini kami akan menggunakan versi 12 oleh karena itu Anda hanya perlu menjalankan perintah berikut untuk enable nya:

    [root@pg1 ~]#
    [root@pg1 ~]# dnf module enable postgresql:12
    Last metadata expiration check: 0:25:48 ago on Fri 04 Sep 2020 06:24:50 AM UTC.
    Dependencies resolved.
    ============================================================================================================================================================================================== Package Architecture Version Repository Size
    ==============================================================================================================================================================================================Enabling module streams:
     postgresql 12
    
    Transaction Summary
    ==============================================================================================================================================================================================
    Is this ok [y/N]: y
    Complete!
    [root@pg1 ~]#

Untuk instalasi postgre SQL server nya Anda jalankan perintah berikut

    [root@pg1 ~]#
    [root@pg1 ~]# dnf install postgresql-server -y

Inisiasi postgresql

    [root@pg1 ~]#
    [root@pg1 ~]# postgresql-setup --initdb
     * Initializing database in '/var/lib/pgsql/data'
     * Initialized, logs are in /var/lib/pgsql/initdb_postgresql.log
    [root@pg1 ~]#

Start dan enable postgreSQL

    [root@pg1 ~]#
    [root@pg1 ~]# systemctl start postgresql
    [root@pg1 ~]# systemctl enable postgresql
    Created symlink /etc/systemd/system/multi-user.target.wants/postgresql.service → /usr/lib/systemd/system/postgresql.service.
    [root@pg1 ~]# systemctl status postgresql
    ● postgresql.service - PostgreSQL database server
       Loaded: loaded (/usr/lib/systemd/system/postgresql.service; enabled; vendor preset: disabled)
       Active: active (running) since Fri 2020-09-04 06:52:04 UTC; 18s ago
     Main PID: 5672 (postmaster)
        Tasks: 8 (limit: 11328)
       Memory: 17.1M
       CGroup: /system.slice/postgresql.service
               ├─5672 /usr/bin/postmaster -D /var/lib/pgsql/data
               ├─5674 postgres: logger
               ├─5676 postgres: checkpointer
               ├─5677 postgres: background writer
               ├─5678 postgres: walwriter
               ├─5679 postgres: autovacuum launcher
               ├─5680 postgres: stats collector
               └─5681 postgres: logical replication launcher
    
    Sep 04 06:52:04 pg1.nurhamim.my.id systemd[1]: Starting PostgreSQL database server...
    Sep 04 06:52:04 pg1.nurhamim.my.id postmaster[5672]: 2020-09-04 06:52:04.503 UTC [5672] LOG: starting PostgreSQL 12.1 on x86_64-redhat-linux-gnu, compiled by gcc (GCC) 8.3.1 20190507 (Red >Sep 04 06:52:04 pg1.nurhamim.my.id postmaster[5672]: 2020-09-04 06:52:04.503 UTC [5672] LOG: listening on IPv6 address "::1", port 5432
    Sep 04 06:52:04 pg1.nurhamim.my.id postmaster[5672]: 2020-09-04 06:52:04.504 UTC [5672] LOG: listening on IPv4 address "127.0.0.1", port 5432
    Sep 04 06:52:04 pg1.nurhamim.my.id postmaster[5672]: 2020-09-04 06:52:04.518 UTC [5672] LOG: listening on Unix socket "/var/run/postgresql/.s.PGSQL.5432"
    Sep 04 06:52:04 pg1.nurhamim.my.id postmaster[5672]: 2020-09-04 06:52:04.650 UTC [5672] LOG: listening on Unix socket "/tmp/.s.PGSQL.5432"
    Sep 04 06:52:04 pg1.nurhamim.my.id postmaster[5672]: 2020-09-04 06:52:04.669 UTC [5672] LOG: redirecting log output to logging collector process
    Sep 04 06:52:04 pg1.nurhamim.my.id postmaster[5672]: 2020-09-04 06:52:04.669 UTC [5672] HINT: Future log output will appear in directory "log".
    Sep 04 06:52:04 pg1.nurhamim.my.id systemd[1]: Started PostgreSQL database server.
    
    [root@pg1 ~]#

Cek versi posgreSQL

    [root@pg1 ~]# postgres --version
    postgres (PostgreSQL) 12.1
    [root@pg1 ~]#

Selanjutnya mengamankan akun postgres dengan cara memberikan password

    [root@pg1 ~]#
    [root@pg1 ~]# passwd postgres
    Changing password for user postgres.
    New password:
    Retype new password:
    passwd: all authentication tokens updated successfully.
    [root@pg1 ~]#

Login ke postgres dan membuat user role postgres

    [root@pg1 ~]# su - postgres
    Last login: Fri Sep 4 18:45:05 UTC 2020 on pts/0
    [postgres@pg1 ~]$
    [postgres@pg1 ~]$ psql -c "ALTER USER postgres WITH PASSWORD 'secret2020';"
    ALTER ROLE
    [postgres@pg1 ~]$ exit
    logout
    [root@pg1 ~]#

Selanjutnya konfigurasi postgres untuk dapat melakukan authentikasi client seperti pgAdmin.

Metode otentikasi yang didukung mencakup otentikasi berbasis kata sandi yang menggunakan salah satu metode enkripsi berikut: md5, crypt, atau password.

Disini kami akan menggunakan md5.

    [root@pg1 ~]#
    [root@pg1 ~]# vim /var/lib/pgsql/data/pg_hba.conf

<figure class="wp-block-image size-large"><img loading="lazy" width="570" height="157" src="/content/images/wordpress/2020/09/image-16.png" alt="" class="wp-image-456" srcset="/content/images/wordpress/2020/09/image-16.png 570w, /content/images/wordpress/2020/09/image-16-300x83.png 300w" sizes="(max-width: 570px) 100vw, 570px"></figure>

Ubah menjadi md5

<figure class="wp-block-image size-large"><img loading="lazy" width="608" height="153" src="/content/images/wordpress/2020/09/image-17.png" alt="" class="wp-image-457" srcset="/content/images/wordpress/2020/09/image-17.png 608w, /content/images/wordpress/2020/09/image-17-300x75.png 300w" sizes="(max-width: 608px) 100vw, 608px"></figure>

Selanjutnya restart postgresql

    [root@pg1 ~]# systemctl restart postgresql
    [root@pg1 ~]#

Selamat saat ini postgresql Anda sudah berhasil terinstall.

Selamat mencoba 😁

Please follow and like us:

[![error](/wp-content/plugins/ultimate-social-media-icons/images/follow_subscribe.png)](https://api.follow.it/widgets/icon/VHc3d1lpVGdwRnE5QnV0eERCNUx5RCtvTTVoUkNYS3NNRmd5eVhlQW9tNXRHS3VTbGh6Y0NybkRJRS8zSGpjRDVZb1ZGMlNTSEpJYUpuZzZqNzdnd3VSN3dwM2VlQTF6ejJEaGV5UGRUbnlEcHFNd3luYTV4ZTZtUGowVWI2Q2x8M2kzdnBEeUIrUk5xOFI5TXZ3cHF3bFNQRkRJSGhUNGdrRFd0TlNtdE1OWT0=/OA==/)

[![fb-share-icon](/wp-content/plugins/ultimate-social-media-icons/images/visit_icons/fbshare_bck.png "Facebook Share")](https://www.facebook.com/sharer/sharer.php?u=https%3A%2F%2Fbelajarlinux.id%2F%3Fp%3D455%26ghostexport%3Dtrue%26submit%3DDownload+Ghost+File)

[![Tweet](/wp-content/plugins/ultimate-social-media-icons/images/visit_icons/en_US_Tweet.svg "Tweet")](https://twitter.com/intent/tweet?text=Cara+Install+PostgreSQL+di+CentOS+8+https://belajarlinux.id/?p=455&ghostexport=true&submit=Download Ghost File)

[![fb-share-icon](/wp-content/plugins/ultimate-social-media-icons/images/share_icons/Pinterest_Save/en_US_save.svg "Pin Share")](#)

<!--kg-card-end: html-->
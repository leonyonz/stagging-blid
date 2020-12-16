---
layout: post
title: Cara Install pgAdmin4 di CentOS 8
featured: true
date: '2020-09-06 04:12:56'
tags:
- centos
- database
---

pgAdmin adalah sebuah proyek open source yang dapat digunakan secara gtratis yang dirilis dibawah lisensi [PostgreSQL/Artistic licence](https://www.pgadmin.org/licence/). pgAdmin dapat Anda gunakan untuk pengelolaan database postgresql, pgadmin layaknya phpmyadmin jika di database mariadb atau mysql.

pgAdmin dapat diinstall di berbagai macam sistem operasi mulai dari Windows, Linux, MacOS.

Pada tutorial kali ini kami akan melakukan instalasi pgAdmin versi 4 di CentOS 8 serta bagaimana cara mengkoneksikan antara pgAdmin dengan database postgresql.

Sebelum mengikuti tutorial kali ini pastikan Anda sudah install terlebih dahulu postgresql nya: **[_Cara Install PostgreSQL di CentOS 8_](/cara-install-postgresql-di-centos-8/)**

Untuk instalasi pgAdmin pertama kali yang harus kita lakukan yaitu install epel repository terlebih dahulu.

    [root@pg1 ~]#
    [root@pg1 ~]# dnf install epel-release -y

Karena pgAdmin akan diakses melalui web browser maka kita perlu install terlebih dahulu web server yang akan digunakna, disini kami mengunakan apache web server.

    [root@pg1 ~]#
    [root@pg1 ~]# dnf install httpd -y

Start apache dan pastikan statusnya running

    [root@pg1 ~]# systemctl start httpd; systemctl status httpd
    ● httpd.service - The Apache HTTP Server
       Loaded: loaded (/usr/lib/systemd/system/httpd.service; disabled; vendor preset: disabled)
       Active: reloading (reload) since Fri 2020-09-04 19:00:09 UTC; 19ms ago
         Docs: man:httpd.service(8)
     Main PID: 7464 (httpd)
       Status: "Reading configuration..."
        Tasks: 1 (limit: 11328)
       Memory: 3.2M
       CGroup: /system.slice/httpd.service
               └─7464 /usr/sbin/httpd -DFOREGROUND
    
    Sep 04 19:00:03 pg1.nurhamim.my.id systemd[1]: Starting The Apache HTTP Server...
    Sep 04 19:00:09 pg1.nurhamim.my.id systemd[1]: Started The Apache HTTP Server.
    [root@pg1 ~]#

Install repository postgresql

    [root@pg1 ~]#
    [root@pg1 ~]# dnf install https://download.postgresql.org/pub/repos/yum/reporpms/EL-8-x86_64/pgdg-redhat-repo-latest.noarch.rpm

Disable module appstream default postgresql di CentOS 8

    [root@pg1 ~]#
    [root@pg1 ~]# dnf -qy module disable postgresql
    [root@pg1 ~]#

Install pgAdmin4 menggunakan command berikut

    [root@pg1 ~]#
    [root@pg1 ~]# dnf install pgadmin4 -y

Pindah ke direktori apache dan copy sample config pgadmin4

    [root@pg1 ~]#
    [root@pg1 ~]# cd /etc/httpd/conf.d/
    [root@pg1 conf.d]#
    [root@pg1 conf.d]# cp pgadmin4.conf.sample pgadmin4.conf
    [root@pg1 conf.d]#

Enable apache dan pastikan status nya running

    [root@pg1 conf.d]# systemctl enable --now httpd
    Created symlink /etc/systemd/system/multi-user.target.wants/httpd.service → /usr/lib/systemd/system/httpd.service.
    [root@pg1 conf.d]#
    [root@pg1 conf.d]# systemctl status httpd -l
    ● httpd.service - The Apache HTTP Server
       Loaded: loaded (/usr/lib/systemd/system/httpd.service; enabled; vendor preset: disabled)
       Active: active (running) since Fri 2020-09-04 19:00:09 UTC; 7min ago
         Docs: man:httpd.service(8)
     Main PID: 7464 (httpd)
       Status: "Running, listening on: port 80"
        Tasks: 213 (limit: 11328)
       Memory: 24.6M
       CGroup: /system.slice/httpd.service
               ├─7464 /usr/sbin/httpd -DFOREGROUND
               ├─7467 /usr/sbin/httpd -DFOREGROUND
               ├─7468 /usr/sbin/httpd -DFOREGROUND
               ├─7469 /usr/sbin/httpd -DFOREGROUND
               └─7470 /usr/sbin/httpd -DFOREGROUND
    
    Sep 04 19:00:03 pg1.nurhamim.my.id systemd[1]: Starting The Apache HTTP Server...
    Sep 04 19:00:09 pg1.nurhamim.my.id systemd[1]: Started The Apache HTTP Server.
    Sep 04 19:00:14 pg1.nurhamim.my.id httpd[7464]: Server configured, listening on: port 80
    [root@pg1 conf.d]#

Membuat direktori _lib_ dan _log_ untuk pgAdmin4

    [root@pg1 conf.d]# mkdir -p /var/lib/pgadmin4
    [root@pg1 conf.d]# mkdir -p /var/log/pgadmin4

Mendeklarasi lokasi / path file log, database SQLite, database session dan penyimpanan dalam file konfigurasi Python untuk pgAdmin dalam file

    [root@pg1 conf.d]#
    [root@pg1 conf.d]# vim /usr/lib/python3.6/site-packages/pgadmin4-web/config_distro.py

Tambahkan file konfigurasi sebagai beriikut

    HELP_PATH = '/usr/share/doc/pgadmin4-docs/en_US/html'
    UPGRADE_CHECK_ENABLED = False
    
    LOG_FILE = '/var/log/pgadmin4/pgadmin4.log'
    SQLITE_PATH = '/var/lib/pgadmin4/pgadmin4.db'
    SESSION_DB_PATH = '/var/lib/pgadmin4/sessions'
    STORAGE_DIR = '/var/lib/pgadmin4/storage'

Jalankan script python berikut untuk setup pgadmin dan membuat username dan password login ke sisi pgadmin

    [root@pg1 conf.d]#
    [root@pg1 conf.d]# python3 /usr/lib/python3.6/site-packages/pgadmin4-web/setup.py
    NOTE: Configuring authentication for SERVER mode.
    
    Enter the email address and password to use for the initial pgAdmin user account:
    
    Email address: me@nurhamim.my.id
    Password: #Isikan_Password
    Retype password: #Konfirmasi_Password
    pgAdmin 4 - Application Initialisation
    ======================================
    
    [root@pg1 conf.d]#

_Noted: input email dan password yang akan digunakan untuk login ke sisi pgadmin_

Change owner menjadi apache untuk direktori pgadmin di _lib_ dan _log_ yang kita buat sebelumnya.

    [root@pg1 conf.d]# chown -R apache:apache /var/lib/pgadmin4
    [root@pg1 conf.d]# chown -R apache:apache /var/log/pgadmin4
    [root@pg1 conf.d]#

Restart apache

    [root@pg1 conf.d]# systemctl restart httpd
    [root@pg1 conf.d]#

Disini kami sudah menyiapkan subdomain yang akan digunakan oleh pgadmin4 yaitu _pgadmin4.nurhamim.my.id_ subdomain tersebut sudah kami arahkan ke public IP instance/VM dengan cara menambahkan A record.

<figure class="wp-block-image size-large"><img loading="lazy" width="919" height="196" src="/content/images/wordpress/2020/09/1-2.png" alt="" class="wp-image-460" srcset="/content/images/wordpress/2020/09/1-2.png 919w, /content/images/wordpress/2020/09/1-2-300x64.png 300w, /content/images/wordpress/2020/09/1-2-768x164.png 768w" sizes="(max-width: 919px) 100vw, 919px"></figure>

Verifikasi subdomain menggunakan ping

<figure class="aligncenter size-large"><img loading="lazy" width="612" height="127" src="/content/images/wordpress/2020/09/2-2.png" alt="" class="wp-image-461" srcset="/content/images/wordpress/2020/09/2-2.png 612w, /content/images/wordpress/2020/09/2-2-300x62.png 300w" sizes="(max-width: 612px) 100vw, 612px"></figure>

Akses subdomain _pgadmin04.nurhamim.my.id/pgadmin4_ jika Anda tidak menggunakan domain silakan akses_public\_ip\_vm/pgadmin4_ hasilnya seperti berikut, silakan input username dan password yang sudah dibuat seeblumnya.

<figure class="aligncenter size-large"><img loading="lazy" width="1024" height="489" src="/content/images/wordpress/2020/09/3-1-1024x489.png" alt="" class="wp-image-462" srcset="/content/images/wordpress/2020/09/3-1-1024x489.png 1024w, /content/images/wordpress/2020/09/3-1-300x143.png 300w, /content/images/wordpress/2020/09/3-1-768x367.png 768w, /content/images/wordpress/2020/09/3-1-1536x733.png 1536w, /content/images/wordpress/2020/09/3-1.png 1919w" sizes="(max-width: 1024px) 100vw, 1024px"></figure>

Berikut default tampilan dari dashboard pgadmin4

<figure class="aligncenter size-large"><img loading="lazy" width="1024" height="352" src="/content/images/wordpress/2020/09/4-1-1024x352.png" alt="" class="wp-image-463" srcset="/content/images/wordpress/2020/09/4-1-1024x352.png 1024w, /content/images/wordpress/2020/09/4-1-300x103.png 300w, /content/images/wordpress/2020/09/4-1-768x264.png 768w, /content/images/wordpress/2020/09/4-1-1536x528.png 1536w, /content/images/wordpress/2020/09/4-1.png 1910w" sizes="(max-width: 1024px) 100vw, 1024px"></figure>

Untuk menambahkan server database postgre, silakan klik _Add New Server_

<figure class="aligncenter size-large"><img loading="lazy" width="1024" height="354" src="/content/images/wordpress/2020/09/1-3-1024x354.png" alt="" class="wp-image-464" srcset="/content/images/wordpress/2020/09/1-3-1024x354.png 1024w, /content/images/wordpress/2020/09/1-3-300x104.png 300w, /content/images/wordpress/2020/09/1-3-768x265.png 768w, /content/images/wordpress/2020/09/1-3-1536x531.png 1536w, /content/images/wordpress/2020/09/1-3.png 1915w" sizes="(max-width: 1024px) 100vw, 1024px"></figure>

Kemudian, isi name server database postgre Anda

<figure class="aligncenter size-large"><img loading="lazy" width="500" height="555" src="/content/images/wordpress/2020/09/2-3.png" alt="" class="wp-image-465" srcset="/content/images/wordpress/2020/09/2-3.png 500w, /content/images/wordpress/2020/09/2-3-270x300.png 270w" sizes="(max-width: 500px) 100vw, 500px"></figure>

Pindah ke tab _connection_ lalu isikan host/ipaddress server database postgre beserta username dan password nya. Jika sudah klik **Save**

<figure class="aligncenter size-large"><img loading="lazy" width="502" height="550" src="/content/images/wordpress/2020/09/3-2.png" alt="" class="wp-image-466" srcset="/content/images/wordpress/2020/09/3-2.png 502w, /content/images/wordpress/2020/09/3-2-274x300.png 274w" sizes="(max-width: 502px) 100vw, 502px"></figure>

<figure class="aligncenter size-large"><img loading="lazy" width="927" height="375" src="/content/images/wordpress/2020/09/4-2.png" alt="" class="wp-image-467" srcset="/content/images/wordpress/2020/09/4-2.png 927w, /content/images/wordpress/2020/09/4-2-300x121.png 300w, /content/images/wordpress/2020/09/4-2-768x311.png 768w" sizes="(max-width: 927px) 100vw, 927px"></figure>

Saat ini server postgresql Anda sudah ditambahkan ke pgadmin4 dan sudah dapat dikelola atau management database postgresql menggunakan pgadmin.

<figure class="aligncenter size-large"><img loading="lazy" width="1024" height="557" src="/content/images/wordpress/2020/09/5-1-1024x557.png" alt="" class="wp-image-468" srcset="/content/images/wordpress/2020/09/5-1-1024x557.png 1024w, /content/images/wordpress/2020/09/5-1-300x163.png 300w, /content/images/wordpress/2020/09/5-1-768x418.png 768w, /content/images/wordpress/2020/09/5-1-1536x835.png 1536w, /content/images/wordpress/2020/09/5-1.png 1916w" sizes="(max-width: 1024px) 100vw, 1024px"></figure>

Gambar diatas hanya sebagai contoh hasil misalnya membuat database, dan membuat tabel di dala database.

Selamat mencoba 😁

Please follow and like us:

[![error](/wp-content/plugins/ultimate-social-media-icons/images/follow_subscribe.png)](https://api.follow.it/widgets/icon/VHc3d1lpVGdwRnE5QnV0eERCNUx5RCtvTTVoUkNYS3NNRmd5eVhlQW9tNXRHS3VTbGh6Y0NybkRJRS8zSGpjRDVZb1ZGMlNTSEpJYUpuZzZqNzdnd3VSN3dwM2VlQTF6ejJEaGV5UGRUbnlEcHFNd3luYTV4ZTZtUGowVWI2Q2x8M2kzdnBEeUIrUk5xOFI5TXZ3cHF3bFNQRkRJSGhUNGdrRFd0TlNtdE1OWT0=/OA==/)

[![fb-share-icon](/wp-content/plugins/ultimate-social-media-icons/images/visit_icons/fbshare_bck.png "Facebook Share")](https://www.facebook.com/sharer/sharer.php?u=https%3A%2F%2Fbelajarlinux.id%2F%3Fp%3D459%26ghostexport%3Dtrue%26submit%3DDownload+Ghost+File)

[![Tweet](/wp-content/plugins/ultimate-social-media-icons/images/visit_icons/en_US_Tweet.svg "Tweet")](https://twitter.com/intent/tweet?text=Cara+Install+pgAdmin4+di+CentOS+8+https://belajarlinux.id/?p=459&ghostexport=true&submit=Download Ghost File)

[![fb-share-icon](/wp-content/plugins/ultimate-social-media-icons/images/share_icons/Pinterest_Save/en_US_save.svg "Pin Share")](#)

<!--kg-card-end: html-->
---
layout: post
title: WordPress High Availability Menggunakan Haproxy di CentOS 8
featured: true
date: '2020-09-02 21:58:23'
tags:
- centos
- cms
- database
- haproxy
- load-balancer
- nginx
---

WordPress salah satu CMS yang paling sering dan banyak digunakan untuk website, baik untuk website pribadi ataupun korporasi.

Pada tutorial kali ini kami akan mencoba mengkombinasikan WordPress dengan beberapa teknologi proxy dan load balancing, tujuannya untuk menciptakan high availability WordPress.

Tutorial – Tutorial sebelumnya kita sudah mencoba set up load balancing untuk database galera cluster menggunakan MariaDB MaxScale dan kali ini akan kami gunakannya sebagai database WordPress.

Berikut topologi yang akan kami gunakan

<figure class="wp-block-image size-large"><img loading="lazy" width="816" height="275" src="/content/images/wordpress/2020/09/galera-maxscale5.png" alt="" class="wp-image-422" srcset="/content/images/wordpress/2020/09/galera-maxscale5.png 816w, /content/images/wordpress/2020/09/galera-maxscale5-300x101.png 300w, /content/images/wordpress/2020/09/galera-maxscale5-768x259.png 768w" sizes="(max-width: 816px) 100vw, 816px"></figure>

Pada topologi diatas terdapat 2 Load Balancing diantaranya  
  
_ **1. Load Balancing Database Menggunakan MariaDB MaxScale yang menggunakan 4 Node.** _  
  
– _Node01, Node02 dan Node03:_ Digunakan sebagai Galera Cluster  
– _Node04:_ Digunakan sebagai proxy atau LB dari Galera Cluster.   
  
_ **2. Load Balancing CMS WordPress menggunakan HAProxy yang terdiri dari 3 Node.** _  
   
– _Node05, Node06:_ Digunakan sebagai CMS WordPress  
– _Node07:_ Digunakan sebagai HAProxy.   
  
Berikut detail IP dari node05 – node07:  
– _Node05:_  
_Hostname: wp1.nurhamim.my.id_  
_IP: 192.168.10.2_  
  
_– Node06_  
_Hostname: wp2.nurhamim.my.id_  
_IP: 192.168.10.24_  
  
– _Node07_:  
_Hostname: haproxy.nurhamim.my.id_  
_IP Local: 192.168.10.23_  
_IP Public: 103.93.52.117_  
  
Jadi setiap service (web server) dan (database server) di load balancing semua tujuannya adalah   
  
1. _Load Balancing HAProxy:_ Jika Web CMS di Node05 down, maka masih ada backup Node06  
2. _Load Balancing MariaDB MaxScale:_ Jika terdapat node di salah satu cluster down maka database masih dapat di handling oleh node yang lainnya.   
  
Untuk mengikuti tutorial kali ini pastikan Anda sudah melakukan instalasi Galera Cluster dan Instalasi Mariadb MaxScale terlebih dahulu panduannya dapat Anda lihat pada link berikut: _**[Memanfaatkan MariaDB MaxScale Sebagai Load Balancing Untuk Galera Cluster pada CentOS 8](/memanfaatkan-mariadb-maxscale-sebagai-load-balancing-untuk-galera-cluster-pada-centos-8/)**_

Pertama yang akan kita lakukan yaitu menyiapkan database CMS WordPress melalui database galera cluster, Anda dapat membuat database di salah satu node Galera Cluster, bisa di node01, node02 atau di node03.   
  
Disini kami akan setup database WordPress di node01

    [root@galera01 ~]#
    [root@galera01 ~]# mysql -u root -p
    Enter password:
    Welcome to the MariaDB monitor. Commands end with ; or \g.
    Your MariaDB connection id is 167
    Server version: 10.3.17-MariaDB MariaDB Server
    
    Copyright (c) 2000, 2018, Oracle, MariaDB Corporation Ab and others.
    
    Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.
    
    MariaDB [(none)]> create database wordpress;
    Query OK, 1 row affected (0.021 sec)
    
    MariaDB [(none)]> GRANT ALL ON wordpress.* TO userwp@192.168.10.2 IDENTIFIED BY 'secret';
    Query OK, 0 rows affected (0.025 sec)
    
    MariaDB [(none)]> GRANT ALL ON wordpress.* TO userwp@192.168.10.24 IDENTIFIED BY 'secret';
    Query OK, 0 rows affected (0.030 sec)
    
    MariaDB [(none)]> GRANT ALL ON wordpress.* TO userwp@192.168.10.15 IDENTIFIED BY 'secret';
    Query OK, 0 rows affected (0.033 sec)
    
    MariaDB [(none)]> flush privileges;
    Query OK, 0 rows affected (0.020 sec)
    
    MariaDB [(none)]> exit
    Bye
    [root@galera01 ~]#

_Noted: Create database, dan grant user ke masing – masing IP node web server yaitu 192.168.10.2, 192.168.10.24 serta grant ke IP Proxy MariaDB MaxScale 192.168.10.15_

Selanjutnya menyiapkan CMS WordPress di node05, karena CMS WordPress membutuhkan PHP oleh karena itu pastikan di setiap node webserver (node05 & node06) sudah terinsall PHP, disini kami menggunakan PHP 7.2 untuk instalasi PHP Anda dapat merujuk pada link berikut: _**[Cara Instalasi PHP 7 di CentOS 8](/cara-instalasi-php-7-di-centos-8/)**_

Verifikasi PHP di masing – masing node web server  
  
_Node05_

    [root@wp1 ~]# php -v
    PHP 7.2.24 (cli) (built: Oct 22 2019 08:28:36) ( NTS )
    Copyright (c) 1997-2018 The PHP Group
    Zend Engine v3.2.0, Copyright (c) 1998-2018 Zend Technologies
        with Zend OPcache v7.2.24, Copyright (c) 1999-2018, by Zend Technologies
    [root@wp1 ~]#

_Node06_

    [root@wp2 ~]# php -v
    PHP 7.2.24 (cli) (built: Oct 22 2019 08:28:36) ( NTS )
    Copyright (c) 1997-2018 The PHP Group
    Zend Engine v3.2.0, Copyright (c) 1998-2018 Zend Technologies
        with Zend OPcache v7.2.24, Copyright (c) 1999-2018, by Zend Technologies
    [root@wp2 ~]#

Berikutnya kita akan mengunduh dan menyiapkan CMS WordPress, web server yang aka kami gunakna yaitu Nginx untuk tahapan unduh, konfigurasi Nginx Anda dapat merujuk pada link berikut: [_ **Cara Instalasi WordPress menggunakan Nginx di CentOS 8** _](/cara-instalasi-wordpress-menggunakan-nginx-di-centos-8/)

Kemudian, pada konfigurasi database WordPress di _ **wp-config.php** _ silakan isikan IP proxy Mariadb MaxScale contoh nya

<figure class="wp-block-image size-large"><img loading="lazy" width="947" height="336" src="/content/images/wordpress/2020/09/image-6.png" alt="" class="wp-image-426" srcset="/content/images/wordpress/2020/09/image-6.png 947w, /content/images/wordpress/2020/09/image-6-300x106.png 300w, /content/images/wordpress/2020/09/image-6-768x272.png 768w" sizes="(max-width: 947px) 100vw, 947px"></figure>

Selanjutnya kita akan mensikronisasi data dan file antara node05 dengan node06.

Untuk sinkronisasi node05 dengan node06 akan menggunakan lsyncd.

Lsyncd akan kami install di tinggal node05 (sebagai master) node06 (sebagai backup/slave). Untuk instalasi dan Lsyncd Anda dapat merujuk pada tutorial berikut: _**[Cara Instalasi dan Menggunakan Lsyncd di CentOS 8](/cara-instalasi-dan-menggunakan-lsyncd-di-centos-8/)**_

Berikut contoh full konfigurasi lsyncd di node05

    ----
    -- User configuration file for lsyncd.
    --
    -- Simple example for default rsync, but executing moves through on the target.
    --
    -- For more examples, see /usr/share/doc/lsyncd*/examples/
    --
    -- sync{default.rsyncssh, source="/var/www/html", host="localhost", targetdir="/tmp/htmlcopy/"}
    
    settings {
            logfile = "/var/log/lsyncd/lsyncd.log",
            statusFile = "/tmp/lsyncd.stat",
            statusInterval = 1,
    }
    
    sync {
            default.rsync,
            source = "/var/www/html",
            target = "192.168.10.24:/var/www/html",
    }
    
    sync { default.rsync,
            source = "/etc/php-fpm.d",
            target = "192.168.10.24:/etc/php-fpm.d",
    }
    
    sync {
            default.rsync,
            source = "/etc/nginx/conf.d",
            target = "192.168.10.24:/etc/nginx/conf.d",
    }
    rsync = {
            update = true,
            perms = true,
            owner = true,
            group = true,
            rsh = "/usr/bin/ssh -l root -i /root/.ssh/id_rsa"
    }

Berikut contoh log sinkronisasi antara node05 dan node06 menggunakan lsyncd

    [root@wp1 ~]#
    [root@wp1 ~]# tail -f /var/log/lsyncd/lsyncd.log
    /wordpress/wp-config.php
    Wed Sep 2 12:41:03 2020 Normal: Finished a list after exitcode: 0
    Wed Sep 2 12:41:14 2020 Normal: --- TERM signal, fading ---
    Wed Sep 2 12:41:14 2020 Normal: --- Startup ---
    Wed Sep 2 12:41:14 2020 Normal: recursive startup rsync: /var/www/html/ -> 192.168.10.24:/var/www/html/
    Wed Sep 2 12:41:14 2020 Normal: recursive startup rsync: /etc/php-fpm.d/ -> 192.168.10.24:/etc/php-fpm.d/
    Wed Sep 2 12:41:14 2020 Normal: recursive startup rsync: /etc/nginx/conf.d/ -> 192.168.10.24:/etc/nginx/conf.d/
    Wed Sep 2 12:41:14 2020 Normal: Startup of /etc/nginx/conf.d/ -> 192.168.10.24:/etc/nginx/conf.d/ finished.
    Wed Sep 2 12:41:14 2020 Normal: Startup of /etc/php-fpm.d/ -> 192.168.10.24:/etc/php-fpm.d/ finished.
    Wed Sep 2 12:41:14 2020 Normal: Startup of /var/www/html/ -> 192.168.10.24:/var/www/html/ finished.

Jika sudah tahapan selanjutnya yaitu melakukan instalasi load balancer menggunakan HAProxy.

**High Availability Proxy** adalah kepanjangan dari HAProxy sebuah perangkat lunak open source dibawah **GPLv2 license**. HAProxy digunakan untuk membagi beban request atau load balancer TCP/HTTP dan solusi proxy yang dapat dijalankan di sistem operasi Linux, Solaris, dan FreeBSD.

Pembagian bebannya pun beragam sesuai dengan algoritma yang ada. HAProxy sudah umum digunakan untuk meningkatkan kinerja dan kehandalan sebuah server dengan mendistribusikan beban kerja dari beberapa server lain seperti web server, database server, smtp server dan yang lainnya.

Load Balancer menggunakan HAProxy bekerja sesuai dengan algoritma yang ditentukan. Terdapat 3 algoritma yang dapat digunakan diantaranya:

#### 1. Roundrobin

Algoritma Roundrobin salah satu algoritma default yang umum digunakan, cara kerjanya yaitu memilih secara bergantian antara host 1 dengan bost 2 dan seterusnya apabila terdapat request dari client.

#### 2. Leastconn

Jika Anda menggunakan algoritma Lestconn maka Anda dapat menentukan host mana yang akan menjadi beban atau tumpuan bila terdapat request dari client. Namun di sisi Backend Anda masih dapat menggunakan algoritma roundrobin.

#### 3. Source

Algoritma Source adalah salah satu metode yang dapat digunakan untuk memastikan bahwa pengguna akan terhubung ke server yang sama. Anda dapat memilih berdasarkan hash dari IP sumber yaitu alamat IP pengguna (Client).

Untuk melakukan instalasi HAProxy di CentOS 8 Anda hanya perlu menjalankan satu baris perintah berikut:

    [root@haproxy ~]#
    [root@haproxy ~]# dnf install haproxy -y

Tunggu proses instalasi sampai selesai, dan jika sudah silakan simpan konfigurasi default haproxy kita akan menggunakan konfigurasi custom

    [root@haproxy ~]#
    [root@haproxy ~]# cd /etc/haproxy/
    [root@haproxy haproxy]#
    [root@haproxy haproxy]# cp haproxy.cfg haproxy.cfg-org
    [root@haproxy haproxy]#
    [root@haproxy haproxy]# vim haproxy.cfg

Berikut full konfigurasi HAProxy nya

    global
            log /dev/log local0
            log /dev/log local1 notice
            chroot /var/lib/haproxy
            stats timeout 30s
            user haproxy
            group haproxy
            daemon
    
    defaults
            log global
            mode http
            option httplog
            option dontlognull
            timeout connect 5000
            timeout client 50000
            timeout server 50000
    
    frontend http_front
            bind *:80
            stats uri /haproxy?stats
            default_backend http_back
    
    backend http_back
            balance roundrobin
            server wp1.nurhamim.my.id 192.168.10.2:80 check
            server wp2.nurhamim.my.id 192.168.10.24:80 check

_Noted: Disini kami menggunakan algoritma roundrobin._

Jika sudah silakan simpan, dan restart dan pastikan status HAProxy running

    [root@haproxy haproxy]# systemctl restart haproxy
    [root@haproxy haproxy]# systemctl status haproxy -l
    ● haproxy.service - HAProxy Load Balancer
       Loaded: loaded (/usr/lib/systemd/system/haproxy.service; disabled; vendor preset: disabled)
       Active: active (running) since Wed 2020-09-02 10:42:08 UTC; 6s ago
      Process: 4947 ExecStartPre=/usr/sbin/haproxy -f $CONFIG -c -q (code=exited, status=0/SUCCESS)
     Main PID: 4949 (haproxy)
        Tasks: 2 (limit: 11328)
       Memory: 2.3M
       CGroup: /system.slice/haproxy.service
               ├─4949 /usr/sbin/haproxy -Ws -f /etc/haproxy/haproxy.cfg -p /run/haproxy.pid
               └─4950 /usr/sbin/haproxy -Ws -f /etc/haproxy/haproxy.cfg -p /run/haproxy.pid
    
    Sep 02 10:42:08 haproxy.nurhamim.my.id systemd[1]: Starting HAProxy Load Balancer...
    Sep 02 10:42:08 haproxy.nurhamim.my.id haproxy[4949]: Proxy http_front started.
    Sep 02 10:42:08 haproxy.nurhamim.my.id haproxy[4949]: Proxy http_front started.
    Sep 02 10:42:08 haproxy.nurhamim.my.id haproxy[4949]: Proxy http_back started.
    Sep 02 10:42:08 haproxy.nurhamim.my.id haproxy[4949]: Proxy http_back started.
    Sep 02 10:42:08 haproxy.nurhamim.my.id systemd[1]: Started HAProxy Load Balancer.
    [root@haproxy haproxy]#
    [root@haproxy haproxy]#

Disini kami sudah mengarahkan subdomain _wp-ha.nurhamim.my.id_ ke IP Public _HAProxy_

<figure class="wp-block-image size-large"><img loading="lazy" width="924" height="44" src="/content/images/wordpress/2020/09/image-7.png" alt="" class="wp-image-427" srcset="/content/images/wordpress/2020/09/image-7.png 924w, /content/images/wordpress/2020/09/image-7-300x14.png 300w, /content/images/wordpress/2020/09/image-7-768x37.png 768w" sizes="(max-width: 924px) 100vw, 924px"></figure>

Verifikasi subdomain diatas menggunakan ping

<figure class="wp-block-image size-large"><img loading="lazy" width="753" height="172" src="/content/images/wordpress/2020/09/1.png" alt="" class="wp-image-428" srcset="/content/images/wordpress/2020/09/1.png 753w, /content/images/wordpress/2020/09/1-300x69.png 300w" sizes="(max-width: 753px) 100vw, 753px"></figure>

Akses HAProxy menggunakan IP Public atau subdomain diatas contohnya: [http://IP\_SERVER\_ANDA/haproxy?stats](http://IP_SERVER_ANDA/haproxy?stats)

<figure class="wp-block-image size-large"><img loading="lazy" width="1024" height="353" src="/content/images/wordpress/2020/09/2-1024x353.png" alt="" class="wp-image-429" srcset="/content/images/wordpress/2020/09/2-1024x353.png 1024w, /content/images/wordpress/2020/09/2-300x103.png 300w, /content/images/wordpress/2020/09/2-768x264.png 768w, /content/images/wordpress/2020/09/2-1536x529.png 1536w, /content/images/wordpress/2020/09/2.png 1920w" sizes="(max-width: 1024px) 100vw, 1024px"></figure>

Saat ini web server _node05 dan node06_ sudah berhasil di load balancing, selanjutnya install CMS WordPress

<figure class="wp-block-image size-large"><img loading="lazy" width="1024" height="531" src="/content/images/wordpress/2020/09/3-1024x531.png" alt="" class="wp-image-430" srcset="/content/images/wordpress/2020/09/3-1024x531.png 1024w, /content/images/wordpress/2020/09/3-300x155.png 300w, /content/images/wordpress/2020/09/3-768x398.png 768w, /content/images/wordpress/2020/09/3-1536x796.png 1536w, /content/images/wordpress/2020/09/3.png 1918w" sizes="(max-width: 1024px) 100vw, 1024px"></figure>

Isikan semua yang dibutuhkan lalu klik Install WordPress

<figure class="wp-block-image size-large"><img loading="lazy" width="1024" height="313" src="/content/images/wordpress/2020/09/4-1024x313.png" alt="" class="wp-image-431" srcset="/content/images/wordpress/2020/09/4-1024x313.png 1024w, /content/images/wordpress/2020/09/4-300x92.png 300w, /content/images/wordpress/2020/09/4-768x235.png 768w, /content/images/wordpress/2020/09/4-1536x469.png 1536w, /content/images/wordpress/2020/09/4.png 1915w" sizes="(max-width: 1024px) 100vw, 1024px"></figure>

Selamat proses instalasi CMS WordPress sudah berhasil di lakukan, berikut tampilan default page CMS WordPress.

<figure class="wp-block-image size-large"><img loading="lazy" width="1024" height="307" src="/content/images/wordpress/2020/09/5-1024x307.png" alt="" class="wp-image-432" srcset="/content/images/wordpress/2020/09/5-1024x307.png 1024w, /content/images/wordpress/2020/09/5-300x90.png 300w, /content/images/wordpress/2020/09/5-768x231.png 768w, /content/images/wordpress/2020/09/5-1536x461.png 1536w, /content/images/wordpress/2020/09/5.png 1905w" sizes="(max-width: 1024px) 100vw, 1024px"></figure>

Pastikan semua database sudah tereplikasi

<figure class="wp-block-image size-large"><img loading="lazy" width="1024" height="424" src="/content/images/wordpress/2020/09/image-8-1024x424.png" alt="" class="wp-image-433" srcset="/content/images/wordpress/2020/09/image-8-1024x424.png 1024w, /content/images/wordpress/2020/09/image-8-300x124.png 300w, /content/images/wordpress/2020/09/image-8-768x318.png 768w, /content/images/wordpress/2020/09/image-8-1536x635.png 1536w, /content/images/wordpress/2020/09/image-8.png 1912w" sizes="(max-width: 1024px) 100vw, 1024px"></figure>

Selanjutnya kita akan mencoba melihat koneksi di sisi proxy atau load balancing MariaDB MaxScale di node04

<figure class="wp-block-image size-large"><img loading="lazy" width="1024" height="734" src="/content/images/wordpress/2020/09/image-9-1024x734.png" alt="" class="wp-image-434" srcset="/content/images/wordpress/2020/09/image-9-1024x734.png 1024w, /content/images/wordpress/2020/09/image-9-300x215.png 300w, /content/images/wordpress/2020/09/image-9-768x551.png 768w, /content/images/wordpress/2020/09/image-9.png 1141w" sizes="(max-width: 1024px) 100vw, 1024px"></figure>

Selamat mencoba 😁

Please follow and like us:

[![error](/wp-content/plugins/ultimate-social-media-icons/images/follow_subscribe.png)](https://api.follow.it/widgets/icon/VHc3d1lpVGdwRnE5QnV0eERCNUx5RCtvTTVoUkNYS3NNRmd5eVhlQW9tNXRHS3VTbGh6Y0NybkRJRS8zSGpjRDVZb1ZGMlNTSEpJYUpuZzZqNzdnd3VSN3dwM2VlQTF6ejJEaGV5UGRUbnlEcHFNd3luYTV4ZTZtUGowVWI2Q2x8M2kzdnBEeUIrUk5xOFI5TXZ3cHF3bFNQRkRJSGhUNGdrRFd0TlNtdE1OWT0=/OA==/)

[![fb-share-icon](/wp-content/plugins/ultimate-social-media-icons/images/visit_icons/fbshare_bck.png "Facebook Share")](https://www.facebook.com/sharer/sharer.php?u=https%3A%2F%2Fbelajarlinux.id%2F%3Fp%3D420%26ghostexport%3Dtrue%26submit%3DDownload+Ghost+File)

[![Tweet](/wp-content/plugins/ultimate-social-media-icons/images/visit_icons/en_US_Tweet.svg "Tweet")](https://twitter.com/intent/tweet?text=WordPress+High+Availability+Menggunakan+Haproxy+di+CentOS+8+https://belajarlinux.id/?p=420&ghostexport=true&submit=Download Ghost File)

[![fb-share-icon](/wp-content/plugins/ultimate-social-media-icons/images/share_icons/Pinterest_Save/en_US_save.svg "Pin Share")](#)

<!--kg-card-end: html-->
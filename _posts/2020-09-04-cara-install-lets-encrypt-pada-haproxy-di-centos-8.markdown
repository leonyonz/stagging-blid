---
layout: post
title: Cara Install Let's Encrypt pada HAProxy di CentOS 8
featured: true
date: '2020-09-04 03:13:49'
tags:
- centos
- haproxy
- ssl
---

**[Letsencrypt](https://letsencrypt.org/id/getting-started/)**&nbsp;salah satu SSL&nbsp;_(Secure Sockets Layer)_&nbsp;free yang dapat Anda gunakan Letsencrypt dapat Anda install di berbagai sistem operasi, dan web server. Untuk instalasi letsencrypt dapat menggunakan&nbsp;_**[Certbot](https://certbot.eff.org/)**_

Sebelum melakukan instalasi certbot kita perlu install epel repository terlebih dahulu seperti berikut

    [root@haproxy ~]#
    [root@haproxy ~]# dnf install epel-release -y

Selanjutnya install certbot menggunakan perintah berikut

    [root@haproxy ~]#
    [root@haproxy ~]# dnf install certbot -y

Stop HAProxy nya terlebih dahulu dan pastikan tidak ada yang listen ke port 80

    [root@haproxy ~]# systemctl stop haproxy
    [root@haproxy ~]# netstat -na | grep ':80.*LISTEN'
    [root@haproxy ~]#

Selanjutnya generate dan menerbitkan certificate SSL letsencrypt

    [root@haproxy ~]#
    [root@haproxy ~]# certbot certonly --standalone --preferred-challenges http --http-01-port 80 -d wp-ha.nurhamim.my.id

_Noted: Ubah wp-ha.nurhamim.my.id dengan nama domain atau subdomain HAProxy Anda_

Jika berhasil akan ada pesan atau output seperti berikut

    IMPORTANT NOTES:
     - Congratulations! Your certificate and chain have been saved at:
       /etc/letsencrypt/live/wp-ha.nurhamim.my.id/fullchain.pem
       Your key file has been saved at:
       /etc/letsencrypt/live/wp-ha.nurhamim.my.id/privkey.pem
       Your cert will expire on 2020-12-02. To obtain a new or tweaked
       version of this certificate in the future, simply run certbot
       again. To non-interactively renew *all* of your certificates, run
       "certbot renew"
     - If you like Certbot, please consider supporting our work by:
    
       Donating to ISRG / Let's Encrypt: https://letsencrypt.org/donate
       Donating to EFF: https://eff.org/donate-le
    
     - We were unable to subscribe you the EFF mailing list because your
       e-mail address appears to be invalid. You can try again later by
       visiting https://act.eff.org.
    [root@haproxy ~]#

Lihat SSL yang sudah di generate di direktori _/etc/letsencrypt_/_live_

    [root@haproxy ~]#
    [root@haproxy ~]# ls /etc/letsencrypt/live
    README wp-ha.nurhamim.my.id
    [root@haproxy ~]#

Membuat direktori _ **certs** di direktori haproxy_

    [root@haproxy ~]# mkdir -p /etc/haproxy/certs
    [root@haproxy ~]#

Gabungkan SSL _wp-ha.nurhamim.my.id_ menggunakan _cat_ seperti berikut

    [root@haproxy ~]#
    [root@haproxy ~]# DOMAIN='wp-ha.nurhamim.my.id' sudo -E bash -c 'cat /etc/letsencrypt/live/$DOMAIN/fullchain.pem /etc/letsencrypt/live/$DOMAIN/privkey.pem > /etc/haproxy/certs/$DOMAIN.pem'
    [root@haproxy ~]#

_Noted: Sesuaikan wp-ha.nurhamim.my.id dengan nama domain atau subdomain SSL Anda_

Berikan permission berikut, pada direktori _/etc/haproxy/certs_

    [root@haproxy ~]#
    [root@haproxy ~]# chmod -R go-rwx /etc/haproxy/certs
    [root@haproxy ~]#

Konfigurasi HAProxy

    [root@haproxy ~]#
    [root@haproxy ~]# vim /etc/haproxy/haproxy.cfg

Berikut isi full konfigurasi HAProxy

    global
            log /dev/log local0
            log /dev/log local1 notice
            chroot /var/lib/haproxy
            stats timeout 30s
            user haproxy
            group haproxy
            daemon
            tune.ssl.default-dh-param 2048
    
    defaults
            log global
            mode http
            option httplog
            option dontlognull
            timeout connect 5000
            timeout client 50000
            timeout server 50000
    
    frontend www-http
            bind *:80
            reqadd X-Forwarded-Proto:\ http
            stats uri /haproxy?stats
            default_backend www-backend
    
    
    frontend www-https
            bind *:443 ssl crt /etc/haproxy/certs/wp-ha.nurhamim.my.id.pem
            reqadd X-Forwarded-Proto:\ https
            acl letsencrypt-acl path_beg /.well-known/acme-challenge/
            use_backend letsencrypt-backend if letsencrypt-acl
            default_backend www-backend
    
    backend www-backend
            redirect scheme https if !{ ssl_fc }
            server wp01 192.168.10.2:80 check
            server wp02 192.168.10.24:80 check
    
    backend letsencrypt-backend
            server letsencrypt 127.0.0.1:54321
    
    listen stats
            bind *:2233 ssl crt /etc/haproxy/certs/wp-ha.nurhamim.my.id.pem
            stats enable
            stats hide-version
            stats refresh 30s
            stats show-node
            stats auth username:password
            stats uri /stats

_Noted: Silakan sesuaikan bagian ssl dengan menambahkan /etc/haproxy/certs/wp-ha.nurhamim.my.id.pem_

Simpan konfigurasi HAProxy nya dan silakan start dan pastikan status HAProxy running

    [root@haproxy ~]#
    [root@haproxy ~]# systemctl start haproxy
    [root@haproxy ~]# systemctl status haproxy -l
    ● haproxy.service - HAProxy Load Balancer
       Loaded: loaded (/usr/lib/systemd/system/haproxy.service; disabled; vendor preset: disabled)
       Active: active (running) since Thu 2020-09-03 19:12:17 UTC; 3s ago
      Process: 12408 ExecStartPre=/usr/sbin/haproxy -f $CONFIG -c -q (code=exited, status=0/SUCCESS)
     Main PID: 12409 (haproxy)
        Tasks: 2 (limit: 11328)
       Memory: 6.7M
       CGroup: /system.slice/haproxy.service
               ├─12409 /usr/sbin/haproxy -Ws -f /etc/haproxy/haproxy.cfg -p /run/haproxy.pid
               └─12411 /usr/sbin/haproxy -Ws -f /etc/haproxy/haproxy.cfg -p /run/haproxy.pid
    
    Sep 03 19:12:17 haproxy.nurhamim.my.id haproxy[12409]: Proxy www-http started.
    Sep 03 19:12:17 haproxy.nurhamim.my.id haproxy[12409]: Proxy www-https started.
    Sep 03 19:12:17 haproxy.nurhamim.my.id haproxy[12409]: Proxy www-https started.
    Sep 03 19:12:17 haproxy.nurhamim.my.id haproxy[12409]: Proxy www-backend started.
    Sep 03 19:12:17 haproxy.nurhamim.my.id haproxy[12409]: Proxy www-backend started.
    Sep 03 19:12:17 haproxy.nurhamim.my.id haproxy[12409]: Proxy letsencrypt-backend started.
    Sep 03 19:12:17 haproxy.nurhamim.my.id haproxy[12409]: Proxy letsencrypt-backend started.
    Sep 03 19:12:17 haproxy.nurhamim.my.id haproxy[12409]: Proxy stats started.
    Sep 03 19:12:17 haproxy.nurhamim.my.id haproxy[12409]: Proxy stats started.
    Sep 03 19:12:17 haproxy.nurhamim.my.id systemd[1]: Started HAProxy Load Balancer.
    [root@haproxy ~]#

Akses HAProxy Anda melalui web browser dan isikan password login ke HAProxy nya

<figure class="wp-block-image size-large"><img loading="lazy" width="1024" height="264" src="/content/images/wordpress/2020/09/image-13-1024x264.png" alt="" class="wp-image-450" srcset="/content/images/wordpress/2020/09/image-13-1024x264.png 1024w, /content/images/wordpress/2020/09/image-13-300x77.png 300w, /content/images/wordpress/2020/09/image-13-768x198.png 768w, /content/images/wordpress/2020/09/image-13.png 1363w" sizes="(max-width: 1024px) 100vw, 1024px"></figure>

Saat ini HAProxy sudah terinstall SSL letsencrypt

<figure class="wp-block-image size-large"><img loading="lazy" width="1024" height="550" src="/content/images/wordpress/2020/09/image-14-1024x550.png" alt="" class="wp-image-451" srcset="/content/images/wordpress/2020/09/image-14-1024x550.png 1024w, /content/images/wordpress/2020/09/image-14-300x161.png 300w, /content/images/wordpress/2020/09/image-14-768x413.png 768w, /content/images/wordpress/2020/09/image-14.png 1366w" sizes="(max-width: 1024px) 100vw, 1024px"></figure>

Saat ini SSL sudah issued menggunakan letsencrypt

<figure class="wp-block-image size-large"><img loading="lazy" width="773" height="598" src="/content/images/wordpress/2020/09/image-15.png" alt="" class="wp-image-452" srcset="/content/images/wordpress/2020/09/image-15.png 773w, /content/images/wordpress/2020/09/image-15-300x232.png 300w, /content/images/wordpress/2020/09/image-15-768x594.png 768w" sizes="(max-width: 773px) 100vw, 773px"></figure>

Selamat mencoba 😁

Please follow and like us:

[![error](/wp-content/plugins/ultimate-social-media-icons/images/follow_subscribe.png)](https://api.follow.it/widgets/icon/VHc3d1lpVGdwRnE5QnV0eERCNUx5RCtvTTVoUkNYS3NNRmd5eVhlQW9tNXRHS3VTbGh6Y0NybkRJRS8zSGpjRDVZb1ZGMlNTSEpJYUpuZzZqNzdnd3VSN3dwM2VlQTF6ejJEaGV5UGRUbnlEcHFNd3luYTV4ZTZtUGowVWI2Q2x8M2kzdnBEeUIrUk5xOFI5TXZ3cHF3bFNQRkRJSGhUNGdrRFd0TlNtdE1OWT0=/OA==/)

[![fb-share-icon](/wp-content/plugins/ultimate-social-media-icons/images/visit_icons/fbshare_bck.png "Facebook Share")](https://www.facebook.com/sharer/sharer.php?u=https%3A%2F%2Fbelajarlinux.id%2F%3Fp%3D448%26ghostexport%3Dtrue%26submit%3DDownload+Ghost+File)

[![Tweet](/wp-content/plugins/ultimate-social-media-icons/images/visit_icons/en_US_Tweet.svg "Tweet")](https://twitter.com/intent/tweet?text=Cara+Install+Let%26%238217%3Bs+Encrypt+pada+HAProxy+di+CentOS+8+https://belajarlinux.id/?p=448&ghostexport=true&submit=Download Ghost File)

[![fb-share-icon](/wp-content/plugins/ultimate-social-media-icons/images/share_icons/Pinterest_Save/en_US_save.svg "Pin Share")](#)

<!--kg-card-end: html-->
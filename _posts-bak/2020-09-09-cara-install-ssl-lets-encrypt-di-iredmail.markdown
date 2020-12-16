---
layout: post
title: Cara Install SSL Let's Encrypt di iRedMail
featured: true
date: '2020-09-09 20:30:00'
tags:
- centos
- mail-server
- ssl
---

_Secure Socket Layer (SSL)_ tidak hanya digunakan untuk secure untuk website saja, mail server juga perlu SSL tentunya sebagai koneksi antara _client_ dan server dapat berjalan secara aman dari pihak lain, dengan SSL maka komunikasi _client_ dengan _server mail_ kita lebih secure atau kata lainnya _terenkripsi._

iRedMail sebagai mail server secara default pada saat instalasi sudah terinstall SSL self sign dan jika Anda ingin menggunakan SSL berbayar misal menggunakan SSL nya Globalsign atau menggunakan SSL Free dari Letsencrypt dapat di lakukan.

Disini kami akan mencontohkan bagaimana cara install SSL Letsencrypt di iRedMail mulai dari mengamankan web admin iRedMail sampai memasang SSL di postfix dan dovecot iRedMail.

Untuk mengikuti tutorial kali ini pastikan Anda sudah mengikuti tutorial berikut ya: **_[Membuat Mail Server Menggunakan iRedMail di CentOS 8](/membuat-mail-server-menggunakan-iredmail-di-centos-8/)_**

Untuk melakukan instalasi Letsencrypt jalankan perintah berikut:

    [root@mail ~]#
    [root@mail ~]# dnf install certbot python3-certbot-nginx -y

Selanjutnya generate SSL Letsencrypt menggunakan perintah berikut

    [root@mail ~]#
    [root@mail ~]# certbot certonly --webroot --agree-tos --email postmaster@nurhamim.my.id -d mail.nurhamim.my.id -w /var/www/html/
    Saving debug log to /var/log/letsencrypt/letsencrypt.log
    Plugins selected: Authenticator webroot, Installer None
    
    - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    Would you be willing, once your first certificate is successfully issued, to
    share your email address with the Electronic Frontier Foundation, a founding
    partner of the Let's Encrypt project and the non-profit organization that
    develops Certbot? We'd like to send you email about our work encrypting the web,
    EFF news, campaigns, and ways to support digital freedom.
    - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    (Y)es/(N)o: Yes
    Obtaining a new certificate
    Performing the following challenges:
    http-01 challenge for mail.nurhamim.my.id
    Using the webroot path /var/www/html for all unmatched domains.
    Waiting for verification...
    Cleaning up challenges
    Subscribe to the EFF mailing list (email: postmaster@nurhamim.my.id).
    
    IMPORTANT NOTES:
     - Congratulations! Your certificate and chain have been saved at:
       /etc/letsencrypt/live/mail.nurhamim.my.id/fullchain.pem
       Your key file has been saved at:
       /etc/letsencrypt/live/mail.nurhamim.my.id/privkey.pem
       Your cert will expire on 2020-12-07. To obtain a new or tweaked
       version of this certificate in the future, simply run certbot
       again. To non-interactively renew *all* of your certificates, run
       "certbot renew"
     - Your account credentials have been saved in your Certbot
       configuration directory at /etc/letsencrypt. You should make a
       secure backup of this folder now. This configuration directory will
       also contain certificates and private keys obtained by Certbot so
       making regular backups of this folder is ideal.
     - If you like Certbot, please consider supporting our work by:
    
       Donating to ISRG / Let's Encrypt: https://letsencrypt.org/donate
       Donating to EFF: https://eff.org/donate-le
    
     - We were unable to subscribe you the EFF mailing list because your
       e-mail address appears to be invalid. You can try again later by
       visiting https://act.eff.org.
    [root@mail ~]#

_Noted: Silakan sesuaikan dengan host atau name mail server Anda disini mail server kami yaitu mail.nurhamim.my.id._

Saat ini kita sudah mempunyai SSL Letsencrypt. Ada 3 Bagian yang akan kita pasangkan SSL diantaranya:

### – Pasang SSL Untuk Administrator, Webmail iRedMail

Untuk memasang SSL Administratori, Webmail dari iRedMail Anda hanya perlu mengubah atau menyesuaikannya pada direktori _/etc/nginx/templates/ssl.tmpl_ berikut:

    [root@mail ~]#
    [root@mail ~]# vim /etc/nginx/templates/ssl.tmpl

Default konfigurasi SSL nya seperti berikut

    # To request free "Let's Encrypt" cert, please check our tutorial:
    # https://docs.iredmail.org/letsencrypt.html
    ssl_certificate /etc/pki/tls/certs/iRedMail.crt;
    ssl_certificate_key /etc/pki/tls/private/iRedMail.key;

Ubah menjadi seperti berikut

    # To request free "Let's Encrypt" cert, please check our tutorial:
    # https://docs.iredmail.org/letsencrypt.html
    ssl_certificate /etc/letsencrypt/live/mail.nurhamim.my.id/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/mail.nurhamim.my.id/privkey.pem;

Simpan konfigurasi diatas dan verifikasi konfigurasi web server nginx, pastikan tidak ada yang salah konfigurasi

    [root@mail ~]#
    [root@mail ~]# nginx -t
    nginx: the configuration file /etc/nginx/nginx.conf syntax is ok
    nginx: configuration file /etc/nginx/nginx.conf test is successful
    [root@mail ~]#

Selanjutnya reload Nginx

    [root@mail ~]# systemctl reload nginx
    [root@mail ~]#

Silakan maksure atau pastikan SSL sudah terinstall dengan cara akses Administrator iRedMail, pastikan sudah HTTPS contohnya

- Administrator
<figure class="wp-block-image size-large"><img loading="lazy" width="1024" height="354" src="/content/images/wordpress/2020/09/1-8-1024x354.png" alt="" class="wp-image-517" srcset="/content/images/wordpress/2020/09/1-8-1024x354.png 1024w, /content/images/wordpress/2020/09/1-8-300x104.png 300w, /content/images/wordpress/2020/09/1-8-768x265.png 768w, /content/images/wordpress/2020/09/1-8.png 1361w" sizes="(max-width: 1024px) 100vw, 1024px"></figure>
- Webmail
<figure class="wp-block-image size-large"><img loading="lazy" width="1024" height="365" src="/content/images/wordpress/2020/09/image-21-1024x365.png" alt="" class="wp-image-518" srcset="/content/images/wordpress/2020/09/image-21-1024x365.png 1024w, /content/images/wordpress/2020/09/image-21-300x107.png 300w, /content/images/wordpress/2020/09/image-21-768x273.png 768w, /content/images/wordpress/2020/09/image-21.png 1362w" sizes="(max-width: 1024px) 100vw, 1024px"></figure>
### – Pasang SSL Untuk Postfix

Untuk memasang SSL di Postfix sangatlah mudah, silakan buka file konfigurasi postfix di iRedMail

    [root@mail ~]#
    [root@mail ~]# vim /etc/postfix/main.cf

Default konfigurasi SSL nya seperti berikut

    #
    # TLS settings.
    #
    # SSL key, certificate, CA
    #
    smtpd_tls_key_file = /etc/pki/tls/private/iRedMail.key
    smtpd_tls_cert_file = /etc/pki/tls/certs/iRedMail.crt
    smtpd_tls_CAfile = /etc/pki/tls/certs/iRedMail.crt
    smtpd_tls_CApath = /etc/pki/tls/certs

Silakan ubah menjadi seperti berikut

    #
    # TLS settings.
    #
    # SSL key, certificate, CA
    #
    smtpd_tls_key_file = /etc/letsencrypt/live/mail.nurhamim.my.id/privkey.pem
    smtpd_tls_cert_file = /etc/letsencrypt/live/mail.nurhamim.my.id/cert.pem
    smtpd_tls_CAfile = /etc/letsencrypt/live/mail.nurhamim.my.id/chain.pem
    smtpd_tls_CApath = /etc/pki/tls/certs

Simpan konfigurasi diatas dan silakan reload postfix menggunakan perintah berikut

    [root@mail ~]# systemctl reload postfix
    [root@mail ~]#

### – Pasang SSL Untuk Dovecot

Sama seperti postfix di dovecot juga sangat mudah untuk memasang SSL nya silakan buka konfigurasi dovecot berikut

    [root@mail ~]#
    [root@mail ~]# vim /etc/dovecot/dovecot.conf

Default konfigurasi SSL di dovecot

    #ssl_ca = </path/to/ca
    ssl_cert = </etc/pki/tls/certs/iRedMail.crt
    ssl_key = </etc/pki/tls/private/iRedMail.key
    ssl_dh = </etc/pki/tls/dh2048_param.pem

Silakan ubah menjadi seperti berikut

    #ssl_ca = </path/to/ca
    ssl_cert = </etc/letsencrypt/live/mail.nurhamim.my.id/fullchain.pem
    ssl_key = </etc/letsencrypt/live/mail.nurhamim.my.id/privkey.pem
    ssl_dh = </etc/pki/tls/dh2048_param.pem

Silakan simpan konfigurasi diatas dan reload dovecot

    [root@mail ~]# systemctl reload dovecot
    [root@mail ~]#

Oke, saat ini SSL sudah terpasang dengan sempurna.

Selamat mencoba 😁

Please follow and like us:

[![error](/wp-content/plugins/ultimate-social-media-icons/images/follow_subscribe.png)](https://api.follow.it/widgets/icon/VHc3d1lpVGdwRnE5QnV0eERCNUx5RCtvTTVoUkNYS3NNRmd5eVhlQW9tNXRHS3VTbGh6Y0NybkRJRS8zSGpjRDVZb1ZGMlNTSEpJYUpuZzZqNzdnd3VSN3dwM2VlQTF6ejJEaGV5UGRUbnlEcHFNd3luYTV4ZTZtUGowVWI2Q2x8M2kzdnBEeUIrUk5xOFI5TXZ3cHF3bFNQRkRJSGhUNGdrRFd0TlNtdE1OWT0=/OA==/)

[![fb-share-icon](/wp-content/plugins/ultimate-social-media-icons/images/visit_icons/fbshare_bck.png "Facebook Share")](https://www.facebook.com/sharer/sharer.php?u=https%3A%2F%2Fbelajarlinux.id%2F%3Fp%3D516%26ghostexport%3Dtrue%26submit%3DDownload+Ghost+File)

[![Tweet](/wp-content/plugins/ultimate-social-media-icons/images/visit_icons/en_US_Tweet.svg "Tweet")](https://twitter.com/intent/tweet?text=Cara+Install+SSL+Let%26%238217%3Bs+Encrypt+di+iRedMail+https://belajarlinux.id/?p=516&ghostexport=true&submit=Download Ghost File)

[![fb-share-icon](/wp-content/plugins/ultimate-social-media-icons/images/share_icons/Pinterest_Save/en_US_save.svg "Pin Share")](#)

<!--kg-card-end: html-->
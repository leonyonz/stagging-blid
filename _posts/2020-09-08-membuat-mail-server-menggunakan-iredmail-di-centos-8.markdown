---
layout: post
title: Membuat Mail Server Menggunakan iRedMail di CentOS 8
featured: true
date: '2020-09-08 19:51:14'
tags:
- centos
- mail-server
---

iRedMail salah satu solusi yang tepat bagi Anda yang ingin membangun sebuah mail server dengan instan, mudah, dan powerfull tentunya. iRedmail merupakan aplikasi mail server (Collaboration Suite) yang bersifat open source (free/bebas) namun ada juga yang versi berbayar.

iRedmail dapat diinstall di berbagai macam distro Linux diantaranya: Debian, Ubuntu, CentOS, selain itu iRedmail juga dapat diinstall di distro Unix contohnya FreeBSD dan OpenBSD. Selengkapnya mengenai keterangan lebih lanjut mengenai iRedmail dapat dilihat melalui link berikut: https://iredmail.org/

Sebenarnya iRedMail sudah bisa dibilang paket komplit untuk mail server, karena nanti pada saat instalasi service – service email beserta security dan antivirus sudah terinstall secara otomatis, berikut service – service yang akan diinstall secara otomatis oleh iRedMail

- Postfix SMTP server
- Dovecot IMAP server
- **Nginx** webserver to serve the admin panel and webmail
- OpenLDAP, MySQL/MariaDB, or PostgreSQL for storing user information
- Amavised-new for DKIM signing and verification
- SpamAssassin for anti-spam
- ClamAV for anti-virus
- Roundcube webmail
- Fail2ban for protecting SSH
- mlmmj mailing list manager
- Netdata server monitoring
- iRedAPD Postfix policy server for greylisting

Berikut System Requirements yang dibutuhkan:

- Sistem operasi Linux CentOS/Ubuntu/Debian/FreeBSD/OpenBSD.
- Memory/RAM 2 GB rekomendasi untuk low traffic.
- Pastikan VM Anda dalam keadaan Fresh Install atau belum terdapat aplikasi apapun.
- Pastikan hostname VM di set FQDN (fully qualified domain name)

Disini kami menyewa instance dari **[NEO Cloud](https://www.biznetgio.com/product/neo-virtual-compute)** untuk kebutuhan mail server, kenapa **[NEO Cloud](https://www.biznetgio.com/product/neo-virtual-compute)**?  
  
Alasan kami menggunakan NEO Cloud karena banyak macam pemilihan paket yang sesuai dengan kebutuhan kami, dan tentunya harga yang murah dan yang paling kami sukai yaitu tidak ada pemblokiran port 25 SMTP tentunya dan bisa kita atur sendiri melalui security group yang sudah di sediakan oleh NEO Cloud.

Disini kami menggunakan paket SM4.4 dengan spesifikasi dan harga sebagai berikut:

<figure class="aligncenter size-large"><img loading="lazy" width="684" height="303" src="/content/images/wordpress/2020/09/image-20.png" alt="" class="wp-image-500" srcset="/content/images/wordpress/2020/09/image-20.png 684w, /content/images/wordpress/2020/09/image-20-300x133.png 300w" sizes="(max-width: 684px) 100vw, 684px"></figure>

Untuk instalasi iRedMail disini kami menggunakan OS CentOS 8

Silakan akses instance atau VM Anda dan langkah pertama lakukan update CentOS 8 menggunakan command berikut

    [root@sinau ~]#
    [root@sinau ~]# dnf update -y

Setting hostname menggunakan fqdn

    [root@sinau ~]# hostnamectl set-hostname mail.nurhamim.my.id
    [root@sinau ~]# hostname -f
    mail.nurhamim.my.id
    [root@sinau ~]#

Install beberapa service untuk kebutuhan instalasi iRedMail

    [root@sinau ~]#
    [root@sinau ~]# dnf install vim wget tar -y

Disable SELINUX

    [root@sinau ~]#
    [root@sinau ~]# vim /etc/selinux/config

Set disabled pada SELINUX

    # This file controls the state of SELinux on the system.
    # SELINUX= can take one of these three values:
    # enforcing - SELinux security policy is enforced.
    # permissive - SELinux prints warnings instead of enforcing.
    # disabled - No SELinux policy is loaded.
    SELINUX=disabled
    # SELINUXTYPE= can take one of these three values:
    # targeted - Targeted processes are protected,
    # minimum - Modification of targeted policy. Only selected processes are protected.
    # mls - Multi Level Security protection.
    SELINUXTYPE=targeted

Simpan konfigurasi SELINUX dan silakan reboot instance atau VM

    [root@sinau ~]#
    [root@sinau ~]# reboot

Selanjutnya unduh iRedMail versi latest, untuk melihat release iRedMail klik link berikut: https://github.com/iredmail/iRedMail/releases

    [root@mail ~]#
    [root@mail ~]# wget https://github.com/iredmail/iRedMail/releases/download/1.3.1/iRedMail-1.3.1.tar.gz

Ekstrak file iRedMail

    [root@mail ~]#
    [root@mail ~]# tar xvf iRedMail-1.3.1.tar.gz

Pindah ke direktori iRedMail, dan berikan permission execut pada file bash

    [root@mail ~]#
    [root@mail ~]# cd iRedMail-1.3.1/
    [root@mail iRedMail-1.3.1]# chmod +x iRedMail.sh

Jalankan file bash iRedMail untuk proses instalasi

    [root@mail iRedMail-1.3.1]# bash iRedMail.sh

Tunggu beberapa saat dan akan muncul seperti gambar dibawah ini klik _Yes_

<figure class="wp-block-image size-large"><img loading="lazy" width="1024" height="541" src="/content/images/wordpress/2020/09/1-7-1024x541.png" alt="" class="wp-image-502" srcset="/content/images/wordpress/2020/09/1-7-1024x541.png 1024w, /content/images/wordpress/2020/09/1-7-300x158.png 300w, /content/images/wordpress/2020/09/1-7-768x406.png 768w, /content/images/wordpress/2020/09/1-7.png 1113w" sizes="(max-width: 1024px) 100vw, 1024px"></figure>

Menentukan direktori mail, langkah ini Anda tidak perlu mengubah nya biarkan secara default saja direktorinya yaitu _/var/vmail,_ Klik _Next_

<figure class="wp-block-image size-large"><img loading="lazy" width="1024" height="538" src="/content/images/wordpress/2020/09/2-7-1024x538.png" alt="" class="wp-image-503" srcset="/content/images/wordpress/2020/09/2-7-1024x538.png 1024w, /content/images/wordpress/2020/09/2-7-300x158.png 300w, /content/images/wordpress/2020/09/2-7-768x403.png 768w, /content/images/wordpress/2020/09/2-7.png 1104w" sizes="(max-width: 1024px) 100vw, 1024px"></figure>

Pilih webserver Nginx, _Next_

<figure class="wp-block-image size-large"><img loading="lazy" width="1024" height="536" src="/content/images/wordpress/2020/09/3-5-1024x536.png" alt="" class="wp-image-504" srcset="/content/images/wordpress/2020/09/3-5-1024x536.png 1024w, /content/images/wordpress/2020/09/3-5-300x157.png 300w, /content/images/wordpress/2020/09/3-5-768x402.png 768w, /content/images/wordpress/2020/09/3-5.png 1104w" sizes="(max-width: 1024px) 100vw, 1024px"></figure>

Pilih database yang ingin digunakan, bisa menggunakan MariDB/MySQL atau PostgreSQL bahkan bisa menggunakan OpenLDAP, disini kami menggunakan MariaDB, _Next_

<figure class="wp-block-image size-large"><img loading="lazy" width="1024" height="536" src="/content/images/wordpress/2020/09/4-5-1024x536.png" alt="" class="wp-image-505" srcset="/content/images/wordpress/2020/09/4-5-1024x536.png 1024w, /content/images/wordpress/2020/09/4-5-300x157.png 300w, /content/images/wordpress/2020/09/4-5-768x402.png 768w, /content/images/wordpress/2020/09/4-5.png 1105w" sizes="(max-width: 1024px) 100vw, 1024px"></figure>

Input password yang Anda inginkan untuk login ke sisi database MariaDB, _Next_

<figure class="wp-block-image size-large"><img loading="lazy" width="1024" height="536" src="/content/images/wordpress/2020/09/5-3-1024x536.png" alt="" class="wp-image-506" srcset="/content/images/wordpress/2020/09/5-3-1024x536.png 1024w, /content/images/wordpress/2020/09/5-3-300x157.png 300w, /content/images/wordpress/2020/09/5-3-768x402.png 768w, /content/images/wordpress/2020/09/5-3.png 1102w" sizes="(max-width: 1024px) 100vw, 1024px"></figure>

Tentukan nama domain yang Anda gunakan disini domain yang akan kami gunakan yaitu nurhamim.my.id

<figure class="wp-block-image size-large"><img loading="lazy" width="1024" height="543" src="/content/images/wordpress/2020/09/6-1-1024x543.png" alt="" class="wp-image-507" srcset="/content/images/wordpress/2020/09/6-1-1024x543.png 1024w, /content/images/wordpress/2020/09/6-1-300x159.png 300w, /content/images/wordpress/2020/09/6-1-768x407.png 768w, /content/images/wordpress/2020/09/6-1.png 1101w" sizes="(max-width: 1024px) 100vw, 1024px"></figure>

Input password yang ingin Anda gunakan untuk login ke sisi Administrator iRedMail nantinya, _Next_

<figure class="wp-block-image size-large"><img loading="lazy" width="1024" height="544" src="/content/images/wordpress/2020/09/7-1-1024x544.png" alt="" class="wp-image-508" srcset="/content/images/wordpress/2020/09/7-1-1024x544.png 1024w, /content/images/wordpress/2020/09/7-1-300x159.png 300w, /content/images/wordpress/2020/09/7-1-768x408.png 768w, /content/images/wordpress/2020/09/7-1.png 1093w" sizes="(max-width: 1024px) 100vw, 1024px"></figure>

Pada langkah ini terdapat pemilihan apakah Anda ingin install semua service _Roundcube, Sogo, Netdata (untuk monitoring), IredMail panel, dan Fail2ban (untuk security)_. Disini akan kami install semuanya, _Next_

<figure class="wp-block-image size-large"><img loading="lazy" width="1024" height="539" src="/content/images/wordpress/2020/09/8-1024x539.png" alt="" class="wp-image-510" srcset="/content/images/wordpress/2020/09/8-1024x539.png 1024w, /content/images/wordpress/2020/09/8-300x158.png 300w, /content/images/wordpress/2020/09/8-768x404.png 768w, /content/images/wordpress/2020/09/8.png 1096w" sizes="(max-width: 1024px) 100vw, 1024px"></figure>

Tunggu proses review dan akan muncul informasi seperti berikut, silakan ketik _y_ untuk lanjut ke proses instalasi

    *************************************************************************
    *****************************WARNING***********************************
    *************************************************************************
    * *
    * Below file contains sensitive infomation (username/password), please *
    * do remember to *MOVE* it to a safe place after installation. *
    * *
    * * /root/iRedMail-1.3.1/config
    * *
    *************************************************************************
    **********************Review your settings*****************************
    *************************************************************************
    
    * Storage base directory: /var/vmail
    * Mailboxes:
    * Daily backup of SQL/LDAP databases:
    * Store mail accounts in: MariaDB
    * Web server: Nginx
    * First mail domain name: nurhamim.my.id
    * Mail domain admin: postmaster@nurhamim.my.id
    * Additional components: Roundcubemail SOGo netdata iRedAdmin Fail2ban
    
    < Question > Continue? [y|N]y

Tunggu proses instalasi yang membutuhkan waktu setelah itu akan Anda pertanyaan apakah Anda ingin install firewall ketik y seperti berikut

    [INFO] Disable SELinux in /etc/selinux/config.
    < Question > Would you like to use firewall rules provided by iRedMail?
    < Question > File: /etc/firewalld/zones/iredmail.xml, with SSHD ports: 22. [Y|n]y
    [INFO] Copy firewall sample rules.
    < Question > Restart firewall now (with ssh ports: 22)? [y|N]y
    [INFO] Restarting firewall ...
    < Question > Would you like to use MySQL configuration file shipped within iRedMail now?
    < Question > File: /etc/my.cnf. [Y|n]y
    [INFO] Copy MySQL sample file: /etc/my.cnf.
    [INFO] Enable SSL support for MySQL server.
    [INFO] Updating ClamAV database (freshclam), please wait ...

Silakan tunggu kembali proses instalasinya sampai selesai, apabila selesai Anda akan mendapatkan informasi detail seperti berikut:

    ********************************************************************
    * URLs of installed web applications:
    *
    * - Roundcube webmail: https://mail.nurhamim.my.id/mail/
    * - SOGo groupware: https://mail.nurhamim.my.id/SOGo/
    * - netdata (monitor): https://mail.nurhamim.my.id/netdata/
    *
    * - Web admin panel (iRedAdmin): https://mail.nurhamim.my.id/iredadmin/
    *
    * You can login to above links with below credential:
    *
    * - Username: postmaster@nurhamim.my.id
    * - Password: password2020
    *
    *
    ********************************************************************
    * Congratulations, mail server setup completed successfully. Please
    * read below file for more information:
    *
    * - /root/iRedMail-1.3.1/iRedMail.tips
    *
    * And it's sent to your mail account postmaster@nurhamim.my.id.
    *
    *********************WARNING**************************************
    *
    * Please reboot your system to enable all mail services.
    *
    ********************************************************************
    [root@mail iRedMail-1.3.1]#
    [root@mail iRedMail-1.3.1]#

Sesuai informasi diatas silakan reboot instance atau VM Anda

    [root@mail iRedMail-1.3.1]# reboot
    Connection to 103.89.7.26 closed by remote host.
    Connection to 103.89.7.26 closed.
    root@A1-LR08Q321:~#

Berikut informasi untuk login ke Administrator dan webmail:

- Administrator: https://mail.nurhamim.my.id/iredadmin/
- Webmail: https://mail.nurhamim.my.id/mail/
- SOGo groupware: https://mail.nurhamim.my.id/SOGo/
- Netdata (monitoring): https://mail.nurhamim.my.id/netdata/

Contoh tampilan page login iRedMail

<figure class="wp-block-image size-large"><img loading="lazy" width="1024" height="383" src="/content/images/wordpress/2020/09/9-1-1024x383.png" alt="" class="wp-image-513" srcset="/content/images/wordpress/2020/09/9-1-1024x383.png 1024w, /content/images/wordpress/2020/09/9-1-300x112.png 300w, /content/images/wordpress/2020/09/9-1-768x287.png 768w, /content/images/wordpress/2020/09/9-1.png 1366w" sizes="(max-width: 1024px) 100vw, 1024px"></figure>

Dan berikut dashboard iRedMail

<figure class="wp-block-image size-large"><img loading="lazy" width="1024" height="505" src="/content/images/wordpress/2020/09/10-1024x505.png" alt="" class="wp-image-514" srcset="/content/images/wordpress/2020/09/10-1024x505.png 1024w, /content/images/wordpress/2020/09/10-300x148.png 300w, /content/images/wordpress/2020/09/10-768x379.png 768w, /content/images/wordpress/2020/09/10.png 1361w" sizes="(max-width: 1024px) 100vw, 1024px"></figure>

Selamat mencoba 😁

Please follow and like us:

[![error](/wp-content/plugins/ultimate-social-media-icons/images/follow_subscribe.png)](https://api.follow.it/widgets/icon/VHc3d1lpVGdwRnE5QnV0eERCNUx5RCtvTTVoUkNYS3NNRmd5eVhlQW9tNXRHS3VTbGh6Y0NybkRJRS8zSGpjRDVZb1ZGMlNTSEpJYUpuZzZqNzdnd3VSN3dwM2VlQTF6ejJEaGV5UGRUbnlEcHFNd3luYTV4ZTZtUGowVWI2Q2x8M2kzdnBEeUIrUk5xOFI5TXZ3cHF3bFNQRkRJSGhUNGdrRFd0TlNtdE1OWT0=/OA==/)

[![fb-share-icon](/wp-content/plugins/ultimate-social-media-icons/images/visit_icons/fbshare_bck.png "Facebook Share")](https://www.facebook.com/sharer/sharer.php?u=https%3A%2F%2Fbelajarlinux.id%2F%3Fp%3D499%26ghostexport%3Dtrue%26submit%3DDownload+Ghost+File)

[![Tweet](/wp-content/plugins/ultimate-social-media-icons/images/visit_icons/en_US_Tweet.svg "Tweet")](https://twitter.com/intent/tweet?text=Membuat+Mail+Server+Menggunakan+iRedMail+di+CentOS+8+https://belajarlinux.id/?p=499&ghostexport=true&submit=Download Ghost File)

[![fb-share-icon](/wp-content/plugins/ultimate-social-media-icons/images/share_icons/Pinterest_Save/en_US_save.svg "Pin Share")](#)

<!--kg-card-end: html-->
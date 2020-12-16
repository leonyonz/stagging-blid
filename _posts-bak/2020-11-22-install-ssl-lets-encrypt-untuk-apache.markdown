---
layout: post
title: 'Ubuntu: Install SSL Let''s Encrypt untuk Apache di Ubuntu Server 20.04 TLS.'
featured: true
date: '2020-11-22 13:19:06'
tags:
- apache
- linux
- ssl
- ubuntu
---

Let's Encrypt merupakan otoritas sertifikat yang dibuat oleh Internet Security Research Group (ISRG). Let's Encrypt menyediakan sertifikat SSL dengan proses yang lengkap seperti membuat, validasi, instalasi sampai renewal sertifikat SSL.

Secara default masa aktif sertifikat SSL dari Let's Encrypt memiliki jangka waktu hingga 90 hari. Kita bisa melakukan renewal secara manual maupun otomatis agar sertifikat tetap aktif dan bisa digunakan.

Pada kesempatan kali ini, kita akan membahas cara mengamankan Apache dengan Let's Encrypt pada Ubuntu Server 20.04. Adapun persyaratan untuk melakukan lab ini yakni sebagai berikut:

### Prasyarat 
<!--kg-card-begin: markdown-->
1. Menggunakan akses root atau user dengan sudo privileges
2. Domain / subdomain yang sudah dipointing ke IP Public, kita akan menggunakan domain `example.id`
3. Sudah terinstall Apache
<!--kg-card-end: markdown-->

Apabila Anda belum menginstall Apache, Anda bisa melihat panduan kami sebelumnya pada tautan berikut [ini](/install-lamp-stack-di-ubuntu-20-04/).

### Instalasi Certbot

Kita akan menggunakan cerbot untuk mendapatkan sertifikat dari Let's Encrypt, tool tersebut dapat digunakan untuk melakukan renewal baik manual maupun secara otomatis. Aplikasi certbot juga tersedia pada repository default Ubuntu, oleh karena itu update paket terlebih dahulu dan install certbot.

<!--kg-card-begin: markdown-->

    ubuntu@tutorialbelajarlinux:~$ sudo apt update
    ubuntu@tutorialbelajarlinux:~$ sudo apt install certbot

<!--kg-card-end: markdown-->
### Generate Grup Diffie-Helman (Dh) 

Diffie – Hellman key exchange (DH) merupakan metode pengamanan pertukaran kunci kriptografi dengan aman melalui saluran komunikasi yang tidak aman. Sekarang coba generata key Dh baru dengan ukuran 2048 bit untuk memperkuat keamanan.

<!--kg-card-begin: markdown-->

    ubuntu@tutorialbelajarlinux:~$ openssl dhparam -out /etc/ssl/certs/dhparam.pem 2048

<!--kg-card-end: markdown-->

Selain menggunakan ukuran 2048 bit, Anda juga bisa menggunakan 4096 bit. Namun, biasanya hal &nbsp;tersebut membutuhkan waktu generate yang lama sekitar 30 menit dan tergantung dari sistem entropi.

### Mendapatkan Sertifikat Let's Encrypt 

Untuk mendapatkan sertifikat SSL Let's Encrypt, kita akan menggunakan plugin webroot yang akan bekerja dengan membuat file temporari untuk validasi permintaan domain pada folder `${webroot-path}/.well-known/acme-challenge`. Server Let's Encrypt membuat request HTTP ke file temporari untuk validasi bahwa permintaan domain sebelumnnya sudah benar-benar resolv dimana cerbot berjalan.

Untuk membuat lebih simple, kita akan melakukan mapping semua permintaan HTTP untuk `.well-known/acme-challenge` ke dalam satu folder `/var/lib/letsencrypt`.

Jalankan perintah dibawah ini untuk membuat direktori dan memberikan akses write pada user Apache.

<!--kg-card-begin: markdown-->

    ubuntu@tutorialbelajarlinux:~$ sudo mkdir -p /var/lib/letsencrypt/.well-known
    ubuntu@tutorialbelajarlinux:~$ sudo chgrp www-data /var/lib/letsencrypt
    ubuntu@tutorialbelajarlinux:~$ sudo chmod g+s /var/lib/letsencrypt

<!--kg-card-end: markdown-->

Untuk menghindari adanya duplicate script dan memudahkan dalam mengelola konfigurasi, kita bisa membuat file konfigurasi snippet pada file `/etc/apache2/conf-available/letsencrypt.conf`

<!--kg-card-begin: markdown-->

    Alias /.well-known/acme-challenge/ "/var/lib/letsencrypt/.well-known/acme-challenge/"
    <Directory "/var/lib/letsencrypt/">
        AllowOverride None
        Options MultiViews Indexes SymLinksIfOwnerMatch IncludesNoExec
        Require method GET POST OPTIONS
    </Directory>

<!--kg-card-end: markdown-->

dan juga pada file `/etc/apache2/conf-available/ssl-params.conf`

<!--kg-card-begin: markdown-->

    SSLProtocol all -SSLv3 -TLSv1 -TLSv1.1
    SSLCipherSuite ECDHE-ECDSA-AES128-GCM-SHA256:ECDHE-RSA-AES128-GCM-SHA256:ECDHE-ECDSA-AES256-GCM-SHA384:ECDHE-RSA-AES256-GCM-SHA384:ECDHE-ECDSA-CHACHA20-POLY1305:ECDHE-RSA-CHACHA20-POLY1305:DHE-RSA-AES128-GCM-SHA256:DHE-RSA-AES256-GCM-SHA384
    SSLHonorCipherOrder off
    SSLSessionTickets off
    
    SSLUseStapling On
    SSLStaplingCache "shmcb:logs/ssl_stapling(32768)"
    
    SSLOpenSSLConfCmd DHParameters "/etc/ssl/certs/dhparam.pem" 
    
    Header always set Strict-Transport-Security "max-age=63072000"
    

<!--kg-card-end: markdown-->

Snippet diatas menggunaan chippers yang direkomendasikan oleh [Mozilla](https://ssl-config.mozilla.org/), mengakifkan OCSP Stappling, HTTP Strict Transport Security (HSTS) dan memberlakukan beberapa header HTTP yang berfokus pada keamanan.

Sebelum mengaktifkan konfigurasi file diatas, pastikan Anda sudah mengaktifkan `mod_ssl` dan `mod_headers` dengan perintah:

<!--kg-card-begin: markdown-->

    ubuntu@tutorialbelajarlinux:~$ sudo a2enmod ssl
    ubuntu@tutorialbelajarlinux:~$ sudo a2enmod headers

<!--kg-card-end: markdown-->

Selanjutnya, akifkan konfigurasi file SSL dengan menjalankan perintah:

<!--kg-card-begin: markdown-->

    ubuntu@tutorialbelajarlinux:~$ sudo a2enconf letsencrypt
    ubuntu@tutorialbelajarlinux:~$ sudo a2enconf ssl-params

<!--kg-card-end: markdown-->

Selain itu, aktifkan modul HTTP/2 juga untuk membuat website lebih cepat dan kuat:

<!--kg-card-begin: markdown-->

    ubuntu@tutorialbelajarlinux:~$ sudo a2enmod http2

<!--kg-card-end: markdown-->

Reload konfigurasi Apache.

<!--kg-card-begin: markdown-->

    ubuntu@tutorialbelajarlinux:~$ sudo systemctl reload apache2

<!--kg-card-end: markdown-->

Kita bisa menjalankan tool certbot dengan plugin webroot dan mendapatkan file sertifikat SSL dengan perintah:

<!--kg-card-begin: markdown-->

    sudo certbot certonly --agree-tos --email admin@example.id --webroot -w /var/lib/letsencrypt/ -d example.id -d www.example.id

<!--kg-card-end: markdown-->

Setelah proses mendapatkan file sertifikat SSL berhasil dan tidak mendapatkan pesan error apapun, maka akan muncul output seperti berikut ini:

<!--kg-card-begin: markdown-->

    IMPORTANT NOTES:
     - Congratulations! Your certificate and chain have been saved at:
       /etc/letsencrypt/live/example.id/fullchain.pem
       Your key file has been saved at:
       /etc/letsencrypt/live/example.id/privkey.pem
       Your cert will expire on 2020-10-06. To obtain a new or tweaked
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

<!--kg-card-end: markdown-->

Selanjutnya, kita akan membuat virtualhost seperti berikut:

<!--kg-card-begin: markdown-->

    <VirtualHost *:80> 
      ServerName example.id
    
      Redirect permanent / https://example.id/
    </VirtualHost>
    
    <VirtualHost *:443>
      ServerName example.id
    
      Protocols h2 http/1.1
    
      <If "%{HTTP_HOST} == 'www.example.id'">
        Redirect permanent / https://example.id/
      </If>
    
      DocumentRoot /var/www/example.id/public_html
      ErrorLog ${APACHE_LOG_DIR}/example.id-error.log
      CustomLog ${APACHE_LOG_DIR}/example.id-access.log combined
    
      SSLEngine On
      SSLCertificateFile /etc/letsencrypt/live/example.id/fullchain.pem
      SSLCertificateKeyFile /etc/letsencrypt/live/example.id/privkey.pem
    
      # Other Apache Configuration
    
    </VirtualHost>

<!--kg-card-end: markdown-->

Pada konfigurasi virtualhost diatas melakukan force akses ke protokol HTTPS dan redirect dari www ke non-www. Silakan disesuaikan untuk kebutuhan konfigurasi virtualhost Anda.

Reload service Apache

<!--kg-card-begin: markdown-->

    ubuntu@tutorialbelajarlinux:~$ sudo systemctl reload apache2

<!--kg-card-end: markdown-->

Sekarang buka website pada browser Anda, dan nantinya akan menggunakan protokol https seperti pada gambar dibawah ini.

<figure class="kg-card kg-image-card kg-card-hascaption"><img src="/content/images/2020/11/Website-https-.png" class="kg-image" alt srcset="/content/images/size/w600/2020/11/Website-https-.png 600w, /content/images/size/w1000/2020/11/Website-https-.png 1000w, /content/images/2020/11/Website-https-.png 1234w" sizes="(min-width: 720px) 720px"><figcaption>Website dengan protokol HTTPS</figcaption></figure>

Selain itu, Anda juga bisa melihat hasil test sertifikat SSL yang digunakan pada website tersebut pada [SSL Server Test](https://www.ssllabs.com/ssltest/) dan nantinya hasil akan menunjukkan grade **A+** seperti pada gambar dibawah ini.

<figure class="kg-card kg-image-card kg-card-hascaption"><img src="/content/images/2020/11/grade--A--.png" class="kg-image" alt srcset="/content/images/size/w600/2020/11/grade--A--.png 600w, /content/images/2020/11/grade--A--.png 992w" sizes="(min-width: 720px) 720px"><figcaption>Hasil pengujian sertifikat SSL</figcaption></figure>
### Auto-renew Sertifikat SSL Let's Encrypt 

Secara default sertifikat SSL Let's Encrypt memiliki masa aktif selama 90 hari, apabila masa aktifnya sudah melewati batas 90 hari, maka sertifikat SSL akan expired. Kita bisa melakukan renewal sertifikat SSL secara manual maupun secara otomatis, untuk mempermudah pekerjaan bisa kita implementasikan cronjob untuk melakukan renewal sertifikat SSL secara otomatis.

Sebagai contoh, cronjob yang digunakan kali ini akan mengeksekusi setiap sehari dua kali dan sertifikat SSL akan diperpanjang secara otomatis sebelum 30 hari masa expired. Setelah menjalankan cronjob, service Apache perlu melakukan reload agar sertifikat SSL berhasil diperpanjang. Oleh karena itu, pada perintah cronjob tersebut akan ditambahkan `--renew-hook "systemctl reload apache2"` ke `/etc/cron.d/certbot` seperti berikut:

<!--kg-card-begin: markdown-->

    0 */12 * * * root test -x /usr/bin/certbot -a \! -d /run/systemd/system && perl -e 'sleep int(rand(3600))' && certbot -q renew --renew-hook "systemctl reload apache2"

<!--kg-card-end: markdown-->

Untuk menguji perpanjangan sertifikat SSL, Anda bisa menjalankan perintah berikut:

<!--kg-card-begin: markdown-->

    ubuntu@tutorialbelajarlinux:~$ sudo certbot renew --dry-run

<!--kg-card-end: markdown-->

Apabila tidak terdapat pesan error apapun, berarti perpanjangan sertifikat SSL berhasil.

### Kesimpulan

Pembahasan diatas menujukkan panduan untuk membuat sertifikat SSL free dari Let's Encrypt menggunakan tool certbot. Apabila Anda ingin mempelajari lebih dalam tentang perintah-perintah certbot, bisa melalui tautan berikut [ini](https://certbot.eff.org/docs/).

Sekian, dan terima kasih. Semoga bermanfaat dan barokah :)

<!--kg-card-begin: html--><script async src="https://pagead2.googlesyndication.com/pagead/js/adsbygoogle.js"></script><ins class="adsbygoogle" style="display:block; text-align:center;" data-ad-layout="in-article" data-ad-format="fluid" data-ad-client="ca-pub-1515372853161377" data-ad-slot="4684565489"></ins><script>
     (adsbygoogle = window.adsbygoogle || []).push({});
</script><!--kg-card-end: html-->
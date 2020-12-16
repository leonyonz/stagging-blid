---
layout: post
title: Struktur Konfigurasi dan Perintah Dasar Apache di CentOS 8
featured: true
date: '2020-08-21 15:02:19'
tags:
- apache
- centos
---

Seperti yang sudah kita bahas sebelumnya di web server nginx berikut: _[Struktur Konfigurasi dan Perintah Dasar Nginx](/struktur-konfigurasi-dan-perintah-dasar-nginx/)_, apache sebagai web server juga mempunya struktur konfigurasi dan perintah – perintah nya tersendiri.

Dengan memahmi struktur konfigurasi dan perintah dasar, Anda dapat dengan mudah mengelola, mengoperasikan dan menggunakan web server apache.

## # Struktur Konfigurasi Apache

Berikut ini beberapa struktur file konfigurasi Apache yang perlu dan sering digunakan di CentOS 8

- Semua file konfigurasi Apache berada di direktori _ **/etc/httpd** _
- Untuk default konfigurasi utama Apache berada di direktori _ **/etc/httpd/conf/httpd.conf** _
- Semua file konfigurasi Apache diakhiri dengan **.conf** yang berada di direktori _ **/etc/httpd/conf.d** _ termasuk dalam file konfigurasi default atau utama Apache
- Untuk file konfigurasi yang bertanggung jawab untuk memuat berbagai modul Apache berada di direktori **_/etc/httpd/conf.modules.d_**
- Untuk mempermudah kita dalam sebuah konfigurasi serta troubleshoot maka sangat disarankan untuk membuat konfigurasi sendiri (terpisah) dengan menggunakan Virtual Host (vhost) untuk setiap domain
- File Virtual Host (vhost) sendiri diakhiri dengan **.conf** dan defaultnya disimpan di direktori **_/etc/httpd/conf.d/_** Anda dapat membuat Virtual Host sesuai kebutuhan Anda (tak terbatas)
- Dalam membuat Virtual Host disarankan untuk memberikan penamaan Virtual Host sesuai dengan nama domain. Misalnya nama domain _ **nurhamim.my.id** _, maka pembuatan file konfigurasi Virtual Host (vhost) yakni _ **nurhamim.my.id.conf** _ untuk mempermudah Anda dalam pengelolaan konfigurasi Virtual Host (vshost). Secara default untuk letak direktorinya berada di _ **/etc/httpd/conf.d/nurhamim.my.id.conf** _
- File log Apache (access\_log dan error\_log) berada di direktori _ **/var/log/httpd/** _. Disarankan setiap Virtual Host domain memiliki file log masing – masing untuk mempermudah dalam pengelolaan dan troubleshoot.
- Anda dapat mengatur direktori root direktori domain Anda ke lokasi yang Anda inginkan. Lokasi yang paling umum digunakan untuk webroot yaitu:

    # /home/<user_name>/<site_name>
    # /var/www/<site_name>
    # /var/www/html/<site_name>
    # /opt/<site_name>

## # Perintah Dasar Apache 

Berikut ini beberapa perintah – perintah dasar yang sering digunakan dan perlu Anda ketahui:

Untuk menghentikan service Apache, jalankan perintah:

    [root@tutorial ~]# systemctl stop httpd

Untuk memulai atau start service Apache, jalankan perintah:

    [root@tutorial ~]# systemctl start httpd

Untuk melakukan restart service Apache, jalankan perintah:

    [root@tutorial ~]# systemctl restart httpd

Jika Anda sebelumnya telah melakukan perubahan konfigurasi Apache dapat melakukan reload service apache dengan menjalankan perintah:

    [root@tutorial ~]# systemctl reload httpd

Jika Anda ingin menonaktifkan service apache pada saat memulai proses boot jalankan perintah berikut:

    [root@tutorial ~]# systemctl disable httpd
    Removed /etc/systemd/system/multi-user.target.wants/httpd.service.
    [root@tutorial ~]#

Dan untuk mengaktifkannya kembali jalankan perintah:

    [root@tutorial ~]# systemctl enable httpd
    Created symlink /etc/systemd/system/multi-user.target.wants/httpd.service → /usr/lib/systemd/system/httpd.service.
    [root@tutorial ~]#

Selamat mencoba 😁

Please follow and like us:

[![error](/wp-content/plugins/ultimate-social-media-icons/images/follow_subscribe.png)](https://api.follow.it/widgets/icon/VHc3d1lpVGdwRnE5QnV0eERCNUx5RCtvTTVoUkNYS3NNRmd5eVhlQW9tNXRHS3VTbGh6Y0NybkRJRS8zSGpjRDVZb1ZGMlNTSEpJYUpuZzZqNzdnd3VSN3dwM2VlQTF6ejJEaGV5UGRUbnlEcHFNd3luYTV4ZTZtUGowVWI2Q2x8M2kzdnBEeUIrUk5xOFI5TXZ3cHF3bFNQRkRJSGhUNGdrRFd0TlNtdE1OWT0=/OA==/)

[![fb-share-icon](/wp-content/plugins/ultimate-social-media-icons/images/visit_icons/fbshare_bck.png "Facebook Share")](https://www.facebook.com/sharer/sharer.php?u=https%3A%2F%2Fbelajarlinux.id%2F%3Fp%3D122%26ghostexport%3Dtrue%26submit%3DDownload+Ghost+File)

[![Tweet](/wp-content/plugins/ultimate-social-media-icons/images/visit_icons/en_US_Tweet.svg "Tweet")](https://twitter.com/intent/tweet?text=Struktur+Konfigurasi+dan+Perintah+Dasar+Apache+di+CentOS+8+https://belajarlinux.id/?p=122&ghostexport=true&submit=Download Ghost File)

[![fb-share-icon](/wp-content/plugins/ultimate-social-media-icons/images/share_icons/Pinterest_Save/en_US_save.svg "Pin Share")](#)

<!--kg-card-end: html-->
---
layout: post
title: Cara Membuat Virtual Host Apache di CentOS 8
featured: true
date: '2020-08-21 19:06:13'
tags:
- apache
- centos
---

Apache salah satu web server yang banyak digunakan karena kecepatan dan yang lainnya. Layaknya di nginx jika kita ingin menjalankan lebih dari satu domain atau sub domain di apache Anda dapat menggunakan virtual host atau sering dibilang _vhost._

Dengan vhost Anda dapat meng hosting banyak domain atau bisa dibilang multi domain dalam 1 web server.

Pada tutorial ini akan kami berikan contoh membuat vhost di apache dengan study case sebagai berikut:

Terdapat 2 subdomain dintaranya:

1. Subdomain: vhost01.nurhamim.my.id
2. Subdomain: vhost02.nurhamim.my.id

Ke 2 subdomain diatas nantinya akan menampilkan sample page html biasa sebagai contoh saja.

Untuk menentukan direktori website bisa disesuaikan dengan kebutuhan untuk detail dapat merujuk pada tutorial berikut: _[Struktur Konfigurasi dan Perintah Dasar Apache di CentOS 8](/struktur-konfigurasi-dan-perintah-dasar-apache-di-centos-8/)_, di tutorial ini ke 2 subdomain tersebut akan kami buat dan simpan di _/var/www/_ sebagai berikut:

    [root@tutorial ~]# cd /var/www/
    [root@tutorial www]#
    [root@tutorial www]# mkdir vhost02.nurhamim.my.id
    [root@tutorial www]# mkdir vhost01.nurhamim.my.id

Buat file index.html di dalam direktori yang dibuat diatas

    [root@tutorial www]#
    [root@tutorial www]# cd vhost01.nurhamim.my.id/
    [root@tutorial vhost01.nurhamim.my.id]#
    [root@tutorial vhost01.nurhamim.my.id]# vim index.html

Isi file index.html dengan file html contohnya sebagai berikut

    <!DOCTYPE html>
    <html lang="en" dir="ltr">
    <head>
    <meta charset="utf-8">
    <title>Vhost Apache | BelajarLinux.ID</title>
    </head>
    <body>
    <h1>Test Page vhost01.nurhamim.my.id</h1>
    </body>
    </html>

Ulangi dan sesuaikan langkah diatas untuk _vhost02.nurhamim.my.id_, jika sudah silakan berikan hak akses dan owner contohnya

    [root@tutorial www]# chown -R apache:apache vhost01.nurhamim.my.id/
    [root@tutorial www]# chown -R apache:apache vhost02.nurhamim.my.id/
    [root@tutorial www]# chmod -R 755 vhost01.nurhamim.my.id/
    [root@tutorial www]# chmod -R 755 vhost02.nurhamim.my.id/

Selanjutnya membuat vhost, letak direktori vhost berada di _/etc/httpd/conf.d/_ sebagai berikut:

    [root@tutorial www]# cd /etc/httpd/conf.d/
    [root@tutorial conf.d]#
    [root@tutorial conf.d]# vim vhost01.nurhamim.my.id.conf

Berikut sample konfigurasi vhost untuk subdomain _vhost01.nurhamim.my.id_

    <VirtualHost *:80>
            ServerName vhost01.nurhamim.my.id
            ServerAdmin me@nurhamim.my.id
            DocumentRoot /var/www/vhost01.nurhamim.my.id
            ErrorLog logs/nurhamim.my.id-error_log
            CustomLog logs/nurhamim.my.id-access_log combined
    <IfModule dir_module>
            DirectoryIndex index.php index.html
    </IfModule>
    </VirtualHost>

Silakan disesuaikan untuk subdomain _vhost02.nurhamim.my.id_

Pastikan tidak ada konfigurasi yang mis atau salah di sisi vhost

    [root@tutorial conf.d]# httpd -t
    Syntax OK
    [root@tutorial conf.d]#

Jika sudah silakan di reload apache nya

    [root@tutorial conf.d]#
    [root@tutorial conf.d]# systemctl reload httpd
    [root@tutorial conf.d]#

Langkah selanjutnya, pastikan subdomain atau domain Anda sudah diarahkan ke IP VPS atau VM dengan cara menambahkan A record contohnya

<figure class="wp-block-image size-large"><img loading="lazy" width="1020" height="247" src="/content/images/wordpress/2020/08/image-25.png" alt="" class="wp-image-127" srcset="/content/images/wordpress/2020/08/image-25.png 1020w, /content/images/wordpress/2020/08/image-25-300x73.png 300w, /content/images/wordpress/2020/08/image-25-768x186.png 768w" sizes="(max-width: 1020px) 100vw, 1020px"></figure>

Untuk memastikannya sudah mengarah dengan baik silakan di ping saja

<figure class="wp-block-image size-large"><img loading="lazy" width="859" height="230" src="/content/images/wordpress/2020/08/image-26.png" alt="" class="wp-image-128" srcset="/content/images/wordpress/2020/08/image-26.png 859w, /content/images/wordpress/2020/08/image-26-300x80.png 300w, /content/images/wordpress/2020/08/image-26-768x206.png 768w" sizes="(max-width: 859px) 100vw, 859px"></figure>

Apabila sudah mengarah silakan diakses ke 2 subdomain tersebut melalui browser, jika hasil test page maka sudah benar contohnya

- Subdomain: _ **vhost01.nurhamim.my.id** _
<figure class="wp-block-image size-large"><img loading="lazy" width="1024" height="208" src="/content/images/wordpress/2020/08/image-27-1024x208.png" alt="" class="wp-image-129" srcset="/content/images/wordpress/2020/08/image-27-1024x208.png 1024w, /content/images/wordpress/2020/08/image-27-300x61.png 300w, /content/images/wordpress/2020/08/image-27-768x156.png 768w, /content/images/wordpress/2020/08/image-27.png 1366w" sizes="(max-width: 1024px) 100vw, 1024px"></figure>
- Subdomain: **_vhost02.nurhamim.my.id_**
<figure class="wp-block-image size-large"><img loading="lazy" width="1024" height="160" src="/content/images/wordpress/2020/08/image-29-1024x160.png" alt="" class="wp-image-131" srcset="/content/images/wordpress/2020/08/image-29-1024x160.png 1024w, /content/images/wordpress/2020/08/image-29-300x47.png 300w, /content/images/wordpress/2020/08/image-29-768x120.png 768w, /content/images/wordpress/2020/08/image-29.png 1361w" sizes="(max-width: 1024px) 100vw, 1024px"></figure>

Saat ini vhost sudah berhasil dibuat.

Selamat mencoba 😁

Please follow and like us:

[![error](/wp-content/plugins/ultimate-social-media-icons/images/follow_subscribe.png)](https://api.follow.it/widgets/icon/VHc3d1lpVGdwRnE5QnV0eERCNUx5RCtvTTVoUkNYS3NNRmd5eVhlQW9tNXRHS3VTbGh6Y0NybkRJRS8zSGpjRDVZb1ZGMlNTSEpJYUpuZzZqNzdnd3VSN3dwM2VlQTF6ejJEaGV5UGRUbnlEcHFNd3luYTV4ZTZtUGowVWI2Q2x8M2kzdnBEeUIrUk5xOFI5TXZ3cHF3bFNQRkRJSGhUNGdrRFd0TlNtdE1OWT0=/OA==/)

[![fb-share-icon](/wp-content/plugins/ultimate-social-media-icons/images/visit_icons/fbshare_bck.png "Facebook Share")](https://www.facebook.com/sharer/sharer.php?u=https%3A%2F%2Fbelajarlinux.id%2F%3Fp%3D126%26ghostexport%3Dtrue%26submit%3DDownload+Ghost+File)

[![Tweet](/wp-content/plugins/ultimate-social-media-icons/images/visit_icons/en_US_Tweet.svg "Tweet")](https://twitter.com/intent/tweet?text=Cara+Membuat+Virtual+Host+Apache+di+CentOS+8+https://belajarlinux.id/?p=126&ghostexport=true&submit=Download Ghost File)

[![fb-share-icon](/wp-content/plugins/ultimate-social-media-icons/images/share_icons/Pinterest_Save/en_US_save.svg "Pin Share")](#)

<!--kg-card-end: html-->
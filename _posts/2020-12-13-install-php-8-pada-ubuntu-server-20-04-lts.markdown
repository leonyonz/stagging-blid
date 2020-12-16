---
layout: post
title: Install PHP 8 pada Ubuntu Server 20.04 LTS
featured: true
date: '2020-12-13 16:11:05'
---

PHP merupakan salah satu bahasa pemrograman server-side yang paling banyak digunakan. Banyak CMS yang populer yang menggunakan PHP dalam bahasa pemrogramannya termasuk WordPress, Magento dan Laravel.

PHP 8 merupakan versi major yang terbaru, dan terdapat penambahan banyak [fitur](https://www.php.net/releases/8.0/en.php)dan optimasisasi termasuk nama argumen, atribut, operator nullsafe, JIT dan perbaikan dalam tipe sistem, penanganan error dan konsistensi.

Kali ini saya akan membagikan cara menginstall PHP 8 dan beberapa contoh modulnya, sebenarnya bisa diterpakan pada web server Apache, Nginx, ataupun web server yang lainnya. Namun implementasi saat ini menggunakan web server Nginx. Yuk langsung saja simak penjelasan berikut ini!

<!--kg-card-begin: html--><script async src="https://pagead2.googlesyndication.com/pagead/js/adsbygoogle.js"></script><ins class="adsbygoogle" style="display:block; text-align:center;" data-ad-layout="in-article" data-ad-format="fluid" data-ad-client="ca-pub-1515372853161377" data-ad-slot="4684565489"></ins><script>
     (adsbygoogle = window.adsbygoogle || []).push({});
</script><!--kg-card-end: html-->
### Mengaktifkan Repositori PHP

Langkah yang pertama, silakan mengaktifkan repositori PHP terlebih dahulu.

<!--kg-card-begin: markdown-->

    sudo apt install software-properties-common
    sudo add-apt-repository ppa:ondrej/php

<!--kg-card-end: markdown-->
### Install PHP 8.0 dengan Nginx

Install Nginx dengan perintah sebagai berikut:

<!--kg-card-begin: markdown-->

    ubuntu@belajarlinux-id:~$ sudo apt update
    ubuntu@belajarlinux-id:~$ sudo apt install nginx

<!--kg-card-end: markdown-->

Aktifkan service nginx dan start servicenya.

<!--kg-card-begin: markdown-->

    sudo systemctl enable nginx && sudo systemctl start nginx

<!--kg-card-end: markdown-->

Apabila berjalan dengan normal, maka status service Nginx akan running seperti pada gambar berikut.

<figure class="kg-card kg-image-card"><img src="/content/images/2020/12/Status-Nginx.png" class="kg-image" alt></figure>

Setelah itu, install php-fpm dengan perintah:

<!--kg-card-begin: markdown-->

    sudo apt install php8.0-fpm

<!--kg-card-end: markdown-->

Aktifkan dan start service php-fpm dengan perintah sebagai berikut:

<!--kg-card-begin: markdown-->

    sudo systemctl enable php8.0-fpm && sudo systemctl start php8.0-fpm

<!--kg-card-end: markdown-->

Apabila berjalan dengan lancar, maka status php-fpm running.

<figure class="kg-card kg-image-card"><img src="/content/images/2020/12/Status-Phpfpm.png" class="kg-image" alt srcset="/content/images/size/w600/2020/12/Status-Phpfpm.png 600w, /content/images/size/w1000/2020/12/Status-Phpfpm.png 1000w, /content/images/2020/12/Status-Phpfpm.png 1163w" sizes="(min-width: 720px) 720px"></figure>

Selanjutnya, buat salah satu server-block untuk mengarahkan website dan letak direktori website tersebut, kurang lebih seperti berikut ini:

<!--kg-card-begin: markdown-->

    server {
        listen 80;
        server_name ubuntu.belajar-linux.id;
    
        # note that these lines are originally from the "location /" block
        root /var/www/html/;
        index index.php index.html index.htm info.php;
        # log files
        access_log /var/log/nginx/ubuntu.belajar-linux.id-access.log;
        error_log /var/log/nginx/ubuntu.belajar-linux.id-error.log;
        location ~ \.php$ {
            try_files $uri =404;
            fastcgi_pass unix:/run/php/php8.0-fpm.sock;
            fastcgi_index index.php;
            fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
            include fastcgi_params;
        }
    }
    

<!--kg-card-end: markdown-->

Sebagai informasi tambahan, apabila Anda ingin menginstall modul-modul PHP yang lain dapat menginstallnya dengan mencari nama paketnya terlebih dahulu. Berikut beberapa contoh modul PHP yang akan diinstall.

<!--kg-card-begin: markdown-->

    sudo apt install php8.0-mysql/focal php8.0-gd/focal

<!--kg-card-end: markdown-->

Untuk mengetahui versi PHP 8 bisa menggunakan scrip phpinfo dan letakkan file tersebut pada root direktori konfigurasi server-block diatas.

<!--kg-card-begin: markdown-->

    <?php
    phpinfo();
    ?>

<!--kg-card-end: markdown-->

Langkah yang terakhir, silakan akses file info.php tersebut, jika berhasil akan menampilkan gambar seperti berikut.

<figure class="kg-card kg-image-card"><img src="/content/images/2020/12/Php-Info.png" class="kg-image" alt srcset="/content/images/size/w600/2020/12/Php-Info.png 600w, /content/images/size/w1000/2020/12/Php-Info.png 1000w, /content/images/2020/12/Php-Info.png 1320w" sizes="(min-width: 720px) 720px"></figure>
### Kesimpulan

Install PHP 8 beserta modulnya dilakukan pada Ubuntu Server 20.04 LTS, dengan menambahkan repo PHP “ondrej/php” terlebih dahulu dan install PHP 8 dengan `apt`.


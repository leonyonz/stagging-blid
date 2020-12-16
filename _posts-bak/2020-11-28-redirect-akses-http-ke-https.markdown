---
layout: post
title: Redirect Akses HTTP ke HTTPS pada Web Server Apache di Ubuntu 20.04 LTS.
featured: true
date: '2020-11-28 08:28:41'
tags:
- apache
- ubuntu
---

Jika Anda memiliki kebutuhan akses website menggunakan protokol HTTPS, maka Anda dapat melakukan instalasi sertifikat SSL terlebih dahulu pada web server Anda. Untuk menginstall sertifikat SSL pada web server Apache menggunakan sistem operasi Ubuntu 20.04 bisa mengikuti tautan berikut [ini](/install-ssl-lets-encrypt-untuk-apache/).

Setelah Anda menginstal sertifikat SSL tersebut, Anda bisa mengakses website menggunakan protokol HTTPS, akan tetapi diakses secara manual. Nah, kita juga bisa mengaksesnya secara otomatis dengan cara redirect akses HTTP ke HTTPS. Hal tersebut dilakukan untuk memastikan pengunjung website bisa mengakses menggunakan protokol yang aman bila mengakses menggunakan protokol HTTP. Adapun cara-caranya bisa dilihat pada pembahasan berikut ini:

<!--kg-card-begin: markdown-->
1. Redirect dengan konfigurasi file virtualhost
2. Redirect menggunakan file .htaccess
<!--kg-card-end: markdown-->

Cara yang pertama redirect akses HTTP ke HTTPS dengan cara konfigurasi file virtualhost. Buka file tersebut dengan teks editor favorit Anda pada path direktori: `/etc/apache2/sites-available`.

<!--kg-card-begin: markdown-->

    ubuntu@tutorialbelajarlinux:~$ sudo vim /etc/apache2/sites-available/example.conf

<!--kg-card-end: markdown-->

Setidaknya Anda sudah memiliki konfigurasi untuk port 80 (http) dan 443 (https) apabila ingin melakukan redirect akses HTTP ke HTTPS. Tambahkan satu baris konfigurasi didalam seperti &nbsp;`<VirtualHost *:80>` seperti berikut ini:

<!--kg-card-begin: markdown-->

    Redirect permanent / https://example.id/

<!--kg-card-end: markdown--><!--kg-card-begin: markdown-->

    <VirtualHost *:80>
    	ServerName example.id
    	ServerAlias www.example.id
    	
    	ServerAdmin webmaster@localhost 
    	DocumentRoot /var/www/html 
    
    	ErrorLog ${APACHE_LOG_DIR}/error.log
    	CustomLog ${APACHE_LOG_DIR}/access.log combined
    
    	Redirect permanent / https://example.id/
    </VirtualHost>
    
    <Virtualhost *:443>
    	ServerName example.id
    	ServerAlias www.example.id
    ---

<!--kg-card-end: markdown-->

Simpan hasil konfigurasi file virtualhost tersebut dan reload service Apache.

<!--kg-card-begin: markdown-->

    ubuntu@tutorialbelajarlinux:~$ sudo systemctl reload apache2

<!--kg-card-end: markdown-->

Cara yang kedua redirect protokol HTTP ke HTTPS dengan menambahkan file `.htaccess` pada direktori root website. Cara yang kedua ini adalah opsional apabila Anda tidak memiliki akses file virtualhost website.

<!--kg-card-begin: html--><script async src="https://pagead2.googlesyndication.com/pagead/js/adsbygoogle.js"></script><ins class="adsbygoogle" style="display:block; text-align:center;" data-ad-layout="in-article" data-ad-format="fluid" data-ad-client="ca-pub-1515372853161377" data-ad-slot="1986938311"></ins><script>
     (adsbygoogle = window.adsbygoogle || []).push({});
</script><!--kg-card-end: html-->

Tambahkan baris script berikut pada file `.htaccess`:

<!--kg-card-begin: markdown-->

    RewriteEngine On
    RewriteCond %{HTTPS} off
    RewriteRule ^(.*)$ https://example.id/ [L,R=301]

<!--kg-card-end: markdown-->

Setelah menambahkan file `.htaccess`, kemudian simpan dan nantinnya Anda akan diarahkan ke akses HTTPS secara otomatis ketika mengakses website pada browser. Cara yang kedua ini tidak membutuhkan reload service Apache.

Itulah cara melakukan redirect akses protokol HTTP ke HTTPS pada web server Apache menggunakan sistem operasi Ubuntu 20.04 LTS. Selain itu, Anda bisa melakukan uji coba lebih dalam lagi.

<!--kg-card-begin: markdown-->

Terima kasih,  
Semoga bermanfaat dan barokah.

<!--kg-card-end: markdown-->

Aamiin :)

_(Baca juga: [Install SSL Let's Encrypt untuk Apache di Ubuntu Server 20.04 TLS](/install-ssl-lets-encrypt-untuk-apache/))_


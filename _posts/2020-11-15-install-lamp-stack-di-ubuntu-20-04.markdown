---
layout: post
title: 'Ubuntu: Install LAMP Stack di  Ubuntu 20.04'
featured: true
date: '2020-11-15 15:12:09'
tags:
- apache
- cloud-computing
- database
- linux
- php
- ubuntu
---

LAMP merupakan satu paket software yang digunakan untuk mengaktifkan server guna menghosting situs web dinamis dan ditulis dalam bahasa pemrograman PHP. LAMP stack merupakan akronim dari **L** inux yang merupakan basis sistem operasinya, sedangkan **A** pache merupakan web servernya, adapun data-data websitenya disimpan dalam **M** ySQL sebagai database server, dan konten dinamis website yang diproses oleh **P** HP.

Pada panduan instalasi LAMP stack kali ini diterapkan pada sistem operasi Ubuntu Server 20.04 LTS, lebih lengkapnya silakan menyimak pembahasan berikut ini.

Persyaratan &nbsp;untuk menginstall LAMP Stack ini paling utama adalah Ubuntu Server 20.04 dengan menggunakan user non-root. &nbsp;Untuk mengecek versi Ubuntu Server 20.04 bisa menggunakan perintah sebagai berikut:

<!--kg-card-begin: markdown-->

    ubuntu@tutorialbelajarlinux:~$ cat /etc/*release
    DISTRIB_ID=Ubuntu
    DISTRIB_RELEASE=20.04
    DISTRIB_CODENAME=focal
    DISTRIB_DESCRIPTION="Ubuntu 20.04 LTS"
    NAME="Ubuntu"
    VERSION="20.04 LTS (Focal Fossa)"
    ID=ubuntu
    ID_LIKE=debian
    PRETTY_NAME="Ubuntu 20.04 LTS"
    VERSION_ID="20.04"
    HOME_URL="https://www.ubuntu.com/"
    SUPPORT_URL="https://help.ubuntu.com/"
    BUG_REPORT_URL="https://bugs.launchpad.net/ubuntu/"
    PRIVACY_POLICY_URL="https://www.ubuntu.com/legal/terms-and-policies/privacy-policy"
    VERSION_CODENAME=focal
    UBUNTU_CODENAME=focal

<!--kg-card-end: markdown-->
### Install Web Server Apache2

Sebelum install `apache2`, update paket Ubuntu Server 20.04 paling terbaru dengan perintah:

<!--kg-card-begin: markdown-->

    ubuntu@tutorialbelajarlinux:~$ sudo apt update
    ubuntu@tutorialbelajarlinux:~$ sudo apt install apache2

<!--kg-card-end: markdown-->

Jika Anda menggunakan perintah sudo maka sebagai awalan Anda biasanya akan diminta password user terlebih dahulu, isikan password user tersebut dan tekan enter, tunggu proses update dan instalasi `apache2` benar-benar selesai.

Anda bisa mengaktifkan service `apache2` ketika server mengalami reboot secara otomatis dengan perintah:

<!--kg-card-begin: markdown-->

    ubuntu@tutorialbelajarlinux:~$ sudo systemctl enable apache2

<!--kg-card-end: markdown-->

Pastikan service `apache2` sudah berstatus aktif.

<figure class="kg-card kg-image-card kg-card-hascaption"><img src="/content/images/2020/11/2--Status-apache2.png" class="kg-image" alt srcset="/content/images/size/w600/2020/11/2--Status-apache2.png 600w, /content/images/2020/11/2--Status-apache2.png 958w" sizes="(min-width: 720px) 720px"><figcaption>Status Apache2</figcaption></figure>

Setelah itu, Anda bisa coba akses IP Public Ubuntu Server 20.04 pada browser favorit Anda. Nantinya akan muncul tampilan default `apache2` seperti pada gambar berikut.

<figure class="kg-card kg-image-card kg-card-hascaption"><img src="/content/images/2020/11/3--Apache-web-default-1.png" class="kg-image" alt srcset="/content/images/size/w600/2020/11/3--Apache-web-default-1.png 600w, /content/images/size/w1000/2020/11/3--Apache-web-default-1.png 1000w, /content/images/2020/11/3--Apache-web-default-1.png 1520w" sizes="(min-width: 720px) 720px"><figcaption>Tampilan default Apache2</figcaption></figure>
### Install MySQL 

Sekarang kita sudah memiliki web server dan sudah berstatus running, selanjutnya kita bisa menginstall service `MySQL` untuk lebih mudah mengelola website terutama &nbsp;untuk menyimpan data website.

<!--kg-card-begin: markdown-->

    ubuntu@tutorialbelajarlinux:~$ sudo apt install mysql-server

<!--kg-card-end: markdown-->

Konfirmasi dengan tekan Y dan enter.

Setelah instalasi `MySQL` berhasil, direkomendasikan untuk menjalankan _security script_ pada waktu pre-install `MySQL`. Hal tersebut digunakan untuk menghapus pengaturan yang insecure dan membatasi akses ke database server.

<!--kg-card-begin: markdown-->

    ubuntu@tutorialbelajarlinux:~$ sudo mysql_secure_installation

<!--kg-card-end: markdown-->

Nantinya Anda akan diminta **VALIDATE PASSWORD PLUGIN**.

Konfirmasi dengan tekan y untuk yes, atau tekan apapun untuk melanjutkan.

<!--kg-card-begin: markdown-->

    VALIDATE PASSWORD PLUGIN can be used to test passwords
    and improve security. It checks the strength of password
    and allows the users to set only those passwords which are
    secure enough. Would you like to setup VALIDATE PASSWORD plugin?
    
    Press y|Y for Yes, any other key for No:

<!--kg-card-end: markdown-->

Jika Anda mengkonfirmasi yes, maka Anda akan diminta level password untuk akses database server dengan berbagai &nbsp;macam pilihan, antara lain:

<!--kg-card-begin: markdown-->

    There are three levels of password validation policy:
    
    LOW Length >= 8
    MEDIUM Length >= 8, numeric, mixed case, and special characters
    STRONG Length >= 8, numeric, mixed case, special characters and dictionary file
    
    Please enter 0 = LOW, 1 = MEDIUM and 2 = STRONG: 1

<!--kg-card-end: markdown-->

Setelah Anda memilih kriteria level password, maka jika kita ingin login ke database server dengan user `root` maka akan diminta password. Hal tersebut digunakan untuk keamanan dalam mengakses database server Anda.

Selanjutnya, Anda bisa mengkonfirmasi kembali bahwa password yang Anda setup sebelumnya sudah sesuai dengan menekan tombol y untuk yes.

<!--kg-card-begin: markdown-->

    Estimated strength of the password: 100 
    Do you wish to continue with the password provided?(Press y|Y for Yes, any other key for No) : y

<!--kg-card-end: markdown-->

Langkah yang terakhir, Anda bisa menekan tombol y untuk yes pada setiap langkah. Hal tersebut untuk menghapus user anonymouse dan database test, menon-aktifkan remote login user `root`, dan load hasil setup yang sudah selesai dilakukan sebelumnya.

Setelah setup _security script_ berhasil dilakukan, Anda bisa login ke database &nbsp;server. Namun sebelumnya pastikan service `MySQL` sudah berjalan dengan normal.

<figure class="kg-card kg-image-card kg-card-hascaption"><img src="/content/images/2020/11/4--Status-Mysql-Server.png" class="kg-image" alt srcset="/content/images/size/w600/2020/11/4--Status-Mysql-Server.png 600w, /content/images/2020/11/4--Status-Mysql-Server.png 777w" sizes="(min-width: 720px) 720px"><figcaption>Status mysql-server</figcaption></figure><!--kg-card-begin: markdown-->

    ubuntu@tutorialbelajarlinux:~$ sudo mysql

<!--kg-card-end: markdown--><!--kg-card-begin: markdown-->

    Welcome to the MySQL monitor. Commands end with ; or \g.
    Your MySQL connection id is 17
    Server version: 8.0.22-0ubuntu0.20.04.2 (Ubuntu)
    
    Copyright (c) 2000, 2020, Oracle and/or its affiliates. All rights reserved.
    
    Oracle is a registered trademark of Oracle Corporation and/or its
    affiliates. Other names may be trademarks of their respective
    owners.
    
    Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.
    
    mysql>

<!--kg-card-end: markdown-->

Ketika Anda login ke MySQL, Anda tidak dimintai password walaupun sudah melakukan setup sebelumnya. Hal ini dikarenakan secara default, MySQL administratif menggunakan autentikasi `unix_socket` &nbsp;sebagai pengganti dari input password.

Ketik exit untuk keluar dari konsole `MySQL`.

<!--kg-card-begin: markdown-->

    mysql> exit

<!--kg-card-end: markdown-->

Saat ini Anda sudah berhasil menginstall web server dan database server pada Ubuntu Server 20.04.

### Install PHP 

Kita sudah memiliki `apache2` untuk melayani konten website, `MySQL` untuk menyimpan data website. Selain kedua software tersebut, kita juga butuh PHP untuk menjalankan konten website secara dinamis hingga `end user` bisa mengaksesnya dengan normal.

PHP modul yang kita butuhkan yaitu `php-mysql`, dimana modul tersebut berfungsi untuk menghubungkan PHP dengan `mysql-server`, modul `libapache2-mod-php` digunakan untuk mengaktifkan service `apache2` dalam mengakses file PHP.

Untuk menginstal modul-modul tersebut bisa menjalankan perintah sebagai berikut:

<!--kg-card-begin: markdown-->

    ubuntu@tutorialbelajarlinux:~$ sudo apt install php libapache2-mod-php php-mysql

<!--kg-card-end: markdown-->

Konfirmasi dengan tekan y dan enter.

Selanjutnya Anda bisa melihat versi PHP yang sudah berhasil diinstall.

<figure class="kg-card kg-image-card kg-card-hascaption"><img src="/content/images/2020/11/6.-Php-version.png" class="kg-image" alt srcset="/content/images/size/w600/2020/11/6.-Php-version.png 600w, /content/images/2020/11/6.-Php-version.png 744w" sizes="(min-width: 720px) 720px"><figcaption>Versi PHP 7.4</figcaption></figure>

Sampai langkah ini, kita sudah berhasil menginstall LAMP Stack. Selanjutya Anda bisa mensetting `virtualhost` pada `apache2` untuk mengkolaborasikan LAMP Stack tersebut, hal ini akan dibahas pada langah selanjutnya.

### Membuat Virtualhost Website

Ketika kita menggunakan `apache2`, kita bisa membuat virtualhost layaknya serverblock seperti pada web server `Nginx`. Kegunaan virtulhost tersebut untuk mengenkapsulasi konfigurasi web server dengan satu domain maupun multi domain, selain itu bisa menentukan root\_directory dimana website kita akan disimpan, dan lain sebagainya.

Secara default root\_directory tersebut terletak pada direktori `/var/www/html`. Namun kita juga bisa menentukan diluar direktori tersebut, misalnya kita ingin membuat root\_directory pada `/var/www/<nama_website>`. Disini saya ingin membuat root\_directory seperti /var/www/belajar-linux.

Buat direktorinya terlebih dahulu dengan perintah:

<!--kg-card-begin: markdown-->

    ubuntu@tutorialbelajarlinux:~$ sudo mkdir /var/www/belajar-linux

<!--kg-card-end: markdown-->

Selanjutnya, kita bisa menentukan user dan grup pada root\_directory tersebut.

<!--kg-card-begin: markdown-->

    ubuntu@tutorialbelajarlinux:~$ sudo chown -R $USER:$USER /var/www/belajar-linux

<!--kg-card-end: markdown-->

Buat virtualhost dengan teks editor favorit Anda, disini saya menggunakan `vim`:

<!--kg-card-begin: markdown-->

    ubuntu@tutorialbelajarlinux:~$ sudo vim /etc/apache2/sites-available/nama_domain.conf

<!--kg-card-end: markdown-->

Tambahkan konfigurasi virtualhost seperti berikut:

<!--kg-card-begin: markdown-->

    <VirtualHost *:80>
        ServerName your_domain
        ServerAlias www.your_domain
        ServerAdmin webmaster@localhost
        DocumentRoot /var/www/your_domain
        ErrorLog ${APACHE_LOG_DIR}/error.log
        CustomLog ${APACHE_LOG_DIR}/access.log combined
    </VirtualHost>

<!--kg-card-end: markdown-->

Sesuaikan `your_domain` dengan nama domain yang akan Anda gunakan pada website Anda.

Selanjutnya silakan reload service `apache2` untuk load hasil konfigurasi.

<!--kg-card-begin: markdown-->

    sudo systemctl reload apache2

<!--kg-card-end: markdown-->

Kemudian, akifkan konfigurasi virtualhost yang baru kita buat dan non-aktifkan konfigurasi default virtualhost `apache2`.

<!--kg-card-begin: markdown-->

    ubuntu@tutorialbelajarlinux:~$ sudo a2ensite your_domain

<!--kg-card-end: markdown--><!--kg-card-begin: markdown-->

    ubuntu@tutorialbelajarlinux:~$ sudo a2dissite 000-default

<!--kg-card-end: markdown-->

Reload kembali service `apache2`

<!--kg-card-begin: markdown-->

    ubuntu@tutorialbelajarlinux:~$ sudo systemctl reload apache2

<!--kg-card-end: markdown-->

Langkah selanjutnya, buat halaman sederhana dengan script `html`.

<!--kg-card-begin: markdown-->

    <html>
      <head>
        <title>your_domain website</title>
      </head>
      <body>
        <h1>Hello World!</h1>
    
        <p>This is the landing page of <strong>your_domain</strong>.</p>
      </body>
    </html>

<!--kg-card-end: markdown-->

Simpan, dan akses domain Anda pada browser nantinya akan muncul seperti tampilan berikut ini.

<figure class="kg-card kg-image-card kg-card-hascaption"><img src="/content/images/2020/11/7.-Show-pages-final.png" class="kg-image" alt srcset="/content/images/size/w600/2020/11/7.-Show-pages-final.png 600w, /content/images/2020/11/7.-Show-pages-final.png 937w" sizes="(min-width: 720px) 720px"><figcaption>Tampilan website HTML</figcaption></figure>

Secara default halaman index yang diakses pertama kali pada `apache2` adalah `index.html`, apabila ingin menampilkan `index.php` maka Anda bisa menghapus file `index.html` tersebut atau mengganti ekstensinya.

Selain opsi itu, kita juga bisa mengubah prioritas `index.php` agar bisa dibaca pertama kali oleh `apache2` dengan mengubah konfigurasi file berikut ini.

<!--kg-card-begin: markdown-->

    ubuntu@tutorialbelajarlinux:~$ sudo vim /etc/apache2/mods-enabled/dir.conf

<!--kg-card-end: markdown--><!--kg-card-begin: markdown-->

    <IfModule mod_dir.c>
            DirectoryIndex index.php index.html index.cgi index.pl index.xhtml index.htm
    </IfModule>

<!--kg-card-end: markdown-->

Setelah itu, silakan reload kembali service `apache2`

<!--kg-card-begin: markdown-->

    ubuntu@tutorialbelajarlinux:~$ sudo systemctl reload apache2

<!--kg-card-end: markdown-->

Buat script untuk menampilkan versi PHP yang digunakan pada Ubuntu Server 20.04 untuk menguji apakah `apache2` berhasil mengeksekusi file .php secara default (tanpa menghapus file `index.html`).

<!--kg-card-begin: markdown-->

    <?php 
    phpinfo();
    ?>

<!--kg-card-end: markdown--><figure class="kg-card kg-image-card kg-card-hascaption"><img src="/content/images/2020/11/8.-Phpinfo-1.png" class="kg-image" alt srcset="/content/images/size/w600/2020/11/8.-Phpinfo-1.png 600w, /content/images/size/w1000/2020/11/8.-Phpinfo-1.png 1000w, /content/images/2020/11/8.-Phpinfo-1.png 1321w" sizes="(min-width: 720px) 720px"><figcaption>PHP Info</figcaption></figure>
### Test Koneksi Database dari PHP (Opsional)

Modul PHP native yang digunakan untuk menghubungkan ke database server adalah `mysqlnd`. Untuk menguji apakah PHP berhasil terhubung ke database server, kita bisa membuat database terlebih dahulu dan membuat table dengan konten secara dummy.

Login ke `MySQL` server dengan user `root`, dan buat databasenya.

<!--kg-card-begin: markdown-->

    ubuntu@tutorialbelajarlinux:~$ sudo mysql

<!--kg-card-end: markdown--><!--kg-card-begin: markdown-->

    mysql> CREATE DATABASE example_database;

<!--kg-card-end: markdown-->

Setelah itu, buat user untuk akses ke database tersebut. Isikan sesuai dengan user dan database yang Anda inginkan

<!--kg-card-begin: markdown-->

    mysql> CREATE USER 'example_user'@'%' IDENTIFIED BY 'password';

<!--kg-card-end: markdown-->

Sekarang, coba berikan hak akses/permission terhadap user untuk mengakses database tersebut.

<!--kg-card-begin: markdown-->

    mysql> GRANT ALL ON example_database.* TO 'example_user'@'%';

<!--kg-card-end: markdown-->

Exit dari `MySQL` console, dan coba login menggunakan user database yang sudah dibuat sebelumnya.

<!--kg-card-begin: markdown-->

    mysql> exit

<!--kg-card-end: markdown--><!--kg-card-begin: markdown-->

    mysql -u example_user -p

<!--kg-card-end: markdown-->

Setelah berhasil login, tampilkan database untuk memastikan bahwa database yang sudah diizinkan akses oleh user tersebut.

<!--kg-card-begin: markdown-->

    mysql> SHOW DATABASES;

<!--kg-card-end: markdown-->

Jika sudah sesuai, maka buat satu table seperti halnya berikut ini:

<!--kg-card-begin: markdown-->

    mysql> CREATE TABLE example_database.schedule (
    id_item INT AUTO_INCREMENT,
    isian VARCHAR(255),
    PRIMARY KEY(id_item)
    );

<!--kg-card-end: markdown-->

Tambahkan konten untuk table database tersebut.

<!--kg-card-begin: markdown-->

    mysql> INSERT INTO example_database.schedule (content) VALUES ("Jadwal Pertama Kerja");

<!--kg-card-end: markdown-->

Untuk melihat konten yang sudah ditambahkan pada tabel database bisa menggunakan perintah berikut.

<!--kg-card-begin: markdown-->

    mysql> SELECT *FROM example_database.schedule;

<!--kg-card-end: markdown--><!--kg-card-begin: markdown-->

    Output
    +---------+--------------------------+
    | item_id | content |
    +---------+--------------------------+
    | 1 | Jadwal Pertama Kerja |
    | 2 | Jadwal Kedua Kerja |
    | 3 | Jadwal Ketiga Kerja |
    | 4 | Jadwal Keempat Kerja |
    +---------+--------------------------+
    4 rows in set (0.000 sec)

<!--kg-card-end: markdown-->

Setelah sesuai dengan konten tabel database yang sudah diisikan sebelumnya, keluar dari mysql consol.

<!--kg-card-begin: markdown-->

    mysql> exit

<!--kg-card-end: markdown-->

Selanjutnya Anda bisa membuat file script PHP misalnya: `jadwal.php` untuk menghubungkan dengan database yang sudah dibuat sebelumnya. Silakan menyesuaikan user, password, database dan tabelnya.

<!--kg-card-begin: markdown-->

    <?php
    $user = "example_user";
    $password = "password";
    $database = "example_database";
    $table = "schedule";
    
    try {
      $db = new PDO("mysql:host=localhost;dbname=$database", $user, $password);
      echo "<h2>SCHEDULE</h2><ol>";
      foreach($db->query("SELECT content FROM $table") as $row) {
        echo "<li>" . $row['content'] . "</li>";
      }
      echo "</ol>";
    } catch (PDOException $e) {
        print "Error!: " . $e->getMessage() . "<br/>";
        die();
    }

<!--kg-card-end: markdown-->

Setelah itu, simpan file tersebut dan akses ke browser Anda.

Apabila muncul output seperti gambar berikut, maka PHP sudah berhasil terhubung ke database server. Dengan demikian, PHP environment Anda sudah bisa digunakan untuk interaksi ke database server.

<figure class="kg-card kg-image-card kg-card-hascaption"><img src="/content/images/2020/11/9.-PHP-MySQL.png" class="kg-image" alt srcset="/content/images/size/w600/2020/11/9.-PHP-MySQL.png 600w, /content/images/2020/11/9.-PHP-MySQL.png 977w" sizes="(min-width: 720px) 720px"><figcaption>Konten PHP untuk menampilkan database</figcaption></figure>
### Kesimpulan

Pada pembahasan kali ini, kita telah belajar install LAMP Stack untuk kebutuhan aplikasi website dengan basis PHP yang bisa dilihat oleh end user sekalipun. Dimana `apache2` yang bertindak sebagai web server, `MySQL` sebagai sistem database.

Adapun pembahasan lanjutan yang lain akan kami kupas dan share ke kalian tentunya di blog [**ini**](/install-linux-apache-mysql-php-lamp-stack-di-ubuntu-20-04/belajarlinux.id). Semoga bermanfaat dan barokah, Aamiin :)

Sampai jumpa :)


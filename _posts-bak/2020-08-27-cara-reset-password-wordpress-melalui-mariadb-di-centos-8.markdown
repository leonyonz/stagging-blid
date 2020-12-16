---
layout: post
title: Cara Reset Password WordPress Melalui MariaDB di CentOS 8
featured: true
date: '2020-08-27 13:37:41'
tags:
- centos
- cms
- database
---

Sebagai manusia kita pasti akan pernah lupa dan hal ini sudah wajar karena manusia tidak ada yang sempurna. Jika Anda mempunyai WordPress yang diinstall menggunakan mariadb server dan Anda lupa akan password login ke WP Admin WordPress Anda, janganlah khawatir karena password WP dapat Anda reset ulang melalui phpMyAdmin ataupun CLI MariaDB.

Disini kami akan memberikan cara reset password WP Admin WordPress Anda menggunakan CLI database MariaDB.

Langkah pertama yang harus dilakukan yaitu membuat password baru dengan enkripsi MD5

    [root@tutorial ~]#
    [root@tutorial ~]# echo -n "passwordbaruwpbelajarlinux" | md5sum
    41f144634609e72b28d5c53582e801f9 -
    [root@tutorial ~]#

_Noted: Simpan MD5 dan passwordbaru Anda_

Selanjutnya login ke mariadb Anda dan masuk ke database WordPress Anda menggunakan _use [Nama DB]_

    [root@tutorial ~]#
    [root@tutorial ~]# mysql -u root -p
    Enter password:
    Welcome to the MariaDB monitor. Commands end with ; or \g.
    Your MariaDB connection id is 191
    Server version: 10.3.17-MariaDB MariaDB Server
    
    Copyright (c) 2000, 2018, Oracle, MariaDB Corporation Ab and others.
    
    Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.
    
    MariaDB [(none)]> show databases;
    +--------------------+
    | Database |
    +--------------------+
    | belajarlinuxdb |
    | chamilo |
    | ci_db |
    | drupal |
    | information_schema |
    | joomla |
    | joomladb |
    | laravel |
    | moodle |
    | mysql |
    | performance_schema |
    | prestashop |
    | typo3 |
    | wordpress |
    +--------------------+
    14 rows in set (0.170 sec)
    
    MariaDB [(none)]> use wordpress;
    Reading table information for completion of table and column names
    You can turn off this feature to get a quicker startup with -A
    
    Database changed
    MariaDB [wordpress]>

Melihat tabel WordPress

    MariaDB [wordpress]> show tables;
    +-----------------------+
    | Tables_in_wordpress |
    +-----------------------+
    | wp_commentmeta |
    | wp_comments |
    | wp_links |
    | wp_options |
    | wp_postmeta |
    | wp_posts |
    | wp_term_relationships |
    | wp_term_taxonomy |
    | wp_termmeta |
    | wp_terms |
    | wp_usermeta |
    | wp_users |
    +-----------------------+
    12 rows in set (0.000 sec)

Pada tabel tersebut ada _wp\_users_ dimana list user login ke WP Admin ada disitu

Untuk mengetahuinya user dan password nya jalankan perintah berikut

    MariaDB [wordpress]> SELECT ID, user_login, user_pass FROM wp_users;
    +----+---------------------+------------------------------------+
    | ID | user_login | user_pass |
    +----+---------------------+------------------------------------+
    | 1 | adminbelajarlinuxid | $P$BmLezSVhiKAQcX3wiz7inzC9YScbcy0 |
    +----+---------------------+------------------------------------+
    1 row in set (0.000 sec)

Anda dapat reset password atau memperbaharui password Anda seperti berikut

    MariaDB [wordpress]>
    
    MariaDB [wordpress]> UPDATE wp_users SET user_pass= "41f144634609e72b28d5c53582e801f9" WHERE ID = 1;
    Query OK, 1 row affected (0.004 sec)
    Rows matched: 1 Changed: 1 Warnings: 0
    
    MariaDB [wordpress]>

_Noted: user\_pass = Isikan MD5 yang didapatkan pada saat membuat password baru_

Jika di select user wp kembali saat ini password sudah berubah

    MariaDB [wordpress]>
    
    MariaDB [wordpress]> SELECT ID, user_login, user_pass FROM wp_users;
    +----+---------------------+----------------------------------+
    | ID | user_login | user_pass |
    +----+---------------------+----------------------------------+
    | 1 | adminbelajarlinuxid | 41f144634609e72b28d5c53582e801f9 |
    +----+---------------------+----------------------------------+
    1 row in set (0.001 sec)
    
    MariaDB [wordpress]>

Langkah terakhir _flush privileges database Anda_

    MariaDB [wordpress]>
    MariaDB [wordpress]> flush privileges;
    Query OK, 0 rows affected (0.034 sec)
    
    MariaDB [wordpress]> exit
    Bye
    [root@tutorial ~]#

Sekarang mencoba login menggunakan username dan password baru ke WP Admin

<figure class="wp-block-image size-large"><img loading="lazy" width="1024" height="478" src="/content/images/wordpress/2020/08/image-100-1024x478.png" alt="" class="wp-image-351" srcset="/content/images/wordpress/2020/08/image-100-1024x478.png 1024w, /content/images/wordpress/2020/08/image-100-300x140.png 300w, /content/images/wordpress/2020/08/image-100-768x359.png 768w, /content/images/wordpress/2020/08/image-100.png 1353w" sizes="(max-width: 1024px) 100vw, 1024px"></figure>

Pastikan sudah sesuai, jika berhasil maka Anda akan diarahkan ke Dashboard WP Admin WordPress

<figure class="wp-block-image size-large"><img loading="lazy" width="1024" height="551" src="/content/images/wordpress/2020/08/image-101-1024x551.png" alt="" class="wp-image-352" srcset="/content/images/wordpress/2020/08/image-101-1024x551.png 1024w, /content/images/wordpress/2020/08/image-101-300x161.png 300w, /content/images/wordpress/2020/08/image-101-768x413.png 768w, /content/images/wordpress/2020/08/image-101.png 1355w" sizes="(max-width: 1024px) 100vw, 1024px"></figure>

Selamat mencoba 😁

Please follow and like us:

[![error](/wp-content/plugins/ultimate-social-media-icons/images/follow_subscribe.png)](https://api.follow.it/widgets/icon/VHc3d1lpVGdwRnE5QnV0eERCNUx5RCtvTTVoUkNYS3NNRmd5eVhlQW9tNXRHS3VTbGh6Y0NybkRJRS8zSGpjRDVZb1ZGMlNTSEpJYUpuZzZqNzdnd3VSN3dwM2VlQTF6ejJEaGV5UGRUbnlEcHFNd3luYTV4ZTZtUGowVWI2Q2x8M2kzdnBEeUIrUk5xOFI5TXZ3cHF3bFNQRkRJSGhUNGdrRFd0TlNtdE1OWT0=/OA==/)

[![fb-share-icon](/wp-content/plugins/ultimate-social-media-icons/images/visit_icons/fbshare_bck.png "Facebook Share")](https://www.facebook.com/sharer/sharer.php?u=https%3A%2F%2Fbelajarlinux.id%2F%3Fp%3D349%26ghostexport%3Dtrue%26submit%3DDownload+Ghost+File)

[![Tweet](/wp-content/plugins/ultimate-social-media-icons/images/visit_icons/en_US_Tweet.svg "Tweet")](https://twitter.com/intent/tweet?text=Cara+Reset+Password+WordPress+Melalui+MariaDB+di+CentOS+8+https://belajarlinux.id/?p=349&ghostexport=true&submit=Download Ghost File)

[![fb-share-icon](/wp-content/plugins/ultimate-social-media-icons/images/share_icons/Pinterest_Save/en_US_save.svg "Pin Share")](#)

<!--kg-card-end: html-->
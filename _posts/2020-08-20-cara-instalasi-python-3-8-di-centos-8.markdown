---
layout: post
title: Cara Instalasi Python 3.8 di CentOS 8
featured: true
date: '2020-08-20 21:39:57'
tags:
- centos
- linux
---

Python adalah salah satu bahasa pemrograman yang paling banyak digunakan di dunia. Dengan sintaks nya yang sederhana dan mudah dipelajari, Python adalah pilihan populer untuk pemula dan pengembang berpengalaman. Python adalah bahasa pemrograman yang cukup serbaguna, dapat digunakan untuk membangun semua jenis aplikasi, dari skrip sederhana hingga algoritma pembelajaran mesin.

CentOS 8 menyertakan Python versi 3.6, yang dapat diinstal atau diperbarui menggunakan dnf.

Pada saat penulisan, Python 3.8 adalah rilis utama terbaru dari bahasa Python, banyak fitur baru seperti expressions, positional-only parameters, f-strings support dan yang lainnya. Python 3.8 tidak tersedia di repositori CentOS 8 standar.

## #Instalasi Python 3.8

Untuk melakukan compile python membutuhkan beberapa paket yang dibutuhkan silakan jalankan perintah berikut

    [root@tutorial ~]# dnf groupinstall 'development tools'
    Last metadata expiration check: 1:48:46 ago on Thu Aug 20 12:26:29 2020.
    Dependencies resolved.
    ========================================================================================================================
     Package Architecture Version Repository Size
    ========================================================================================================================

    [root@tutorial ~]#
    [root@tutorial ~]# dnf install bzip2-devel expat-devel gdbm-devel \
    > ncurses-devel openssl-devel readline-devel wget \
    > sqlite-devel tk-devel xz-devel zlib-devel libffi-devel

Menunduh python 3.8 melalui situs resmi python berikut: _[Python Download Page](https://www.python.org/downloads/source/)_ atau Anda dapat menjalankan perintah berikut

    [root@tutorial ~]#
    [root@tutorial ~]# wget https://www.python.org/ftp/python/${VERSION=3.8.5}/Python-${VERSION=3.8.5}.tgz
    --2020-08-20 14:20:34-- https://www.python.org/ftp/python/3.8.5/Python-3.8.5.tgz
    Resolving www.python.org (www.python.org)... 151.101.8.223, 2a04:4e42:2::223
    Connecting to www.python.org (www.python.org)|151.101.8.223|:443... connected.
    HTTP request sent, awaiting response... 200 OK
    Length: 24149103 (23M) [application/octet-stream]
    Saving to: ‘Python-3.8.5.tgz’
    
    Python-3.8.5.tgz 100%[======================================================================>] 23.03M 30.5MB/s in 0.8s
    
    2020-08-20 14:20:34 (30.5 MB/s) - ‘Python-3.8.5.tgz’ saved [24149103/24149103]
    
    [root@tutorial ~]#

Ekstrack file python yang baru saja diunduh

    [root@tutorial ~]#
    [root@tutorial ~]# ls
    Python-3.8.5.tgz anaconda-ks.cfg original-ks.cfg
    [root@tutorial ~]#
    [root@tutorial ~]# tar -xf Python-3.8.5.tgz

Pindah ke direktori Python dan jalankan _configure_ untuk memerikan depedensi yang dibutuhkan sebelum melakukan compile

    [root@tutorial ~]# cd Python-3.8/
    [root@tutorial Python-3.8]# ./configure --enable-optimizations

Build python, gunakan perintah berikut

    [root@tutorial Python-3.8]# make -j 4

Noted: _Ubah -j sesuai dengan processor yang Anda gunakan, jika Anda menggunakan 2 core silakan ubah nilai nya menjadi 2, untuk melihat processor ketikan perintah **nproc.** _

<figure class="wp-block-image size-large"><img loading="lazy" width="1024" height="609" src="/content/images/wordpress/2020/08/image-13-1024x609.png" alt="" class="wp-image-82" srcset="/content/images/wordpress/2020/08/image-13-1024x609.png 1024w, /content/images/wordpress/2020/08/image-13-300x178.png 300w, /content/images/wordpress/2020/08/image-13-768x457.png 768w, /content/images/wordpress/2020/08/image-13.png 1083w" sizes="(max-width: 1024px) 100vw, 1024px"></figure>

Proses build membutuhkan waktu silakan tunggu sampai selesai jika selesai hasil akhirnya seperti berikut

<figure class="wp-block-image size-large"><img loading="lazy" width="1024" height="524" src="/content/images/wordpress/2020/08/image-14-1024x524.png" alt="" class="wp-image-83" srcset="/content/images/wordpress/2020/08/image-14-1024x524.png 1024w, /content/images/wordpress/2020/08/image-14-300x153.png 300w, /content/images/wordpress/2020/08/image-14-768x393.png 768w, /content/images/wordpress/2020/08/image-14.png 1359w" sizes="(max-width: 1024px) 100vw, 1024px"></figure>

Selanjutnya install binary python

    [root@tutorial Python-3.8]#
    [root@tutorial Python-3.8]# make altinstall

Noted: Mohon untuk tidak menggunakan _make install_ jika Anda menggunakanya _make install_ maka python akan menimpa binary default system.

Verifikasi python 3.8 menggunakan perintah berikut

    [root@tutorial Python-3.8]# python3.8 --version
    Python 3.8.0
    [root@tutorial Python-3.8]#

Saat ini python 3.8 sudah terinstall dan python 3.6 (default CentOS 8) juga masih ada detailnya sebai berikut

    [root@tutorial ~]# python3
    python3 python3.6 python3.6m python3.8

Selamat mencoba 😄

Please follow and like us:

[![error](/wp-content/plugins/ultimate-social-media-icons/images/follow_subscribe.png)](https://api.follow.it/widgets/icon/VHc3d1lpVGdwRnE5QnV0eERCNUx5RCtvTTVoUkNYS3NNRmd5eVhlQW9tNXRHS3VTbGh6Y0NybkRJRS8zSGpjRDVZb1ZGMlNTSEpJYUpuZzZqNzdnd3VSN3dwM2VlQTF6ejJEaGV5UGRUbnlEcHFNd3luYTV4ZTZtUGowVWI2Q2x8M2kzdnBEeUIrUk5xOFI5TXZ3cHF3bFNQRkRJSGhUNGdrRFd0TlNtdE1OWT0=/OA==/)

[![fb-share-icon](/wp-content/plugins/ultimate-social-media-icons/images/visit_icons/fbshare_bck.png "Facebook Share")](https://www.facebook.com/sharer/sharer.php?u=https%3A%2F%2Fbelajarlinux.id%2F%3Fp%3D79%26ghostexport%3Dtrue%26submit%3DDownload+Ghost+File)

[![Tweet](/wp-content/plugins/ultimate-social-media-icons/images/visit_icons/en_US_Tweet.svg "Tweet")](https://twitter.com/intent/tweet?text=Cara+Instalasi+Python+3.8+di+CentOS+8+https://belajarlinux.id/?p=79&ghostexport=true&submit=Download Ghost File)

[![fb-share-icon](/wp-content/plugins/ultimate-social-media-icons/images/share_icons/Pinterest_Save/en_US_save.svg "Pin Share")](#)

<!--kg-card-end: html-->
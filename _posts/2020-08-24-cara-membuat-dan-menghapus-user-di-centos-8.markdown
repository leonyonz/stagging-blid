---
layout: post
title: Cara Membuat dan Menghapus User di CentOS 8
featured: true
date: '2020-08-24 09:28:45'
tags:
- centos
- linux
---

CentOS dan semua distribusi Linux lainnya adalah sistem operasi multi-pengguna. Setiap pengguna dapat memliki tingkat izin yang berbeda – beda dan pengaturan khusus baik di CLI ataupun GUI.

User juga dapat digunakan untuk menyimpan data – data website misalnya Anda mempunyai 2 CMS yang berjalan secara bersama sebagai contoh

_User 1 : Digunakan untuk CMS WordPress_

_User 2 : Digunakan untuk CMS Joomla_

Hal tersebut dapat di lakukan, dan sangat direkomendasikan dengan mendifine masing – masing CMS ke masing – masing user, maka akan bagus dari segi security karena website kita tidak di simpan default root misalnya jika di Nginx _usr/share/nginx/html_ jika di apache _/var/www/html._

Pada tutorial kali ini kami akan memberikan cara bagaimana cara membuat user dan menghapus user di CentOS 8.

Untuk membuat user di CentOS 8 sangatlah mudah Anda hanya perlu menjalankan command _adduser [namauser]_ saja contohnya

    [root@tutorial ~]# adduser userlinux
    [root@tutorial ~]# passwd userlinux
    Changing password for user userlinux.
    New password:
    Retype new password:
    passwd: all authentication tokens updated successfully.
    [root@tutorial ~]#

_Catatan:_

- _adduser : Perintah untuk menambahkan user_
- _passwd : Perintah untuk set password user_

User diatas masih belum memiliki hak akses istimewa atau root, jika ingin diberikan akses root perlu di tambahkan ke group terlebih dahulu

    [root@tutorial ~]# usermod -aG wheel userlinux
    [root@tutorial ~]#

Untuk uji coba login root bisa menggunakan ssh menggunakan user yang telah dibuat, pastikan di konfigurasi ssh sudah allow _[yes]_ untuk _PasswordAuthentication_ nya, direktori ssh berada di _/etc/ssh/sshd\_config_ .

    # To disable tunneled clear text passwords, change to no here!
    PasswordAuthentication yes
    #PermitEmptyPasswords no
    #PasswordAuthentication no

Jika sudah silakan reload sshd

    [root@tutorial ~]#
    [root@tutorial ~]# systemctl reload sshd

Login ssh menggunakan _userlinux_

    root@A1-LR08Q321:~#
    root@A1-LR08Q321:~# ssh userlinux@103.89.7.26
    userlinux@103.89.7.26's password:
    Activate the web console with: systemctl enable --now cockpit.socket
    
    [userlinux@tutorial ~]$ sudo su
    
    We trust you have received the usual lecture from the local System
    Administrator. It usually boils down to these three things:
    
        #1) Respect the privacy of others.
        #2) Think before you type.
        #3) With great power comes great responsibility.
    
    [sudo] password for userlinux: #Input Password userlinux
    [root@tutorial userlinux]#

Untuk memastikan apakah _userlinux_ sudah mempunyai akses root silakan ketikan perintah _whoami_

    [root@tutorial userlinux]# whoami
    root
    [root@tutorial userlinux]#

Secara default user yang dibuat berada di direktori _/home/userlinux_

    [root@tutorial userlinux]# pwd
    /home/userlinux
    [root@tutorial userlinux]#
    [root@tutorial userlinux]# ls -lah /home
    total 0
    drwxr-xr-x. 4 root root 37 Aug 24 02:01 .
    dr-xr-xr-x. 17 root root 244 Aug 22 17:11 ..
    drwx------. 3 centos centos 95 Aug 22 17:11 centos
    drwx------ 2 userlinux userlinux 62 Aug 24 02:01 userlinux
    [root@tutorial userlinux]#

Ada dua cara untuk menghapus user yang telah dibuat sebelumnya diantaranya

- Hapus user tanpa menghapus isi file di dalam user 

    [root@tutorial ~]# userdel userlinux

Saat ini userlinux sudah di hapus namun data – data atau file userlinux yang berada di _/home/userlinux_ masih ada

    [root@tutorial userlinux]#
    [root@tutorial userlinux]# ls -lah /home/
    total 0
    drwxr-xr-x. 4 root root 37 Aug 24 02:01 .
    dr-xr-xr-x. 17 root root 244 Aug 22 17:11 ..
    drwx------. 3 centos centos 95 Aug 22 17:11 centos
    drwx------ 2 userlinux userlinux 62 Aug 24 02:01 userlinux
    [root@tutorial userlinux]#

Untuk menghapus semua nya tambahkan _-r_ setelah _userdel_ Anda bisa menambahkan _-f (force delete)_ seperti berikut

    [root@tutorial ~]# userdel -f -r userlinux

Itulah cara membuat dan menghapus user di CentOS 8

Selamat mencoba 😁

Please follow and like us:

[![error](/wp-content/plugins/ultimate-social-media-icons/images/follow_subscribe.png)](https://api.follow.it/widgets/icon/VHc3d1lpVGdwRnE5QnV0eERCNUx5RCtvTTVoUkNYS3NNRmd5eVhlQW9tNXRHS3VTbGh6Y0NybkRJRS8zSGpjRDVZb1ZGMlNTSEpJYUpuZzZqNzdnd3VSN3dwM2VlQTF6ejJEaGV5UGRUbnlEcHFNd3luYTV4ZTZtUGowVWI2Q2x8M2kzdnBEeUIrUk5xOFI5TXZ3cHF3bFNQRkRJSGhUNGdrRFd0TlNtdE1OWT0=/OA==/)

[![fb-share-icon](/wp-content/plugins/ultimate-social-media-icons/images/visit_icons/fbshare_bck.png "Facebook Share")](https://www.facebook.com/sharer/sharer.php?u=https%3A%2F%2Fbelajarlinux.id%2F%3Fp%3D198%26ghostexport%3Dtrue%26submit%3DDownload+Ghost+File)

[![Tweet](/wp-content/plugins/ultimate-social-media-icons/images/visit_icons/en_US_Tweet.svg "Tweet")](https://twitter.com/intent/tweet?text=Cara+Membuat+dan+Menghapus+User+di+CentOS+8+https://belajarlinux.id/?p=198&ghostexport=true&submit=Download Ghost File)

[![fb-share-icon](/wp-content/plugins/ultimate-social-media-icons/images/share_icons/Pinterest_Save/en_US_save.svg "Pin Share")](#)

<!--kg-card-end: html-->
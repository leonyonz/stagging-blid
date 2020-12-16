---
layout: post
title: 'Openstack: Cara Rescue Instance'
featured: true
date: '2020-11-11 07:21:41'
tags:
- openstack
---

[Belajar Linux ID](/) - Pada tutorial kali ini kami akan melakukan rescue instance, tujuan dari rescue ini bila mana Anda lupa password login ke sisi instance, dengan rescue ini maka Anda dapat membuat user baru atau reset password user yang sudah ada sebelumnya.

Proses rescue ini akan membutuhkan reboot atau restart instance yang membutuhkan waktu kurang lebih proses reboot 10 menit.

Rescue instance di Openstack dapat di lakukan dengan mudah, menggunakan Live CD. Anda dapat menggunakan ISO **_[GParted](https://gparted.org/)_** base nya Debian untuk Live CD nya, silakan unduh ISO gparted pada link berikut: _[Download GParted](https://gparted.org/download.php)._

Berikut tahapan rescue instance di Openstack

- Upload ISO _GParted_ ke openstack bisa melalui Horizon atau CLI

(Baca juga: [Openstack: Upload Image atau ISO](/openstack-upload-image-atau-iso/))  
(Baca juga: [Openstack: Membuat Image via CLI](/openstack-membuat-image-via-cli/))

Login Horizon \>\> Image \>\> Create Image \>\> Isi Nama Image \>\> Upload Image \>\> Create Image

<figure class="kg-card kg-image-card kg-width-wide kg-card-hascaption"><img src="/content/images/2020/11/1-1.png" class="kg-image" alt srcset="/content/images/size/w600/2020/11/1-1.png 600w, /content/images/size/w1000/2020/11/1-1.png 1000w, /content/images/size/w1600/2020/11/1-1.png 1600w, /content/images/2020/11/1-1.png 1896w" sizes="(min-width: 1200px) 1200px"><figcaption><em>upload image iso via horizon</em></figcaption></figure>
- Login ke RC Admin openstack 
<!--kg-card-begin: markdown-->

    [centos@jumpwjv ~]$ source rcwjv.sh
    Please enter your OpenStack Password for project Project #21246 as user hi@belajarlinux.id:
    [centos@jumpwjv ~]$

<!--kg-card-end: markdown-->
- Cari ID Instance dan ID image Live CD (gparted)
<!--kg-card-begin: markdown-->

    [centos@jumpwjv ~]$ openstack server list

<!--kg-card-end: markdown-->

Atau dapat Anda grep sesuai spesifik name instance misalnya

<!--kg-card-begin: markdown-->

    [centos@jumpwjv ~]$ openstack server list |grep Hamim

<!--kg-card-end: markdown--><figure class="kg-card kg-image-card kg-width-wide"><img src="/content/images/2020/11/2-1.png" class="kg-image" alt srcset="/content/images/size/w600/2020/11/2-1.png 600w, /content/images/size/w1000/2020/11/2-1.png 1000w, /content/images/size/w1600/2020/11/2-1.png 1600w, /content/images/2020/11/2-1.png 1883w" sizes="(min-width: 1200px) 1200px"></figure>

Cari ID image Lice CD yang akan digunakan

<!--kg-card-begin: markdown-->

    [centos@jumpwjv ~]$ openstack image list |grep "Live CD"
    | df332d85-23b8-4e20-a423-e62adbd57112 | Live CD (Rescue) | active |
    [centos@jumpwjv ~]$

<!--kg-card-end: markdown-->

Sebagai contoh kali ini kita akan rescue instance dengan nama instance _Hamim-RS-Backup,_ berikut ID image dan ID instance nya

`ID Instance: e6b3911e-a823-4c65-a4a8-3504030f24af`

`ID image gparted: df332d85-23b8-4e20-a423-e62adbd57112`

Berikut command untuk melakukan rescue `openstack server rescue --image <ID-image-Live-CD> <ID-Instance`

Contohnya:

<!--kg-card-begin: markdown-->

    [centos@jumpwjv ~]$ openstack server rescue --image df332d85-23b8-4e20-a423-e62adbd57112 e6b3911e-a823-4c65-a4a8-3504030f24af
    [centos@jumpwjv ~]$

<!--kg-card-end: markdown-->
- Selanjutnya silakan akses console instance Anda bisa melalui Horizon
<figure class="kg-card kg-image-card kg-width-wide kg-card-hascaption"><img src="/content/images/2020/11/3.png" class="kg-image" alt srcset="/content/images/size/w600/2020/11/3.png 600w, /content/images/size/w1000/2020/11/3.png 1000w, /content/images/size/w1600/2020/11/3.png 1600w, /content/images/2020/11/3.png 1891w" sizes="(min-width: 1200px) 1200px"><figcaption>console instance x gparted</figcaption></figure>

Gambar diatas silakan pilih _Dont touch keymap_

<figure class="kg-card kg-image-card kg-width-wide"><img src="/content/images/2020/11/4.png" class="kg-image" alt srcset="/content/images/size/w600/2020/11/4.png 600w, /content/images/2020/11/4.png 858w"></figure>

Gambar diatas pilih Bahasa

<figure class="kg-card kg-image-card kg-width-wide"><img src="/content/images/2020/11/5.png" class="kg-image" alt srcset="/content/images/size/w600/2020/11/5.png 600w, /content/images/size/w1000/2020/11/5.png 1000w, /content/images/2020/11/5.png 1031w"></figure>

Gambar diatas pilih _0_ atau langsung _Enter_ saja, tunggu proses provisioning live CD gparted

<figure class="kg-card kg-image-card kg-width-wide"><img src="/content/images/2020/11/6.png" class="kg-image" alt srcset="/content/images/size/w600/2020/11/6.png 600w, /content/images/size/w1000/2020/11/6.png 1000w, /content/images/2020/11/6.png 1031w"></figure>

Selanjutnya _Open Terminal Live CD_

<figure class="kg-card kg-image-card kg-width-wide"><img src="/content/images/2020/11/7.png" class="kg-image" alt srcset="/content/images/size/w600/2020/11/7.png 600w, /content/images/size/w1000/2020/11/7.png 1000w, /content/images/2020/11/7.png 1030w"></figure>

Kemudian, cek disk menggunakan `fdisk -l` dan silakan `mount root disk` ke direktori `/mnt/` seperti berikut

<figure class="kg-card kg-image-card kg-width-wide"><img src="/content/images/2020/11/8-1.png" class="kg-image" alt srcset="/content/images/size/w600/2020/11/8-1.png 600w, /content/images/size/w1000/2020/11/8-1.png 1000w, /content/images/2020/11/8-1.png 1025w"></figure>

Selanjutnya `chroot /mnt/`

<figure class="kg-card kg-image-card kg-width-wide"><img src="/content/images/2020/11/9.png" class="kg-image" alt srcset="/content/images/size/w600/2020/11/9.png 600w, /content/images/2020/11/9.png 861w"></figure>

Apabila sudah masuk ke `chroot` Anda dapat reset password user atau membuat user baru.

Berikut cara membuat user baru melalui Live CD

<!--kg-card-begin: markdown-->

    root@debian:/# useradd blinux
    root@debian:/# chmod 600 /etc/shadow
    root@debian:/# vi /etc/shadow 

<!--kg-card-end: markdown-->

Pada user `blinux` ubah dari `!` menjadi `*` seperti berikut

<figure class="kg-card kg-image-card kg-width-wide"><img src="/content/images/2020/11/10.png" class="kg-image" alt srcset="/content/images/size/w600/2020/11/10.png 600w, /content/images/2020/11/10.png 776w"></figure>

Silakan simpan dan set password user `blinux` berikut command nya

<!--kg-card-begin: markdown-->

    root@debian:/# passwd blinux
    root@debian:/# Isi_Password

<!--kg-card-end: markdown-->

Selanjutnya konfigurasi password ssh

<!--kg-card-begin: markdown-->

    root@debian:/# vi /etc/ssh/sshd_config

<!--kg-card-end: markdown-->

Cari line `PasswordAuthentication` ubah menjadi `yes`

<figure class="kg-card kg-image-card kg-width-wide"><img src="/content/images/2020/11/11.png" class="kg-image" alt srcset="/content/images/size/w600/2020/11/11.png 600w, /content/images/2020/11/11.png 732w"></figure>

Selanjutnya ubah permission user `blinux` untuk mendapatkan akses root

<!--kg-card-begin: markdown-->

    root@debian:/# visudo

<!--kg-card-end: markdown-->

Tambahkan user `blinux ALL=(ALL) ALL` di bawah root

<figure class="kg-card kg-image-card kg-card-hascaption"><img src="/content/images/2020/11/12.png" class="kg-image" alt srcset="/content/images/size/w600/2020/11/12.png 600w, /content/images/2020/11/12.png 895w" sizes="(min-width: 720px) 720px"><figcaption>konfigurasi visudo</figcaption></figure>

Jika sudah silakan simpan konfigurasi `visudo` diatas. Jika ingin reset password user default misal OS Ubuntu default user `ubuntu` (di openstack), anda hanya perlu menjalankan perintah `passwd ubuntu` .

Setelah dilakukan rescue Anda dapat keluar dari mode rescue dengan cara `unrescue` berikut perintah nya `openstack server unrescue <ID-Instance>` contohnya

<!--kg-card-begin: markdown-->

    [centos@jumpwjv ~]$ openstack server rescue --image df332d85-23b8-4e20-a423-e62adbd57112 e6b3911e-a823-4c65-a4a8-3504030f24af
    [centos@jumpwjv ~]$

<!--kg-card-end: markdown-->

Selanjutnya silakan akses instance menggunakan user baru atau user existing yang sudah di reset password, sebagai contoh disini kami akan coba akses instance menggunakan user baru `blinux`

<figure class="kg-card kg-image-card kg-width-wide"><img src="/content/images/2020/11/13.png" class="kg-image" alt srcset="/content/images/size/w600/2020/11/13.png 600w, /content/images/size/w1000/2020/11/13.png 1000w, /content/images/size/w1600/2020/11/13.png 1600w, /content/images/2020/11/13.png 1919w" sizes="(min-width: 1200px) 1200px"></figure>

Sesuai informasi gambar diatas saat ini instance sudah dapat diakses kembali dengan normal menggunakan user baru `blinux` yang sudah memiliki akses `root`.

Selamat mencoba 😁


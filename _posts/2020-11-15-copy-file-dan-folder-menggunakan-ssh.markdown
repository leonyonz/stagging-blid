---
layout: post
title: 'SSH: Copy File dan Folder Menggunakan SSH'
featured: true
date: '2020-11-15 08:43:14'
tags:
- ssh
- linux
- centos
- ubuntu
---

Pada post ini saya ingin berbagi informasi seputar **Cara Copy File dan Folder Menggunakan SSH.** Untuk tool yang akan digunakan pada post kali ini adalah [SCP](https://en.wikipedia.org/wiki/Secure_copy_protocol) (Secure Copy Protocol) sehingga untuk mengikuti post ini Anda perlu memiliki akses ke terminal ataupun console untuk menjalankannya karena tool ini bersifat CLI.

SCP ini merupakan sarana untuk melakukan penyalinan file dari lokal device ke remote device ataupun server yang menggunakan protokol SSH sebagai media komunikasinya.

Secara default apabila pada device lokal sudah terinstall paket SSH Client maka sudah include dengan paket SCP ini.

**Copy file dari device lokal ke remote server**

Untuk melakukan copy file dari device lokal ke remote server berikut adalah contoh perintah yang digunakan:

<!--kg-card-begin: markdown-->

    $ scp -P22 nama-file user@ip-address:/lokasi/dir/tujuan

<!--kg-card-end: markdown-->

**Copy file dari remote server ke device lokal**

Untuk melakukan copy file dari remote server ke device lokal berikut adalah contoh perintah yang digunakan:

<!--kg-card-begin: markdown-->

    $ scp -P22 user@ip-address:/lokasi/file lokasi/tujuan/

<!--kg-card-end: markdown--><!--kg-card-begin: html--><script async src="https://pagead2.googlesyndication.com/pagead/js/adsbygoogle.js"></script><ins class="adsbygoogle" style="display:block; text-align:center;" data-ad-layout="in-article" data-ad-format="fluid" data-ad-client="ca-pub-1515372853161377" data-ad-slot="1986938311"></ins><script>
     (adsbygoogle = window.adsbygoogle || []).push({});
</script><!--kg-card-end: html-->

**Copy folder dari device lokal ke remote server**

Untuk melakukan copy folder dari device lokal ke remote server berikut adalah contoh perintah yang digunakan:

<!--kg-card-begin: markdown-->

    $ scp -P22 -r /nama-folder user@ipaddress:/lokasi/dir/tujuan

<!--kg-card-end: markdown-->

**Copy Folder dari remote server ke device lokal**

Untuk melakukan copy folder dari remote server ke device lokal berikut adalah contoh perintah yang digunakan:

<!--kg-card-begin: markdown-->

    $ scp -P22 -r user@ip-address:/lokasi/dir /lokasi/dir/tujuan

<!--kg-card-end: markdown-->

**Keterangan**

- `scp`: Tool yang digunakan untuk melakukan copy file menggunakan SSH.
- `-P22`: Flag yang digunakan untuk mendefinisikan port SSH yang digunakan oleh remote server.
- `user`: User yang digunakan oleh remote server.
- `ip-address`: IP address yang digunakan oleh remote server.

Sekian dulu langkah **Cara Copy File dan Folder Menggunakan SSH** , semoga bermanfaat bagi pengunjung blog ini.


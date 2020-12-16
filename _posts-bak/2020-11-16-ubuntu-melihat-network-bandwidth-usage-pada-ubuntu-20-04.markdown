---
layout: post
title: 'Ubuntu: Melihat Penggunaan Network Usage Pada Ubuntu 20.04'
featured: true
date: '2020-11-16 08:18:09'
tags:
- ubuntu
- linux
---

Pada post kali ini, saya ingin berbagi informasi tentang tool yang dapat digunakan untuk **Melihat Penggunaan Network Usage Pada Ubuntu 20.04.**

Tool yang digunakan adalah `bwm-ng` atau Bandwidth Monitoring NG, tool ini bisa kita gunakan untuk melihat penggunaan network pada spesifik interface dan untuk ukuran paketnya pun tidak terlalu besar.

**Update repository Ubuntu**

Sebelum memulai instalasi paket, silakan untuk melakukan update repositry ubuntu dengan perintah berikut ini:

<!--kg-card-begin: markdown-->

    $ sudo apt update

<!--kg-card-end: markdown--><figure class="kg-card kg-image-card"><img src="/content/images/2020/11/image-21.png" class="kg-image" alt></figure>

**Instalasi paket bwm-ng**

Selanjutnya apabila repository telah update, instalasi paket `bwm-ng` sudah dapat dilakukan berikut perintahnya:

<!--kg-card-begin: markdown-->

    $ sudo apt install bwm-ng

<!--kg-card-end: markdown--><figure class="kg-card kg-image-card"><img src="/content/images/2020/11/image-22.png" class="kg-image" alt srcset="/content/images/size/w600/2020/11/image-22.png 600w, /content/images/2020/11/image-22.png 654w"></figure>

**Penggunaan**

Untuk penggunaannya, cukup dijalankan baris perintah `bwm-ng` saja dan kalian langsung dapat melihat penggunaan bandwidth interface network server secara live.

<figure class="kg-card kg-image-card"><img src="/content/images/2020/11/image-23.png" class="kg-image" alt srcset="/content/images/size/w600/2020/11/image-23.png 600w, /content/images/2020/11/image-23.png 630w"></figure>

**Selesai**

Sekian dulu langkah **Melihat Penggunaan Network Usage Pada Ubuntu 20.04** , semoga bermanfaat bagi pengunjung blog ini.


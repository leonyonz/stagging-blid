---
layout: post
title: 'SSH: Tunneling Menggunakan SSH'
date: '2020-11-07 05:43:00'
tags:
- ssh
- linux
- ubuntu
- centos
---

Post kali ini saya ingin berbagi tentang **Tunneling Menggunakan SSH,** biasanya tunneling SSH ini digunakan apabila kita ingin mencoba melihat hasil aplikasi yang berjalan pada spesifik port yang tidak dapat diakses secara langsung dari device lokal kita.

Contoh casenya, semisal terdapat aplikasi web yang berjalan pada port misal : `1010` dan dari sisi server tidak memiliki ip publik, dan port tidak ter-ekspose ataupun dari sisi device lokal tidak dapat menggapai network dari server, namun dari sisi device lokal perlu dapat mengakses aplikasi yang berjalan pada port `1010` tersebut pada network lokal.

Untuk mengakali hal tersebut, kita dapat menggunakan fitur **SSH** yaitu tunneling, konsep dari tunneling ini seperti port forwarding yang mana melakukan penerusan port dari sisi server ke spesifik port di device lokal.

Berikut contoh commandnya :

<!--kg-card-begin: markdown-->

    ssh -L local_port:localhost:remote_port user@ip-server

Contoh

    ssh -L 1123:localhost:1010 user@ip-server

<!--kg-card-end: markdown--><!--kg-card-begin: markdown-->

**Penjelasan**

- `1123:localhost:1010`: Melakukan forward port `1010` pada sisi server ke port `1123` pada sisi device lokal.
- `user@ip-server`: Merupakan user dan IP dari server yang akan diremote menggunakan SSH
<!--kg-card-end: markdown-->

Kalian bisa menyesuaikan untuk baris perintah diatas sesuai dengan kebutuhan kalian.

Sekian dulu sharing kali ini, sampai jumpa pada sharing berikutnya.


---
layout: post
title: 'PMG: Mengenal Apa itu Proxmox Mail Gateway'
featured: true
date: '2020-12-03 21:07:42'
tags:
- proxmox-mail-gateway
---

[Belajar Linux ID](/) - PMG singkatan dari _Proxmox Mail Gateway,_ salah satu produk dari **[Proxmox Server Solutions GmbH](https://www.proxmox.com)**.

Proxmox Mail Gateway merupakan solusi keamanan email sumber terbuka (open source) terkemuka yang dapat membantu Anda melindungi server email Anda dari semua ancaman email. Arsitektur yang fleksibel dikombinasikan dengan antarmuka manajemen berbasis web yang ramah pengguna, memungkinkan para profesional IT untuk mengontrol semua email masuk (incoming) dan keluar (outgoing) dengan mudah, dan untuk melindungi pengguna (user) dari berbagai macam serangan seperti spam, virus, phishing, dan trojan.

<!--kg-card-begin: html--><script async src="https://pagead2.googlesyndication.com/pagead/js/adsbygoogle.js"></script><ins class="adsbygoogle" style="display:block; text-align:center;" data-ad-layout="in-article" data-ad-format="fluid" data-ad-client="ca-pub-1515372853161377" data-ad-slot="1986938311"></ins><script>
     (adsbygoogle = window.adsbygoogle || []).push({});
</script><!--kg-card-end: html-->

Dari segi bisnis Proxmox Mail Gateway ini sangat cocok digunakan bagi korporasi dari level kecil, menengah sampai atas.

## Fitur Proxmox Mail Gateway

Banyak fitur yang dapat Anda manfaatkan apabila menggunakan Proxmox Mail Gateway, diantaranya sebagai berikut:

##### Anti Spam / Virus

- Spam & Virus Detection
- Virus Scanning
- Spam Detection

#### Metode Filtering

Proxmox mail gateway memiliki banyak metode yang dapat digunakan dalam melakukan filtering email diantaranya:

- Receiver Verification
- Sender policy famework (SPF)
- DNS-based Blackhole List
- SMTP Whitelist
- Bayesian Filter - Automatically trained statistical filters
- Black- and Whitelist
- Spam Uri Realtime BlockList (SURBL)
- Greylisting 
<!--kg-card-begin: html--><script async src="https://pagead2.googlesyndication.com/pagead/js/adsbygoogle.js"></script><ins class="adsbygoogle" style="display:block; text-align:center;" data-ad-layout="in-article" data-ad-format="fluid" data-ad-client="ca-pub-1515372853161377" data-ad-slot="1986938311"></ins><script>
     (adsbygoogle = window.adsbygoogle || []).push({});
</script><!--kg-card-end: html-->
#### Tracking & Logs

Yaa, fitur tracking ini sangatlah berguna untuk melihat history dari aktivitas email tentunya, selain itu Anda juga dapat melihat logs dari aktivitas email dengan mudah melalui dashboard proxmox mail gateway.

#### HA Cluster

Salah satu alasan proxmox mail gateway ini cocok digunakan oleh korporasi level kecil - tinggi karena proxmox mail gateway sudah dapat diterapkan _High Availability (HA) Cluster._

Proxmox HA Cluster sendiri terdiri dari master dan beberapa node (minimal satu node) artinya jika ingin menggunakan HA Cluster minimal terdapat 2 server (1 master 1 node) dan semua konfigurasi dilakukan di sisi master karena server node akan join ke master dan akan tersinkronisasi antara master dengan node secara realtime.

Benefit menggunakan Proxmox HA Cluster:

- Manajemen konfigurasi terpusat
- Penyimpanan data yang sepenuhnya redundan
- Ketersediaan tinggi
- Performa tinggi
- Skema pengelompokan tingkat aplikasi yang unik
- Penyiapan cluster selesai dalam beberapa menit saja
- Node secara otomatis diintegrasikan kembali setelah kegagalan sementara - tanpa interaksi operator apa pun.

Selain itu Anda juga dapat menerapkan MX secara load balancing cluster di proxmox mail gateway. Untuk menggunakan load balancer MX minimal ada 2 server proxmox mail gateway yang memiliki IP sendiri dan MX sendiri, dengan menggunakan LB ini Anda nantinya dapat menentukan algoritma LB yang ingin digunakan bisa RR (Round robin).

#### Rule System

Di Proxmox mail gateway Anda dapat membuat sebuah rule atau aturan sesuai keinginan Anda bisa dibilang custome rule. Rulenya sendiri bersifat &nbsp;object oriented.

Berikut beberapa rule yang dapat Anda gunakan:

- ACTIONS -object: Digunakan untuk mendefinisikan apa yang harus terjadi dengan email
- WHO: -object: Siapa pengirim atau penerima email
- WHAT -object: Apa yang ada di email
- WHEN -object: Kapan email akan diterima oleh Proxmox mail gateway

Setiap aturan (rule) memiliki 5 kategori diantaranya kategori (FROM, TO, WHEN, WHAT dan ACTIOn. Masing - masing kategori ini dapat berisi beberapa objek misal untuk in, out atau keduanya.

<!--kg-card-begin: html--><script async src="https://pagead2.googlesyndication.com/pagead/js/adsbygoogle.js"></script><ins class="adsbygoogle" style="display:block; text-align:center;" data-ad-layout="in-article" data-ad-format="fluid" data-ad-client="ca-pub-1515372853161377" data-ad-slot="4684565489"></ins><script>
     (adsbygoogle = window.adsbygoogle || []).push({});
</script><!--kg-card-end: html-->
## Infrastruktur Proxmox Mail Gateway

Berikut contoh topologi dari infrastruktur mail gateway

<figure class="kg-card kg-image-card"><img src="/content/images/2020/12/image.png" class="kg-image" alt srcset="/content/images/size/w600/2020/12/image.png 600w, /content/images/2020/12/image.png 887w" sizes="(min-width: 720px) 720px"></figure>
## Pemrosesan Trafik Proxmox Mail Gateway

Berikut ini merupakan sebuah pemrosesan dari trafik incoming email bila menggunakan proxmox mail gateway

<figure class="kg-card kg-image-card"><img src="/content/images/2020/12/image-1.png" class="kg-image" alt srcset="/content/images/size/w600/2020/12/image-1.png 600w, /content/images/size/w1000/2020/12/image-1.png 1000w, /content/images/2020/12/image-1.png 1077w" sizes="(min-width: 720px) 720px"></figure>
## Konsep HA Proxmox Mail Gateway

Berikut merupakan contoh topologi dari implementasi HA di Proxmox mail gateway

<figure class="kg-card kg-image-card"><img src="/content/images/2020/12/image-2.png" class="kg-image" alt srcset="/content/images/size/w600/2020/12/image-2.png 600w, /content/images/size/w1000/2020/12/image-2.png 1000w, /content/images/2020/12/image-2.png 1076w" sizes="(min-width: 720px) 720px"></figure>

Bagi Anda yang ingin melihat **Roadmap** dari Proxmox Mail Gateway dapat merujuk pada link berikut: **[Roadmap PMG](https://pmg.proxmox.com/wiki/index.php/Roadmap)**

Selamat mencoba 😁


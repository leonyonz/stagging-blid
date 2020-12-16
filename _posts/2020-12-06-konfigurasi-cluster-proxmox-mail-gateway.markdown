---
layout: post
title: 'PMG: Konfigurasi Cluster Proxmox Mail Gateway'
featured: true
date: '2020-12-06 02:02:58'
tags:
- proxmox-mail-gateway
---

[Belajar Linux ID](/) - Pada penjelasan sebelumnya mengenai pengenalan proxmox mail gateway terdapat fitur `cluster` yang dapat Anda gunakan dan diimplementasikan untuk detailnya dapat merujuk pada link berikut: [Mengenal Apa itu Proxmox Mail Gateway](/mengenal-proxmox-mail-gateway/).

Pada tutorial ini tidak dibahas kembali pengertian dari cluster karena untuk pengertian dan fungsinya sudah dibahas pada link diatas, dengan demikian tutorial kali ini lebih ke arah teknikal atau cara membuat cluster nya.

<!--kg-card-begin: html--><script async src="https://pagead2.googlesyndication.com/pagead/js/adsbygoogle.js"></script><ins class="adsbygoogle" style="display:block; text-align:center;" data-ad-layout="in-article" data-ad-format="fluid" data-ad-client="ca-pub-1515372853161377" data-ad-slot="1986938311"></ins><script>
     (adsbygoogle = window.adsbygoogle || []).push({});
</script><!--kg-card-end: html-->

Untuk membuat cluster di proxmox mail gateway minimal terdapat 2 server proxmox mail gateway dimana 1 server digunakan sebagai `master` dan 1 server digunakan sebagai `node`, server `node` akan terhubung ke server `master` secara otomatis dan semua konfigurasi yang ada di server `master` akan terduplikasi ke server `node` bisa dibilang data antara server `master` dan `node` sama.

Disini kami sudah mempunyai 2 server proxmox mail gateway dengan detail sebagai berikut:

1. pmg.nurhamim.my.id:8006 \>\> IP: 20.20.20.104 \>\> Digunakan untuk master
2. pmg1.nurhamim.my.id:8006 \>\> IP: 20.20.20.105 \>\> Digunakan untuk node

### Membuat Cluster di Server Master Proxmox Mail Gateway

Untuk membuat cluster di proxmox mail gateway sangat mudah, silahkan klik menu _Cluster \>\> Create_

<figure class="kg-card kg-image-card"><img src="/content/images/2020/12/1-4.png" class="kg-image" alt srcset="/content/images/size/w600/2020/12/1-4.png 600w, /content/images/2020/12/1-4.png 966w" sizes="(min-width: 720px) 720px"></figure>

Proses pembuatan cluster

<figure class="kg-card kg-image-card"><img src="/content/images/2020/12/2-4.png" class="kg-image" alt srcset="/content/images/size/w600/2020/12/2-4.png 600w, /content/images/size/w1000/2020/12/2-4.png 1000w, /content/images/size/w1600/2020/12/2-4.png 1600w, /content/images/2020/12/2-4.png 1914w" sizes="(min-width: 720px) 720px"></figure>

Klik master

<figure class="kg-card kg-image-card"><img src="/content/images/2020/12/3-2.png" class="kg-image" alt srcset="/content/images/size/w600/2020/12/3-2.png 600w, /content/images/size/w1000/2020/12/3-2.png 1000w, /content/images/2020/12/3-2.png 1443w" sizes="(min-width: 720px) 720px"></figure>

Selanjutnya Anda akan mendapatkan detail informasi dari master proxmox mail gateway, seperti berikut

<figure class="kg-card kg-image-card"><img src="/content/images/2020/12/4-2.png" class="kg-image" alt srcset="/content/images/size/w600/2020/12/4-2.png 600w, /content/images/size/w1000/2020/12/4-2.png 1000w, /content/images/size/w1600/2020/12/4-2.png 1600w, /content/images/2020/12/4-2.png 1919w" sizes="(min-width: 720px) 720px"></figure>

_Noted: Silahkan di catat fingerprint dan ip address master_

### Menghubungkan Node ke Master 
<!--kg-card-begin: html--><script async src="https://pagead2.googlesyndication.com/pagead/js/adsbygoogle.js"></script><ins class="adsbygoogle" style="display:block; text-align:center;" data-ad-layout="in-article" data-ad-format="fluid" data-ad-client="ca-pub-1515372853161377" data-ad-slot="1986938311"></ins><script>
     (adsbygoogle = window.adsbygoogle || []).push({});
</script><!--kg-card-end: html-->

Untuk menghubungkan `node` ke `master` silakan login ke proxmox mail gateway `node` pada menu _Cluster \>\> Join_

<figure class="kg-card kg-image-card"><img src="/content/images/2020/12/5-2.png" class="kg-image" alt srcset="/content/images/size/w600/2020/12/5-2.png 600w, /content/images/size/w1000/2020/12/5-2.png 1000w, /content/images/size/w1600/2020/12/5-2.png 1600w, /content/images/2020/12/5-2.png 1912w" sizes="(min-width: 720px) 720px"></figure>

Isikan informasi IP, Password dan fingerprint dari server `master`, lalu klik **OK** seperti berikut

<figure class="kg-card kg-image-card"><img src="/content/images/2020/12/6-3.png" class="kg-image" alt srcset="/content/images/size/w600/2020/12/6-3.png 600w, /content/images/size/w1000/2020/12/6-3.png 1000w, /content/images/size/w1600/2020/12/6-3.png 1600w, /content/images/2020/12/6-3.png 1915w" sizes="(min-width: 720px) 720px"></figure>

Jika sudah Anda akan melihat proses `sync` antara server `master` dengan `node`

<figure class="kg-card kg-image-card"><img src="/content/images/2020/12/8-2.png" class="kg-image" alt srcset="/content/images/size/w600/2020/12/8-2.png 600w, /content/images/size/w1000/2020/12/8-2.png 1000w, /content/images/2020/12/8-2.png 1455w" sizes="(min-width: 720px) 720px"></figure>

Disisi server `master`

<figure class="kg-card kg-image-card"><img src="/content/images/2020/12/9-1.png" class="kg-image" alt srcset="/content/images/size/w600/2020/12/9-1.png 600w, /content/images/size/w1000/2020/12/9-1.png 1000w, /content/images/2020/12/9-1.png 1439w" sizes="(min-width: 720px) 720px"></figure>

Cek proses sinkronisasi melalui CLI proxmox mail gateway

- Master proxmox mail gateway 
<figure class="kg-card kg-image-card"><img src="/content/images/2020/12/10-1.png" class="kg-image" alt srcset="/content/images/size/w600/2020/12/10-1.png 600w, /content/images/2020/12/10-1.png 797w" sizes="(min-width: 720px) 720px"></figure>
- Node proxmox mail gateway
<figure class="kg-card kg-image-card"><img src="/content/images/2020/12/11-1.png" class="kg-image" alt srcset="/content/images/size/w600/2020/12/11-1.png 600w, /content/images/2020/12/11-1.png 868w" sizes="(min-width: 720px) 720px"></figure>

Apabila proses sinkronisasi sudah selesai status nya akan menjadi aktif baik disisi `master` atau `node` contoh terlampir

<figure class="kg-card kg-image-card"><img src="/content/images/2020/12/12-1.png" class="kg-image" alt srcset="/content/images/size/w600/2020/12/12-1.png 600w, /content/images/size/w1000/2020/12/12-1.png 1000w, /content/images/size/w1600/2020/12/12-1.png 1600w, /content/images/2020/12/12-1.png 1654w" sizes="(min-width: 720px) 720px"></figure>

Sampai disini konfigurasi `clustering` di proxmox mail gateway sudah berhasil dilakukan.

Selamat mencoba 😁


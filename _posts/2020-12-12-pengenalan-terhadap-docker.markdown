---
layout: post
title: 'Docker: Pengenalan Terhadap Docker'
featured: true
date: '2020-12-12 08:03:38'
tags:
- ubuntu
- docker
- linux
---

 **Docker** adalah salah satu platform yang dibangun berdasarkan teknologi container. Docker merupakan sebuah project open-source yang menyediakan platform terbuka untuk developer maupun sysadmin untuk dapat membangun, mengemas, dan menjalankan aplikasi dimanapun sebagai sebuah wadah (container) yang ringan. Dengan sangat populernya docker, sebagian orang sering menganggap Docker adalah sebutan lain untuk container.

<!--kg-card-begin: html--><script async src="https://pagead2.googlesyndication.com/pagead/js/adsbygoogle.js"></script><ins class="adsbygoogle" style="display:block; text-align:center;" data-ad-layout="in-article" data-ad-format="fluid" data-ad-client="ca-pub-1515372853161377" data-ad-slot="1986938311"></ins><script>
     (adsbygoogle = window.adsbygoogle || []).push({});
</script><!--kg-card-end: html-->

Dikutip dari situs resmi docker, pengembang dapat mengefektifkan waktu mereka dengan menghilangkan proses konfigurasi yang cocok dengan programnya. Selain itu, berkat fitur sandbox, pengembang leluasa untuk berkreasi tanpa takut merusak programnya. Terakhir docker menjamin program yang kita buat, akan selamanya berjalan seperti seharusnya. Pemaketan aplikasi dan seluruh kebutuhannya, memastikan aplikasi berjalan lancer pada kondisi lingkungan apapun.

**Aristektur Docker**

Docker menggunakan arsitektur klien-server. Klien Docker berbicara dengan daemon Docker, yang melakukan pekerjaan berat membangun, menjalankan, dan mendistribusikan kontainer Docker Anda. Klien dan daemon Docker dapat berjalan di sistem yang sama, atau Anda dapat menghubungkan klien Docker ke daemon Docker jarak jauh. Klien Docker dan daemon berkomunikasi menggunakan REST API, melalui soket UNIX atau antarmuka jaringan.

<figure class="kg-card kg-image-card"><img src="/content/images/2020/12/image-10.png" class="kg-image" alt srcset="/content/images/size/w600/2020/12/image-10.png 600w, /content/images/size/w1000/2020/12/image-10.png 1000w, /content/images/2020/12/image-10.png 1034w" sizes="(min-width: 720px) 720px"></figure>

**Docker Client**

Docker Client adalah adalah sebuah command line / baris perintah yang  
digunakan untuk mengeksekusi service dari docker host.

**Docker Host**

Docker Host mesin yang menjalankan service dari docker. Host tidak dapat  
berhubungan langsung ke daemon karena harus melalui docker client untuk saling  
berinteraksi.

**Docker Registry**

Docker Registry adalah wadah penyimpanan image yang sudah dibuat pada  
docker host.

**Sekian !**

Sekian dulu posting kali ini, selanjutnya kita akan belajar tentang cara Instalasi Docker pada Virtual Mesin.

**Referensi**

[https://docs.docker.com/get-started/overview/](https://docs.docker.com/get-started/overview/)


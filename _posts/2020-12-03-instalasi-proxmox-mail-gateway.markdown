---
layout: post
title: 'PMG: Instalasi Proxmox Mail Gateway'
date: '2020-12-03 21:43:10'
tags:
- proxmox-mail-gateway
---

[Belajar Linux ID](/) - Pada tutorial kali ini kami akan menjelaskan bagaimana cara melakukan instalasi Proxmox Mail Gateway.

Sebelum mengikuti panduan ini ada baiknya Anda membaca terlebih dahulu fungsi dan kegunaan dari Proxmox Mail Gateway pada link berikut: [Mengenal Apa itu Proxmox Mail Gateway](/mengenal-proxmox-mail-gateway/).

Kemudian, pastikan environment Anda sudah memenuhi requirements dari proxmox mail gateway yang dapat Anda lihat detailnya pada link berikut: [System Requirements](https://www.proxmox.com/en/proxmox-mail-gateway/requirements).

<!--kg-card-begin: html--><script async src="https://pagead2.googlesyndication.com/pagead/js/adsbygoogle.js"></script><ins class="adsbygoogle" style="display:block; text-align:center;" data-ad-layout="in-article" data-ad-format="fluid" data-ad-client="ca-pub-1515372853161377" data-ad-slot="1986938311"></ins><script>
     (adsbygoogle = window.adsbygoogle || []).push({});
</script><!--kg-card-end: html-->

Untuk melakukan instalasi proxmox mail gateway sendiri dapat dilakukan menggunakan beberapa metode, bisa install proxmox mail gateway menggunakan ISO yang dapat Anda unduh melalui link berikut: [ISO Image PMG](https://www.proxmox.com/en/downloads/category/iso-images-pmg) atau Anda dapat install proxmox mail gateway under sistem operasi Debian.

Tutorial kali ini kami akan menggunakan ISO, berikut detailnya:

Langkah yang paling utama silakan sesuaikan dengan kondisi server Anda, jika Anda menggunakan server colocation Anda dapat boot ISO proxmox mail gateway menjadi bootable bisa DVD/flasdisk. Jika Anda install proxmox mail gateway di provider Cloud silakan upload ISO dan silakan booting instance menggunakan ISO proxmox mail gateway, berikut tampilan awal dari proxmox mail gateway.

<figure class="kg-card kg-image-card"><img src="/content/images/2020/12/1.png" class="kg-image" alt srcset="/content/images/size/w600/2020/12/1.png 600w, /content/images/size/w1000/2020/12/1.png 1000w, /content/images/2020/12/1.png 1284w" sizes="(min-width: 720px) 720px"></figure>

Pada gambar diatas silakan pilih _Install Proxmox Mail Gateway \>\> Enter,_ dan akan nampak seperti gambar dibawah ini, silakan tunggu beberapa saat.

<figure class="kg-card kg-image-card"><img src="/content/images/2020/12/2.png" class="kg-image" alt srcset="/content/images/size/w600/2020/12/2.png 600w, /content/images/size/w1000/2020/12/2.png 1000w, /content/images/2020/12/2.png 1069w" sizes="(min-width: 720px) 720px"></figure>

Kemudian, Anda akan diminta untuk menjawab agreement license, silakan klik _I agree_ untuk melanjutkannya

<figure class="kg-card kg-image-card"><img src="/content/images/2020/12/3.png" class="kg-image" alt srcset="/content/images/size/w600/2020/12/3.png 600w, /content/images/size/w1000/2020/12/3.png 1000w, /content/images/2020/12/3.png 1077w" sizes="(min-width: 720px) 720px"></figure>

Pilih &nbsp;disk yang akan digunakan kemudian _Next_

<!--kg-card-begin: html--><script async src="https://pagead2.googlesyndication.com/pagead/js/adsbygoogle.js"></script><ins class="adsbygoogle" style="display:block; text-align:center;" data-ad-layout="in-article" data-ad-format="fluid" data-ad-client="ca-pub-1515372853161377" data-ad-slot="1986938311"></ins><script>
     (adsbygoogle = window.adsbygoogle || []).push({});
</script><!--kg-card-end: html--><figure class="kg-card kg-image-card"><img src="/content/images/2020/12/4.png" class="kg-image" alt srcset="/content/images/size/w600/2020/12/4.png 600w, /content/images/size/w1000/2020/12/4.png 1000w, /content/images/2020/12/4.png 1076w" sizes="(min-width: 720px) 720px"></figure>

Pilih negara dimana Anda berada dan mengatur waktu atau time zone, kemudian _Next_

<figure class="kg-card kg-image-card"><img src="/content/images/2020/12/5.png" class="kg-image" alt srcset="/content/images/size/w600/2020/12/5.png 600w, /content/images/size/w1000/2020/12/5.png 1000w, /content/images/2020/12/5.png 1066w" sizes="(min-width: 720px) 720px"></figure>

Kemudian, silakan set up password, password ini yang akan digunakan Anda untuk login ke server proxmox mail gateway nantinya

<figure class="kg-card kg-image-card"><img src="/content/images/2020/12/6-1.png" class="kg-image" alt srcset="/content/images/size/w600/2020/12/6-1.png 600w, /content/images/size/w1000/2020/12/6-1.png 1000w, /content/images/2020/12/6-1.png 1067w" sizes="(min-width: 720px) 720px"></figure>

Selanjutnya silakan setup hostname server proxmox mail gateway pastikan Anda menggunakan hostname yang FQDN _(Full Qualified Domain Name Server)_ dan silakan setup IP Address, Netmask, Gateway, serta DNS Server yang digunakan

<!--kg-card-begin: html--><script async src="https://pagead2.googlesyndication.com/pagead/js/adsbygoogle.js"></script><ins class="adsbygoogle" style="display:block; text-align:center;" data-ad-layout="in-article" data-ad-format="fluid" data-ad-client="ca-pub-1515372853161377" data-ad-slot="4684565489"></ins><script>
     (adsbygoogle = window.adsbygoogle || []).push({});
</script><!--kg-card-end: html--><figure class="kg-card kg-image-card"><img src="/content/images/2020/12/7.png" class="kg-image" alt srcset="/content/images/size/w600/2020/12/7.png 600w, /content/images/size/w1000/2020/12/7.png 1000w, /content/images/2020/12/7.png 1073w" sizes="(min-width: 720px) 720px"></figure>

Informasi detail server proxmox atau overview sebelum proses instalasi proxmox mail gateway

<figure class="kg-card kg-image-card"><img src="/content/images/2020/12/8.png" class="kg-image" alt srcset="/content/images/size/w600/2020/12/8.png 600w, /content/images/size/w1000/2020/12/8.png 1000w, /content/images/2020/12/8.png 1073w" sizes="(min-width: 720px) 720px"></figure>

Klik _Install_ pada gambar diatas untuk melakukan proses instalasi proxmox mail gateway

<figure class="kg-card kg-image-card"><img src="/content/images/2020/12/9.png" class="kg-image" alt srcset="/content/images/size/w600/2020/12/9.png 600w, /content/images/size/w1000/2020/12/9.png 1000w, /content/images/2020/12/9.png 1069w" sizes="(min-width: 720px) 720px"></figure>

Silakan tunggu proses instalasi sampai selesai, proses ini membutuhkan waktu, apabila sudah selesai akan nampak informasi URL yang dapat Anda gunakan untuk login ke proxmox mail gateway

<!--kg-card-begin: html--><script async src="https://pagead2.googlesyndication.com/pagead/js/adsbygoogle.js"></script><ins class="adsbygoogle" style="display:block; text-align:center;" data-ad-layout="in-article" data-ad-format="fluid" data-ad-client="ca-pub-1515372853161377" data-ad-slot="4684565489"></ins><script>
     (adsbygoogle = window.adsbygoogle || []).push({});
</script><!--kg-card-end: html--><figure class="kg-card kg-image-card"><img src="/content/images/2020/12/10.png" class="kg-image" alt srcset="/content/images/size/w600/2020/12/10.png 600w, /content/images/size/w1000/2020/12/10.png 1000w, /content/images/2020/12/10.png 1072w" sizes="(min-width: 720px) 720px"></figure>

Setelah itu silakan klik _Reboot,_ selanjutnya silakan dicoba login ke server proxmox mail gateway via SSH dan pastikan server dapat beroperasi dengan benar

<figure class="kg-card kg-image-card"><img src="/content/images/2020/12/11.png" class="kg-image" alt srcset="/content/images/size/w600/2020/12/11.png 600w, /content/images/size/w1000/2020/12/11.png 1000w, /content/images/2020/12/11.png 1065w" sizes="(min-width: 720px) 720px"></figure>

Untuk login ke dashboard proxmox mail gateway melalui web browser silakan akses IP atau domain dengan port `8006` seperti berikut ini

<figure class="kg-card kg-image-card"><img src="/content/images/2020/12/12.png" class="kg-image" alt srcset="/content/images/size/w600/2020/12/12.png 600w, /content/images/size/w1000/2020/12/12.png 1000w, /content/images/2020/12/12.png 1361w" sizes="(min-width: 720px) 720px"></figure>

Isikan username dan password yang telah Anda tentukan sebelumnya, apabila berhasil akan nampak dashboard dari proxmox mail gateway seperti berikut

<figure class="kg-card kg-image-card"><img src="/content/images/2020/12/13.png" class="kg-image" alt srcset="/content/images/size/w600/2020/12/13.png 600w, /content/images/size/w1000/2020/12/13.png 1000w, /content/images/size/w1600/2020/12/13.png 1600w, /content/images/2020/12/13.png 1920w" sizes="(min-width: 720px) 720px"></figure>

Sampai disini Anda sudah berhasil melakukan instalasi proxmox mail gateway.

Selamat mencoba 😁


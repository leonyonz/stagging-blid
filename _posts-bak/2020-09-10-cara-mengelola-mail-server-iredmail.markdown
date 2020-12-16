---
layout: post
title: Cara Mengelola Mail Server iRedMail
featured: true
date: '2020-09-10 07:59:54'
tags:
- centos
- mail-server
---

Tutorial kali ini salah satu lanjutan dari tutorial kami sebelumnya mengenai mail server berikut:  
  
_**1. [Membuat Mail Server Menggunakan iRedMail di CentOS 8](/membuat-mail-server-menggunakan-iredmail-di-centos-8/)  
2. [Cara Install SSL Let’s Encrypt di iRedMail](/cara-install-ssl-lets-encrypt-di-iredmail/)  
3. [Enable SMTPS service (SMTP over SSL) di iRedMail](/enable-smtps-service-smtp-over-ssl-di-iredmail/)  
4. [Menambahkan DNS Record Mail Server iRedMail](/menambahkan-dns-record-mail-server-iredmail/)**_

Dimana pada tutorial kali ini akan dibahas bagaimana cara pengelolaan mail server di iRedMail sepertihalnya penambahan user, alokasi size user, menentukan user administrator dan bagaimana cara melihat monitoring netdata yang telah tersedia secara default di iRedMail.

Silakan login ke masing – masing Administrator iRedMail Anda

<figure class="wp-block-image size-large"><img loading="lazy" width="1024" height="378" src="/content/images/wordpress/2020/09/image-26-1024x378.png" alt="" class="wp-image-554" srcset="/content/images/wordpress/2020/09/image-26-1024x378.png 1024w, /content/images/wordpress/2020/09/image-26-300x111.png 300w, /content/images/wordpress/2020/09/image-26-768x284.png 768w, /content/images/wordpress/2020/09/image-26.png 1359w" sizes="(max-width: 1024px) 100vw, 1024px"></figure>

Berikut tampilan dashboard Administrator iRedMail

<figure class="wp-block-image size-large"><img loading="lazy" width="1024" height="423" src="/content/images/wordpress/2020/09/image-27-1024x423.png" alt="" class="wp-image-555" srcset="/content/images/wordpress/2020/09/image-27-1024x423.png 1024w, /content/images/wordpress/2020/09/image-27-300x124.png 300w, /content/images/wordpress/2020/09/image-27-768x317.png 768w, /content/images/wordpress/2020/09/image-27.png 1322w" sizes="(max-width: 1024px) 100vw, 1024px"></figure>

Untuk menambahkan user baru klik menu _+ Add \>\> User_

<figure class="wp-block-image size-large"><img loading="lazy" width="802" height="295" src="/content/images/wordpress/2020/09/image-28.png" alt="" class="wp-image-556" srcset="/content/images/wordpress/2020/09/image-28.png 802w, /content/images/wordpress/2020/09/image-28-300x110.png 300w, /content/images/wordpress/2020/09/image-28-768x282.png 768w" sizes="(max-width: 802px) 100vw, 802px"></figure>

Isi detail informasi user baru dan tentukan storage user baru contohnya

<figure class="wp-block-image size-large"><img loading="lazy" width="1024" height="446" src="/content/images/wordpress/2020/09/image-29-1024x446.png" alt="" class="wp-image-557" srcset="/content/images/wordpress/2020/09/image-29-1024x446.png 1024w, /content/images/wordpress/2020/09/image-29-300x131.png 300w, /content/images/wordpress/2020/09/image-29-768x335.png 768w, /content/images/wordpress/2020/09/image-29.png 1069w" sizes="(max-width: 1024px) 100vw, 1024px"></figure>

Klik _Add_ untuk menambahkan user baru

<figure class="wp-block-image size-large"><img loading="lazy" width="1024" height="481" src="/content/images/wordpress/2020/09/image-30-1024x481.png" alt="" class="wp-image-558" srcset="/content/images/wordpress/2020/09/image-30-1024x481.png 1024w, /content/images/wordpress/2020/09/image-30-300x141.png 300w, /content/images/wordpress/2020/09/image-30-768x360.png 768w, /content/images/wordpress/2020/09/image-30.png 1057w" sizes="(max-width: 1024px) 100vw, 1024px"></figure>

Untuk set user menjadi admin centang pada _Global admin_

<figure class="wp-block-image size-large"><img loading="lazy" width="1024" height="347" src="/content/images/wordpress/2020/09/image-35.png" alt="" class="wp-image-563" srcset="/content/images/wordpress/2020/09/image-35.png 1024w, /content/images/wordpress/2020/09/image-35-300x102.png 300w, /content/images/wordpress/2020/09/image-35-768x260.png 768w" sizes="(max-width: 1024px) 100vw, 1024px"></figure>

Untuk set kuota mailbox menjadi 2 GB misalnya, Anda hanya perlu ubah pada menu _Mailbox Quota_ misalnya 2GB lalu _Save changes_

<figure class="wp-block-image size-large"><img loading="lazy" width="1024" height="413" src="/content/images/wordpress/2020/09/image-36-1024x413.png" alt="" class="wp-image-564" srcset="/content/images/wordpress/2020/09/image-36-1024x413.png 1024w, /content/images/wordpress/2020/09/image-36-300x121.png 300w, /content/images/wordpress/2020/09/image-36-768x310.png 768w, /content/images/wordpress/2020/09/image-36.png 1031w" sizes="(max-width: 1024px) 100vw, 1024px"></figure>

Jika ingin melihat list user yang telah dibuat klik menu _Domains and Accounts_

<figure class="wp-block-image size-large"><img loading="lazy" width="1024" height="322" src="/content/images/wordpress/2020/09/image-37-1024x322.png" alt="" class="wp-image-565" srcset="/content/images/wordpress/2020/09/image-37-1024x322.png 1024w, /content/images/wordpress/2020/09/image-37-300x94.png 300w, /content/images/wordpress/2020/09/image-37-768x242.png 768w, /content/images/wordpress/2020/09/image-37.png 1032w" sizes="(max-width: 1024px) 100vw, 1024px"></figure>

Jika ingin melihat user yang mempunyai privileges Admin klik menu _Admins_

<figure class="wp-block-image size-large"><img loading="lazy" width="1024" height="260" src="/content/images/wordpress/2020/09/image-38-1024x260.png" alt="" class="wp-image-566" srcset="/content/images/wordpress/2020/09/image-38-1024x260.png 1024w, /content/images/wordpress/2020/09/image-38-300x76.png 300w, /content/images/wordpress/2020/09/image-38-768x195.png 768w, /content/images/wordpress/2020/09/image-38.png 1039w" sizes="(max-width: 1024px) 100vw, 1024px"></figure>

Untuk melihat log klik menu _System \>\> Admin Log_

<figure class="wp-block-image size-large"><img loading="lazy" width="1024" height="242" src="/content/images/wordpress/2020/09/image-39-1024x242.png" alt="" class="wp-image-567" srcset="/content/images/wordpress/2020/09/image-39-1024x242.png 1024w, /content/images/wordpress/2020/09/image-39-300x71.png 300w, /content/images/wordpress/2020/09/image-39-768x181.png 768w, /content/images/wordpress/2020/09/image-39.png 1037w" sizes="(max-width: 1024px) 100vw, 1024px"></figure>

User sudah berhasil dibuat, sekarang kita coba login ke sisi webmail user

- Menggunakan Roundcube
<figure class="wp-block-image size-large"><img loading="lazy" width="1024" height="363" src="/content/images/wordpress/2020/09/image-31-1024x363.png" alt="" class="wp-image-559" srcset="/content/images/wordpress/2020/09/image-31-1024x363.png 1024w, /content/images/wordpress/2020/09/image-31-300x106.png 300w, /content/images/wordpress/2020/09/image-31-768x272.png 768w, /content/images/wordpress/2020/09/image-31.png 1364w" sizes="(max-width: 1024px) 100vw, 1024px"></figure><figure class="wp-block-image size-large"><img loading="lazy" width="1024" height="312" src="/content/images/wordpress/2020/09/image-32-1024x312.png" alt="" class="wp-image-560" srcset="/content/images/wordpress/2020/09/image-32-1024x312.png 1024w, /content/images/wordpress/2020/09/image-32-300x91.png 300w, /content/images/wordpress/2020/09/image-32-768x234.png 768w, /content/images/wordpress/2020/09/image-32.png 1357w" sizes="(max-width: 1024px) 100vw, 1024px"></figure>
- Menggunakan Sogo
<figure class="wp-block-image size-large"><img loading="lazy" width="1024" height="414" src="/content/images/wordpress/2020/09/image-33-1024x414.png" alt="" class="wp-image-561" srcset="/content/images/wordpress/2020/09/image-33-1024x414.png 1024w, /content/images/wordpress/2020/09/image-33-300x121.png 300w, /content/images/wordpress/2020/09/image-33-768x311.png 768w, /content/images/wordpress/2020/09/image-33.png 1365w" sizes="(max-width: 1024px) 100vw, 1024px"></figure><figure class="wp-block-image size-large"><img loading="lazy" width="1024" height="332" src="/content/images/wordpress/2020/09/image-34-1024x332.png" alt="" class="wp-image-562" srcset="/content/images/wordpress/2020/09/image-34-1024x332.png 1024w, /content/images/wordpress/2020/09/image-34-300x97.png 300w, /content/images/wordpress/2020/09/image-34-768x249.png 768w, /content/images/wordpress/2020/09/image-34.png 1362w" sizes="(max-width: 1024px) 100vw, 1024px"></figure>
- Menggunakan Microsoft Outlook

Buka aplikasi _Outlook \>\> File \>\> Add Account \>\> Manual Setup \>\> POP or IMAP \>\> konfigurasi seperti berikut_

<figure class="wp-block-image size-large"><img loading="lazy" width="680" height="486" src="/content/images/wordpress/2020/09/image-40.png" alt="" class="wp-image-568" srcset="/content/images/wordpress/2020/09/image-40.png 680w, /content/images/wordpress/2020/09/image-40-300x214.png 300w" sizes="(max-width: 680px) 100vw, 680px"></figure>

_Noted: Disini kami menggunakan POP jika ingin menggunakan IMAP silakan ubah Account Type menjadi IMAP_

Kemudian, klik _More Setting \>\> Outgoing Server \>\> Ceklist My outgoing (SMTP)_

<figure class="wp-block-image size-large"><img loading="lazy" width="513" height="254" src="/content/images/wordpress/2020/09/image-41.png" alt="" class="wp-image-569" srcset="/content/images/wordpress/2020/09/image-41.png 513w, /content/images/wordpress/2020/09/image-41-300x149.png 300w" sizes="(max-width: 513px) 100vw, 513px"></figure>

Pindah ke menu _Advanced \>\> ceklist pada this server requires an ecrypted connection SSL (karena disini kita akan menggunakan SSL supaya secure) \>\> Input port incoming dan outgoing \>\> gambar terlampir_

<figure class="wp-block-image size-large"><img loading="lazy" width="678" height="414" src="/content/images/wordpress/2020/09/image-42.png" alt="" class="wp-image-570" srcset="/content/images/wordpress/2020/09/image-42.png 678w, /content/images/wordpress/2020/09/image-42-300x183.png 300w" sizes="(max-width: 678px) 100vw, 678px"></figure>

_Noted: Berikut port incoming dan outgoing SSL yang dapat Anda gunakan_

_Incomming Server : mail.nurhamim.my.id  
IMAP Port : 993  
POP3 Port : 995  
Outgoing Server : mail.nurhamim.my.id  
SMTP Port : 465_

Kemudian, klik _Test Account Settings_

<figure class="wp-block-image size-large"><img loading="lazy" width="1024" height="355" src="/content/images/wordpress/2020/09/image-43-1024x355.png" alt="" class="wp-image-571" srcset="/content/images/wordpress/2020/09/image-43-1024x355.png 1024w, /content/images/wordpress/2020/09/image-43-300x104.png 300w, /content/images/wordpress/2020/09/image-43-768x267.png 768w, /content/images/wordpress/2020/09/image-43.png 1233w" sizes="(max-width: 1024px) 100vw, 1024px"></figure>

Oke saat ini kita sudah berhasil konfigurasi email di outlook klik _Finish._

<figure class="wp-block-image size-large"><img loading="lazy" width="682" height="483" src="/content/images/wordpress/2020/09/image-44.png" alt="" class="wp-image-572" srcset="/content/images/wordpress/2020/09/image-44.png 682w, /content/images/wordpress/2020/09/image-44-300x212.png 300w" sizes="(max-width: 682px) 100vw, 682px"></figure>

Berikut tampilan user di outlook

<figure class="wp-block-image size-large"><img loading="lazy" width="1024" height="357" src="/content/images/wordpress/2020/09/image-46-1024x357.png" alt="" class="wp-image-574" srcset="/content/images/wordpress/2020/09/image-46-1024x357.png 1024w, /content/images/wordpress/2020/09/image-46-300x105.png 300w, /content/images/wordpress/2020/09/image-46-768x268.png 768w, /content/images/wordpress/2020/09/image-46.png 1359w" sizes="(max-width: 1024px) 100vw, 1024px"></figure>
- Mozilla Thunderbird

Buka aplikasi _Mozilla Thunderbird \>\> Account \>\> Email \>\> Input username dan password email \>\> Manual config_

<figure class="wp-block-image size-large"><img loading="lazy" width="1016" height="568" src="/content/images/wordpress/2020/09/image-47.png" alt="" class="wp-image-575" srcset="/content/images/wordpress/2020/09/image-47.png 1016w, /content/images/wordpress/2020/09/image-47-300x168.png 300w, /content/images/wordpress/2020/09/image-47-768x429.png 768w" sizes="(max-width: 1016px) 100vw, 1016px"></figure>

Sesuaikan protokol yang ingin digunakan bisa IMAP atau POP dan sesuaikan juga server hostname atau incoming dan outoging server nya menjadi _mail.nurhamim.my.id_ dan sesuaikan port yang ingin digunakan SSL atau non SSL/TLS

<figure class="wp-block-image size-large"><img loading="lazy" width="754" height="369" src="/content/images/wordpress/2020/09/image-48.png" alt="" class="wp-image-576" srcset="/content/images/wordpress/2020/09/image-48.png 754w, /content/images/wordpress/2020/09/image-48-300x147.png 300w" sizes="(max-width: 754px) 100vw, 754px"></figure>

Klik _Re-test_

<figure class="wp-block-image size-large"><img loading="lazy" width="749" height="368" src="/content/images/wordpress/2020/09/image-49.png" alt="" class="wp-image-577" srcset="/content/images/wordpress/2020/09/image-49.png 749w, /content/images/wordpress/2020/09/image-49-300x147.png 300w" sizes="(max-width: 749px) 100vw, 749px"></figure>

Klik _Done_

Berikut tampilan user akun email di _Mozilla Thunderbird_

<figure class="wp-block-image size-large"><img loading="lazy" width="1024" height="331" src="/content/images/wordpress/2020/09/image-50-1024x331.png" alt="" class="wp-image-578" srcset="/content/images/wordpress/2020/09/image-50-1024x331.png 1024w, /content/images/wordpress/2020/09/image-50-300x97.png 300w, /content/images/wordpress/2020/09/image-50-768x248.png 768w, /content/images/wordpress/2020/09/image-50.png 1030w" sizes="(max-width: 1024px) 100vw, 1024px"></figure>

Sekarang kita coba melihat monitoring mail server iRedMail menggunakan netdata, silakan akses netdata dan login menggunakan username admin _postmaster@nurhamim.my.id_

<figure class="wp-block-image size-large"><img loading="lazy" width="1024" height="339" src="/content/images/wordpress/2020/09/image-51-1024x339.png" alt="" class="wp-image-579" srcset="/content/images/wordpress/2020/09/image-51-1024x339.png 1024w, /content/images/wordpress/2020/09/image-51-300x99.png 300w, /content/images/wordpress/2020/09/image-51-768x254.png 768w, /content/images/wordpress/2020/09/image-51.png 1365w" sizes="(max-width: 1024px) 100vw, 1024px"></figure>

Berikut system overwiew netdata yang memonitoring server mail iRedMail

<figure class="wp-block-image size-large"><img loading="lazy" width="1024" height="513" src="/content/images/wordpress/2020/09/image-52-1024x513.png" alt="" class="wp-image-580" srcset="/content/images/wordpress/2020/09/image-52-1024x513.png 1024w, /content/images/wordpress/2020/09/image-52-300x150.png 300w, /content/images/wordpress/2020/09/image-52-768x385.png 768w, /content/images/wordpress/2020/09/image-52.png 1376w" sizes="(max-width: 1024px) 100vw, 1024px"></figure>

Disini kita dapat melihat semua resource dari server sampai ke sisi service yang ada mulai dari web server, email semua dimonitoring dan bisa di lihat

Contoh penggunaan Memory

<figure class="wp-block-image size-large"><img loading="lazy" width="1024" height="498" src="/content/images/wordpress/2020/09/image-53-1024x498.png" alt="" class="wp-image-581" srcset="/content/images/wordpress/2020/09/image-53-1024x498.png 1024w, /content/images/wordpress/2020/09/image-53-300x146.png 300w, /content/images/wordpress/2020/09/image-53-768x373.png 768w, /content/images/wordpress/2020/09/image-53.png 1348w" sizes="(max-width: 1024px) 100vw, 1024px"></figure>

Contoh monitoring Firewall

<figure class="wp-block-image size-large"><img loading="lazy" width="1024" height="467" src="/content/images/wordpress/2020/09/image-54-1024x467.png" alt="" class="wp-image-582" srcset="/content/images/wordpress/2020/09/image-54-1024x467.png 1024w, /content/images/wordpress/2020/09/image-54-300x137.png 300w, /content/images/wordpress/2020/09/image-54-768x350.png 768w, /content/images/wordpress/2020/09/image-54.png 1348w" sizes="(max-width: 1024px) 100vw, 1024px"></figure>

Contoh monitoring network

<figure class="wp-block-image size-large"><img loading="lazy" width="1024" height="507" src="/content/images/wordpress/2020/09/image-55-1024x507.png" alt="" class="wp-image-583" srcset="/content/images/wordpress/2020/09/image-55-1024x507.png 1024w, /content/images/wordpress/2020/09/image-55-300x148.png 300w, /content/images/wordpress/2020/09/image-55-768x380.png 768w, /content/images/wordpress/2020/09/image-55.png 1263w" sizes="(max-width: 1024px) 100vw, 1024px"></figure>

Contoh monitoring Nginx web server

<figure class="wp-block-image size-large"><img loading="lazy" width="1024" height="510" src="/content/images/wordpress/2020/09/image-56-1024x510.png" alt="" class="wp-image-584" srcset="/content/images/wordpress/2020/09/image-56-1024x510.png 1024w, /content/images/wordpress/2020/09/image-56-300x150.png 300w, /content/images/wordpress/2020/09/image-56-768x383.png 768w, /content/images/wordpress/2020/09/image-56.png 1282w" sizes="(max-width: 1024px) 100vw, 1024px"></figure>

Dan masih banyak lagi yang lainnya, Anda dapat eksplore secara mandiri.

Selamat mencoba 😁

Please follow and like us:

[![error](/wp-content/plugins/ultimate-social-media-icons/images/follow_subscribe.png)](https://api.follow.it/widgets/icon/VHc3d1lpVGdwRnE5QnV0eERCNUx5RCtvTTVoUkNYS3NNRmd5eVhlQW9tNXRHS3VTbGh6Y0NybkRJRS8zSGpjRDVZb1ZGMlNTSEpJYUpuZzZqNzdnd3VSN3dwM2VlQTF6ejJEaGV5UGRUbnlEcHFNd3luYTV4ZTZtUGowVWI2Q2x8M2kzdnBEeUIrUk5xOFI5TXZ3cHF3bFNQRkRJSGhUNGdrRFd0TlNtdE1OWT0=/OA==/)

[![fb-share-icon](/wp-content/plugins/ultimate-social-media-icons/images/visit_icons/fbshare_bck.png "Facebook Share")](https://www.facebook.com/sharer/sharer.php?u=https%3A%2F%2Fbelajarlinux.id%2F%3Fp%3D553%26ghostexport%3Dtrue%26submit%3DDownload+Ghost+File)

[![Tweet](/wp-content/plugins/ultimate-social-media-icons/images/visit_icons/en_US_Tweet.svg "Tweet")](https://twitter.com/intent/tweet?text=Cara+Mengelola+Mail+Server+iRedMail+https://belajarlinux.id/?p=553&ghostexport=true&submit=Download Ghost File)

[![fb-share-icon](/wp-content/plugins/ultimate-social-media-icons/images/share_icons/Pinterest_Save/en_US_save.svg "Pin Share")](#)

<!--kg-card-end: html-->
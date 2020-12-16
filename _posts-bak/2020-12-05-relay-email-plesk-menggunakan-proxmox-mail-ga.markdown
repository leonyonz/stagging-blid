---
layout: post
title: 'PMG: Relay Email Plesk Panel Menggunakan Proxmox Mail Gateway'
featured: true
date: '2020-12-05 06:09:12'
tags:
- proxmox-mail-gateway
---

[Belajar Linux ID](/) - Tutorial kali ini akan dibahas bagaimana cara memanfaatkan email relay dari proxmox mail gateway, study kasus nya disini kami sudah mempunyai [Hosting Dedicated Plesk](https://plesk.biznetgio.com/dedicated-hosting) &nbsp;untuk pengiriman email (outgoing) dari Dedicated Hosting Plesk tersebut nantinya akan dialihkan atau menggunakan proxmox mail gateway.

Topologi sederhana dari email relay menggunakan proxmox mail gateway sebagai berikut:

<figure class="kg-card kg-image-card"><img src="/content/images/2020/12/relay-mail-gateway.png" class="kg-image" alt srcset="/content/images/size/w600/2020/12/relay-mail-gateway.png 600w, /content/images/2020/12/relay-mail-gateway.png 610w"></figure>

Keterangan: Dari topologi dapat disimpulkan apabila terdapat pengiriman email (outgoing) dari sisi Dedicated Plesk, maka email tersebut akan melewati proxmox mail gateway, selanjutnya proxmox mail gateway yang akan bertindak sebagai sender email ke provider email seperti hal nya @gmail.com, @yahaoo.com atau @domain.com.

### Konfigurasi Relay di Proxmox Mail Gateway

Silahkan login ke proxmox mail gateway, masuk ke menu _Mail Proxy_

<figure class="kg-card kg-image-card"><img src="/content/images/2020/12/1-2.png" class="kg-image" alt srcset="/content/images/size/w600/2020/12/1-2.png 600w, /content/images/size/w1000/2020/12/1-2.png 1000w, /content/images/2020/12/1-2.png 1362w" sizes="(min-width: 720px) 720px"></figure>

Pindah ke tab menu _Networks \>\> isikan IP Plesk Panel beserta prefix nya_

<!--kg-card-begin: html--><script async src="https://pagead2.googlesyndication.com/pagead/js/adsbygoogle.js"></script><ins class="adsbygoogle" style="display:block; text-align:center;" data-ad-layout="in-article" data-ad-format="fluid" data-ad-client="ca-pub-1515372853161377" data-ad-slot="1986938311"></ins><script>
     (adsbygoogle = window.adsbygoogle || []).push({});
</script><!--kg-card-end: html--><figure class="kg-card kg-image-card"><img src="/content/images/2020/12/2-2.png" class="kg-image" alt srcset="/content/images/size/w600/2020/12/2-2.png 600w, /content/images/size/w1000/2020/12/2-2.png 1000w, /content/images/2020/12/2-2.png 1363w" sizes="(min-width: 720px) 720px"></figure>

Konfigurasi tambahan dapat dilakukan misalnya _Enable TLS_ pada menu _TLS_

<figure class="kg-card kg-image-card"><img src="/content/images/2020/12/image-4.png" class="kg-image" alt srcset="/content/images/size/w600/2020/12/image-4.png 600w, /content/images/2020/12/image-4.png 900w" sizes="(min-width: 720px) 720px"></figure>

Anda juga dapat melakukan kustom konfigurasi dari proxmox mail gateway untuk relay jika dibutuhkan misalnya mengubah banner default Proxmox, mengatur DNSBL, Rate Limit, Waktu delay dan sebagainya, terlampir gambar konfigurasi default dari proxmox mail gateway

<figure class="kg-card kg-image-card"><img src="/content/images/2020/12/image-5.png" class="kg-image" alt srcset="/content/images/size/w600/2020/12/image-5.png 600w, /content/images/2020/12/image-5.png 729w" sizes="(min-width: 720px) 720px"></figure>

Untuk melihat port apa saja yang dapat digunakan untuk melakukan relay domain silakan ke menu _Ports_

<figure class="kg-card kg-image-card"><img src="/content/images/2020/12/image-6.png" class="kg-image" alt srcset="/content/images/size/w600/2020/12/image-6.png 600w, /content/images/2020/12/image-6.png 769w" sizes="(min-width: 720px) 720px"></figure>

Jika mail server yang akan di relay merupakan email server external dapat menggunakan _SMTP Port 25._ Jika menggunakan internal _SMTP Port dapat gunakan port 26._

### Konfigurasi Relay di Plesk Panel

Selanjutnya, akses server Dedicated Plesk Panel Anda melalui SSH dan membuat rule _transport,_ tujuannya untuk membuat rule email relay ke spesifik relay misalnya relay hanya ke @gmail.com, @yahoo.com atau ke @domain.com saja, seperti berikut

<!--kg-card-begin: html--><script async src="https://pagead2.googlesyndication.com/pagead/js/adsbygoogle.js"></script><ins class="adsbygoogle" style="display:block; text-align:center;" data-ad-layout="in-article" data-ad-format="fluid" data-ad-client="ca-pub-1515372853161377" data-ad-slot="1986938311"></ins><script>
     (adsbygoogle = window.adsbygoogle || []).push({});
</script><!--kg-card-end: html--><!--kg-card-begin: markdown-->

    [root@plesk-panel ~]#
    [root@plesk-panel ~]# vim /var/spool/postfix/plesk/transport

<!--kg-card-end: markdown-->

Contoh konfigurasi relay di sisi Plesk (relay plesk ke gmail dan yahoo)

<!--kg-card-begin: markdown-->

    gmail.com smtp:pmg.nurhamim.my.id:26
    yahoo.com smtp:pmg.nurhamim.my.id:26

<!--kg-card-end: markdown-->

_Noted: Pada url pmg.nurhamim.my.id dapat disesuaikan dengan alamat IP atau URL Proxmox Mail Gateway._

Jika sudah silahkan jalankan command `postmap` ke direktori `transport`

<!--kg-card-begin: markdown-->

    [root@plesk-panel ~]# postmap /var/spool/postfix/plesk/transport
    [root@plesk-panel ~]#

<!--kg-card-end: markdown-->

Restart postfix Plesk Panel

<!--kg-card-begin: markdown-->

    [root@plesk-panel ~]# systemctl restart postfix.service
    [root@plesk-panel ~]#

<!--kg-card-end: markdown-->
### Percobaan Pengiriman Email Plesk ke @gmail.com dan @yahoo.com

Kami sudah membuat email di sisi plesk panel dengan alamat email me@belajarlinux.id dimana email tersebut akan kami gunakan sebagai email test pengiriman ke @gmail.com

- Send email dari me@belajarlinux.id to @gmail.com
<figure class="kg-card kg-image-card"><img src="/content/images/2020/12/1-3.png" class="kg-image" alt srcset="/content/images/size/w600/2020/12/1-3.png 600w, /content/images/size/w1000/2020/12/1-3.png 1000w, /content/images/size/w1600/2020/12/1-3.png 1600w, /content/images/2020/12/1-3.png 1918w" sizes="(min-width: 720px) 720px"></figure>
- Email Sudah di terima disisi @gmail.com
<figure class="kg-card kg-image-card"><img src="/content/images/2020/12/2-3.png" class="kg-image" alt srcset="/content/images/size/w600/2020/12/2-3.png 600w, /content/images/size/w1000/2020/12/2-3.png 1000w, /content/images/2020/12/2-3.png 1366w" sizes="(min-width: 720px) 720px"></figure><figure class="kg-card kg-image-card"><img src="/content/images/2020/12/3-1.png" class="kg-image" alt srcset="/content/images/size/w600/2020/12/3-1.png 600w, /content/images/size/w1000/2020/12/3-1.png 1000w, /content/images/2020/12/3-1.png 1361w" sizes="(min-width: 720px) 720px"></figure>
- Cek Header Email
<figure class="kg-card kg-image-card"><img src="/content/images/2020/12/4-1.png" class="kg-image" alt srcset="/content/images/size/w600/2020/12/4-1.png 600w, /content/images/size/w1000/2020/12/4-1.png 1000w, /content/images/2020/12/4-1.png 1501w" sizes="(min-width: 720px) 720px"></figure>

Dari informasi header email penerima (@gmail.com) diatas terlihat pengiriman email sudah melalui proxmox mail gateway

<!--kg-card-begin: html--><script async src="https://pagead2.googlesyndication.com/pagead/js/adsbygoogle.js"></script><ins class="adsbygoogle" style="display:block; text-align:center;" data-ad-layout="in-article" data-ad-format="fluid" data-ad-client="ca-pub-1515372853161377" data-ad-slot="4684565489"></ins><script>
     (adsbygoogle = window.adsbygoogle || []).push({});
</script><!--kg-card-end: html-->
- Send email dari me@belajarlinux.id ke @yahoo.com
<figure class="kg-card kg-image-card"><img src="/content/images/2020/12/5-1.png" class="kg-image" alt srcset="/content/images/size/w600/2020/12/5-1.png 600w, /content/images/size/w1000/2020/12/5-1.png 1000w, /content/images/size/w1600/2020/12/5-1.png 1600w, /content/images/2020/12/5-1.png 1915w" sizes="(min-width: 720px) 720px"></figure>
- Email sudah diterima disisi @yahoo.com
<figure class="kg-card kg-image-card"><img src="/content/images/2020/12/6-2.png" class="kg-image" alt srcset="/content/images/size/w600/2020/12/6-2.png 600w, /content/images/size/w1000/2020/12/6-2.png 1000w, /content/images/2020/12/6-2.png 1587w" sizes="(min-width: 720px) 720px"></figure><figure class="kg-card kg-image-card"><img src="/content/images/2020/12/7-1.png" class="kg-image" alt srcset="/content/images/size/w600/2020/12/7-1.png 600w, /content/images/size/w1000/2020/12/7-1.png 1000w, /content/images/2020/12/7-1.png 1576w" sizes="(min-width: 720px) 720px"></figure>
- Cek Header Email
<figure class="kg-card kg-image-card"><img src="/content/images/2020/12/8-1.png" class="kg-image" alt srcset="/content/images/size/w600/2020/12/8-1.png 600w, /content/images/2020/12/8-1.png 975w" sizes="(min-width: 720px) 720px"></figure>

Dari informasi header email penerima (@yahoo.com) diatas terlihat pengiriman email sudah melalui proxmox mail gateway

### Tambahan

Sebagai tambahan informasi untuk menghindari email dari proxmox mail gateway &nbsp;masuk ke dalam kategori spam, Anda dapat set up PTR/rDNS untuk IP proxmox mail gateway Anda. Biasanya untuk kebutuhan PTR/rDNS dapat menghubungi pihak penyedia blocklist IP server yang Anda gunakan, jika Anda menggunakan Instance atau VPS misalnya di NEO Cloud Anda dapat menghubungi support NEO Cloud bisa melalui support@neo.id atau via live chat melalui website berikut: biznetgio.com untuk kebutuhan PTR/rDNS.

Contoh IP proxmox mail gateway yang sudah di setup PTR/rDNS

<figure class="kg-card kg-image-card"><img src="/content/images/2020/12/image-7.png" class="kg-image" alt srcset="/content/images/size/w600/2020/12/image-7.png 600w, /content/images/size/w1000/2020/12/image-7.png 1000w, /content/images/2020/12/image-7.png 1048w" sizes="(min-width: 720px) 720px"></figure>

Selamat mencoba 😁


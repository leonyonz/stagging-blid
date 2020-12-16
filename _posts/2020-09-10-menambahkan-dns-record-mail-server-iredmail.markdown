---
layout: post
title: Menambahkan DNS Record Mail Server iRedMail
featured: true
date: '2020-09-10 06:59:19'
tags:
- centos
- dns
- mail-server
---

iRedMail sebuah mail server yang bersifat open source, dengan iRedMail Anda dapat dapat membangun mail server sendiri di VPS atau VM. Namun untuk mempunyai email server kita butuh yang namanya DNS Record untuk mail server.

DNS Record apa saja yang dibutuhkan untuk membangun mail server?.

Sebelum menjawab pertanyaan diatas pastikan Anda sudah mengikuti tutorial – tutorial kami sebelumnya mengenai mail server berikut  
  
_**1. [Membuat Mail Server Menggunakan iRedMail di CentOS 8](/membuat-mail-server-menggunakan-iredmail-di-centos-8/)  
2. [Cara Install SSL Let’s Encrypt di iRedMail](/cara-install-ssl-lets-encrypt-di-iredmail/)  
3. [Enable SMTPS service (SMTP over SSL) di iRedMail](/enable-smtps-service-smtp-over-ssl-di-iredmail/)**_

Berikut ini merupakan beberapa DNS Record yang sering digunakan untuk kebutuhan mail server

- _ **Record MX + Mail Priority** _  
_MX (Mail Exchanger) merupakan record routing email, untuk domain. Dalam hal ini akan diarahkan ke mail.nurhamim.my.id sebagai host yang ditunjuk sebagai mail exchanger akan memproses atau meneruskan mail untuk domain (nurhamim.my.id). Pada MX tersebut terdapat priority atau nilai preferensi (preference value) untuk menunjukkan tingkat prioritas mail exchanger yang digunakan untuk memproses atau meneruskan mail yang menuju domain (nurhamim.my.id). Standard priority atau nilai preferensi MX yang sering digunakan yakni 10_.  
- _**SPF (Sender Policy Framework)**_  
_Merupakan sebuah record mail yang digunakan untuk memvalidasi email yg didesain untuk mencegah spam dengan cara mendeteksi spoofing, dengan memverifikasi alamat IP pengirim._

- **_Record DKIM (DomainKeys Identified Mail)_**  
_Merupakan sebuah record mail yang bertujuan untuk dapat memverifikasi apakah ini email yang valid yang berasal dari nama domain tertentu. Fungsi utamanya yaitu untuk mencegah spoofing dan phising pada email._

- **_Record PTR/rDNS_**  
_PTR/rDNS merupakan record mail yang digunakan untuk menyatakan pemetaan  
sebuah alamat IP ke domain (nurhamim.my.id) yang merupakan reversed-address. Reverse Address ini sangat diperlukan jika kita membuat mail server karena dengan adanya reverse IP Address ke alamat domain, maka proses send/receive protocol SMTP pada vm/server mail server Anda dapat berjalan normal. Tanpa adanya reverse Address, IP kita dianggap sebagai spam oleh vm/server smtp mail server lain karena tidak dikenali._  

Untuk penambahan record mail server dapat di lakukan di DNS Management domain untuk mengetahuinya bisa dengan cara melihat name server domain sebagai contoh domain nurhamim.my.id.

Jika di whois name server domain nurhamim.my.id menggunakan cloudflare

<figure class="wp-block-image size-large"><img loading="lazy" width="578" height="135" src="/content/images/wordpress/2020/09/image-22.png" alt="" class="wp-image-531" srcset="/content/images/wordpress/2020/09/image-22.png 578w, /content/images/wordpress/2020/09/image-22-300x70.png 300w" sizes="(max-width: 578px) 100vw, 578px"></figure>

Dengan demikian untuk input record DNS Server dilakukan di sisi cloudflare.

Sebagai informasi tambahan fungsi Name Server sendiri sebagai tempat penyimpanan atau database record – record DNS.

### **– Add Record DNS Mail di DNS Management Domain**

Berikut contoh record MX, SPF, DKIM

<figure class="wp-block-image size-large"><img loading="lazy" width="932" height="472" src="/content/images/wordpress/2020/09/image-23.png" alt="" class="wp-image-533" srcset="/content/images/wordpress/2020/09/image-23.png 932w, /content/images/wordpress/2020/09/image-23-300x152.png 300w, /content/images/wordpress/2020/09/image-23-768x389.png 768w" sizes="(max-width: 932px) 100vw, 932px"></figure>

Dengan detail sebagai berikut:  
  
**Record MX**  
Type: MX  
Name: Domain (@)  
Content: mail.nurhamim.my.id  
  
**Record Mail**  
Type: A  
Name: mail  
Content: IPPublic\_VM\_VPS  
  
**Record SPF**  
Type: TXT  
Name: Domain (@)  
Content: v=spf1 +a +mx +ip4:IPPublic\_VM\_VPS ~all  
  
**Record DKIM**  
Type: TXT  
Name: dkim.\_domainkey  
Content: v=DKIM1; p=MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEApnOGGDH+G56WX3qSLA89XLDscKhnVDdOpp/gg4XbzOY6GdM7ciOioMMHKT1CQITdE5hJj49cEkuwP7xHAjaKSoNhYu/XSNMWWFMCQsMm134wvv7yvMh7Tw0fVaOpXCtk3nTkuAC8oJy8JlkVqDTskD3YewWMfNmj85VcO1V/GSXi1YiO/aDPs2tK4nErXNlNxVEKpcjq2n4PlcYbvlbeGJymxr056D1FBNgJowtq3x4lrFnbL26LSgLDBfd9iOx3dX5jdWj/UINvSUwJnyGZmG+PLZvUScBJ8YNNBcA8486jJRGWxT7HgQ/NEXPT+aveoZXkjWKz5lfsJPfYDguQUwIDAQAB;  
  
Untuk mendapatkan record DKIM di iRedMail Anda hanya perlu menjalankan perintah berikut

    [root@mail ~]#
    [root@mail ~]# amavisd -c /etc/amavisd/amavisd.conf showkeys
    ; key#1 2048 bits, i=dkim, d=nurhamim.my.id, /var/lib/dkim/nurhamim.my.id.pem
    dkim._domainkey.nurhamim.my.id. 3600 TXT (
      "v=DKIM1; p="
      "MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEApnOGGDH+G56WX3qSLA89"
      "XLDscKhnVDdOpp/gg4XbzOY6GdM7ciOioMMHKT1CQITdE5hJj49cEkuwP7xHAjaK"
      "SoNhYu/XSNMWWFMCQsMm134wvv7yvMh7Tw0fVaOpXCtk3nTkuAC8oJy8JlkVqDTs"
      "kD3YewWMfNmj85VcO1V/GSXi1YiO/aDPs2tK4nErXNlNxVEKpcjq2n4PlcYbvlbe"
      "GJymxr056D1FBNgJowtq3x4lrFnbL26LSgLDBfd9iOx3dX5jdWj/UINvSUwJnyGZ"
      "mG+PLZvUScBJ8YNNBcA8486jJRGWxT7HgQ/NEXPT+aveoZXkjWKz5lfsJPfYDguQ"
      "UwIDAQAB")
    
    [root@mail ~]#

Hilangkan tanda ptik (“”) dan gabungkan semua value diatas seperti contoh diatas.

Khusus untuk record PTR/rDNS Anda hanya perlu request ke penyedia VPS atau VM Anda seperti kami menggunakan layanan NEO Cloud sebagai Mail Server jadi jika kami butuh record PTR kami hanya perlu request by email ke support@neo.id untuk pembuatan PTR record IP VPS atau VM.

### **– Verifikasi DNS Record Mail Server**

Untuk melakukan verifikasi DKIM dan SPF dapat menggunakan _command dig_ seperti berikut

<figure class="wp-block-image size-large"><img loading="lazy" width="1024" height="215" src="/content/images/wordpress/2020/09/3-6-1024x215.png" alt="" class="wp-image-534" srcset="/content/images/wordpress/2020/09/3-6-1024x215.png 1024w, /content/images/wordpress/2020/09/3-6-300x63.png 300w, /content/images/wordpress/2020/09/3-6-768x161.png 768w, /content/images/wordpress/2020/09/3-6.png 1107w" sizes="(max-width: 1024px) 100vw, 1024px"></figure>

Atau Anda dapat memastikan record DKIM sudah benar terpasang dengan cara testing langsung melalui iRedMail Anda seperti berikut

    [root@mail ~]#
    [root@mail ~]# amavisd -c /etc/amavisd/amavisd.conf testkeys
    TESTING#1 nurhamim.my.id: dkim._domainkey.nurhamim.my.id => pass
    [root@mail ~]#

Untuk verifikasi record MX bisa menggunakan _command host_

<figure class="wp-block-image size-large"><img loading="lazy" width="551" height="181" src="/content/images/wordpress/2020/09/image-25.png" alt="" class="wp-image-536" srcset="/content/images/wordpress/2020/09/image-25.png 551w, /content/images/wordpress/2020/09/image-25-300x99.png 300w" sizes="(max-width: 551px) 100vw, 551px"></figure>

Untuk memastikan record PTR dapat menggunakan [MXToolbox](https://mxtoolbox.com/)berikut

<figure class="wp-block-image size-large"><img loading="lazy" width="1024" height="274" src="/content/images/wordpress/2020/09/image-24-1024x274.png" alt="" class="wp-image-535" srcset="/content/images/wordpress/2020/09/image-24-1024x274.png 1024w, /content/images/wordpress/2020/09/image-24-300x80.png 300w, /content/images/wordpress/2020/09/image-24-768x206.png 768w, /content/images/wordpress/2020/09/image-24.png 1027w" sizes="(max-width: 1024px) 100vw, 1024px"></figure>
### **– Testing Spam Score Mail Server**

Langkah selanjutnya cek spam score mail server Anda menggunakan **[Mail Tester](https://www.mail-tester.com/)** silakan kirim email ke email mail tester berikut

<figure class="wp-block-image size-large"><img loading="lazy" width="1024" height="370" src="/content/images/wordpress/2020/09/4-6-1024x370.png" alt="" class="wp-image-537" srcset="/content/images/wordpress/2020/09/4-6-1024x370.png 1024w, /content/images/wordpress/2020/09/4-6-300x108.png 300w, /content/images/wordpress/2020/09/4-6-768x277.png 768w, /content/images/wordpress/2020/09/4-6.png 1363w" sizes="(max-width: 1024px) 100vw, 1024px"></figure>

Kirim email bisa menggunakan webmail contohnya

<figure class="wp-block-image size-large"><img loading="lazy" width="1024" height="273" src="/content/images/wordpress/2020/09/5-4-1024x273.png" alt="" class="wp-image-538" srcset="/content/images/wordpress/2020/09/5-4-1024x273.png 1024w, /content/images/wordpress/2020/09/5-4-300x80.png 300w, /content/images/wordpress/2020/09/5-4-768x205.png 768w, /content/images/wordpress/2020/09/5-4.png 1364w" sizes="(max-width: 1024px) 100vw, 1024px"></figure>

Saat ini sudah berhasil terkirim, selanjutnya lihat score email nya

<figure class="wp-block-image size-large"><img loading="lazy" width="1024" height="529" src="/content/images/wordpress/2020/09/6-2-1024x529.png" alt="" class="wp-image-539" srcset="/content/images/wordpress/2020/09/6-2-1024x529.png 1024w, /content/images/wordpress/2020/09/6-2-300x155.png 300w, /content/images/wordpress/2020/09/6-2-768x396.png 768w, /content/images/wordpress/2020/09/6-2.png 1364w" sizes="(max-width: 1024px) 100vw, 1024px"></figure>

Oke score email Anda SEMPURNA ! #ANTI SPAM SPAM CLUB 😂.

Sekarang kita akan coba mengirimkan email dari @nurhamim.my.id ke @gmail.com dan @yahoo.com.

**Dari Mail Server iRedMail @nurhamim.my.id ke @gmail.com**

- Sender postmaster@nurhamim.my.id
<figure class="wp-block-image size-large"><img loading="lazy" width="1024" height="312" src="/content/images/wordpress/2020/09/gmail01-1024x312.png" alt="" class="wp-image-540" srcset="/content/images/wordpress/2020/09/gmail01-1024x312.png 1024w, /content/images/wordpress/2020/09/gmail01-300x91.png 300w, /content/images/wordpress/2020/09/gmail01-768x234.png 768w, /content/images/wordpress/2020/09/gmail01.png 1366w" sizes="(max-width: 1024px) 100vw, 1024px"></figure>
- Received hamimistimewa@gmail.com
<figure class="wp-block-image size-large"><img loading="lazy" width="1024" height="383" src="/content/images/wordpress/2020/09/gmail02-1024x383.png" alt="" class="wp-image-542" srcset="/content/images/wordpress/2020/09/gmail02-1024x383.png 1024w, /content/images/wordpress/2020/09/gmail02-300x112.png 300w, /content/images/wordpress/2020/09/gmail02-768x287.png 768w, /content/images/wordpress/2020/09/gmail02.png 1361w" sizes="(max-width: 1024px) 100vw, 1024px"></figure>
- Received hamimistimewa@yahoo.com 
<figure class="wp-block-image size-large"><img loading="lazy" width="1007" height="508" src="/content/images/wordpress/2020/09/yahoo-diterima.png" alt="" class="wp-image-543" srcset="/content/images/wordpress/2020/09/yahoo-diterima.png 1007w, /content/images/wordpress/2020/09/yahoo-diterima-300x151.png 300w, /content/images/wordpress/2020/09/yahoo-diterima-768x387.png 768w" sizes="(max-width: 1007px) 100vw, 1007px"></figure>

Selamat mencoba 😁

Please follow and like us:

[![error](/wp-content/plugins/ultimate-social-media-icons/images/follow_subscribe.png)](https://api.follow.it/widgets/icon/VHc3d1lpVGdwRnE5QnV0eERCNUx5RCtvTTVoUkNYS3NNRmd5eVhlQW9tNXRHS3VTbGh6Y0NybkRJRS8zSGpjRDVZb1ZGMlNTSEpJYUpuZzZqNzdnd3VSN3dwM2VlQTF6ejJEaGV5UGRUbnlEcHFNd3luYTV4ZTZtUGowVWI2Q2x8M2kzdnBEeUIrUk5xOFI5TXZ3cHF3bFNQRkRJSGhUNGdrRFd0TlNtdE1OWT0=/OA==/)

[![fb-share-icon](/wp-content/plugins/ultimate-social-media-icons/images/visit_icons/fbshare_bck.png "Facebook Share")](https://www.facebook.com/sharer/sharer.php?u=https%3A%2F%2Fbelajarlinux.id%2F%3Fp%3D526%26ghostexport%3Dtrue%26submit%3DDownload+Ghost+File)

[![Tweet](/wp-content/plugins/ultimate-social-media-icons/images/visit_icons/en_US_Tweet.svg "Tweet")](https://twitter.com/intent/tweet?text=Menambahkan+DNS+Record+Mail+Server+iRedMail+https://belajarlinux.id/?p=526&ghostexport=true&submit=Download Ghost File)

[![fb-share-icon](/wp-content/plugins/ultimate-social-media-icons/images/share_icons/Pinterest_Save/en_US_save.svg "Pin Share")](#)

<!--kg-card-end: html-->
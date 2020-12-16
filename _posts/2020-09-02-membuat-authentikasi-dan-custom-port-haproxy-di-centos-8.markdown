---
layout: post
title: Membuat Authentikasi dan Custom Port HAProxy di CentOS 8
featured: true
date: '2020-09-02 23:00:06'
tags:
- centos
- haproxy
---

Pada tutorial kali ini kami akan memberikan cara sederhana bagaimana membuat authentikasi login ke HAProxy menggunakan username dan password selain itu untuk login ke HAProxy nantinya kita akan mencoba custom menggunakan port tujuan utama nya supaya lebih secure dan hanya Anda yang mengetahui URL login ke sisi HAProxy Anda.

Untuk mengikuti tutorial kali ini pastikan Anda sudah melakukan instalasi HAProxy, silakan buka konfigurasi haproxy Anda

    [root@haproxy ~]#
    [root@haproxy ~]# vim /etc/haproxy/haproxy.cfg

Tambahkan konfigurasi statistik HAProxy berikut

    listen stats
            bind *:2233
            stats enable
            stats hide-version
            stats refresh 30s
            stats show-node
            stats auth hamim:secret
            stats uri /stats

_Keterangan:_   
_ **bind:** Tentukan port yang ingin Anda gunakan_  
_ **stats enable:** Enable statistik HAProxy_  
_ **stats hide-version:** Melakukan disable versi HAProxy_  
_ **stats refresh:** Digunakan untuk refresh brower setiap s/m/sesuai keinginan_  
_ **stats show-node:** Digunakan untuk menampilkan node stats_  
_ **stats auth:** Digunakan untuk define username dan password login ke HAProxy sebagai contoj hamim:secret (hamim = username dan secret = password)_  
_ **stats uri:** Digunakan untuk difine /url yang diinginkan_

Pastikan Anda sudah allow port 2233 di sisi Firewall yang Anda gunakan

<figure class="wp-block-image size-large"><img loading="lazy" width="1024" height="31" src="/content/images/wordpress/2020/09/image-10-1024x31.png" alt="" class="wp-image-438" srcset="/content/images/wordpress/2020/09/image-10-1024x31.png 1024w, /content/images/wordpress/2020/09/image-10-300x9.png 300w, /content/images/wordpress/2020/09/image-10-768x23.png 768w, /content/images/wordpress/2020/09/image-10-1536x46.png 1536w, /content/images/wordpress/2020/09/image-10.png 1668w" sizes="(max-width: 1024px) 100vw, 1024px"></figure>

Reload HAProxy

    [root@haproxy ~]#
    [root@haproxy ~]# systemctl reload haproxy
    [root@haproxy ~]#

Akses HAProxy melalui web browser contohnya sebagai berikut

<figure class="wp-block-image size-large"><img loading="lazy" width="1024" height="526" src="/content/images/wordpress/2020/09/1-1-1024x526.png" alt="" class="wp-image-439" srcset="/content/images/wordpress/2020/09/1-1-1024x526.png 1024w, /content/images/wordpress/2020/09/1-1-300x154.png 300w, /content/images/wordpress/2020/09/1-1-768x395.png 768w, /content/images/wordpress/2020/09/1-1-1536x790.png 1536w, /content/images/wordpress/2020/09/1-1.png 1920w" sizes="(max-width: 1024px) 100vw, 1024px"></figure>

Isikan username dan password yang sudah tentukan sebelumnya

<figure class="wp-block-image size-large"><img loading="lazy" width="1024" height="307" src="/content/images/wordpress/2020/09/2-1-1024x307.png" alt="" class="wp-image-440" srcset="/content/images/wordpress/2020/09/2-1-1024x307.png 1024w, /content/images/wordpress/2020/09/2-1-300x90.png 300w, /content/images/wordpress/2020/09/2-1-768x230.png 768w, /content/images/wordpress/2020/09/2-1-1536x460.png 1536w, /content/images/wordpress/2020/09/2-1.png 1920w" sizes="(max-width: 1024px) 100vw, 1024px"></figure>

Saat ini HAProxy sudah dapat diakses menggunakan port dan authentikasi berupa username dan password.

Selamat mencoba 😁

Please follow and like us:

[![error](/wp-content/plugins/ultimate-social-media-icons/images/follow_subscribe.png)](https://api.follow.it/widgets/icon/VHc3d1lpVGdwRnE5QnV0eERCNUx5RCtvTTVoUkNYS3NNRmd5eVhlQW9tNXRHS3VTbGh6Y0NybkRJRS8zSGpjRDVZb1ZGMlNTSEpJYUpuZzZqNzdnd3VSN3dwM2VlQTF6ejJEaGV5UGRUbnlEcHFNd3luYTV4ZTZtUGowVWI2Q2x8M2kzdnBEeUIrUk5xOFI5TXZ3cHF3bFNQRkRJSGhUNGdrRFd0TlNtdE1OWT0=/OA==/)

[![fb-share-icon](/wp-content/plugins/ultimate-social-media-icons/images/visit_icons/fbshare_bck.png "Facebook Share")](https://www.facebook.com/sharer/sharer.php?u=https%3A%2F%2Fbelajarlinux.id%2F%3Fp%3D437%26ghostexport%3Dtrue%26submit%3DDownload+Ghost+File)

[![Tweet](/wp-content/plugins/ultimate-social-media-icons/images/visit_icons/en_US_Tweet.svg "Tweet")](https://twitter.com/intent/tweet?text=Membuat+Authentikasi+dan+Custom+Port+HAProxy+di+CentOS+8+https://belajarlinux.id/?p=437&ghostexport=true&submit=Download Ghost File)

[![fb-share-icon](/wp-content/plugins/ultimate-social-media-icons/images/share_icons/Pinterest_Save/en_US_save.svg "Pin Share")](#)

<!--kg-card-end: html-->
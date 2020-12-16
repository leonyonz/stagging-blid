---
layout: post
title: 'CentOS: Cara Mengatur Timezone Pada CentOS 8'
featured: true
date: '2020-11-23 10:32:12'
tags:
- centos
---

Mengatur timezone atau zona waktu sangat penting pada server, terlebih lagi apabila server yang digunakan memiliki cluster karena apabila zona waktu yang digunakan tidak sinkron dengan server lainnya akan menyebabkan masalah pada server kedepannya.

Pada kesempatan kali ini saya ingin berbagi **Cara mengatur timezone pada CentOS 8.**

**Memeriksa Zona Waktu Saat Ini.**

Cara untu memeriksa zona waktu yang saat ini sedang digunakan pada server Centos 8 adalah sebagai berikut:

<!--kg-card-begin: markdown-->

    $ timedatectl

<!--kg-card-end: markdown-->

Output yang seharusnya muncul dari perintah tersebut kurang lebih sebagai berikut:

<!--kg-card-begin: markdown-->

          Local time: Mon 2020-11-23 14:59:35 WIB
      Universal time: Mon 2020-11-23 07:59:35 UTC
            RTC time: Mon 2020-11-23 07:59:35
           Time zone: Asia/Jakarta (WIB, +0700)
         NTP enabled: yes
    NTP synchronized: yes
     RTC in local TZ: no
          DST active: n/a

<!--kg-card-end: markdown-->

**Mengubah Zona Waktu Pada CentOS.**

Untuk menyesuaikan zona waktu pada server CentOS 8 hal yang perlu dilakukan adalah melakukan listing zona waktu yang tersedia terlebih dahulu.

<!--kg-card-begin: markdown-->

    $ timedatectl list-timezones

<!--kg-card-end: markdown-->

Output yang seharusnya muncul adalah sebagai berikut:

<!--kg-card-begin: markdown-->

    ...
    Africa/Abidjan
    Africa/Accra
    Africa/Addis_Ababa
    Africa/Algiers
    Africa/Asmara
    Africa/Bamako
    Africa/Bangui
    Africa/Banjul
    Africa/Bissau
    Africa/Blantyre
    Africa/Brazzaville
    Africa/Bujumbura
    Africa/Cairo

<!--kg-card-end: markdown-->

Saat Anda telah menemukan zona waktu yang akan digunakan, silakan untuk menjalankan perintah berikut menggunakan root atau user yang memiliki previleges sudo.

<!--kg-card-begin: html--><script async src="https://pagead2.googlesyndication.com/pagead/js/adsbygoogle.js"></script><ins class="adsbygoogle" style="display:block; text-align:center;" data-ad-layout="in-article" data-ad-format="fluid" data-ad-client="ca-pub-1515372853161377" data-ad-slot="4684565489"></ins><script>
     (adsbygoogle = window.adsbygoogle || []).push({});
</script><!--kg-card-end: html--><!--kg-card-begin: markdown-->

    $ sudo timedatectl set-timezone zona-waktu-Anda

<!--kg-card-end: markdown-->

Sebagai contoh, berikut saya lampirkan juga perintahnya:

<!--kg-card-begin: markdown-->

    $ sudo timedatectl set-timezone Asia/Jakarta

<!--kg-card-end: markdown-->

**Selesai**

Demikian artikel **Cara mengatur timezone pada CentOS 8.** semoga bermanfaat bagi pengunjung yang sengaja ataupun tidak sengaja mengakses halaman ini.


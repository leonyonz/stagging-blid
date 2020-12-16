---
layout: post
title: 'Linux: Mengenal vmstat'
featured: true
date: '2020-11-15 01:39:44'
tags:
- linux
- ubuntu
- centos
---

[Belajar Linux ID](/) - Tutorial kali ini kita akan mencoba aplikasi alternatif dari `free` untuk mengetahui penggunaan memori di Linux. Sebenarnya sangat banyak aplikasi yang dapat Anda pilih dan gunakan untuk melihat penggunaan ram, namun kali ini kita akan mencoba menggunakan `vmstat`.

Di `vmstat` tidak hanya penggunaan memory saja yang ditampilkan melainkan Anda juga dapat melihat penggunaan resource lain seperti `interrupt sistem, kecepatan I/O, statistik CPU` secara real time.

<!--kg-card-begin: html--><script async src="https://pagead2.googlesyndication.com/pagead/js/adsbygoogle.js"></script><ins class="adsbygoogle" style="display:block; text-align:center;" data-ad-layout="in-article" data-ad-format="fluid" data-ad-client="ca-pub-1515372853161377" data-ad-slot="4684565489"></ins><script>
     (adsbygoogle = window.adsbygoogle || []).push({});
</script><!--kg-card-end: html-->

Perbedaan antara `free` dengan `vmstat` menurut pribadi penulis `free` lebih ke mencatat aktivitas yang terjadi, lebih detail dan spesifik fungsinya.

Untuk menggunakan `vmstat` Anda dapat install terlebih dahulu paket nya sebagai berikut

<!--kg-card-begin: markdown-->
### Debian/Ubuntu

    $ apt-get install sysstat

### CentOS

    $ yum install sysstat

<!--kg-card-end: markdown-->

Jika sudah di install Anda dapat jalankan perintah `vmstat` di terminal linux Anda contoh

<!--kg-card-begin: markdown-->

    [root@jumpwjv ~]# vmstat
    procs -----------memory---------- ---swap-- -----io---- -system-- ------cpu-----
     r b swpd free buff cache si so bi bo in cs us sy id wa st
     3 0 0 618260 2088 1063036 0 0 0 2 7 1 0 0 100 0 0
    [root@jumpwjv ~]#

<!--kg-card-end: markdown-->

Dari informasi diatas sudah terlihat informasi dari `memory, swap, io, system, dan cpu`. untuk informasi diatas satuan yang digunakan yaitu `byte`, jika Anda ingin melihat secara spesifik penggunaan ram dalam satuan MB di `vmstat` gunakan parameter `-SM` seperti berikut

<!--kg-card-begin: markdown-->

    [root@jumpwjv ~]# vmstat -sSM
             1837 M total memory
              194 M used memory
              556 M active memory
              425 M inactive memory
              603 M free memory
                2 M buffer memory
             1038 M swap cache
                0 M total swap
                0 M used swap
                0 M free swap
           266363 non-nice user cpu ticks
              665 nice user cpu ticks
           202228 system cpu ticks
        465203335 idle cpu ticks
            17535 IO-wait cpu ticks
                0 IRQ cpu ticks
             2635 softirq cpu ticks
             5209 stolen cpu ticks
           668103 pages paged in
         11254238 pages paged out
                0 pages swapped in
                0 pages swapped out
         74691046 interrupts
        134058621 CPU context switches
       1600743517 boot time
           292411 forks
    [root@jumpwjv ~]#

<!--kg-card-end: markdown--><!--kg-card-begin: html--><script async src="https://pagead2.googlesyndication.com/pagead/js/adsbygoogle.js"></script><ins class="adsbygoogle" style="display:block; text-align:center;" data-ad-layout="in-article" data-ad-format="fluid" data-ad-client="ca-pub-1515372853161377" data-ad-slot="4684565489"></ins><script>
     (adsbygoogle = window.adsbygoogle || []).push({});
</script><!--kg-card-end: html-->

Keunggulan dari `vmstat` yaitu `vmstat` mengambil data secara real time atau data yang terbaru.

Misalnya kita ingin melihat koneksi data per 5 detik sebayak 10 kali

<!--kg-card-begin: markdown-->

    [root@jumpwjv ~]# vmstat 5 10
    procs -----------memory---------- ---swap-- -----io---- -system-- ------cpu-----
     r b swpd free buff cache si so bi bo in cs us sy id wa st
     2 0 0 618408 2088 1063052 0 0 0 2 7 1 0 0 100 0 0
     0 0 0 618384 2088 1063052 0 0 0 0 37 72 0 0 100 0 0
     0 0 0 618384 2088 1063052 0 0 0 0 37 71 0 0 100 0 0
     0 0 0 618384 2088 1063052 0 0 0 2 38 73 0 0 100 0 0
     0 0 0 617764 2088 1063056 0 0 0 2 61 96 0 1 99 0 0
     0 0 0 617764 2088 1063056 0 0 0 0 37 71 0 0 100 0 0
     0 0 0 617764 2088 1063056 0 0 0 0 37 71 0 0 100 0 0
     0 0 0 617764 2088 1063056 0 0 0 0 39 71 0 0 100 0 0
     0 0 0 617764 2088 1063056 0 0 0 1 37 71 0 0 100 0 0
     0 0 0 617764 2088 1063056 0 0 0 0 37 71 0 0 100 0 0
    [root@jumpwjv ~]#

<!--kg-card-end: markdown-->

Dalam satuan MB

<!--kg-card-begin: markdown-->

    [root@jumpwjv ~]# vmstat -SM 5 10
    procs -----------memory---------- ---swap-- -----io---- -system-- ------cpu-----
     r b swpd free buff cache si so bi bo in cs us sy id wa st
     2 0 0 603 2 1038 0 0 0 2 7 1 0 0 100 0 0
     1 0 0 603 2 1038 0 0 0 0 37 70 0 0 100 0 0
     0 0 0 603 2 1038 0 0 0 0 36 71 0 0 100 0 0
     0 0 0 603 2 1038 0 0 0 0 37 69 0 0 100 0 0
     0 0 0 603 2 1038 0 0 0 9 39 75 0 0 100 0 0
     0 0 0 603 2 1038 0 0 0 0 39 73 0 0 100 0 0
     0 0 0 603 2 1038 0 0 0 0 37 70 0 0 100 0 0
     0 0 0 603 2 1038 0 0 0 0 38 72 0 0 100 0 0
     0 0 0 603 2 1038 0 0 0 0 36 70 0 0 100 0 0
     0 0 0 603 2 1038 0 0 0 0 37 69 0 0 100 0 0
    [root@jumpwjv ~]#

<!--kg-card-end: markdown-->

Jika di lihat informasi diatas untuk tingkat penggunaan diatas VPS atau VM yang saya gunakan terpantau stabil dan tidak ada lonjakan yang berarti.

Dengan menggunakan `vmstat` Anda dapat gunakan apabila ingin melakukan diagnosa masalah atau performa server.

Selamat mencoba 😁

<!--kg-card-begin: html--><script async src="https://pagead2.googlesyndication.com/pagead/js/adsbygoogle.js"></script><ins class="adsbygoogle" style="display:block; text-align:center;" data-ad-layout="in-article" data-ad-format="fluid" data-ad-client="ca-pub-1515372853161377" data-ad-slot="4684565489"></ins><script>
     (adsbygoogle = window.adsbygoogle || []).push({});
</script><!--kg-card-end: html-->
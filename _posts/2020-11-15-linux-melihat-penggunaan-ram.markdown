---
layout: post
title: 'Linux: Melihat Penggunaan RAM'
featured: true
date: '2020-11-15 00:41:35'
tags:
- linux
- ubuntu
- centos
---

[Belajar Linux ID](/) - Menurut wikipedia _Random-access Memory_ atau sering disingkat dengan _RAM_ adalah sebuah tipe [penyimpanan komputer](https://id.wikipedia.org/wiki/Penyimpanan_komputer) yang isinya dapat diakses dalam waktu yang tetap tidak memperdulikan letak data tersebut dalam memori.

Pengerrtian lain dari RAM adalah sebuah perangkat keras (hardwar) yang berada di komputer, laptop, server etc, yang berfungsi sebagai penyimpanan data sementara dan berbagai intruksi program.

<!--kg-card-begin: html--><script async src="https://pagead2.googlesyndication.com/pagead/js/adsbygoogle.js"></script><ins class="adsbygoogle" style="display:block; text-align:center;" data-ad-layout="in-article" data-ad-format="fluid" data-ad-client="ca-pub-1515372853161377" data-ad-slot="4684565489"></ins><script>
     (adsbygoogle = window.adsbygoogle || []).push({});
</script><!--kg-card-end: html-->

Untuk mengetahui size dan penggunaan RAM di Linux dapat dilakukan melalui command line interface (CLI), biasanya menggunakan command `free` dimana seharusnya command `free` sudah terinstall di semua distro linux, contoh:

<!--kg-card-begin: markdown-->

    hamimaja@A1-LR08Q321:~$ free
                  total used free shared buff/cache available
    Mem: 8092044 6758176 1104516 17720 229352 1200136
    Swap: 25165824 442196 24723628
    hamimaja@A1-LR08Q321:~$

<!--kg-card-end: markdown-->

Seperti yang Anda lihat diatas, output dibagi menjadi dua kategori: memori (RAM aktual) dan swap (juga disebut memori virtual). Berikut detil informasi diatas:

- **total:** jumlah total memori yang saat ini terinstal di sistem Anda dalam kilobyte.
- **used:** jumlah RAM yang saat ini digunakan di sistem Anda dalam kilobyte.
- **free:** jumlah memori bebas yang tersedia di sistem Anda dalam kilobyte.
- **shared:** mewakili memori yang digunakan oleh _`tmpfs`_ yang merupakan sistem file virtual yang tampaknya terpasang tetapi termasuk dalam memori volatil.
- **buffer:** memori yang digunakan oleh `buffer kernel` 
- **cache:** jumlah memori yang digunakan oleh cache halaman tempat data mungkin disimpan terlebih dahulu sebelum ditulis ke disk 
- **available:** memori yang tersedia di sistem dalam kilobyte

Sangat banyak opsi penggunaan command `free` yang dapat di gunakan, berikut beberapa contoh penggunaan command free beserta beberapa opsi yang digunakan.

1. Menampilikan Penggunaan RAM dalam satuan Bytes
<!--kg-card-begin: markdown-->

    hamimaja@A1-LR08Q321:~$ free -b
                  total used free shared buff/cache available
    Mem: 8286253056 6977146880 1074249728 18145280 234856448 1172164608
    Swap: 25769803776 462049280 25307754496
    hamimaja@A1-LR08Q321:~$

<!--kg-card-end: markdown-->

2. Menampilkan Penggunaan RAM dalam satuan KB (Kilo Bytes)

<!--kg-card-begin: markdown-->

    hamimaja@A1-LR08Q321:~$ free -k
                  total used free shared buff/cache available
    Mem: 8092044 6665916 1196776 17720 229352 1292396
    Swap: 25165824 565380 24600444
    hamimaja@A1-LR08Q321:~$

<!--kg-card-end: markdown-->

3. Menampilkan Penggunaan RAM dalam satuan MB (Megabytes)

<!--kg-card-begin: markdown-->

    hamimaja@A1-LR08Q321:~$ free -m
                  total used free shared buff/cache available
    Mem: 7902 6482 1196 17 223 1289
    Swap: 24576 551 24024
    hamimaja@A1-LR08Q321:~$

<!--kg-card-end: markdown-->

4. Menampilkan Penggunaan RAM dalam satuan GB (Gigabytes)

<!--kg-card-begin: markdown-->

    hamimaja@A1-LR08Q321:~$ free -g
                  total used free shared buff/cache available
    Mem: 7 6 1 0 0 1
    Swap: 24 0 23
    hamimaja@A1-LR08Q321:~$

<!--kg-card-end: markdown--><!--kg-card-begin: html--><script async src="https://pagead2.googlesyndication.com/pagead/js/adsbygoogle.js"></script><ins class="adsbygoogle" style="display:block; text-align:center;" data-ad-layout="in-article" data-ad-format="fluid" data-ad-client="ca-pub-1515372853161377" data-ad-slot="4684565489"></ins><script>
     (adsbygoogle = window.adsbygoogle || []).push({});
</script><!--kg-card-end: html-->

5. Menampilkan Total Line

<!--kg-card-begin: markdown-->

    hamimaja@A1-LR08Q321:~$ free -t
                  total used free shared buff/cache available
    Mem: 8092044 6738256 1124436 17720 229352 1220056
    Swap: 25165824 530344 24635480
    Total: 33257868 7268600 25759916
    hamimaja@A1-LR08Q321:~$

<!--kg-card-end: markdown-->

6. Menampilkan statistik RAM (Low and High) Usage

<!--kg-card-begin: markdown-->

    hamimaja@A1-LR08Q321:~$ free -l
                  total used free shared buff/cache available
    Mem: 8092044 6782724 1079968 17720 229352 1175588
    Low: 8092044 7012076 1079968
    High: 0 0 0
    Swap: 25165824 530344 24635480
    hamimaja@A1-LR08Q321:~$

<!--kg-card-end: markdown-->

7. Kombinasi opsi

<!--kg-card-begin: markdown-->

    hamimaja@A1-LR08Q321:~$ free -lg
                  total used free shared buff/cache available
    Mem: 7 6 1 0 0 1
    Low: 7 6 1
    High: 0 0 0
    Swap: 24 0 23
    hamimaja@A1-LR08Q321:~$

<!--kg-card-end: markdown-->

Itulah beberapa contoh bagaimana cara cek penggunaan RAM di Linux, Anda dapat eksplorasi secara mandiri melalui link berikut: **[free(1) — Linux manual page](https://man7.org/linux/man-pages/man1/free.1.html)**

Selamat mencoba 😁

<!--kg-card-begin: html--><script async src="https://pagead2.googlesyndication.com/pagead/js/adsbygoogle.js"></script><ins class="adsbygoogle" style="display:block; text-align:center;" data-ad-layout="in-article" data-ad-format="fluid" data-ad-client="ca-pub-1515372853161377" data-ad-slot="4684565489"></ins><script>
     (adsbygoogle = window.adsbygoogle || []).push({});
</script><!--kg-card-end: html-->
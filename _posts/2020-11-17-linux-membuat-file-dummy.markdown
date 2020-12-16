---
layout: post
title: 'Linux: Membuat File Dummy'
featured: true
date: '2020-11-17 10:46:31'
tags:
- linux
- centos
- ubuntu
---

[Belajar Linux ID](/) - Tutorial kali ini kita akan mencoba membuat file dummy. Biasanya ada waktu dimana kita membutuhkan file berukuran besar buat testing misalnya ingin melakukan speed test IO write and read dimana membutuhkan direktori atau folder atau ingin melakukan uji coba benchmark terhadap disk dalam keadaan disk full dengan file - file besar misalnya dapat di lakukan dengan cara membuat file dummy.

<!--kg-card-begin: html--><script async src="https://pagead2.googlesyndication.com/pagead/js/adsbygoogle.js"></script><ins class="adsbygoogle" style="display:block; text-align:center;" data-ad-layout="in-article" data-ad-format="fluid" data-ad-client="ca-pub-1515372853161377" data-ad-slot="1986938311"></ins><script>
     (adsbygoogle = window.adsbygoogle || []).push({});
</script><!--kg-card-end: html-->

File dummy itu sendiri merupakan file kosong yang mempunyai size atau ukuran file dari kecil sampai besar.

Untuk membuat file dummy sendiri dapat di lakukan dengan menggunakan perintah `fallowcate` dengan perintah ini Anda dapat membuat file dummy dengan extension file apapun yang Anda inginkan, berikut contoh membuat file dummy menggunakan `fallowcate`

<!--kg-card-begin: markdown-->
##### 15 GB File Dummy

    [centos@jumpwjv folder1]$ sudo fallocate -l 15GB file-dummy.tar.gz
    [centos@jumpwjv folder1]$ du -sh file-dummy.tar.gz
    14G file-dummy.tar.gz
    [centos@jumpwjv folder1]$

##### 1 GB File Dummy

    [centos@jumpwjv folder1]$ sudo fallocate -l 1GB file-dummy01.tar.gz
    [centos@jumpwjv folder1]$ du -sh file-dummy01.tar.gz
    954M file-dummy01.tar.gz
    [centos@jumpwjv folder1]$

##### 100 MB File Dummy

    [centos@jumpwjv folder1]$ sudo fallocate -l 100M test-image-dummy.img
    [centos@jumpwjv folder1]$ du -sh test-image-dummy.img
    100M test-image-dummy.img
    [centos@jumpwjv folder1]$

<!--kg-card-end: markdown--><!--kg-card-begin: html--><script async src="https://pagead2.googlesyndication.com/pagead/js/adsbygoogle.js"></script><ins class="adsbygoogle" style="display:block; text-align:center;" data-ad-layout="in-article" data-ad-format="fluid" data-ad-client="ca-pub-1515372853161377" data-ad-slot="4684565489"></ins><script>
     (adsbygoogle = window.adsbygoogle || []).push({});
</script><!--kg-card-end: html-->

Itulah tutorial singkat mengenai cara membuat file dummy di Linux.

Selamat mencoba 😁


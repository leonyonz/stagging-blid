---
layout: post
title: 'Linux: Menggunakan Perintah Du (Disk Usage)'
featured: true
date: '2020-11-17 10:30:59'
tags:
- linux
- centos
- ubuntu
---

[Belajar Linux ID](/) - Perintah `du` merupakan kependekan dari `disk usage` dimana dapat kita gunakna untuk melihat jumlah ruang disk yang digunakan oleh file atau direktori tertentu. Perintah `du` sangatlah praktis dan sangat berguna untuk menemukan file dan direktori yang menghabiskan banyak ruang disk.

<!--kg-card-begin: html--><script async src="https://pagead2.googlesyndication.com/pagead/js/adsbygoogle.js"></script><ins class="adsbygoogle" style="display:block; text-align:center;" data-ad-layout="in-article" data-ad-format="fluid" data-ad-client="ca-pub-1515372853161377" data-ad-slot="4684565489"></ins><script>
     (adsbygoogle = window.adsbygoogle || []).push({});
</script><!--kg-card-end: html-->

Perintah `du` memiliki beberapa opsi yang dapat Anda gunakan, sebagai contoh

<!--kg-card-begin: markdown-->

    $ du [OPTIONS]... FILE...

<!--kg-card-end: markdown-->

Jika `FILE` yang diberikan adalah direktori, `du` akan meringkas penggunaan disk dari setiap file dan subdirektori dalam direktori tersebut. Jika `FILE` tidak ditentukan, du akan melaporkan penggunaan disk dari direktori saat ini.

Ketika dijalankan tanpa opsi apa pun, `du` menampilkan penggunaan disk dari file atau direktori yang diberikan dan setiap subdirektorinya dalam byte. contoh

<!--kg-card-begin: markdown-->

    [centos@jumpwjv ~]$
    [centos@jumpwjv ~]$ du
    40 ./.ssh
    8 ./.cache/pip/http/c/1/4/3/6
    8 ./.cache/pip/http/c/1/4/3
    8 ./.cache/pip/http/c/1/4
    8 ./.cache/pip/http/c/1
    88 ./.cache/pip/http/c/f/7/3/0
    88 ./.cache/pip/http/c/f/7/3
    88 ./.cache/pip/http/c/f/7
    16 ./.cache/pip/http/c/f/e/0/3
    16 ./.cache/pip/http/c/f/e/0
    16 ./.cache/pip/http/c/f/e

<!--kg-card-end: markdown-->

Jika ingin melihat spesifik size direktori juga dapat di lakukan contoh

<!--kg-card-begin: markdown-->

    [centos@jumpwjv ~]$ ll
    total 1920
    -rwxrwxr-x. 1 centos centos 230 Nov 5 19:28 detect-os.sh
    drwxr-xr-x. 2 root root 31 Nov 17 10:00 folder1
    drwxr-xr-x. 2 root root 31 Nov 17 10:00 folder2
    -rwxrwxr-x. 1 centos centos 65018 Sep 22 02:37 speedtest-cli
    [centos@jumpwjv ~]$
    [centos@jumpwjv ~]$ du folder1
    9765636 folder1
    [centos@jumpwjv ~]$

<!--kg-card-end: markdown-->

Anda juga dapat melihat size multiple direktori contoh

<!--kg-card-begin: html--><script async src="https://pagead2.googlesyndication.com/pagead/js/adsbygoogle.js"></script><ins class="adsbygoogle" style="display:block; text-align:center;" data-ad-layout="in-article" data-ad-format="fluid" data-ad-client="ca-pub-1515372853161377" data-ad-slot="4684565489"></ins><script>
     (adsbygoogle = window.adsbygoogle || []).push({});
</script><!--kg-card-end: html--><!--kg-card-begin: markdown-->

    [centos@jumpwjv ~]$
    [centos@jumpwjv ~]$ du folder1 folder2
    9765636 folder1
    9765632 folder2
    [centos@jumpwjv ~]$
    [centos@jumpwjv ~]$ du folder*
    9765636 folder1
    9765632 folder2
    [centos@jumpwjv ~]$

<!--kg-card-end: markdown-->

Perintah `du` memiliki banyak opsi yang dapat Anda gunakan, disini kami akan berikan opsi `du` yang sering digunakan

Opsi `-a` digunakan untuk melihat size dari file di dalam folder yang telah ditentukan

<!--kg-card-begin: markdown-->

    [centos@jumpwjv ~]$
    [centos@jumpwjv ~]$ du -a ~/folder1
    9765636 /home/centos/folder1/dummy-file.tar.gz
    102400 /home/centos/folder1/speed-test.img
    9868036 /home/centos/folder1
    [centos@jumpwjv ~]$

<!--kg-card-end: markdown-->

Biasanya, Anda hanya ingin menampilkan ruang yang ditempati oleh direktori tertentu dalam format yang dapat dibaca manusia. Untuk melakukan itu, gunakan opsi `-h`.

<!--kg-card-begin: html--><script async src="https://pagead2.googlesyndication.com/pagead/js/adsbygoogle.js"></script><ins class="adsbygoogle" style="display:block; text-align:center;" data-ad-layout="in-article" data-ad-format="fluid" data-ad-client="ca-pub-1515372853161377" data-ad-slot="1986938311"></ins><script>
     (adsbygoogle = window.adsbygoogle || []).push({});
</script><!--kg-card-end: html-->

Misalnya, untuk mendapatkan ukuran total `/var/lib` dan semua subdirektorinya, Anda akan menjalankan perintah berikut:

<!--kg-card-begin: markdown-->

    [centos@jumpwjv ~]$ du -h /var/lib/
    0 /var/lib/yum/repos/x86_64/7/base
    0 /var/lib/yum/repos/x86_64/7/extras
    0 /var/lib/yum/repos/x86_64/7/updates
    0 /var/lib/yum/repos/x86_64/7/epel
    0 /var/lib/yum/repos/x86_64/7
    0 /var/lib/yum/repos/x86_64
    0 /var/lib/yum/repos
    52K /var/lib/yum/yumdb/d/61b5ff426351369ebdf947ab1f6b46694f27cac7-diffutils-3.3-5.el7-x86_64
    36K /var/lib/yum/yumdb/d/717484391d537ebdff57733778fb8e9c43d2591a-dhcp-libs-4.2.5-82.el7.centos-x86_64
    20K /var/lib/yum/yumdb/d/1f6c77b9ad1179de5c4e7292494170e877903837-device-mapper-1.02.170-6.el7-x86_64

<!--kg-card-end: markdown-->

Jika ingin melihat size dari direktori `/var/lib` saja gunakan opsi `-sh` contohnya

<!--kg-card-begin: markdown-->

    [centos@jumpwjv ~]$ sudo du -sh /var/lib/
    137M /var/lib/
    [centos@jumpwjv ~]$
    [centos@jumpwjv ~]$ sudo du -sh /var/
    365M /var/
    [centos@jumpwjv ~]$

<!--kg-card-end: markdown-->

Opsi `-c` memberi tahu `du` untuk menginformasikan total keseluruhan.

<!--kg-card-begin: markdown-->

    [centos@jumpwjv ~]$ sudo du -csh /var/log /var/lib
    69M /var/log
    137M /var/lib
    206M total
    [centos@jumpwjv ~]$

<!--kg-card-end: markdown-->

Jika Anda ingin menampilkan penggunaan disk subdirektori level-n, gunakan opsi `--max-depth` dan tentukan level subdirektori. Misalnya, untuk mendapatkan report tentang direktori tingkat pertama

<!--kg-card-begin: markdown-->

    [centos@jumpwjv ~]$ sudo du -h --max-depth=1 /var/lib
    8.6M /var/lib/yum
    128M /var/lib/rpm
    24K /var/lib/alternatives
    0 /var/lib/games
    0 /var/lib/misc
    0 /var/lib/rpm-state
    4.0K /var/lib/logrotate
    [centos@jumpwjv ~]$

<!--kg-card-end: markdown-->

Perintah `du` juga dapat di kombinasikan dengan perintah lain di linux seperti `sort, head` dan yang lainnya.

<!--kg-card-begin: html--><script async src="https://pagead2.googlesyndication.com/pagead/js/adsbygoogle.js"></script><ins class="adsbygoogle" style="display:block; text-align:center;" data-ad-layout="in-article" data-ad-format="fluid" data-ad-client="ca-pub-1515372853161377" data-ad-slot="1986938311"></ins><script>
     (adsbygoogle = window.adsbygoogle || []).push({});
</script><!--kg-card-end: html-->

Berikut contoh bagaimana cara melihat 5 size direktori terbesar yang berada di direktori `/var/lib` dengan kombinasi perintah `sort dan head`

<!--kg-card-begin: markdown-->

    [centos@jumpwjv ~]$
    [centos@jumpwjv ~]$ sudo du -h /var/ | sort -rh | head -5
    365M /var/
    159M /var/cache
    158M /var/cache/yum/x86_64/7
    158M /var/cache/yum/x86_64
    158M /var/cache/yum
    [centos@jumpwjv ~]$

<!--kg-card-end: markdown-->

Jika ingin ke spesifik folder juga dapat dilakukan contoh nya

<!--kg-card-begin: markdown-->

    [centos@jumpwjv ~]$ cd folder1
    [centos@jumpwjv folder1]$
    [centos@jumpwjv folder1]$ du -hsx * | sort -rh
    9.4G dummy-file.tar.gz
    100M speed-test.img
    [centos@jumpwjv folder1]$

<!--kg-card-end: markdown-->

Selamat mencoba 😁


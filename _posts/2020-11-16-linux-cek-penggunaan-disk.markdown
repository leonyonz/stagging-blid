---
layout: post
title: 'Linux: Cek Penggunaan Disk'
featured: true
date: '2020-11-16 10:37:49'
tags:
- linux
---

[Belajar Linux ID](/) - Pada tutorial kali ini kita akan belajar bagaimana cara melakukan pengecekan terhadap penggunaan disk melalui terminal Linux. Untuk melakukan pengecekan disk dapat menggunakan perintah `df` dengan perintah ini kita dapat melihat secara detail report disk usage yang digunakan.

Secara general untuk perintah `df` seperti berikut:

<!--kg-card-begin: html--><script async src="https://pagead2.googlesyndication.com/pagead/js/adsbygoogle.js"></script><ins class="adsbygoogle" style="display:block; text-align:center;" data-ad-layout="in-article" data-ad-format="fluid" data-ad-client="ca-pub-1515372853161377" data-ad-slot="4684565489"></ins><script>
     (adsbygoogle = window.adsbygoogle || []).push({});
</script><!--kg-card-end: html--><!--kg-card-begin: markdown-->

    df [OPTIONS]... FILESYSTEM...

<!--kg-card-end: markdown-->

contohnya:

<!--kg-card-begin: markdown-->

    [centos@jumpwjv ~]$ df
    Filesystem 1K-blocks Used Available Use% Mounted on
    devtmpfs 917012 0 917012 0% /dev
    tmpfs 941004 0 941004 0% /dev/shm
    tmpfs 941004 110568 830436 12% /run
    tmpfs 941004 0 941004 0% /sys/fs/cgroup
    /dev/vda1 62903276 3276860 59626416 6% /
    tmpfs 188204 0 188204 0% /run/user/1000
    [centos@jumpwjv ~]$

<!--kg-card-end: markdown-->

Berikut keterangan dari beberapa bagian diatas

- **Filesystem** - Nama filesystem.
- **1K-blok** - Ukuran sistem file dalam 1K blok.
- **Used** - Ruang terpakai dalam 1K blok.
- **Available** - Ruang yang tersedia dalam 1K blok.
- **Use%** - Persentase ruang yang digunakan.
- **Mounted on** - direktori dari file system

Dengan menggunakan sintak `df` kita dapat melihat size secara spesifik ke file system misalnya ingin melihat penggunaan disk `(/)`, Anda dapat menjalankan sintak seperti berikut

<!--kg-card-begin: markdown-->

    [centos@jumpwjv ~]$ df /
    Filesystem 1K-blocks Used Available Use% Mounted on
    /dev/vda1 62903276 3276656 59626620 6% /
    [centos@jumpwjv ~]$

<!--kg-card-end: markdown-->

Secara default, perintah `df` menunjukkan ruang disk dalam blok `1-kilobyte` dan ukuran ruang disk yang digunakan dan tersedia dalam `kilobytes`.

<!--kg-card-begin: html--><script async src="https://pagead2.googlesyndication.com/pagead/js/adsbygoogle.js"></script><ins class="adsbygoogle" style="display:block; text-align:center;" data-ad-layout="in-article" data-ad-format="fluid" data-ad-client="ca-pub-1515372853161377" data-ad-slot="4684565489"></ins><script>
     (adsbygoogle = window.adsbygoogle || []).push({});
</script><!--kg-card-end: html-->

Untuk menampilkan informasi tentang `disk drive` dalam format yang dapat dibaca manusia `(kilobyte, megabyte, gigabyte, dan sebagainya)`, dapat dilakukan dengan cara menambahkan opsi `-h`, contohnya

<!--kg-card-begin: markdown-->

    [centos@jumpwjv ~]$ df -h
    Filesystem Size Used Avail Use% Mounted on
    devtmpfs 896M 0 896M 0% /dev
    tmpfs 919M 0 919M 0% /dev/shm
    tmpfs 919M 108M 811M 12% /run
    tmpfs 919M 0 919M 0% /sys/fs/cgroup
    /dev/vda1 60G 3.2G 57G 6% /
    tmpfs 184M 0 184M 0% /run/user/1000
    [centos@jumpwjv ~]$

<!--kg-card-end: markdown-->

Untuk melihat type `file system` dengan perintah `df` dapat di lakukan dengan menambahkan opsi `-T` contoh

<!--kg-card-begin: markdown-->

    [centos@jumpwjv ~]$ df -T
    Filesystem Type 1K-blocks Used Available Use% Mounted on
    devtmpfs devtmpfs 917012 0 917012 0% /dev
    tmpfs tmpfs 941004 0 941004 0% /dev/shm
    tmpfs tmpfs 941004 110568 830436 12% /run
    tmpfs tmpfs 941004 0 941004 0% /sys/fs/cgroup
    /dev/vda1 xfs 62903276 3276660 59626616 6% /
    tmpfs tmpfs 188204 0 188204 0% /run/user/1000
    [centos@jumpwjv ~]$

<!--kg-card-end: markdown-->

Jika Anda ingin melihat ke spesifik `file system` juga dapat dilakukan misal Anda ingin melihat `file system` `/devtmpfs/` saja

<!--kg-card-begin: markdown-->

    [centos@jumpwjv ~]$
    [centos@jumpwjv ~]$ df -T /dev/
    Filesystem Type 1K-blocks Used Available Use% Mounted on
    devtmpfs devtmpfs 917012 0 917012 0% /dev
    [centos@jumpwjv ~]$

<!--kg-card-end: markdown-->

Sebagai tambahan jika Anda ingin melihat `inode` dapat di lakukan.

`Inode` adalah struktur data dalam sistem file `Unix` dan `Linux`, yang berisi informasi tentang file atau direktori seperti `size, owner, device node, socket, pipe, etc., except da.`

<!--kg-card-begin: html--><script async src="https://pagead2.googlesyndication.com/pagead/js/adsbygoogle.js"></script><ins class="adsbygoogle" style="display:block; text-align:center;" data-ad-layout="in-article" data-ad-format="fluid" data-ad-client="ca-pub-1515372853161377" data-ad-slot="4684565489"></ins><script>
     (adsbygoogle = window.adsbygoogle || []).push({});
</script><!--kg-card-end: html-->

Perintah `df` juga dapat melihat `inode` dengan cara menambahkan opsi `-i` seperti berikut

<!--kg-card-begin: markdown-->

    [centos@jumpwjv ~]$ df -ih
    Filesystem Inodes IUsed IFree IUse% Mounted on
    devtmpfs 224K 302 224K 1% /dev
    tmpfs 230K 1 230K 1% /dev/shm
    tmpfs 230K 407 230K 1% /run
    tmpfs 230K 16 230K 1% /sys/fs/cgroup
    /dev/vda1 30M 79K 30M 1% /
    tmpfs 230K 1 230K 1% /run/user/1000
    [centos@jumpwjv ~]$

<!--kg-card-end: markdown-->

Ketika opsi `-i`digunakan, setiap baris output menyertakan kolom berikut:

- **Filesystem** - Nama filesystem.
- **Inode** - Jumlah total inode pada sistem file.
- **IUsed** - Jumlah inode yang digunakan.
- **IFree** - Jumlah inode free (tidak digunakan).
- **IUse%** - Persentase inode yang digunakan.
- **Mounted on** - direktori tempat sistem berkas dipasang.

Perintah `df` memungkinkan Anda menyesuaikan dengan format output yang Anda inginkan, untuk menentukan spesifik field output dapat dilakukan dengan opsi `--output[=FIELD_LIST` . `FIELD_LIST` adalah daftar kolom yang dipisahkan koma untuk disertakan dalam output. Setiap field hanya dapat digunakan sekali. Nama field yang valid sebagai berikut:

- **source** - Sumber sistem file.
- **fstype** - Jenis sistem file.
- **itotal** - Jumlah total inode.
- **iused** - Jumlah inode yang digunakan.
- **iavail** - Jumlah inode yang tersedia.
- **ipcent** - Persentase inode yang digunakan.
- **size** - Total ruang disk.
- **used** - Ruang disk yang digunakan.
- **avail** - Ruang disk yang tersedia.
- **pcent** - Persentase ruang yang digunakan.
- **file** - Nama file jika ditentukan pada baris perintah.
- **target** - Titik pemasangan.
<!--kg-card-begin: html--><script async src="https://pagead2.googlesyndication.com/pagead/js/adsbygoogle.js"></script><ins class="adsbygoogle" style="display:block; text-align:center;" data-ad-layout="in-article" data-ad-format="fluid" data-ad-client="ca-pub-1515372853161377" data-ad-slot="4684565489"></ins><script>
     (adsbygoogle = window.adsbygoogle || []).push({});
</script><!--kg-card-end: html-->

Sebagai contoh

<!--kg-card-begin: markdown-->

    [root@jumpwjv ~]# df -h /dev/ --output=source,size,pcent
    Filesystem Size Use%
    devtmpfs 896M 0%
    [root@jumpwjv ~]#

<!--kg-card-end: markdown-->

Sekian tutorial mengenai perintah `df` di Linux.

Selamat mencoba 😁


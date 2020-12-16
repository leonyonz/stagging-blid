---
layout: post
title: 'Linux: Cara Menggunakan Screen'
featured: true
date: '2020-11-11 16:29:28'
tags:
- ubuntu
- centos
- linux
---

[Belajar Linux ID](/) - Tutorial kali ini kita akan belajar tentang _screen_ di linux. Sebelum mengetahui tentang apa itu _screen_ kita akan memberikan sedikit cerita kenapa harus menggunakan _screen_?.

Sebagai seorang sysadmin mungkin Anda sudah pernah melakukan instalasi atau deployment service yang membutuhkan waktu berjam - jam dan menunggu sampai selesai karena takut koneksi ke SSH ke server putus karena beberapa faktor general yang sangat banyak? hmm ya penulis juga pernah mengalamin hal itu dan itu pengalaman yang sangat menyebalkan sekali bukan :).

Untuk mengatasi permasalahan diatas kita dapat memanfaatkan service _screen,_ dengan menggunakan _screen_ Anda dapat dengan santai dan tenang melakukan instalasi yang memakan waktu lama tanpa kebingungan lagi meskipun koneksi ataupun rumah Anda mati lampu dan koneksi SSH ke server mati.

Yaa, screen salah service atau utility yang dapat kita gunakan untuk melanjutkan sesi jika koneksi kita ke server putus. Dengan _screen_ Anda juga dapat melakukan aktivitas atau instalasi service yang lain secara bersamaan, karena _screen_ sendiri bersifat _Multiplexer terminal._

Sebelum lanjut ke bagaimana cara menggunakan _screen_ disini kami akan memberi tahu Anda bagaimana cara install _screen_ di OS Ubuntu dan CentOS, tenang ... instalasinya cukup satu perintah saja, berikut perintah nya

**#Ubuntu**

<!--kg-card-begin: markdown-->

    $ sudo apt update
    $ sudo apt install screen

<!--kg-card-end: markdown-->

**#CentOS**

<!--kg-card-begin: markdown-->

    $ sudo yum install screen

<!--kg-card-end: markdown-->

Untuk membuat _screen_ di linux Anda dapat menjalankan perintah `screen`

<figure class="kg-card kg-image-card kg-width-wide"><img src="/content/images/2020/11/image-1.png" class="kg-image" alt srcset="/content/images/size/w600/2020/11/image-1.png 600w, /content/images/2020/11/image-1.png 617w"></figure>

Output nya seperti berikut:

<figure class="kg-card kg-image-card kg-width-wide"><img src="/content/images/2020/11/image-2.png" class="kg-image" alt srcset="/content/images/size/w600/2020/11/image-2.png 600w, /content/images/2020/11/image-2.png 620w"></figure>

Untuk keluar dari _screen_ diatas gunakan perintah `exit`, output nya seperti berikut

<figure class="kg-card kg-image-card kg-width-wide"><img src="/content/images/2020/11/image-4.png" class="kg-image" alt srcset="/content/images/size/w600/2020/11/image-4.png 600w, /content/images/2020/11/image-4.png 620w"></figure>

Jika ingin membuat screen dengan identitas atau nama _screen_ tertentu Anda dapat gunakan opsi `-R` seperti berikut

<!--kg-card-begin: markdown-->

    $ screen -R "Screen Blinux 1"

<!--kg-card-end: markdown-->

Berikut outputnya

<figure class="kg-card kg-image-card kg-width-wide"><img src="/content/images/2020/11/image-5.png" class="kg-image" alt srcset="/content/images/size/w600/2020/11/image-5.png 600w, /content/images/2020/11/image-5.png 615w"></figure>

Lalu bagaimana cara keluar dari _screen_ tanpa terminate proses yang sedang berjalan di dalam _screen_?.

Anda dapat keluar atau _Detach_ screen dengan menekan tombol kombinasi _ **Ctrl + a + d** _ (tanpa +), nantinya proses yang berjalan di dalam screen akan berjalan atau di lanjutkan di background, sehingga Anda dapat melanjutkan task yang lainnya.

Untuk melihat daftar _screen_ gunakan perintah _`screen -ls`_

<figure class="kg-card kg-image-card kg-width-wide"><img src="/content/images/2020/11/image-6.png" class="kg-image" alt srcset="/content/images/size/w600/2020/11/image-6.png 600w, /content/images/2020/11/image-6.png 614w"></figure>

Seperti yang Anda lihat gambar diatas saat ini Anda sudah memiliki _screen_ yang sedang berjalan, jika Anda ingin login ke sisi _screen_ diatas Anda cukup menggunakan command `screen -r <ID-Screen>`

<figure class="kg-card kg-image-card"><img src="/content/images/2020/11/image-7.png" class="kg-image" alt srcset="/content/images/size/w600/2020/11/image-7.png 600w, /content/images/2020/11/image-7.png 617w"></figure>

Sekaran kita coba terminate sesi _screen_ atau keluar ke _screen_ gunakan perintah `exit`

<figure class="kg-card kg-image-card"><img src="/content/images/2020/11/image-8.png" class="kg-image" alt srcset="/content/images/size/w600/2020/11/image-8.png 600w, /content/images/2020/11/image-8.png 619w"></figure>

Hasilnya seperti pada gambar diatas dimana _screen_ sudah tidak ada lagi.

Berikut beberapa cheat sheet _screen_ yang dapat Anda coba

<!--kg-card-begin: markdown-->

| Command | Keterangan |
| --- | --- |
| screen -S [session-name] | start screen with session name |
| screen -r [pid-session] | reattach to screen session |
| screen -d [pid-session] | deattach to screen session |
| ctrl + a + c | create a new window (with shell) |
| ctrl + a + " | list all window |
| ctrl + a + A | rename the current screen window |

<!--kg-card-end: markdown-->

Itulah tutorial singkat mengenai _screen_ selamat mencoba 😁


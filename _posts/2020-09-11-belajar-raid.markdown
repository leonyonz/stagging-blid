---
layout: post
title: Belajar RAID
featured: true
date: '2020-09-11 23:51:59'
tags:
- centos
- raid
---

### Mengenal RAID

RAID adalah teknologi yang digunakan untuk meningkatkan kinerja dan / keandalan _(reability)_ dari sebuah penyimpanan data _(storage)_. RAID singkatan dari _Redundant Array of Independent Drives_ atau _Redundant Array of Inexpensive Disk_s. Sistem RAID terdiri dari dua atau lebih drive (storage) yang bekerja secara paralel. RAID juga mempunya tingkatan atau level yang berbeda – beda dan bisa di sesuaikan dengan kebutuhan.

### Tipe RAID

RAID mempunyai 3 tipe diantaranya

**# RAID Hardware**

RAID Hardware biasanya disebut dengan _controler hardware_ terdapat prosesor untuk pengelolaan perangkat RAID.  
  
Keuntungannya:

> – Performance  
> – Abstracting away complexity  
> – Availability at boot

Kerugiannya:

> – Vendor lock-in  
> – High cost

**# RAID Software**

Raid Software biasanya dikonfigurasi di sisi sistem operasi, dan untuk konfigurasinya bisa pada saat instalasi atau menggunakan pihak ketiga.

Keuntungannya:

> – Flexibility  
> – Open Source  
> **–** No additional costs

Kerugiannya:

> – spesific Implementation  
> – Performance overhead

**# RAID Hardware-Assisted Software**

Jenis RAID ini biasa disebuh dengan hardware-Assisted Software RAID, RAID firmware, atau Fake RAID. RAID ini biasanya ditemukan dalam fungsi RAID dalam motherboard atau dalam kartu RAID yang murah. Hardware-assisted software RAID sebuah implementasi yang menggunakan firmware pada pengontrol atau kartu untuk mengelola RAID, tetapi menggunakan CPU biasa untuk menangani pemrosesan.

Keuntungannya:

> – Multi-operating system support

Kerugiannya:

> – Limited RAID support (biasanya hanya tersedia untuk RAID0 dan RAID1)  
> – Requires specific hardware  
> – Performance overhead

### Level RAID

Berikut beberapa level RAID yang akan dibahas pada tutorial kali ini:RAID 0 – striping

- Level RAID 0 – striping
- Level RAID 1 – mirroring
- Level RAID 5 – striping with parity
- Level RAID 6 – striping with double parity
- Level RAID 10 – combining mirroring and striping

**# RAID 0 – Striping**

RAID 0 sebuah metode untuk menggabungkan beberapa drive menjadi seolah-olah menjadi 1 drive. Untuk implementasi RAID 0 minimal ada 2 drive. Sebagai contoh, ketika Anda mempunyai 2 drive, drive A = 50 GB dan drive B = 50 dan Anda konfigurasi RAID 0, maka ke 2 drive tersebut dijadikan 1 dalam 1 drive dengan ukurang 100GB.

<figure class="aligncenter size-large"><img loading="lazy" width="246" height="259" src="/content/images/wordpress/2020/09/image-57.png" alt="" class="wp-image-593"></figure>

Keutungan RAID 0

- RAID 0 menawarkan kinerja yang sangat bagus, baik dalam operasi baca dan tulis. Tidak ada overhead yang disebabkan oleh parity controls.
- Semua data penyimpanan digunakan dan tidak ada biaya tambahan
- RAID 0 mudah di implemenstasikan

Kerugian RAID 0

- RAID 0 tidak toleran terhadap kesalahan _(not fault-tolerant_), jika terdapat 1 drive bersasalah atau rusak, maka semua data di RAID 0 akan hilang dan tidak cocok digunakan untuk system yang sifatnya kritis _(mission-critical systems_).

**# RAID 1 – Mirroring**

Untuk RAID 1 sifat nya mirroring drive, untuk menggunakan RAID 1 minimal ada 2 drive dan nantinya setelah dikonfigurasi RAID 1, maka akan tetap menjadi satu drive, dan drive yang lain sebagai mirror atau redudansi.

<figure class="aligncenter size-large"><img loading="lazy" width="227" height="259" src="/content/images/wordpress/2020/09/image-58.png" alt="" class="wp-image-597"></figure>

Keuntungan RAID 1

- RAID 1 menawarkan kecepatan baca yang luar biasa dan kecepatan tulis yang sebanding dengan drive tunggal.
- Jika sebuah drive gagal, data tidak harus dibangun kembali, mereka hanya perlu disalin ke drive pengganti.
- RAID 1 salah satu teknologi yang sederhana dan mudah dalam implementasi

Kerugian RAID 1

- Kerugian utamanya adalah kapasitas penyimpanan efektif hanya setengah dari total kapasitas drive karena semua data ditulis dua kali.

**# RAID 5 – striping with parity**

Jika RAID 1 mirroring, untuk RAID 5 sifat nya redudansi atau didistribusikan ke semua drive. Minimum drive yang digunakan adalah 3 atau 4.

<figure class="aligncenter size-large"><img loading="lazy" width="373" height="270" src="/content/images/wordpress/2020/09/image-59.png" alt="" class="wp-image-598" srcset="/content/images/wordpress/2020/09/image-59.png 373w, /content/images/wordpress/2020/09/image-59-300x217.png 300w" sizes="(max-width: 373px) 100vw, 373px"></figure>

Kelebihan:

- Proses read data sangat cepat sedangkan proses write data agak lambat (karena parity yang harus dihitung/calculated).
- Jika salah satu drive gagal, Anda masih memiliki akses ke semua data, bahkan saat drive yang gagal diganti dan pengontrol penyimpanan akan membuat ulang data pada drive baru.

Kerugian:

- Kegagalan pada drive akan berpengaruh pada throughput, meskipun ini masih dapat diterima.
- RAID 5 adalah teknologi yang kompleks. Misalnya jika salah satu drive menggunakan size 4TB gagal dan diganti, pemulihan data (waktu rekondisi) dapat memakan waktu satu hari atau lebih, tergantung pada beban size dan kecepatan pengontrol. Jika drive lain rusak selama waktu itu, data akan hilang selamanya.

**# RAID 6 – striping with double parity**

RAID 6 hampir sama dengan RAID 5, hanya saja dua buah drive bisa saja down pada saat yang sama. Jumlah minimum drive yang dapat digunakan RAID 6 yaitu 4.

<figure class="aligncenter size-large"><img loading="lazy" width="374" height="272" src="/content/images/wordpress/2020/09/image-60.png" alt="" class="wp-image-599" srcset="/content/images/wordpress/2020/09/image-60.png 374w, /content/images/wordpress/2020/09/image-60-300x218.png 300w" sizes="(max-width: 374px) 100vw, 374px"></figure>

Kelebihan:

- Seperti RAID 5, proses read data sangat cepat.
- Jika dua drive gagal, Anda masih memiliki akses ke semua data, bahkan saat drive yang gagal diganti. Jadi RAID 6 lebih aman daripada RAID 5.

Kerugian:

- Proses read data lebih lambat dari RAID 5 karena data paruty tambahan yang harus dihitung. Dalam satu laporan membaca kinerja menulis 20% lebih rendah.
- Kegagalan drive berpengaruh pada throughput, meskipun ini masih dapat diterima.
- RAID 6 adalah teknologi yang kompleks. Membangun kembali array di mana satu drive gagal dapat memakan waktu lama.

**# RAID 10 – combining mirroring and striping**

RAID 10 merupakan kombinasi antara RAID 1 + RAID 0. Hasilnya RAID 10 dapat memberikan optimasi untuk toleransi kesalahan yang terjadi pada RAID 0 dan RAID 1. Dimana RAID 0 memiliki kecepatan yang lebih karena lebih banyak ruang dari dua hard disk yang dijadikan satu, sedangkan RAID 1 memberikan mirroring drive untuk redundansi. Harddisk yang bisa digunakan untuk RAID 10 minimalnya adalah 4 drive.

<figure class="aligncenter size-large"><img loading="lazy" width="369" height="265" src="/content/images/wordpress/2020/09/image-61.png" alt="" class="wp-image-600" srcset="/content/images/wordpress/2020/09/image-61.png 369w, /content/images/wordpress/2020/09/image-61-300x215.png 300w" sizes="(max-width: 369px) 100vw, 369px"></figure>

Kelebihan:

- Jika terjadi kesalahan dengan salah satu drive dalam konfigurasi RAID 10, waktu pembuatan ulang akan sangat cepat karena yang diperlukan hanyalah menyalin semua data dari mirror yang masih ada ke drive baru. Oleh karenanya waktu yang dibutuhkan sedikit 30 menit untuk hard disk 1 TB.

Kerugian:

- Separuh dari kapasitas penyimpanan digunakan untuk pencerminan, jadi dibandingkan dengan array RAID 5 atau RAID 6 yang besar, RAID 10 adalah cara yang tepat untuk memiliki redundansi.

### Apakah RAID 2, 3, 4 dan 7 Ada?

Level ini ada tetapi tidak begitu umum digunakan (RAID 3 pada dasarnya seperti RAID 5 tetapi dengan data parity selalu ditulis ke drive yang sama) bisa dibilang hanyalah pengenalan sederhana untuk sistem RAID. Anda dapat menemukan informasi detailnya melalui halaman **[Wikipedia](https://en.wikipedia.org/wiki/RAID)**atau **[ACNC](https://www.acnc.com/raid.php)**.

### Ingat !!! RAID Bukan Pengganti Backup (Cadangan)

Semua tingkatan atau level RAID kecuali RAID 0 menawarkan perlindungan dari kegagalan drive tunggal. Sistem RAID 6 bahkan bertahan dari 2 disk yang down secara bersamaan. Untuk keamanan lengkap, Anda masih perlu mencadangkan data yang disimpan di sistem RAID.

- Backup itu akan berguna jika semua drive gagal secara bersamaan karena lonjakan daya.
- Pengamanan jika ada sistem data yang hilang misal (dicuri)
- Backup dapat disimpan di luar lokasi atau di lokasi yang berbeda. Dan sangat berguna jika ada bencana alam atau kebakaran menghancurkan tempat penyimapanan data Anda.
- Alasan terpenting untuk melakukan backuup beberapa generasi data adalah kesalahan dari sisi pengguna (user). Jika seseorang secara tidak sengaja menghapus beberapa data penting dan ini tidak diketahui selama beberapa jam, hari, atau minggu, kumpulan backup yang baik memastikan Anda masih dapat mengambil file tersebut.

Itulah beberapa hal terkait RAID, jika terdapat pertanyaan silakan commend di kolom komentar ya 😁

Please follow and like us:

[![error](/wp-content/plugins/ultimate-social-media-icons/images/follow_subscribe.png)](https://api.follow.it/widgets/icon/VHc3d1lpVGdwRnE5QnV0eERCNUx5RCtvTTVoUkNYS3NNRmd5eVhlQW9tNXRHS3VTbGh6Y0NybkRJRS8zSGpjRDVZb1ZGMlNTSEpJYUpuZzZqNzdnd3VSN3dwM2VlQTF6ejJEaGV5UGRUbnlEcHFNd3luYTV4ZTZtUGowVWI2Q2x8M2kzdnBEeUIrUk5xOFI5TXZ3cHF3bFNQRkRJSGhUNGdrRFd0TlNtdE1OWT0=/OA==/)

[![fb-share-icon](/wp-content/plugins/ultimate-social-media-icons/images/visit_icons/fbshare_bck.png "Facebook Share")](https://www.facebook.com/sharer/sharer.php?u=https%3A%2F%2Fbelajarlinux.id%2F%3Fp%3D589%26ghostexport%3Dtrue%26submit%3DDownload+Ghost+File)

[![Tweet](/wp-content/plugins/ultimate-social-media-icons/images/visit_icons/en_US_Tweet.svg "Tweet")](https://twitter.com/intent/tweet?text=Belajar+RAID+https://belajarlinux.id/?p=589&ghostexport=true&submit=Download Ghost File)

[![fb-share-icon](/wp-content/plugins/ultimate-social-media-icons/images/share_icons/Pinterest_Save/en_US_save.svg "Pin Share")](#)

<!--kg-card-end: html-->
---
layout: post
title: Benchmark Disk/Volume Menggunakan FIO
featured: true
date: '2020-09-27 22:03:50'
tags:
- centos
- raid
- volume
---

Dalam sebuah disk kita akan menemukan istilah read dan write dimana proses read dan write ini sangat penting di ketahui seberapa cepat proses read dan write pada disk tersebut, terlebih jika kita menjalankan sebuah service yang membutuhkan read dan write yang sangat tinggi misalnya database dan masih banyak lagi lainnya.

Pada tutorial ini kita akan memberikan Anda cara bagaimana untuk mengetahui **Input/output operations per second** ( **IOPS** , pronounced _eye-ops_) pada disk menggunakan aplikasi FIO.

Flexible IO tester (FIO) merupakan tools open source yang dapat Anda gunakan secara free dalam artian bebas digunakan dan pertama kali dikembangkan oleh [Jens Axboe](https://en.wikipedia.org/wiki/Jens_Axboe).

FIO dapat menghasilkan berbagai beban kerja IO seperti: sequential reads atau random writes, synchronous atau asynchronous, semua dapat disesuaikan sesuai dengan opsi yang tersedia.

FIO adalah tools yang paling mudah dan serbaguna untuk melakukan uji kinerja IO dengan cepat pada sistem penyimpanan (disk), dan memungkinkan Anda untuk mensimulasikan berbagai jenis beban IO dan mengubah beberapa parameter, antara lain, write/read mix dan jumlah proses.

FIO sendiri dapat di install di berbagai jenis sistem operasi mulai dari Linux, FreeBSD, NetBSD, OS X, OpenSolaris, AIX, HP-UX, dan Windows.

Sebenarnya untuk melakukan pengukuran atau benchmark IOPS banyak tool – tool yang dapat Anda gunakan sepertihalnya _iozone, Bonnie++, IOmeter, Xbench, RawIo_ dan masih banyak lagi lainnya.

Ditutorial kali kami akan memberikan cara bagaimana install FIO di CentOS 8.

Secara default di CentOS 8 FIO sudah ada di default repostitory appstream, untuk melihatnya dapat menggunakan perintah berikut

    [root@raid-belajarlinux ~]#
    [root@raid-belajarlinux ~]# dnf info fio
    Last metadata expiration check: 0:01:23 ago on Sat 12 Sep 2020 04:46:07 PM UTC.
    Available Packages
    Name : fio
    Version : 3.7
    Release : 3.el8
    Architecture : x86_64
    Size : 498 k
    Source : fio-3.7-3.el8.src.rpm
    Repository : AppStream
    Summary : Multithreaded IO generation tool
    URL : http://git.kernel.dk/?p=fio.git;a=summary
    License : GPLv2
    Description : fio is an I/O tool that will spawn a number of threads or processes doing
                 : a particular type of io action as specified by the user. fio takes a
                 : number of global parameters, each inherited by the thread unless
                 : otherwise parameters given to them overriding that setting is given.
                 : The typical use of fio is to write a job file matching the io load
                 : one wants to simulate.
    
    [root@raid-belajarlinux ~]#

Untuk melakukan instalasi FIO Anda di CentOS 8 Anda hanya perlu menjalankan satu bari perintah berikut

    [root@raid-belajarlinux ~]#
    [root@raid-belajarlinux ~]# dnf install fio -y

Sebagai bahan uji coba disini kami sudah menyiapkan RAID 10 yang akan kita benchmark menggunakan FIO.

Bagi Anda yang ingin mengetahui RAID dan cara membuat RAID dapat mempelajarinya pada link berikut:

- **_[Belajar RAID](/belajar-raid/)_**
- **_[Membuat RAID di CentOS 8](/belajar-raid/)_**

Dalam benchmark kali ini kita akan menggunakan beberapa metode pengukurangan diantaranya

- Read
- Write
- Read dan Write
- Random Read
- Random Write
- Random Read dan Write

Detailnya sebagai berikut:

### _– Read_

    [root@raid-belajarlinux home]# time fio --randrepeat=1 --ioengine=libaio --direct=1 --gtod_reduce=1 --name=read-raid10 --filename=foo-$(date +"%Y%m%d%H%M%S") --bs=4k --iodepth=256 --size=2G --readwrite=read

Output :

    read-raid10: Laying out IO file (1 file / 2048MiB)
    Jobs: 1 (f=1): [R(1)][100.0%][r=17.7MiB/s,w=0KiB/s][r=4520,w=0 IOPS][eta 00m:00s]
    read-raid10: (groupid=0, jobs=1): err= 0: pid=5171: Sat Sep 12 18:40:32 2020
       read: IOPS=4672, BW=18.3MiB/s (19.1MB/s)(2048MiB/112212msec)
       bw ( KiB/s): min=16167, max=26152, per=100.00%, avg=18691.08, stdev=1003.02, samples=224
       iops : min= 4041, max= 6538, avg=4672.73, stdev=250.75, samples=224
      cpu : usr=1.94%, sys=7.23%, ctx=291554, majf=0, minf=264
      IO depths : 1=0.1%, 2=0.1%, 4=0.1%, 8=0.1%, 16=0.1%, 32=0.1%, >=64=100.0%
         submit : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
         complete : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.1%
         issued rwts: total=524288,0,0,0 short=0,0,0,0 dropped=0,0,0,0
         latency : target=0, window=0, percentile=100.00%, depth=256
    
    Run status group 0 (all jobs):
       READ: bw=18.3MiB/s (19.1MB/s), 18.3MiB/s-18.3MiB/s (19.1MB/s-19.1MB/s), io=2048MiB (2147MB), run=112212-112212msec
    
    Disk stats (read/write):
        md0: ios=523972/5, merge=0/0, ticks=0/0, in_queue=0, util=0.00%, aggrios=126251/8, aggrmerge=4820/0, aggrticks=6608786/33, aggrin_queue=6544688, aggrutil=89.10%
      vdd: ios=126320/6, merge=4596/0, ticks=6598565/27, in_queue=6534487, util=78.81%
      vdb: ios=126672/10, merge=4704/1, ticks=6576507/47, in_queue=6510277, util=86.15%
      vde: ios=126401/6, merge=4827/0, ticks=6622604/18, in_queue=6560706, util=88.63%
      vdc: ios=125613/10, merge=5155/1, ticks=6637469/40, in_queue=6573283, util=89.10%
    
    real 2m7.977s
    user 0m3.165s
    sys 0m10.398s

### _– Write_

    [root@raid-belajarlinux home]# time fio --randrepeat=1 --ioengine=libaio --direct=1 --gtod_reduce=1 --name=write-raid10 --filename=foo-$(date +"%Y%m%d%H%M%S") --bs=4k --iodepth=256 --size=2G --readwrite=write

Output :

    write-raid10: (g=0): rw=write, bs=(R) 4096B-4096B, (W) 4096B-4096B, (T) 4096B-4096B, ioengine=libaio, iodepth=256
    fio-3.7
    Starting 1 process
    write-raid10: Laying out IO file (1 file / 2048MiB)
    Jobs: 1 (f=1): [W(1)][100.0%][r=0KiB/s,w=11.1MiB/s][r=0,w=2836 IOPS][eta 00m:00s]
    write-raid10: (groupid=0, jobs=1): err= 0: pid=5175: Sat Sep 12 18:44:32 2020
      write: IOPS=2532, BW=9.89MiB/s (10.4MB/s)(2048MiB/206991msec)
       bw ( KiB/s): min= 128, max=22538, per=100.00%, avg=10502.60, stdev=2459.71, samples=398
       iops : min= 32, max= 5634, avg=2625.62, stdev=614.92, samples=398
      cpu : usr=1.13%, sys=5.61%, ctx=220457, majf=0, minf=7
      IO depths : 1=0.1%, 2=0.1%, 4=0.1%, 8=0.1%, 16=0.1%, 32=0.1%, >=64=100.0%
         submit : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
         complete : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.1%
         issued rwts: total=0,524288,0,0 short=0,0,0,0 dropped=0,0,0,0
         latency : target=0, window=0, percentile=100.00%, depth=256
    
    Run status group 0 (all jobs):
      WRITE: bw=9.89MiB/s (10.4MB/s), 9.89MiB/s-9.89MiB/s (10.4MB/s-10.4MB/s), io=2048MiB (2147MB), run=206991-206991msec
    
    Disk stats (read/write):
        md0: ios=0/524006, merge=0/0, ticks=0/0, in_queue=0, util=0.00%, aggrios=0/230451, aggrmerge=0/31837, aggrticks=0/19680275, aggrin_queue=19564894, aggrutil=48.60%
      vdd: ios=0/232193, merge=0/30088, ticks=0/19858900, in_queue=19742246, util=48.38%
      vdb: ios=0/229849, merge=0/32448, ticks=0/19628884, in_queue=19514061, util=47.85%
      vde: ios=0/231560, merge=0/30721, ticks=0/19549988, in_queue=19434021, util=48.00%
      vdc: ios=0/228203, merge=0/34094, ticks=0/19683330, in_queue=19569248, util=48.60%
    
    real 3m27.682s
    user 0m2.836s
    sys 0m12.571s

### _– Read dan Write_

    [root@raid-belajarlinux home]# time fio --randrepeat=1 --ioengine=libaio --direct=1 --gtod_reduce=1 --name=read-write-raid10 --filename=foo-$(date +"%Y%m%d%H%M%S") --bs=4k --iodepth=256 --size=2G --readwrite=rw

Output

    read-write-raid10: Laying out IO file (1 file / 2048MiB)
    Jobs: 1 (f=1): [M(1)][100.0%][r=5624KiB/s,w=5392KiB/s][r=1406,w=1348 IOPS][eta 00m:00s]
    read-write-raid10: (groupid=0, jobs=1): err= 0: pid=5438: Sat Sep 12 18:52:28 2020
       read: IOPS=1351, BW=5407KiB/s (5537kB/s)(1023MiB/193783msec)
       bw ( KiB/s): min= 8, max=13852, per=100.00%, avg=5967.37, stdev=2558.51, samples=351
       iops : min= 2, max= 3463, avg=1491.82, stdev=639.63, samples=351
      write: IOPS=1353, BW=5415KiB/s (5545kB/s)(1025MiB/193783msec)
       bw ( KiB/s): min= 8, max=14411, per=100.00%, avg=5957.63, stdev=2492.54, samples=352
       iops : min= 2, max= 3602, avg=1489.38, stdev=623.13, samples=352
      cpu : usr=1.06%, sys=4.39%, ctx=153011, majf=0, minf=9
      IO depths : 1=0.1%, 2=0.1%, 4=0.1%, 8=0.1%, 16=0.1%, 32=0.1%, >=64=100.0%
         submit : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
         complete : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.1%
         issued rwts: total=261946,262342,0,0 short=0,0,0,0 dropped=0,0,0,0
         latency : target=0, window=0, percentile=100.00%, depth=256
    
    Run status group 0 (all jobs):
       READ: bw=5407KiB/s (5537kB/s), 5407KiB/s-5407KiB/s (5537kB/s-5537kB/s), io=1023MiB (1073MB), run=193783-193783msec
      WRITE: bw=5415KiB/s (5545kB/s), 5415KiB/s-5415KiB/s (5545kB/s-5545kB/s), io=1025MiB (1075MB), run=193783-193783msec
    
    Disk stats (read/write):
        md0: ios=261946/262454, merge=0/0, ticks=0/0, in_queue=0, util=0.00%, aggrios=62032/123144, aggrmerge=3453/8120, aggrticks=2604017/6718191, aggrin_queue=9229167, aggrutil=36.65%
      vdd: ios=65528/122202, merge=3529/8977, ticks=2457835/6687857, in_queue=9051283, util=36.45%
      vdb: ios=65856/123128, merge=3456/8221, ticks=3279452/7234738, in_queue=10418854, util=36.65%
      vde: ios=58309/123236, merge=3578/7943, ticks=2362992/6454739, in_queue=8726414, util=35.57%
      vdc: ios=58438/124010, merge=3252/7339, ticks=2315790/6495433, in_queue=8720118, util=36.09%
    
    real 3m24.341s
    user 0m3.240s
    sys 0m11.064s

### _– Random Read_

    [root@raid-belajarlinux home]# time fio --randrepeat=1 --ioengine=libaio --direct=1 --gtod_reduce=1 --name=ran-read-raid10 --filename=foo-$(date +"%Y%m%d%H%M%S") --bs=4k --iodepth=256 --size=2G --readwrite=randread

Output:

    ran-read-raid10: Laying out IO file (1 file / 2048MiB)
    Jobs: 1 (f=1): [r(1)][100.0%][r=15.6MiB/s,w=0KiB/s][r=4004,w=0 IOPS][eta 00m:00s]
    ran-read-raid10: (groupid=0, jobs=1): err= 0: pid=5447: Sat Sep 12 18:57:37 2020
       read: IOPS=3986, BW=15.6MiB/s (16.3MB/s)(2048MiB/131510msec)
       bw ( KiB/s): min=13088, max=19120, per=99.95%, avg=15937.24, stdev=472.28, samples=263
       iops : min= 3272, max= 4780, avg=3984.29, stdev=118.08, samples=263
      cpu : usr=1.97%, sys=6.95%, ctx=381568, majf=0, minf=265
      IO depths : 1=0.1%, 2=0.1%, 4=0.1%, 8=0.1%, 16=0.1%, 32=0.1%, >=64=100.0%
         submit : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
         complete : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.1%
         issued rwts: total=524288,0,0,0 short=0,0,0,0 dropped=0,0,0,0
         latency : target=0, window=0, percentile=100.00%, depth=256
    
    Run status group 0 (all jobs):
       READ: bw=15.6MiB/s (16.3MB/s), 15.6MiB/s-15.6MiB/s (16.3MB/s-16.3MB/s), io=2048MiB (2147MB), run=131510-131510msec
    
    Disk stats (read/write):
        md0: ios=524288/5, merge=0/0, ticks=0/0, in_queue=0, util=0.00%, aggrios=130792/8, aggrmerge=279/0, aggrticks=8355840/64, aggrin_queue=8291070, aggrutil=93.24%
      vdd: ios=131270/8, merge=570/1, ticks=9352521/30, in_queue=9286960, util=91.43%
      vdb: ios=131511/8, merge=512/0, ticks=17447342/126, in_queue=17382049, util=93.24%
      vde: ios=130267/8, merge=37/1, ticks=4185851/69, in_queue=4121947, util=84.29%
      vdc: ios=130121/8, merge=0/0, ticks=2437648/34, in_queue=2373325, util=83.80%
    
    real 2m20.839s
    user 0m3.544s
    sys 0m11.538s

### _– Random Write_

    [root@raid-belajarlinux home]# time fio --randrepeat=1 --ioengine=libaio --direct=1 --gtod_reduce=1 --name=ran-write-raid10 --filename=foo-$(date +"%Y%m%d%H%M%S") --bs=4k --iodepth=256 --size=2G --readwrite=write

Output:

    ran-write-raid10: Laying out IO file (1 file / 2048MiB)
    Jobs: 1 (f=1): [W(1)][100.0%][r=0KiB/s,w=11.2MiB/s][r=0,w=2865 IOPS][eta 00m:00s]
    ran-write-raid10: (groupid=0, jobs=1): err= 0: pid=5464: Sat Sep 12 19:05:23 2020
      write: IOPS=2399, BW=9596KiB/s (9827kB/s)(2048MiB/218539msec)
       bw ( KiB/s): min= 8, max=23192, per=100.00%, avg=10222.53, stdev=2904.50, samples=410
       iops : min= 2, max= 5798, avg=2555.60, stdev=726.12, samples=410
      cpu : usr=1.07%, sys=5.35%, ctx=228580, majf=0, minf=8
      IO depths : 1=0.1%, 2=0.1%, 4=0.1%, 8=0.1%, 16=0.1%, 32=0.1%, >=64=100.0%
         submit : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
         complete : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.1%
         issued rwts: total=0,524288,0,0 short=0,0,0,0 dropped=0,0,0,0
         latency : target=0, window=0, percentile=100.00%, depth=256
    
    Run status group 0 (all jobs):
      WRITE: bw=9596KiB/s (9827kB/s), 9596KiB/s-9596KiB/s (9827kB/s-9827kB/s), io=2048MiB (2147MB), run=218539-218539msec
    
    Disk stats (read/write):
        md0: ios=0/524500, merge=0/0, ticks=0/0, in_queue=0, util=0.00%, aggrios=0/230537, aggrmerge=0/31757, aggrticks=0/20008704, aggrin_queue=19893271, aggrutil=47.81%
      vdd: ios=0/230813, merge=0/31478, ticks=0/20217793, in_queue=20102088, util=47.81%
      vdb: ios=0/231339, merge=0/30958, ticks=0/19141212, in_queue=19025410, util=47.31%
      vde: ios=0/229710, merge=0/32581, ticks=0/20093190, in_queue=19978204, util=46.80%
      vdc: ios=0/230286, merge=0/32011, ticks=0/20582621, in_queue=20467384, util=46.70%
    
    real 3m39.203s
    user 0m2.844s
    sys 0m12.701s

### _– Random Read dan Write_

    [root@raid-belajarlinux home]# time fio --randrepeat=1 --ioengine=libaio --direct=1 --gtod_reduce=1 --name=ran-read-write-raid10 --filename=foo-$(date +"%Y%m%d%H%M%S") --bs=4k --iodepth=256 --size=2G --readwrite=randrw --rwmixread=50

    ran-read-write-raid10: Laying out IO file (1 file / 2048MiB)
    Jobs: 1 (f=1): [m(1)][100.0%][r=2504KiB/s,w=3092KiB/s][r=626,w=773 IOPS][eta 00m:00s]
    ran-read-write-raid10: (groupid=0, jobs=1): err= 0: pid=5726: Sat Sep 12 19:19:55 2020
       read: IOPS=752, BW=3011KiB/s (3083kB/s)(1023MiB/347975msec)
       bw ( KiB/s): min= 8, max= 8440, per=100.00%, avg=4265.32, stdev=2149.69, samples=491
       iops : min= 2, max= 2110, avg=1066.31, stdev=537.43, samples=491
      write: IOPS=753, BW=3016KiB/s (3088kB/s)(1025MiB/347975msec)
       bw ( KiB/s): min= 8, max= 7369, per=100.00%, avg=4262.79, stdev=1865.44, samples=492
       iops : min= 2, max= 1842, avg=1065.67, stdev=466.36, samples=492
      cpu : usr=0.78%, sys=3.12%, ctx=278511, majf=0, minf=7
      IO depths : 1=0.1%, 2=0.1%, 4=0.1%, 8=0.1%, 16=0.1%, 32=0.1%, >=64=100.0%
         submit : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
         complete : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.1%
         issued rwts: total=261946,262342,0,0 short=0,0,0,0 dropped=0,0,0,0
         latency : target=0, window=0, percentile=100.00%, depth=256
    
    Run status group 0 (all jobs):
       READ: bw=3011KiB/s (3083kB/s), 3011KiB/s-3011KiB/s (3083kB/s-3083kB/s), io=1023MiB (1073MB), run=347975-347975msec
      WRITE: bw=3016KiB/s (3088kB/s), 3016KiB/s-3016KiB/s (3088kB/s-3088kB/s), io=1025MiB (1075MB), run=347975-347975msec
    
    Disk stats (read/write):
        md0: ios=261946/262496, merge=0/0, ticks=0/0, in_queue=0, util=0.00%, aggrios=65467/131152, aggrmerge=19/147, aggrticks=1513859/15480509, aggrin_queue=16895634, aggrutil=37.86%
      vdd: ios=66842/131092, merge=22/185, ticks=1675458/17174399, in_queue=18750337, util=37.68%
      vdb: ios=66887/131206, merge=17/115, ticks=1715115/17420538, in_queue=19036201, util=37.86%
      vde: ios=64160/131114, merge=22/163, ticks=1020779/12644879, in_queue=13567829, util=36.98%
      vdc: ios=63979/131196, merge=17/125, ticks=1644087/14682222, in_queue=16228171, util=37.14%
    
    real 6m1.829s
    user 0m4.158s
    sys 0m14.078s

_Keterangan: Dari output di masing – masing percobaan diatas kita dapat menyimpulkan dan dapat melihat secara detail berapa besar IOPS yang kita dapatkan, bandwith yang kita butuhkan dan besaran CPU yang akan digunakan dalam proses berlangsung serta disk stats dan masih banyak lagi lainnya._

Detail lebih lanjut mengenai FIO Anda dapat mempelajarinya pada link berikut: https://fio.readthedocs.io/en/latest/fio\_doc.html

Jika terdapat pertanyaan silakan tulis di kolom komentar ya \*-\*

Selamat mencoba 😁

Please follow and like us:

[![error](/wp-content/plugins/ultimate-social-media-icons/images/follow_subscribe.png)](https://api.follow.it/widgets/icon/VHc3d1lpVGdwRnE5QnV0eERCNUx5RCtvTTVoUkNYS3NNRmd5eVhlQW9tNXRHS3VTbGh6Y0NybkRJRS8zSGpjRDVZb1ZGMlNTSEpJYUpuZzZqNzdnd3VSN3dwM2VlQTF6ejJEaGV5UGRUbnlEcHFNd3luYTV4ZTZtUGowVWI2Q2x8M2kzdnBEeUIrUk5xOFI5TXZ3cHF3bFNQRkRJSGhUNGdrRFd0TlNtdE1OWT0=/OA==/)

[![fb-share-icon](/wp-content/plugins/ultimate-social-media-icons/images/visit_icons/fbshare_bck.png "Facebook Share")](https://www.facebook.com/sharer/sharer.php?u=https%3A%2F%2Fbelajarlinux.id%2F%3Fp%3D615%26ghostexport%3Dtrue%26submit%3DDownload+Ghost+File)

[![Tweet](/wp-content/plugins/ultimate-social-media-icons/images/visit_icons/en_US_Tweet.svg "Tweet")](https://twitter.com/intent/tweet?text=Benchmark+Disk%2FVolume+Menggunakan+FIO+https://belajarlinux.id/?p=615&ghostexport=true&submit=Download Ghost File)

[![fb-share-icon](/wp-content/plugins/ultimate-social-media-icons/images/share_icons/Pinterest_Save/en_US_save.svg "Pin Share")](#)

<!--kg-card-end: html-->
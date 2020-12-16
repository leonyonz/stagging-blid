---
layout: post
title: Membuat RAID di CentOS 8
featured: true
date: '2020-09-12 21:47:15'
tags:
- centos
- raid
---

Pada tutorial sebelumnya, kita sudah belajar mengenai RAID berikut: [Belajar RAID](/belajar-raid/)

Dan pada tutorial kali ini kita akan mencoba bagaimana cara membuat RAID yang sudah kita pelajari sebelumnya. Untuk membuat RAID bisa menggunakan service _mdadm_ oleh karena itu kita perlu install terlebih dahulu _mdadm_ di CentOS 8.

Di CentOS 8 _mdadm_ sudah tersedia secara default di repository berikut

    [root@raid-belajarlinux ~]# dnf info mdadm
    Last metadata expiration check: 0:12:32 ago on Sat 12 Sep 2020 11:45:54 AM UTC.
    Available Packages
    Name : mdadm
    Version : 4.1
    Release : 13.el8
    Architecture : x86_64
    Size : 453 k
    Source : mdadm-4.1-13.el8.src.rpm
    Repository : BaseOS
    Summary : The mdadm program controls Linux md devices (software RAID arrays)
    URL : http://www.kernel.org/pub/linux/utils/raid/mdadm/
    License : GPLv2+
    Description : The mdadm program is used to create, manage, and monitor Linux MD (software
                 : RAID) devices. As such, it provides similar functionality to the raidtools
                 : package. However, mdadm is a single program, and it can perform
                 : almost all functions without a configuration file, though a configuration
                 : file can be used to help with some common tasks.
    
    [root@raid-belajarlinux ~]#

Untuk instalasi _mdadm_ di CentOS 8 jalankan perintah berikut

    [root@raid-belajarlinux ~]#
    [root@raid-belajarlinux ~]# dnf install mdadm -y

Cek versi _mdadm_

    [root@raid-belajarlinux ~]#
    [root@raid-belajarlinux ~]# mdadm --version
    mdadm - v4.1 - 2018-10-01
    [root@raid-belajarlinux ~]#

Selanjutnya terdapat 5 level RAID yang akan kita buat pada tutorial ini yaitu level RAID 0, 1, 5, 6 dan 10, sebelum membuat RAID perlu di ketahui pada tutorial kali ini kami akan memberi tahu cara membuat masing – masing RAID dan diakhir akan dibahas bagaimana cara menggunakan RAID misalnya RAID 10 kita jadikan sebagai Ext4 dan di mounting misalnya ke _ **home.** _

### Level RAID 0

Untuk membuat RAID 0 kita minimal mempunyai 2 disk/volume/storage

<figure class="wp-block-table"><table><tbody>
<tr>
<td class="has-text-align-center" data-align="center">Nama Volume</td>
<td class="has-text-align-center" data-align="center">Size Volume</td>
</tr>
<tr>
<td class="has-text-align-center" data-align="center">vdb</td>
<td class="has-text-align-center" data-align="center">10 GB</td>
</tr>
<tr>
<td class="has-text-align-center" data-align="center">vdc</td>
<td class="has-text-align-center" data-align="center">10 GB</td>
</tr>
</tbody></table></figure>

Gunakna perintah berikut untuk melihat volume yang sudah di attach ke Instance/VM

    [root@raid-belajarlinux ~]#
    [root@raid-belajarlinux ~]# lsblk -o NAME,SIZE,FSTYPE,TYPE,MOUNTPOINT
    NAME SIZE FSTYPE TYPE MOUNTPOINT
    vda 60G disk
    └─vda1 60G xfs part /
    vdb 10G disk
    vdc 10G disk
    [root@raid-belajarlinux ~]#

Untuk membuat RAID 0 jalankan perintah berikut

    [root@raid-belajarlinux ~]#
    [root@raid-belajarlinux ~]# mdadm --create --verbose /dev/md0 --level=0 --raid-devices=2 /dev/vdb /dev/vdc
    mdadm: chunk size defaults to 512K
    mdadm: Defaulting to version 1.2 metadata
    mdadm: array /dev/md0 started.
    [root@raid-belajarlinux ~]#

_Noted: Perhatikan nama volume sesuai_

Cek RAID 0 yang sudah kita buat

    
    [root@raid-belajarlinux ~]#
    [root@raid-belajarlinux ~]# cat /proc/mdstat
    Personalities : [raid0]
    md0 : active raid0 vdc[1] vdb[0]
          20953088 blocks super 1.2 512k chunks
    
    unused devices: <none>
    [root@raid-belajarlinux ~]#

Cek volume RAID 0

    [root@raid-belajarlinux ~]#
    [root@raid-belajarlinux ~]# lsblk -o NAME,SIZE,FSTYPE,TYPE,MOUNTPOINT
    NAME SIZE FSTYPE TYPE MOUNTPOINT
    vda 60G disk
    └─vda1 60G xfs part /
    vdb 10G linux_raid_member disk
    └─md0 20G raid0
    vdc 10G linux_raid_member disk
    └─md0 20G raid0
    [root@raid-belajarlinux ~]#

### Level RAID 1

Untuk membuat RAID 1 hampir sama dengan membuat RAID 0 dimana Anda hanya perlu menyesuaikan level dan banyak nya volume yang ingin Anda gunakan, untuk RAID 1 minimal 2 volume

<figure class="wp-block-table"><table><tbody>
<tr>
<td class="has-text-align-center" data-align="center">Nama Volume</td>
<td class="has-text-align-center" data-align="center">Size Volume</td>
</tr>
<tr>
<td class="has-text-align-center" data-align="center">vdb</td>
<td class="has-text-align-center" data-align="center">10 GB</td>
</tr>
<tr>
<td class="has-text-align-center" data-align="center">vdc</td>
<td class="has-text-align-center" data-align="center">10 GB</td>
</tr>
</tbody></table></figure>

Silakan cek volume menggunakan perintah berikut

    [root@raid-belajarlinux ~]# lsblk -o NAME,SIZE,FSTYPE,TYPE,MOUNTPOINT
    NAME SIZE FSTYPE TYPE MOUNTPOINT
    vda 60G disk
    └─vda1 60G xfs part /
    vdb 10G disk
    vdc 10G disk
    [root@raid-belajarlinux ~]#

Jalankan perintah berikut, untuk membuat RAID 1

    [root@raid-belajarlinux ~]#
    [root@raid-belajarlinux ~]# mdadm --create --verbose /dev/md0 --level=1 --raid-devices=2 /dev/vdb /dev/vdc
    mdadm: Note: this array has metadata at the start and
        may not be suitable as a boot device. If you plan to
        store '/boot' on this device please ensure that
        your boot-loader understands md/v1.x metadata, or use
        --metadata=0.90
    mdadm: size set to 10476544K
    Continue creating array? y
    mdadm: Defaulting to version 1.2 metadata
    mdadm: array /dev/md0 started.
    [root@raid-belajarlinux ~]#

Jika sudah silakan cek RAID 1 yang sudah dibuat, perlu diketahui untuk RAID 1 memerlukan waktu resync antar volume

    [root@raid-belajarlinux ~]#
    [root@raid-belajarlinux ~]# cat /proc/mdstat
    Personalities : [raid0] [raid1]
    md0 : active raid1 vdc[1] vdb[0]
          10476544 blocks super 1.2 [2/2] [UU]
          [=======>.............] resync = 37.7% (3960768/10476544) finish=1.3min speed=82517K/sec
    
    unused devices: <none>
    [root@raid-belajarlinux ~]#

Cek status RAID 1

    
    [root@raid-belajarlinux ~]#
    [root@raid-belajarlinux ~]# cat /proc/mdstat
    Personalities : [raid0] [raid1]
    md0 : active raid1 vdc[1] vdb[0]
          10476544 blocks super 1.2 [2/2] [UU]
    
    unused devices: <none>
    [root@raid-belajarlinux ~]#

Cek status volume RAID 1

    [root@raid-belajarlinux ~]#
    [root@raid-belajarlinux ~]# lsblk -o NAME,SIZE,FSTYPE,TYPE,MOUNTPOINT
    NAME SIZE FSTYPE TYPE MOUNTPOINT
    vda 60G disk
    └─vda1 60G xfs part /
    vdb 10G linux_raid_member disk
    └─md0 10G raid1
    vdc 10G linux_raid_member disk
    └─md0 10G raid1
    [root@raid-belajarlinux ~]#

### Level RAID 5

Untuk membuat RAID 5 kita perlu memiliki minimal 3 disk/volume yang sudah ter-attach ke sisi instance

<figure class="wp-block-table"><table><tbody>
<tr>
<td class="has-text-align-center" data-align="center">Nama Volume</td>
<td class="has-text-align-center" data-align="center">Size Volume</td>
</tr>
<tr>
<td class="has-text-align-center" data-align="center">vdb</td>
<td class="has-text-align-center" data-align="center">10 GB</td>
</tr>
<tr>
<td class="has-text-align-center" data-align="center">vdc</td>
<td class="has-text-align-center" data-align="center">10 GB</td>
</tr>
<tr>
<td class="has-text-align-center" data-align="center">vdd</td>
<td class="has-text-align-center" data-align="center">10 GB</td>
</tr>
</tbody></table></figure>

Untuk melihat volume yang sudah ter-attach gunakan perintah berikut

    [root@raid-belajarlinux ~]#
    [root@raid-belajarlinux ~]# lsblk -o NAME,SIZE,FSTYPE,TYPE,MOUNTPOINT
    NAME SIZE FSTYPE TYPE MOUNTPOINT
    vda 60G disk
    └─vda1 60G xfs part /
    vdb 10G disk
    vdc 10G disk
    vdd 10G disk
    [root@raid-belajarlinux ~]#

Untuk membuat RAID 5 jalankan perintah berikut, silakan sesuaikan level, dan nama volume Anda

    [root@raid-belajarlinux ~]# mdadm --create --verbose /dev/md0 --level=5 --raid-devices=3 /dev/vdb /dev/vdc /dev/vdd
    mdadm: layout defaults to left-symmetric
    mdadm: layout defaults to left-symmetric
    mdadm: chunk size defaults to 512K
    mdadm: size set to 10476544K
    mdadm: Defaulting to version 1.2 metadata
    mdadm: array /dev/md0 started.
    [root@raid-belajarlinux ~]#

Selanjutnya cek RAID yang kita buat, untuk RAID 5 memerlukan waktu resync antar disk/volume.

    [root@raid-belajarlinux ~]#
    [root@raid-belajarlinux ~]# cat /proc/mdstat
    Personalities : [raid0] [raid1] [raid6] [raid5] [raid4]
    md0 : active raid5 vdd[3] vdc[1] vdb[0]
          20953088 blocks super 1.2 level 5, 512k chunk, algorithm 2 [3/2] [UU_]
          [==========>..........] recovery = 53.1% (5569248/10476544) finish=0.7min speed=113291K/sec
    
    unused devices: <none>
    [root@raid-belajarlinux ~]#

Cek status RAID 5

    [root@raid-belajarlinux ~]#
    [root@raid-belajarlinux ~]# cat /proc/mdstat
    Personalities : [raid0] [raid1] [raid6] [raid5] [raid4]
    md0 : active raid5 vdd[3] vdc[1] vdb[0]
          20953088 blocks super 1.2 level 5, 512k chunk, algorithm 2 [3/3] [UUU]
    
    unused devices: <none>
    [root@raid-belajarlinux ~]#

Cek status volume RAID 5

    [root@raid-belajarlinux ~]#
    [root@raid-belajarlinux ~]# lsblk -o NAME,SIZE,FSTYPE,TYPE,MOUNTPOINT
    NAME SIZE FSTYPE TYPE MOUNTPOINT
    vda 60G disk
    └─vda1 60G xfs part /
    vdb 10G linux_raid_member disk
    └─md0 20G raid5
    vdc 10G linux_raid_member disk
    └─md0 20G raid5
    vdd 10G linux_raid_member disk
    └─md0 20G raid5
    [root@raid-belajarlinux ~]#

### Level RAID 6

Untuk membuat RAID 6 minimal kita memiliki 4 buah disk atau volume

<figure class="wp-block-table"><table><tbody>
<tr>
<td class="has-text-align-center" data-align="center">Nama Volume</td>
<td class="has-text-align-center" data-align="center">Size Volume</td>
</tr>
<tr>
<td class="has-text-align-center" data-align="center">vdb</td>
<td class="has-text-align-center" data-align="center">10 GB</td>
</tr>
<tr>
<td class="has-text-align-center" data-align="center">vdc</td>
<td class="has-text-align-center" data-align="center">10 GB</td>
</tr>
<tr>
<td class="has-text-align-center" data-align="center">vdd</td>
<td class="has-text-align-center" data-align="center">10 GB</td>
</tr>
<tr>
<td class="has-text-align-center" data-align="center">vde</td>
<td class="has-text-align-center" data-align="center">10 GB</td>
</tr>
</tbody></table></figure>

Cek volume menggunakan perintah berikut

    [root@raid-belajarlinux ~]#
    [root@raid-belajarlinux ~]# lsblk -o NAME,SIZE,FSTYPE,TYPE,MOUNTPOINT
    NAME SIZE FSTYPE TYPE MOUNTPOINT
    vda 60G disk
    └─vda1 60G xfs part /
    vdb 10G disk
    vdc 10G disk
    vdd 10G disk
    vde 10G disk
    [root@raid-belajarlinux ~]#

Jalankan perintah berikut, untuk membuat RAID 6 dan silakan sesuaikan level serta nama volume

    [root@raid-belajarlinux ~]#
    [root@raid-belajarlinux ~]# mdadm --create --verbose /dev/md0 --level=6 --raid-devices=4 /dev/vdb /dev/vdc /dev/vdd /dev/vde
    mdadm: layout defaults to left-symmetric
    mdadm: layout defaults to left-symmetric
    mdadm: chunk size defaults to 512K
    mdadm: size set to 10476544K
    mdadm: Defaulting to version 1.2 metadata
    mdadm: array /dev/md0 started.
    [root@raid-belajarlinux ~]#

Selanjutnya cek RAID yang kita buat, untuk RAID 6 memerlukan waktu resync antar disk/volume.

    [root@raid-belajarlinux ~]#
    [root@raid-belajarlinux ~]# cat /proc/mdstat
    Personalities : [raid0] [raid1] [raid6] [raid5] [raid4]
    md0 : active raid6 vde[3] vdd[2] vdc[1] vdb[0]
          20953088 blocks super 1.2 level 6, 512k chunk, algorithm 2 [4/4] [UUUU]
          [====>................] resync = 23.9% (2509924/10476544) finish=0.6min speed=193071K/sec
    
    unused devices: <none>
    [root@raid-belajarlinux ~]#

Cek status RAID 6

    [root@raid-belajarlinux ~]#
    [root@raid-belajarlinux ~]# cat /proc/mdstat
    Personalities : [raid0] [raid1] [raid6] [raid5] [raid4]
    md0 : active raid6 vde[3] vdd[2] vdc[1] vdb[0]
          20953088 blocks super 1.2 level 6, 512k chunk, algorithm 2 [4/4] [UUUU]
    
    unused devices: <none>
    [root@raid-belajarlinux ~]#

Cek status volume RAID 6

    [root@raid-belajarlinux ~]#
    [root@raid-belajarlinux ~]# lsblk -o NAME,SIZE,FSTYPE,TYPE,MOUNTPOINT
    NAME SIZE FSTYPE TYPE MOUNTPOINT
    vda 60G disk
    └─vda1 60G xfs part /
    vdb 10G linux_raid_member disk
    └─md0 20G raid6
    vdc 10G linux_raid_member disk
    └─md0 20G raid6
    vdd 10G linux_raid_member disk
    └─md0 20G raid6
    vde 10G linux_raid_member disk
    └─md0 20G raid6
    [root@raid-belajarlinux ~]#

### Level RAID 10

Untuk membuat RAID 10 hampir sama dengan RAID 6 dimana minimal kita harus mempunyai 4 disk/volume.

<figure class="wp-block-table"><table><tbody>
<tr>
<td class="has-text-align-center" data-align="center">Nama Volume</td>
<td class="has-text-align-center" data-align="center">Size Volume</td>
</tr>
<tr>
<td class="has-text-align-center" data-align="center">vdb</td>
<td class="has-text-align-center" data-align="center">10 GB</td>
</tr>
<tr>
<td class="has-text-align-center" data-align="center">vdc</td>
<td class="has-text-align-center" data-align="center">10 GB</td>
</tr>
<tr>
<td class="has-text-align-center" data-align="center">vdd</td>
<td class="has-text-align-center" data-align="center">10 GB</td>
</tr>
<tr>
<td class="has-text-align-center" data-align="center">vde</td>
<td class="has-text-align-center" data-align="center">10 GB</td>
</tr>
</tbody></table></figure>

Untuk melakukan pengecekan volume gunakan perintah berikut

    [root@raid-belajarlinux ~]#
    [root@raid-belajarlinux ~]# lsblk -o NAME,SIZE,FSTYPE,TYPE,MOUNTPOINT
    NAME SIZE FSTYPE TYPE MOUNTPOINT
    vda 60G disk
    └─vda1 60G xfs part /
    vdb 10G disk
    vdc 10G disk
    vdd 10G disk
    vde 10G disk
    [root@raid-belajarlinux ~]#

Gunakan perintah berikut untuk membuat RAID 10

    [root@raid-belajarlinux ~]#
    [root@raid-belajarlinux ~]# mdadm --create --verbose /dev/md0 --level=10 --raid-devices=4 /dev/vdb /dev/vdc /dev/vdd /dev/vde
    mdadm: layout defaults to n2
    mdadm: layout defaults to n2
    mdadm: chunk size defaults to 512K
    mdadm: size set to 10476544K
    mdadm: Defaulting to version 1.2 metadata
    mdadm: array /dev/md0 started.
    [root@raid-belajarlinux ~]#

Selanjutnya cek RAID yang kita buat, untuk RAID 10 memerlukan waktu resync antar disk/volume.

    [root@raid-belajarlinux ~]# cat /proc/mdstat
    Personalities : [raid0] [raid1] [raid6] [raid5] [raid4] [raid10]
    md0 : active raid10 vde[3] vdd[2] vdc[1] vdb[0]
          20953088 blocks super 1.2 512K chunks 2 near-copies [4/4] [UUUU]
          [====>................] resync = 20.7% (4339136/20953088) finish=1.3min speed=206625K/sec
    
    unused devices: <none>
    [root@raid-belajarlinux ~]#

Cek status RAID 10

    [root@raid-belajarlinux ~]#
    [root@raid-belajarlinux ~]# cat /proc/mdstat
    Personalities : [raid0] [raid1] [raid6] [raid5] [raid4] [raid10]
    md0 : active raid10 vde[3] vdd[2] vdc[1] vdb[0]
          20953088 blocks super 1.2 512K chunks 2 near-copies [4/4] [UUUU]
    
    unused devices: <none>
    [root@raid-belajarlinux ~]#

Cek status volume RAID 10

    [root@raid-belajarlinux ~]#
    [root@raid-belajarlinux ~]# lsblk -o NAME,SIZE,FSTYPE,TYPE,MOUNTPOINT
    NAME SIZE FSTYPE TYPE MOUNTPOINT
    vda 60G disk
    └─vda1 60G xfs part /
    vdb 10G linux_raid_member disk
    └─md0 20G raid10
    vdc 10G linux_raid_member disk
    └─md0 20G raid10
    vdd 10G linux_raid_member disk
    └─md0 20G raid10
    vde 10G linux_raid_member disk
    └─md0 20G raid10
    [root@raid-belajarlinux ~]#

Untuk melihat detail RAID yang sudah dibuat jalankan perintah berikut:

    [root@raid-belajarlinux ~]#
    [root@raid-belajarlinux ~]# mdadm --detail /dev/md0
    /dev/md0:
               Version : 1.2
         Creation Time : Sat Sep 12 12:54:49 2020
            Raid Level : raid10
            Array Size : 20953088 (19.98 GiB 21.46 GB)
         Used Dev Size : 10476544 (9.99 GiB 10.73 GB)
          Raid Devices : 4
         Total Devices : 4
           Persistence : Superblock is persistent
    
           Update Time : Sat Sep 12 13:04:45 2020
                 State : clean
        Active Devices : 4
       Working Devices : 4
        Failed Devices : 0
         Spare Devices : 0
    
                Layout : near=2
            Chunk Size : 512K
    
    Consistency Policy : resync
    
                  Name : 0
                  UUID : 3de67b5d:e47b0c8c:565303af:ef4a7f03
                Events : 17
    
        Number Major Minor RaidDevice State
           0 252 16 0 active sync set-A /dev/vdb
           1 252 32 1 active sync set-B /dev/vdc
           2 252 48 2 active sync set-A /dev/vdd
           3 252 64 3 active sync set-B /dev/vde
    [root@raid-belajarlinux ~]#

Saat ini RAID 0, 1, 5, 6 dan 10 sudah dibuat.

### [Opsional] Menghapus RAID

Ingat!. Langkah ini bisa di Anda skip atau abaikan jika tidak ingin menghapus RAID. Kami contohkan bagaimana cara hapus RAID 1.

Cek RAID 1 terlebih dahulu

    [root@raid-belajarlinux ~]#
    [root@raid-belajarlinux ~]# lsblk -o NAME,SIZE,FSTYPE,TYPE,MOUNTPOINT
    NAME SIZE FSTYPE TYPE MOUNTPOINT
    vda 60G disk
    └─vda1 60G xfs part /
    vdb 10G linux_raid_member disk
    └─md0 10G raid1
    vdc 10G linux_raid_member disk
    └─md0 10G raid1
    [root@raid-belajarlinux ~]#

Hapus device mdadm RAID 1 menggunakan perintah berikut

    [root@raid-belajarlinux ~]# mdadm --remove /dev/md0
    [root@raid-belajarlinux ~]# mdadm --stop /dev/md0
    mdadm: stopped /dev/md0
    [root@raid-belajarlinux ~]#
    [root@raid-belajarlinux ~]#

Jalankan perintah lsblk kembali seperti berikut, dan pastikan device RAID 1 sudah terhapus

    [root@raid-belajarlinux ~]#
    [root@raid-belajarlinux ~]# lsblk -o NAME,SIZE,FSTYPE,TYPE,MOUNTPOINT
    NAME SIZE FSTYPE TYPE MOUNTPOINT
    vda 60G disk
    └─vda1 60G xfs part /
    vdb 10G linux_raid_member disk
    vdc 10G linux_raid_member disk
    [root@raid-belajarlinux ~]#

Namun disini data volume masih menjadi member atau block dari RAID 1 untuk menghapus nya secara total gunakan perintah berikut

    [root@raid-belajarlinux ~]# mdadm --zero-superblock /dev/vdb /dev/vdc
    [root@raid-belajarlinux ~]#
    [root@raid-belajarlinux ~]# lsblk -o NAME,SIZE,FSTYPE,TYPE,MOUNTPOINT
    NAME SIZE FSTYPE TYPE MOUNTPOINT
    vda 60G disk
    └─vda1 60G xfs part /
    vdb 10G disk
    vdc 10G disk
    [root@raid-belajarlinux ~]#

### Jadikan RAID sebagai Ext4

Disini kami contohkan menggunakan RAID 10 yang akan di jadikan sebaai Ext4

    [root@raid-belajarlinux ~]#
    [root@raid-belajarlinux ~]# cat /proc/mdstat |grep md0
    md0 : active raid10 vde[3] vdd[2] vdc[1] vdb[0]
    [root@raid-belajarlinux ~]#
    [root@raid-belajarlinux ~]# fdisk -l |grep /dev/md0
    Disk /dev/md0: 20 GiB, 21455962112 bytes, 41906176 sectors
    [root@raid-belajarlinux ~]#
    [root@raid-belajarlinux ~]# mkfs.ext4 -F /dev/md0
    mke2fs 1.45.4 (23-Sep-2019)
    Creating filesystem with 5238272 4k blocks and 1310720 inodes
    Filesystem UUID: 2d39f95d-c4be-4a5d-ae4b-eff590458de6
    Superblock backups stored on blocks:
            32768, 98304, 163840, 229376, 294912, 819200, 884736, 1605632, 2654208,
            4096000
    
    Allocating group tables: done
    Writing inode tables: done
    Creating journal (32768 blocks): done
    Writing superblocks and filesystem accounting information: done
    
    [root@raid-belajarlinux ~]#

RAID 10 sudah di format menjadi Ext4 dan selanjutnya dapat Anda mounting ke direktori yang Anda inginkan misalnya ke direktori _ **/home** _

    [root@raid-belajarlinux ~]#
    [root@raid-belajarlinux ~]# mount /dev/md0 /home/
    [root@raid-belajarlinux ~]# df -h /home/
    Filesystem Size Used Avail Use% Mounted on
    /dev/md0 20G 45M 19G 1% /home
    [root@raid-belajarlinux ~]#

Cek size direktori _ **/home** _

    [root@raid-belajarlinux ~]#
    [root@raid-belajarlinux ~]# df -h
    Filesystem Size Used Avail Use% Mounted on
    devtmpfs 886M 0 886M 0% /dev
    tmpfs 914M 0 914M 0% /dev/shm
    tmpfs 914M 8.5M 906M 1% /run
    tmpfs 914M 0 914M 0% /sys/fs/cgroup
    /dev/vda1 60G 2.3G 58G 4% /
    tmpfs 183M 0 183M 0% /run/user/1000
    /dev/md0 20G 45M 19G 1% /home
    [root@raid-belajarlinux ~]#

Uji coba RAID 10 misal dengan membuat direktori dan file di dalam _ **/home** _

    [root@raid-belajarlinux ~]#
    [root@raid-belajarlinux ~]# touch /home/belajarlinuxid.txt
    [root@raid-belajarlinux ~]# echo "Belajar Membuat RAID ya di Belajar Linux ID" > /home/belajarlinuxid.txt
    [root@raid-belajarlinux ~]# cat /home/belajarlinuxid.txt
    Belajar Membuat RAID ya di Belajar Linux ID
    [root@raid-belajarlinux ~]#

### Konfigurasi Otomatis Mounting RAID 

Biasanya jika kita tidak melakukan konfigurasi otomatis mounting volume atau RAID volume, maka pada saat instance/VM di reboot RAID akan otomatis lepas dari direktori yang sudah di mount sebelumnya contoh dalam case ini direktori _ **/home.** _

Untuk konfigurasinya Anda hanya perlu menambahkannya di _ **fstab** _ sebagai berikut

    [root@raid-belajarlinux ~]#
    [root@raid-belajarlinux ~]# vim /etc/fstab

Isi dan sesuaikan fstab Anda dengan direktori Anda contohnya

    #
    # /etc/fstab
    # Created by anaconda on Mon Jan 13 21:48:59 2020
    #
    # Accessible filesystems, by reference, are maintained under '/dev/disk/'.
    # See man pages fstab(5), findfs(8), mount(8) and/or blkid(8) for more info.
    #
    # After editing this file, run 'systemctl daemon-reload' to update systemd
    # units generated from this file.
    #
    UUID=c7b1ead0-f176-4f23-b9c7-299eb4a06cef / xfs defaults 0 0
    /dev/md0 /home ext4 defaults 0 0

Verifikasi _ **fstab** _

    [root@raid-belajarlinux ~]# mount -av
    / : ignored
    /home : already mounted
    [root@raid-belajarlinux ~]#

Simpan detail informasi RAID 10 mengguankan perintah berikut

    [root@raid-belajarlinux ~]# mdadm --detail --scan --verbose >> /etc/mdadm.conf
    [root@raid-belajarlinux ~]#

Silakan reboot instance/VM Anda untuk mengetahui hasilnya.

    [root@raid-belajarlinux ~]#
    [root@raid-belajarlinux ~]# reboot
    Connection to 192.168.10.9 closed by remote host.
    Connection to 192.168.10.9 closed.
    255 ubuntu@my-jumper:~$

Tunggu beberapa saat proses booting instance/VM Anda dan silakan login kembali pastikan /home masih ada seperti berikut

    ubuntu@my-jumper:~$ ssh raid
    centos@192.168.10.9's password:
    Activate the web console with: systemctl enable --now cockpit.socket
    
    Last login: Sat Sep 12 16:26:49 2020 from 192.168.10.7
    Could not chdir to home directory /home/centos: No such file or directory
    [centos@raid-belajarlinux /]$
    [centos@raid-belajarlinux /]$ sudo su
    [root@raid-belajarlinux /]# cd
    [root@raid-belajarlinux ~]#
    [root@raid-belajarlinux ~]# df -h
    Filesystem Size Used Avail Use% Mounted on
    devtmpfs 886M 0 886M 0% /dev
    tmpfs 914M 0 914M 0% /dev/shm
    tmpfs 914M 8.5M 905M 1% /run
    tmpfs 914M 0 914M 0% /sys/fs/cgroup
    /dev/vda1 60G 2.3G 58G 4% /
    /dev/md0 20G 45M 19G 1% /home
    tmpfs 183M 0 183M 0% /run/user/0
    tmpfs 183M 0 183M 0% /run/user/1000
    [root@raid-belajarlinux ~]#

Selamat mencoba 😁

Please follow and like us:

[![error](/wp-content/plugins/ultimate-social-media-icons/images/follow_subscribe.png)](https://api.follow.it/widgets/icon/VHc3d1lpVGdwRnE5QnV0eERCNUx5RCtvTTVoUkNYS3NNRmd5eVhlQW9tNXRHS3VTbGh6Y0NybkRJRS8zSGpjRDVZb1ZGMlNTSEpJYUpuZzZqNzdnd3VSN3dwM2VlQTF6ejJEaGV5UGRUbnlEcHFNd3luYTV4ZTZtUGowVWI2Q2x8M2kzdnBEeUIrUk5xOFI5TXZ3cHF3bFNQRkRJSGhUNGdrRFd0TlNtdE1OWT0=/OA==/)

[![fb-share-icon](/wp-content/plugins/ultimate-social-media-icons/images/visit_icons/fbshare_bck.png "Facebook Share")](https://www.facebook.com/sharer/sharer.php?u=https%3A%2F%2Fbelajarlinux.id%2F%3Fp%3D602%26ghostexport%3Dtrue%26submit%3DDownload+Ghost+File)

[![Tweet](/wp-content/plugins/ultimate-social-media-icons/images/visit_icons/en_US_Tweet.svg "Tweet")](https://twitter.com/intent/tweet?text=Membuat+RAID+di+CentOS+8+https://belajarlinux.id/?p=602&ghostexport=true&submit=Download Ghost File)

[![fb-share-icon](/wp-content/plugins/ultimate-social-media-icons/images/share_icons/Pinterest_Save/en_US_save.svg "Pin Share")](#)

<!--kg-card-end: html-->
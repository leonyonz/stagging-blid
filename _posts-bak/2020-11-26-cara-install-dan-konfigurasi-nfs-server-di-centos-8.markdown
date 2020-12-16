---
layout: post
title: 'Linux: Cara Install dan Konfigurasi NFS Server di CentOS 8'
featured: true
date: '2020-11-26 13:35:29'
tags:
- volume
- centos
---

[Belajar Linux ID](/) - &nbsp;NFS _(Network File System)_ sebuah protokol file sistem terdistribusi yang memungkinkan Anda berbagi direktori baik local ataupun remote (jarak jauh) melalui jaringan. Dengan NFS, Anda dapat memasang direktori secara remote (jarak jauh) pada sistem Anda.

Protokol NFS tidak dienkripsi secara default, dan tidak seperti Samba, protokol NFS tidak menyediakan otentikasi pengguna. Akses ke server dibatasi oleh alamat IP atau nama host klien.

Pada tutorial kali ini Anda akan belajar bagaimana cara instalasi dan konfigurasi NFS Server di CentOS 8 dan cara menggunakannya di sisi client.

Berikut detail informasi IP NFS Server dan Client.

<!--kg-card-begin: markdown-->

    NFS Server IP: 103.93.01.xx
    NFS Clients IPs: 103.93.02.xx range

<!--kg-card-end: markdown-->
### NFS Server

Sebelum melakukan instalasi NFS Server silakan update sistem operasi CentOS 8 Anda terlebih dahulu, gunakan perintah

<!--kg-card-begin: markdown-->

    [root@nfs-cloud ~]#
    [root@nfs-cloud ~]# dnf update -y

<!--kg-card-end: markdown-->

Selanjutnya install utilitas dan daemon `nfs-server`

<!--kg-card-begin: markdown-->

    [root@nfs-cloud ~]#
    [root@nfs-cloud ~]# dnf install nfs-utils -y

<!--kg-card-end: markdown-->

Jika sudah silakan enable `nfs-server`

<!--kg-card-begin: html--><script async src="https://pagead2.googlesyndication.com/pagead/js/adsbygoogle.js"></script><ins class="adsbygoogle" style="display:block; text-align:center;" data-ad-layout="in-article" data-ad-format="fluid" data-ad-client="ca-pub-1515372853161377" data-ad-slot="4684565489"></ins><script>
     (adsbygoogle = window.adsbygoogle || []).push({});
</script><!--kg-card-end: html--><!--kg-card-begin: markdown-->

    [root@nfs-cloud ~]#
    [root@nfs-cloud ~]# systemctl enable --now nfs-server
    Created symlink /etc/systemd/system/multi-user.target.wants/nfs-server.service → /usr/lib/systemd/system/nfs-server.service.
    [root@nfs-cloud ~]#

<!--kg-card-end: markdown-->

Cek versi `nfs-server` gunakan perintah

<!--kg-card-begin: markdown-->

    [root@nfs-cloud ~]#
    [root@nfs-cloud ~]# cat /proc/fs/nfsd/versions
    -2 +3 +4 +4.1 +4.2
    [root@nfs-cloud ~]#

<!--kg-card-end: markdown-->

Disini kami sudah menyiapkan satu volume atau disk yang sebesar 70GB yang akan digunakan untuk `nfs-server` oleh karena itu kita Anda perlu konfigurasi volume atau disk nya terlebih dahulu.

Cek volume dan konfigurasi volume menggunakan command `fdisk`

<!--kg-card-begin: markdown-->

    [root@nfs-cloud ~]#
    [root@nfs-cloud ~]# fdisk -l |grep dev
    Disk /dev/vda: 60 GiB, 64424509440 bytes, 125829120 sectors
    /dev/vda1 * 2048 125829086 125827039 60G 83 Linux
    Disk /dev/vdb: 70 GiB, 75161927680 bytes, 146800640 sectors
    [root@nfs-cloud ~]#
    [root@nfs-cloud ~]# fdisk /dev/vdb
    
    Welcome to fdisk (util-linux 2.32.1).
    Changes will remain in memory only, until you decide to write them.
    Be careful before using the write command.
    
    Device does not contain a recognized partition table.
    Created a new DOS disklabel with disk identifier 0x6ac5b537.

<!--kg-card-end: markdown-->

Kemudian, klik `n` untuk membuat partisi baru, dan `p` untuk lihat partisi dan klik `w` untuk buat volume atau disk nya, seperti berikut

<!--kg-card-begin: markdown-->

    Command (m for help): n
    Partition type
       p primary (0 primary, 0 extended, 4 free)
       e extended (container for logical partitions)
    Select (default p): p
    Partition number (1-4, default 1): 1
    First sector (2048-146800639, default 2048):
    Last sector, +sectors or +size{K,M,G,T,P} (2048-146800639, default 146800639):
    
    Created a new partition 1 of type 'Linux' and of size 70 GiB.
    
    Command (m for help): p
    Disk /dev/vdb: 70 GiB, 75161927680 bytes, 146800640 sectors
    Units: sectors of 1 * 512 = 512 bytes
    Sector size (logical/physical): 512 bytes / 512 bytes
    I/O size (minimum/optimal): 512 bytes / 512 bytes
    Disklabel type: dos
    Disk identifier: 0x6ac5b537
    
    Device Boot Start End Sectors Size Id Type
    /dev/vdb1 2048 146800639 146798592 70G 83 Linux
    
    Command (m for help): w
    The partition table has been altered.
    Calling ioctl() to re-read partition table.
    Syncing disks.
    
    [root@nfs-cloud ~]#

<!--kg-card-end: markdown-->

Selanjutnya, jalankan command `partprobe` dan jalankan `mkfs.ext4` ke direktori volume

<!--kg-card-begin: markdown-->

    [root@nfs-cloud ~]# partprobe
    [root@nfs-cloud ~]#
    [root@nfs-cloud ~]# mkfs.ext4 /dev/vdb1
    mke2fs 1.45.4 (23-Sep-2019)
    Creating filesystem with 18349824 4k blocks and 4587520 inodes
    Filesystem UUID: e4d7022b-9fcf-49d8-aa8e-7c68d451a887
    Superblock backups stored on blocks:
            32768, 98304, 163840, 229376, 294912, 819200, 884736, 1605632, 2654208,
            4096000, 7962624, 11239424
    
    Allocating group tables: done
    Writing inode tables: done
    Creating journal (131072 blocks): done
    Writing superblocks and filesystem accounting information: done
    
    [root@nfs-cloud ~]#

<!--kg-card-end: markdown-->

Jika sudah, berikutnya Anda dapat membuat direktori dan menenukan direktori yang akan digunakan oleh `nfs-server` dan nantinya direktori tersebut yang akan digunakan atau share ke client

<!--kg-card-begin: markdown-->

    [root@nfs-cloud ~]# mkdir -p /srv/datahv

<!--kg-card-end: markdown-->

Jika sudah silakan mount `/dev/vdb1` nya ke direktori diatas `/srv/datahv`

<!--kg-card-begin: markdown-->

    [root@nfs-cloud ~]# mount /dev/vdb1 /srv/datahv/
    [root@nfs-cloud ~]# df -h /srv/datahv/
    Filesystem Size Used Avail Use% Mounted on
    /dev/vdb1 69G 53M 65G 1% /srv/datahv
    [root@nfs-cloud ~]#

<!--kg-card-end: markdown-->

Apabila sudah di mount, selanjutnya Anda dapat menambahkan path direktorinya ke `fstab` tujuannya jika instance atau VM di reboot maka `nfs-server` akan tetap termounting

<!--kg-card-begin: html--><script async src="https://pagead2.googlesyndication.com/pagead/js/adsbygoogle.js"></script><ins class="adsbygoogle" style="display:block; text-align:center;" data-ad-layout="in-article" data-ad-format="fluid" data-ad-client="ca-pub-1515372853161377" data-ad-slot="4684565489"></ins><script>
     (adsbygoogle = window.adsbygoogle || []).push({});
</script><!--kg-card-end: html--><!--kg-card-begin: markdown-->

    [root@nfs-cloud ~]#
    [root@nfs-cloud ~]# vim /etc/fstab
    
    
    /dev/vdb1 /srv/datahv ext4 defaults 0 0

<!--kg-card-end: markdown-->

Contohnya

<!--kg-card-begin: markdown-->

    [root@nfs-cloud ~]#
    [root@nfs-cloud ~]# cat /etc/fstab |grep dev
    # Accessible filesystems, by reference, are maintained under '/dev/disk/'.
    /dev/vdb1 /srv/datahv ext4 defaults 0 0
    [root@nfs-cloud ~]#

<!--kg-card-end: markdown-->

Verifikasi `fstab`

<!--kg-card-begin: markdown-->

    [root@nfs-cloud ~]#
    [root@nfs-cloud ~]# mount -av
    / : ignored
    /srv/data-hv : already mounted
    [root@nfs-cloud ~]#

<!--kg-card-end: markdown-->

Konfigurasi `nfs-server` di menu `/etc/exports`

<!--kg-card-begin: markdown-->

    [root@nfs-cloud ~]# vim /etc/exports

<!--kg-card-end: markdown-->

Input IP Tujuan (client) yang akan mengakses `nfs-server` contohnya

<!--kg-card-begin: markdown-->

    /srv/datahv 103.93.132.17(rw,async,no_root_squash,no_all_squash)

<!--kg-card-end: markdown-->

Contoh nya

<!--kg-card-begin: markdown-->

    [root@nfs-cloud ~]# cat /etc/exports
    /srv/datahv 103.93.02.xx(rw,async,no_root_squash,no_all_squash)
    [root@nfs-cloud ~]#

<!--kg-card-end: markdown-->

direktori `exports` digunakan jika Anda ingin menambahkan client, silakan ditambahkan di bari ke dua jika ingin lebih dari 1 client yang ingin mengakses atau menggunakan `nfs-server` , silakan simpan dan share `nfs-server` jalankan perintah berikut

<!--kg-card-begin: markdown-->

    [root@nfs-cloud ~]# exportfs -ra
    [root@nfs-cloud ~]#
    [root@nfs-cloud ~]# exportfs -v
    /srv/data-hv 103.93.02.xx(async,wdelay,hide,no_subtree_check,sec=sys,rw,secure,no_root_squash,no_all_squash)
    [root@nfs-cloud ~]#

<!--kg-card-end: markdown-->

Atau bisa menggunakan command berikut

<!--kg-card-begin: markdown-->

    [root@nfs-cloud ~]# exportfs -rav
    exporting 103.93.02.xx:/srv/datahv
    [root@nfs-cloud ~]#

<!--kg-card-end: markdown-->

Sampai disini `NFS-Server` sudah berjalan dan dapat digunakan

### NFS Client

Jika NFS Client belum terinstall di local silakan install terlebih dahulu, berikut contoh instalasi `nfs client` di beberapa distro Linux

<!--kg-card-begin: markdown-->
#### Debian/Ubuntu

    $ sudo apt update
    $ sudo apt install nfs-common

#### CentOS/Fedora

    $ sudo yum install nfs-utils

<!--kg-card-end: markdown-->

Buat direktori di `nfs-client` yang ingin Anda gunakan contoh

<!--kg-card-begin: markdown-->

    [root@cloud ~]#
    [root@cloud ~]# mkdir -p /root/test
    [root@cloud ~]#

<!--kg-card-end: markdown-->

Diatas kami membuat direktori `nfs-client` di `/root/test`

<!--kg-card-begin: html--><script async src="https://pagead2.googlesyndication.com/pagead/js/adsbygoogle.js"></script><ins class="adsbygoogle" style="display:block; text-align:center;" data-ad-layout="in-article" data-ad-format="fluid" data-ad-client="ca-pub-1515372853161377" data-ad-slot="1986938311"></ins><script>
     (adsbygoogle = window.adsbygoogle || []).push({});
</script><!--kg-card-end: html-->

Untuk menghubungkan `nfs-client` dengan `nfs-server` silakan `mount` direktori `nfs-server` ke direktori `nfs-client` contoh nya

<!--kg-card-begin: markdown-->

    [root@cloud ~]# mount -t nfs nfs.belajarlinux.id:/srv/datahv /root/test
    [root@cloud ~]#
    [root@cloud ~]# df -h
    Filesystem Size Used Avail Use% Mounted on
    devtmpfs 1.9G 0 1.9G 0% /dev
    tmpfs 1.9G 0 1.9G 0% /dev/shm
    tmpfs 1.9G 9.0M 1.9G 1% /run
    tmpfs 1.9G 0 1.9G 0% /sys/fs/cgroup
    /dev/mapper/cl-root 29G 2.9G 24G 11% /
    /dev/sda1 976M 191M 718M 22% /boot
    tmpfs 376M 0 376M 0% /run/user/0
    tmpfs 376M 0 376M 0% /run/user/1000
    nfs.belajarlinux.id:/srv/datahv 69G 52M 65G 1% /root/test
    [root@cloud ~]#
    [root@cloud ~]#

<!--kg-card-end: markdown-->

Noted:  
- `nfs.belajarlinux.id` isi IP atau domain/subdomain dari ke `nfs-server`  
- `/srv/datahv` direktori `nfs-server`  
- `/root/test` direktori nfs-client

Itulah tahapan sederhana membuat NFS Server, manfaat dari `nfs-server` ini Anda dapat membuat tempat penyimpanan data yang dapat diakses dan digunakan secara remote (jarak jauh) ataupun lokal dan sangat cocok digunakan bagi Anda yang membutuhkan shared storage.

Selamat mencoba 😁


---
layout: post
title: Cara Instalasi dan Menggunakan Lsyncd di CentOS 8
featured: true
date: '2020-08-29 20:16:56'
tags:
- centos
- linux
---

Lsyncd singkatan dari “Live Syncing Daemon”, sebuah service yang digunakan untuk sinkronisasi atau mereplikasi file dan direktori secara lokal dan remote sesuai waktu tertentu menggunakan rsync dan ssh di backend untuk authentication.

Lsyncd bekerja pada arsitektur Master dan Slave di mana ia memantau direktori pada server master, jika ada perubahan atau modifikasi yang dilakukan maka lsyncd akan mereplikasi yang sama pada server slave-nya sesuai interval waktu yang ditentukan.

Selengkapnya tentang Lsyncd dapat merujuk pada link berikut: [Lsyncd – Live Syncing (Mirror) Daemon](https://axkibe.github.io/lsyncd/)

Disini kami mempunyai 2 VM dengan detail name VM dan IP sebagai berikut:

Name VM (master): Apps01, IP: 192.168.10.9  
Name VM (slave): Apps02, IP: 192.168.10.18

Lsyncd akan diinstall di sisi VM master hal pertama kali yang harus di lakukan yaitu melakukan upda CentOS 8 dan instalasi repo epel terlebih dahulu

    [root@apps01 ~]#
    [root@apps01 ~]# dnf update -y; dnf install epel-release -y

Jika sudah selanjutnya menghubungkan VM Apps01 ke Apps02. Silakan generate ssh-key di sisi Apps01

    [root@apps01 ~]# ssh-keygen -t rsa
    Generating public/private rsa key pair.
    Enter file in which to save the key (/root/.ssh/id_rsa): Enter passphrase (empty for no passphrase):
    Enter same passphrase again:
    Your identification has been saved in /root/.ssh/id_rsa.
    Your public key has been saved in /root/.ssh/id_rsa.pub.
    The key fingerprint is:
    SHA256:9uKm5adyPJN84jb8VhUbULOz7q25qCX2iTq/2kQ9WOQ root@apps01.nurhamim.my.id
    The key's randomart image is:
    +---[RSA 3072]----+
    | ooo |
    | o oo |
    | E o+ |
    | + oo |
    | S o o.. |
    | . o .o |
    | +o.=.. . |
    | .+#=+= + o |
    | .BB/Bo+ =o.|
    +----[SHA256]-----+
    [root@apps01 ~]#

Lihat dan copy public key Apps01

    [root@apps01 ~]#
    [root@apps01 ~]# cd ~/.ssh/
    [root@apps01 .ssh]# cat id_rsa.pub
    ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQC4bnwIqcA/8iASB2HQCkcic2K0k0cYCcwJX2VotQAZvrE+WCBolvsHwUghO7PDTLMlgo7muaAZsXoHj5GGzpu0hjbhhi289kKPJ58e5IEJmB77AmYFFwhieFgalxKLYTzcNqph4z8mha/2HRH1liFYhYYxRnniFXFzxkwRGBgKRQQujbdlyWSGhWIQy48TLBch2Xiy+yN5Bhaxw/LD+y+nu1IwxGjc5ejWF8WWijv8l/0JFFa5BnzgvxMxuTExQFnXKbZIZlvRd/x4YXRFNWub4eDnZkEBS7hiJvoEhps8+1u9TPcaCpAPWVHstIO4+IuXQllnKKJWKBdSAALV83De+HyDOFjeWRTgb11nYjksYq8i9yAeieLLCxNdDX/GfVnlzUU7OQmJqdXFLgy1Rm7R1BeBix7ZPzcKGNkkXH1fPhp3BJ21C+XHFNf7AOwea3YV0UkVBIMSXwM9OzRYLysR1FTqvr1W2UPlMLKwifR9fopFDSVvz/YBE+lLy6E= root@apps01.nurhamim.my.id
    [root@apps01 .ssh]#

Pindahkan public key diatas ke _authorized\_keys ssh_ di sisi Apps02

    [root@apps02 ~]#
    [root@apps02 ~]# vim ~/.ssh/authorized_keys

Berikut isi full dari _authorized\_keys ssh_ setelah di tambahkan

    no-port-forwarding,no-agent-forwarding,no-X11-forwarding,command="echo 'Please login as the user \"centos\" rather than the user \"root\".';echo;sleep 10" ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCw5OEmy7SY+AoTX3Dr/HC1llLTzxFl0xbJ1KX2E63v1P4Ciszdfg7RtS2FdEF0fVmOqvGfSSpmalfA9SVkXbv6zec8gdfJkSWgE/keRQOevNcaac+368EM49FlfbTtRt6N0mMoI/lA2BdrEqTO1Py+FznVAALScS8+wjuntm1XdD0UavAgtfgDVtUZ3Y0MYaIbpYlU/DnUDa+HAHykwGsgxFzZYpgpjs3rNypOsXvGXlbGShzNdp9XLNb598pUgxSRRrC7HwBtgt5I9r5oAjrdZt0o46eTlFX5WHxTleUwNRkzToBJZKgRd9D0SJUvo4ZlO2oNYsLoJBpnIQPpU3s+cx6Ai58W9dnEXTgzB6HNufqbRvtz7BUfPx+W0bJZLQVi1Jz42WBSWYZCEhf6f3GaFTsuT3BDgk1jamYyqaSllzbihS68kivd+9xil4yPCHr+rECwG3q0R/mjosUKTxJpwe8W9z+w6LzNzZPcZsujfMEYFjtKa8q05LNE2Zd6lypxmSKOqTtjYI1HgvgrLZ0cj9i0ILHPIcbtnoA5IQG4chtNwLxsU9CoYV4QASokIA8ijEBwoY00HZ9PjwZAiQKZ9vLv9bJtWC0fHRhp5zajflFTrfai/LM8gAevuBXk2Nv6YhosBWfwVatCxis1OH4X4KNNKg873vOUghFw== me@nurhamim.my.id
    
    ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQC4bnwIqcA/8iASB2HQCkcic2K0k0cYCcwJX2VotQAZvrE+WCBolvsHwUghO7PDTLMlgo7muaAZsXoHj5GGzpu0hjbhhi289kKPJ58e5IEJmB77AmYFFwhieFgalxKLYTzcNqph4z8mha/2HRH1liFYhYYxRnniFXFlawRGBgKRQQujbdlyWSGhWIQy48TLBch2Xiy+yN5Bhaxw/LD+y+nu1IwxGjc5ejWF8WWijv8l/0JFFa5BnzgvxMxuTExQFnXKbZIZlvRd/x4YXRFNWub4eDnZkEBS7hiJvoEhps8+1u9TPcaCpAPWVHstIO4+IuXQllnKKJWKBdSAALV83De+HyDOFjeWRTgb11nYjksYq8i9yAeieLLCxNdDX/GfVnlzUU7OQmJqdXFLgy1Rm7R1BeBix7ZPzcKGNkkXH1fPhp3BJ21C+XHFNf7AOwea3YV0UkVBIMSXwM9OzRYLysR1FTqvr1W2UPlMLKwifR9fopFDSVvz/YBE+lLy6E= root@apps01.nurhamim.my.id

Tes login ke VM Apps02 dari Apps01 menggunakan user root, pastikan login sudah tidak menggunakan password lagi

    [root@apps01 .ssh]#
    [root@apps01 .ssh]# ssh root@192.168.10.18
    Activate the web console with: systemctl enable --now cockpit.socket
    
    Last login: Fri Aug 28 17:48:16 2020
    [root@apps02 ~]#

Selanjutnya install lsyncd di VM Apps01 gunakan perintah berikut

    [root@apps01 ~]#
    [root@apps01 ~]# dnf install lsyncd -y

Membuat direktori dan file di sisi VM Apps01 untuk bahan uji coba nantinya

    [root@apps01 ~]# cd /var/www/
    [root@apps01 www]#
    [root@apps01 www]# mkdir belajalinux
    [root@apps01 www]#
    [root@apps01 www]# echo "<h1>Belajar Lsyncd di Belajar Linux ID</h1>" > /var/www/belajalinux/index.html

Konfigurasi lsyncd, default konfigurasi lsyncd beradai di _/etc/lsyncd.conf_

    [root@apps01 ~]#
    [root@apps01 ~]# vim /etc/lsyncd.conf

Default nya seperti berikut:

    ----
    -- User configuration file for lsyncd.
    --
    -- Simple example for default rsync, but executing moves through on the target.
    --
    -- For more examples, see /usr/share/doc/lsyncd*/examples/
    --
    sync{default.rsyncssh, source="/var/www/html", host="localhost", targetdir="/tmp/htmlcopy/"}

Ubah menjadi seperti berikut ini

    ----
    -- User configuration file for lsyncd.
    --
    -- Simple example for default rsync, but executing moves through on the target.
    --
    -- For more examples, see /usr/share/doc/lsyncd*/examples/
    --
    -- sync{default.rsyncssh, source="/var/www/html", host="localhost", targetdir="/tmp/htmlcopy/"}
    
    settings {
            logfile = "/var/log/lsyncd/lsyncd.log",
            statusFile = "/tmp/lsyncd.stat",
            statusInterval = 1,
    }
    
    sync {
            default.rsync,
            source = "/var/www/",
            target = "192.168.10.18:/var/www/",
    }
    
    rsync = {
            update = true,
            perms = true,
            owner = true,
            group = true,
            rsh = "/usr/bin/ssh -l root -i /root/.ssh/id_rsa"
    }

_Keterangan:_

- Pada line _ **setting** _ merupakan konfigurasi stat dan log dari lsyncd
- Pada line _ **sync** _ merupakan konfigurasi source (VM Apps02) atau target/destionation dari direktori yang akan di sinkronisasikan
- Pada line _ **rsync** _ merupakan konfigurasi untuk menghubungkan antara VM Apps01 dan Apps02 melalui SSH key. 

Setelah lsyncd di install sebelumnya status nya saat ini masih inactive

    [root@apps01 www]#
    [root@apps01 www]# systemctl status lsyncd
    ● lsyncd.service - Live Syncing (Mirror) Daemon
       Loaded: loaded (/usr/lib/systemd/system/lsyncd.service; disabled; vendor preset: disabled)
       Active: inactive (dead)
    [root@apps01 www]#

Silakan di start dan enable lsysnd, pastikan statusnya running

    [root@apps01 www]# systemctl start lsyncd
    [root@apps01 www]# systemctl enable lsyncd
    Created symlink /etc/systemd/system/multi-user.target.wants/lsyncd.service → /usr/lib/systemd/system/lsyncd.service.
    [root@apps01 www]# systemctl status lsyncd
    ● lsyncd.service - Live Syncing (Mirror) Daemon
       Loaded: loaded (/usr/lib/systemd/system/lsyncd.service; enabled; vendor preset: disabled)
       Active: active (running) since Fri 2020-08-28 18:08:15 UTC; 17s ago
     Main PID: 8247 (lsyncd)
        Tasks: 1 (limit: 11328)
       Memory: 1.2M
       CGroup: /system.slice/lsyncd.service
               └─8247 /usr/bin/lsyncd -nodaemon /etc/lsyncd.conf
    
    Aug 28 18:08:15 apps01.nurhamim.my.id systemd[1]: Started Live Syncing (Mirror) Daemon.
    [root@apps01 www]#

Cek log lysnd apakah sudah melakukan sinkronisasi direktori dan file yang telah dibuat sebelumnya

    [root@apps01 www]#
    [root@apps01 www]# tail -f /var/log/lsyncd/lsyncd.log
    Fri Aug 28 18:08:15 2020 Normal: --- Startup ---
    Fri Aug 28 18:08:15 2020 Normal: recursive startup rsync: /var/www/ -> 192.168.10.18:/var/www/
    Fri Aug 28 18:08:15 2020 Normal: Startup of /var/www/ -> 192.168.10.18:/var/www/ finished.

Sekarang cek di sisi VM Apps02 jika direktori dan file di Apps01 sudah berada di Apps02 berarti lsyncd sudah berjalan dengan normal.

    [root@apps02 ~]#
    [root@apps02 ~]# cd /var/www/
    [root@apps02 www]#
    [root@apps02 www]# ls
    belajalinux cgi-bin html
    [root@apps02 www]#
    [root@apps02 www]# cd belajalinux/
    [root@apps02 belajalinux]#
    [root@apps02 belajalinux]# ls
    index.html
    [root@apps02 belajalinux]#

Sekarang kita coba kembali buat 1 file .txt di sisi VM Apps01

    [root@apps01 www]# cd belajalinux/
    [root@apps01 belajalinux]#
    [root@apps01 belajalinux]# ls
    index.html
    [root@apps01 belajalinux]# touch filetest.txt
    [root@apps01 belajalinux]# ls -lah
    total 4.0K
    drwxr-xr-x 2 root root 44 Aug 28 18:11 .
    drwxr-xr-x 5 root root 52 Aug 28 18:04 ..
    -rw-r--r-- 1 root root 0 Aug 28 18:11 filetest.txt
    -rw-r--r-- 1 root root 44 Aug 28 18:06 index.html
    [root@apps01 belajalinux]#

Cek log sinkronsisai lsyncd

    
    [root@apps01 belajalinux]# tail -f /var/log/lsyncd/lsyncd.log
    Fri Aug 28 18:08:15 2020 Normal: --- Startup ---
    Fri Aug 28 18:08:15 2020 Normal: recursive startup rsync: /var/www/ -> 192.168.10.18:/var/www/
    Fri Aug 28 18:08:15 2020 Normal: Startup of /var/www/ -> 192.168.10.18:/var/www/ finished.
    Fri Aug 28 18:11:40 2020 Normal: Calling rsync with filter-list of new/modified files/dirs
    /belajalinux/filetest.txt
    /belajalinux/
    /
    Fri Aug 28 18:11:40 2020 Normal: Finished a list after exitcode: 0

Terakhir pastikan di VM Apps02 sudah ada file .txt tersebut

    [root@apps02 belajalinux]#
    [root@apps02 belajalinux]# ls -lah
    total 4.0K
    drwxr-xr-x 2 root root 44 Aug 28 18:11 .
    drwxr-xr-x 5 root root 52 Aug 28 18:04 ..
    -rw-r--r-- 1 root root 0 Aug 28 18:11 filetest.txt
    -rw-r--r-- 1 root root 44 Aug 28 18:06 index.html
    [root@apps02 belajalinux]#

Selamat mencoba 😁

Please follow and like us:

[![error](/wp-content/plugins/ultimate-social-media-icons/images/follow_subscribe.png)](https://api.follow.it/widgets/icon/VHc3d1lpVGdwRnE5QnV0eERCNUx5RCtvTTVoUkNYS3NNRmd5eVhlQW9tNXRHS3VTbGh6Y0NybkRJRS8zSGpjRDVZb1ZGMlNTSEpJYUpuZzZqNzdnd3VSN3dwM2VlQTF6ejJEaGV5UGRUbnlEcHFNd3luYTV4ZTZtUGowVWI2Q2x8M2kzdnBEeUIrUk5xOFI5TXZ3cHF3bFNQRkRJSGhUNGdrRFd0TlNtdE1OWT0=/OA==/)

[![fb-share-icon](/wp-content/plugins/ultimate-social-media-icons/images/visit_icons/fbshare_bck.png "Facebook Share")](https://www.facebook.com/sharer/sharer.php?u=https%3A%2F%2Fbelajarlinux.id%2F%3Fp%3D367%26ghostexport%3Dtrue%26submit%3DDownload+Ghost+File)

[![Tweet](/wp-content/plugins/ultimate-social-media-icons/images/visit_icons/en_US_Tweet.svg "Tweet")](https://twitter.com/intent/tweet?text=Cara+Instalasi+dan+Menggunakan+Lsyncd+di+CentOS+8+https://belajarlinux.id/?p=367&ghostexport=true&submit=Download Ghost File)

[![fb-share-icon](/wp-content/plugins/ultimate-social-media-icons/images/share_icons/Pinterest_Save/en_US_save.svg "Pin Share")](#)

<!--kg-card-end: html-->
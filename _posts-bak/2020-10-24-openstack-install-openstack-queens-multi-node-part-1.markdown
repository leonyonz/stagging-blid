---
layout: post
title: 'Openstack: Install Openstack Queens Multi-Node Part 1'
featured: true
date: '2020-10-24 19:39:22'
tags:
- openstack
---

**[Belajar Linux ID](/)** – Pada tutorial kali ini kita akan mencoba install openstack multi-node. Arti dari multi-node sendiri yaitu lebih dari 1 VM atau server yang digunakan dalam instalasi Openstack, dan pada tutorial kali ini kita akan membagi beberapa part untuk instalasi openstack nya karena tahapaannya yang cukup panjang.

_[Baca juga: [OPENSTACK 01: DEFINISI DAN ARSITEKTUR](/openstack-definisi-dan-arsitektur/)]  
[Baca juga: [OPENSTACK 02: INSTALL OPENSTACK ALL-IN-ONE WITH PACKSTACK](/openstack-02-install-openstack-all-in-one-with-packstack/)]_

Kali ini kita tetap menggunakan packstack untuk instalasi openstack nya. Dan disini kami akan menggunakan 2 node dengan masing – masing rincian dan spesifikasi VM sebagai berikut   
  
**# Node Controller**  
  
_OS: CentOS 7_  
_RAM: 8 GB  
CPU: 4 Core  
Disk: 60 GB  
IP Management [eth1]: 10.36.36.10/24  
IP External [eth2]: 10.136.136.10/24_    
_Hostname: hamim-controller.nurhamim.my.id_  
_Volume: 30 GB_  
  
**# Node Compute**  
  
_OS: CentOS 7_  
_RAM: 8 GB  
CPU: 4 Core  
Disk: 60 GB  
IP Management [eth1]: 10.36.36.20/24  
IP External [eth2]: 10.136.136.20/24_    
_Hostname: hamim-compute.nurhamim.my.id_

Berikut tahapan – tahapan instalasinya.

Silakan remote SSH ke masing – masing node, dan pastikan setiap node sudah memiliki 2 interface ip private yang sudah ditentukan diatas, silakan disesuaikan dengan kondisi Anda masing – masing

    # Controller
    
    [root@hamim-controller ~]#
    [root@hamim-controller ~]# ip a |grep eth
    2: eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast state UP group default qlen 1000
        link/ether fa:16:3e:b6:af:15 brd ff:ff:ff:ff:ff:ff
        inet 10.36.36.10/24 brd 10.36.36.255 scope global dynamic eth0
    3: eth1: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast state UP group default qlen 1000
        link/ether fa:16:3e:c9:74:da brd ff:ff:ff:ff:ff:ff
        inet 10.136.136.10/24 brd 10.136.136.255 scope global dynamic eth1
    [root@hamim-controller ~]#
    
    # Compute
    
    [root@hamim-compute ~]#
    [root@hamim-compute ~]# ip a |grep eth
    2: eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast state UP group default qlen 1000
        link/ether fa:16:3e:38:27:f3 brd ff:ff:ff:ff:ff:ff
        inet 10.36.36.20/24 brd 10.36.36.255 scope global dynamic eth0
    3: eth1: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast state UP group default qlen 1000
        link/ether fa:16:3e:9f:31:58 brd ff:ff:ff:ff:ff:ff
        inet 10.136.136.20/24 brd 10.136.136.255 scope global dynamic eth1
    [root@hamim-compute ~]#

Verifikasi masing – masing node sudah saling terhubung, bisa menggunakan ping

    # Controller 
    [root@hamim-controller ~]#
    [root@hamim-controller ~]# ping -c3 10.36.36.1 |grep icmp
    64 bytes from 10.36.36.1: icmp_seq=1 ttl=64 time=1.86 ms
    64 bytes from 10.36.36.1: icmp_seq=2 ttl=64 time=0.218 ms
    64 bytes from 10.36.36.1: icmp_seq=3 ttl=64 time=0.252 ms
    [root@hamim-controller ~]#
    [root@hamim-controller ~]# ping -c3 10.36.36.10 |grep icmp
    64 bytes from 10.36.36.10: icmp_seq=1 ttl=64 time=0.028 ms
    64 bytes from 10.36.36.10: icmp_seq=2 ttl=64 time=0.038 ms
    64 bytes from 10.36.36.10: icmp_seq=3 ttl=64 time=0.036 ms
    [root@hamim-controller ~]#
    [root@hamim-controller ~]# ping -c3 10.36.36.20 |grep icmp
    64 bytes from 10.36.36.20: icmp_seq=1 ttl=64 time=0.700 ms
    64 bytes from 10.36.36.20: icmp_seq=2 ttl=64 time=0.242 ms
    64 bytes from 10.36.36.20: icmp_seq=3 ttl=64 time=0.235 ms
    [root@hamim-controller ~]#
    [root@hamim-controller ~]# ping -c3 10.136.136.1 |grep icmp
    64 bytes from 10.136.136.1: icmp_seq=1 ttl=64 time=0.695 ms
    64 bytes from 10.136.136.1: icmp_seq=2 ttl=64 time=0.217 ms
    64 bytes from 10.136.136.1: icmp_seq=3 ttl=64 time=0.239 ms
    [root@hamim-controller ~]#
    [root@hamim-controller ~]# ping -c3 10.136.136.10 |grep icmp
    64 bytes from 10.136.136.10: icmp_seq=1 ttl=64 time=0.017 ms
    64 bytes from 10.136.136.10: icmp_seq=2 ttl=64 time=0.042 ms
    64 bytes from 10.136.136.10: icmp_seq=3 ttl=64 time=0.030 ms
    [root@hamim-controller ~]#
    [root@hamim-controller ~]# ping -c3 10.136.136.20 |grep icmp
    64 bytes from 10.136.136.20: icmp_seq=1 ttl=64 time=0.761 ms
    64 bytes from 10.136.136.20: icmp_seq=2 ttl=64 time=0.245 ms
    64 bytes from 10.136.136.20: icmp_seq=3 ttl=64 time=0.228 ms
    [root@hamim-controller ~]#
    
    # Compute
    [root@hamim-compute ~]#
    [root@hamim-compute ~]# ping -c3 10.36.36.1 |grep icmp
    64 bytes from 10.36.36.1: icmp_seq=1 ttl=64 time=1.63 ms
    64 bytes from 10.36.36.1: icmp_seq=2 ttl=64 time=0.300 ms
    64 bytes from 10.36.36.1: icmp_seq=3 ttl=64 time=0.281 ms
    [root@hamim-compute ~]#
    [root@hamim-compute ~]# ping -c3 10.36.36.10 |grep icmp
    64 bytes from 10.36.36.10: icmp_seq=1 ttl=64 time=0.775 ms
    64 bytes from 10.36.36.10: icmp_seq=2 ttl=64 time=0.273 ms
    64 bytes from 10.36.36.10: icmp_seq=3 ttl=64 time=0.268 ms
    [root@hamim-compute ~]#
    [root@hamim-compute ~]# ping -c3 10.36.36.20 |grep icmp
    64 bytes from 10.36.36.20: icmp_seq=1 ttl=64 time=0.022 ms
    64 bytes from 10.36.36.20: icmp_seq=2 ttl=64 time=0.036 ms
    64 bytes from 10.36.36.20: icmp_seq=3 ttl=64 time=0.043 ms
    [root@hamim-compute ~]#
    [root@hamim-compute ~]# ping -c3 10.136.136.1 |grep icmp
    64 bytes from 10.136.136.1: icmp_seq=1 ttl=64 time=0.818 ms
    64 bytes from 10.136.136.1: icmp_seq=2 ttl=64 time=0.262 ms
    64 bytes from 10.136.136.1: icmp_seq=3 ttl=64 time=0.273 ms
    [root@hamim-compute ~]#
    [root@hamim-compute ~]# ping -c3 10.136.136.10 |grep icmp
    64 bytes from 10.136.136.10: icmp_seq=1 ttl=64 time=0.750 ms
    64 bytes from 10.136.136.10: icmp_seq=2 ttl=64 time=0.249 ms
    64 bytes from 10.136.136.10: icmp_seq=3 ttl=64 time=0.263 ms
    [root@hamim-compute ~]#
    [root@hamim-compute ~]# ping -c3 10.136.136.20 |grep icmp
    64 bytes from 10.136.136.20: icmp_seq=1 ttl=64 time=0.019 ms
    64 bytes from 10.136.136.20: icmp_seq=2 ttl=64 time=0.035 ms
    64 bytes from 10.136.136.20: icmp_seq=3 ttl=64 time=0.036 ms
    [root@hamim-compute ~]#

Selanjutnya konfigurasi hostname di masing – masing node

    # Controller
    [root@hamim-controller ~]# hostnamectl set-hostname hamim-controller.nurhamim.my.id
    [root@hamim-controller ~]#
    
    # Compute
    [root@hamim-compute ~]# hostnamectl set-hostname hamim-compute.nurhamim.my.id
    [root@hamim-compute ~]#

Tambahkan hostname ke /etc/hosts di masing – masing node

    # Controller
    [root@hamim-controller ~]#
    [root@hamim-controller ~]# vi /etc/hosts
    
    10.36.36.10 hamim-controller.nurhamim.my.id
    10.36.36.20 hamim-compute.nurhamim.my.id
    
    # Compute
    [root@hamim-compute ~]#
    [root@hamim-compute ~]# vi /etc/hosts
    
    10.36.36.10 hamim-controller.nurhamim.my.id
    10.36.36.20 hamim-compute.nurhamim.my.id

Disable Selinux di masing – masing node

    # Controller
    [root@hamim-controller ~]# sed -i 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/selinux/config
    [root@hamim-controller ~]# cat /etc/selinux/config |grep SELINUX
    # SELINUX= can take one of these three values:
    SELINUX=disabled
    # SELINUXTYPE= can take one of three two values:
    SELINUXTYPE=targeted
    [root@hamim-controller ~]#
    
    # Compute
    [root@hamim-compute ~]# sed -i 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/selinux/config
    [root@hamim-compute ~]# cat /etc/selinux/config |grep SELINUX
    # SELINUX= can take one of these three values:
    SELINUX=disabled
    # SELINUXTYPE= can take one of three two values:
    SELINUXTYPE=targeted
    [root@hamim-compute ~]#

Selanjutnya update CentOS 7 di masing – masing node, dan install repository epel dan openstack queens di masing – masing node

    # Controller
    [root@hamim-controller ~]#
    [root@hamim-controller ~]# [! -d /etc/yum.repos.d.orig] && cp -vR /etc/yum.repos.d /etc/yum.repos.d.orig
    
    [root@hamim-controller ~]#
    [root@hamim-controller ~]# yum -y install centos-release-openstack-queens epel-release
    
    [root@hamim-controller ~]# 
    [root@hamim-controller ~]# yum repolist
    
    [root@hamim-controller ~]#
    [root@hamim-controller ~]# yum -y update
    
    # Compute
    [root@hamim-compute ~]#
    [root@hamim-compute ~]# [! -d /etc/yum.repos.d.orig] && cp -vR /etc/yum.repos.d /etc/yum.repos.d.orig
    
    [root@hamim-compute ~]#
    [root@hamim-compute ~]# yum -y install centos-release-openstack-queens epel-release
    
    [root@hamim-compute ~]# 
    [root@hamim-compute ~]# yum repolist
    
    [root@hamim-compute ~]# 
    [root@hamim-compute ~]# yum -y update

Install NTP dan konfigurasi NPT menggunakan _chrony_ di masing – masing node

    # Controller
    [root@hamim-controller ~]#
    [root@hamim-controller ~]# yum -y install chrony
    [root@hamim-controller ~]# systemctl enable chronyd.service
    [root@hamim-controller ~]# systemctl restart chronyd.service
    [root@hamim-controller ~]# systemctl status chronyd.service
    [root@hamim-controller ~]# chronyc sources
    210 Number of sources = 4
    MS Name/IP address Stratum Poll Reach LastRx Last sample
    ===============================================================================
    ^+ ntp.skyline.net.id 2 6 37 8 +7144us[+6857us] +/- 49ms
    ^+ time.cloudflare.com 3 6 37 8 -1799us[-2086us] +/- 31ms
    ^+ 202-65-114-202.jogja.cit> 2 6 37 6 +68us[+68us] +/- 39ms
    ^* time.cloudflare.com 3 6 37 7 -1826us[-2113us] +/- 31ms
    [root@hamim-controller ~]#
    
    # Compute
    [root@hamim-compute ~]# yum -y install chrony
    [root@hamim-compute ~]# systemctl enable chronyd.service
    [root@hamim-compute ~]# systemctl restart chronyd.service
    [root@hamim-compute ~]# systemctl status chronyd.service
    [root@hamim-compute ~]# chronyc sources
    210 Number of sources = 4
    MS Name/IP address Stratum Poll Reach LastRx Last sample
    ===============================================================================
    ^- 203.114.225.252 4 6 17 47 +1573us[+1573us] +/- 124ms
    ^* 2.ntp.maxindo.net.id 2 6 17 47 -23us[+720us] +/- 36ms
    ^- suro.ubaya.ac.id 4 6 17 39 -2123us[-2123us] +/- 94ms
    ^- ubuntu.ubaya.ac.id 6 6 17 47 +2256us[+2999us] +/- 144ms
    [root@hamim-compute ~]#

Aktifkan _network.service_ di masing – masing node

    # Controller
    [root@hamim-controller ~]#
    [root@hamim-controller ~]# systemctl enable network.service
    network.service is not a native service, redirecting to /sbin/chkconfig.
    Executing /sbin/chkconfig network on
    [root@hamim-controller ~]# systemctl restart network.service
    [root@hamim-controller ~]# systemctl status network.service
    
    # Compute
    [root@hamim-compute ~]# systemctl enable network.service
    network.service is not a native service, redirecting to /sbin/chkconfig.
    Executing /sbin/chkconfig network on
    [root@hamim-compute ~]# systemctl restart network.service
    [root@hamim-compute ~]# systemctl status network.service

Install utility atau paket tambahan yang dibutuhkan seperti wget, vim, screen, crudini dan htop di masing – masing node

    # Controller
    [root@hamim-controller ~]#
    [root@hamim-controller ~]# yum -y install vim wget screen crudini htop
    
    # Compute
    [root@hamim-compute ~]#
    [root@hamim-compute ~]# yum -y install vim wget screen crudini htop

Menghubungkan antar node menggunakan SSH Key

    # Controller
    [root@hamim-controller ~]#
    [root@hamim-controller ~]# ssh-keygen
    
    [root@hamim-controller ~]#
    [root@hamim-controller ~]# ssh-copy-id root@10.36.36.10
    
    [root@hamim-controller ~]#
    [root@hamim-controller ~]# ssh-copy-id root@10.36.36.20
    
    # Compute
    [root@hamim-compute ~]#
    [root@hamim-compute ~]# ssh-keygen
    
    [root@hamim-compute ~]#
    [root@hamim-compute ~]# ssh-copy-id root@10.36.36.10
    
    [root@hamim-compute ~]#
    [root@hamim-compute ~]# ssh-copy-id root@10.36.36.20

Sekian untuk tutorial part 1 silakan lanjut ke part 2 ya 😁

Please follow and like us:

[![error](/wp-content/plugins/ultimate-social-media-icons/images/follow_subscribe.png)](https://api.follow.it/widgets/icon/VHc3d1lpVGdwRnE5QnV0eERCNUx5RCtvTTVoUkNYS3NNRmd5eVhlQW9tNXRHS3VTbGh6Y0NybkRJRS8zSGpjRDVZb1ZGMlNTSEpJYUpuZzZqNzdnd3VSN3dwM2VlQTF6ejJEaGV5UGRUbnlEcHFNd3luYTV4ZTZtUGowVWI2Q2x8M2kzdnBEeUIrUk5xOFI5TXZ3cHF3bFNQRkRJSGhUNGdrRFd0TlNtdE1OWT0=/OA==/)

[![fb-share-icon](/wp-content/plugins/ultimate-social-media-icons/images/visit_icons/fbshare_bck.png "Facebook Share")](https://www.facebook.com/sharer/sharer.php?u=https%3A%2F%2Fbelajarlinux.id%2F%3Fp%3D677%26ghostexport%3Dtrue%26submit%3DDownload+Ghost+File)

[![Tweet](/wp-content/plugins/ultimate-social-media-icons/images/visit_icons/en_US_Tweet.svg "Tweet")](https://twitter.com/intent/tweet?text=Openstack%3A+Install+Openstack+Queens+Multi-Node+Part+1+https://belajarlinux.id/?p=677&ghostexport=true&submit=Download Ghost File)

[![fb-share-icon](/wp-content/plugins/ultimate-social-media-icons/images/share_icons/Pinterest_Save/en_US_save.svg "Pin Share")](#)

<!--kg-card-end: html-->
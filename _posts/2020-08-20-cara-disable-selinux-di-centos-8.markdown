---
layout: post
title: Cara Disable SELinux di CentOS 8
featured: true
date: '2020-08-20 22:03:06'
tags:
- centos
- linux
---

Security Enhanced Linux atau SELinux adalah mekanisme keamanan yang dibangun di dalam kernel Linux yang digunakan oleh distribusi berbasis RHEL.

SELinux menambahkan lapisan keamanan tambahan ke sistem dengan mengizinkan administrator dan pengguna untuk mengontrol akses ke objek berdasarkan aturan kebijakan.

Aturan kebijakan SELinux menentukan bagaimana proses dan pengguna berinteraksi satu sama lain serta bagaimana proses dan pengguna berinteraksi dengan file. Ketika tidak ada aturan yang secara eksplisit mengizinkan akses ke suatu objek, seperti untuk proses membuka file, akses ditolak.

SELinux memiliki tiga mode operasi:

1. _ **Enforcing:** SELinux memungkinkan akses berdasarkan aturan kebijakan SELinux._
2. _ **Permissive:** SELinux hanya mencatat tindakan yang akan ditolak jika berjalan dalam mode enforcing. Mode ini berguna untuk men-debug dan membuat aturan kebijakan baru._
3. _ **Disabled:** Tidak ada kebijakan SELinux yang dimuat, dan tidak ada pesan yang dicatat._

Secara default di CentOS 8, SELinux diaktifkan dan dalam mode enforcing. Sangat disarankan untuk menjaga SELinux dalam mode enforcing. Namun, terkadang hal itu dapat mengganggu fungsi beberapa aplikasi, dan Anda perlu mengaturnya ke mode permissive atau menonaktifkannya sepenuhnya (mode disabled)  
  
Untuk melihat status SELinux gunakan perintah _ **sestatus** _ seperti berikut

    [root@tutorial ~]#
    [root@tutorial ~]# sestatus
    SELinux status: enabled
    SELinuxfs mount: /sys/fs/selinux
    SELinux root directory: /etc/selinux
    Loaded policy name: targeted
    Current mode: enforcing
    Mode from config file: enforcing
    Policy MLS status: enabled
    Policy deny_unknown status: allowed
    Memory protection checking: actual (secure)
    Max kernel policy version: 31
    [root@tutorial ~]#

Untuk menonaktifkan SELinux silakan buka file config SELinux berikut

    [root@tutorial ~]#
    [root@tutorial ~]# vim /etc/selinux/config

Ubah value SELinux menjadi **disabled** lalu simpan file config SELinux

<figure class="wp-block-image size-large"><img loading="lazy" width="869" height="282" src="/content/images/wordpress/2020/08/image-15.png" alt="" class="wp-image-86" srcset="/content/images/wordpress/2020/08/image-15.png 869w, /content/images/wordpress/2020/08/image-15-300x97.png 300w, /content/images/wordpress/2020/08/image-15-768x249.png 768w" sizes="(max-width: 869px) 100vw, 869px"></figure>

Jika sudah silakan reboot pada instance atau VM CentOS 8

    [root@tutorial ~]# reboot

Pastikan SELinux sudah disabled

    [root@tutorial ~]# sestatus
    SELinux status: disabled
    [root@tutorial ~]#

Saat ini SELinux sudah disabled.

Selamat mencoba 😄

Please follow and like us:

[![error](/wp-content/plugins/ultimate-social-media-icons/images/follow_subscribe.png)](https://api.follow.it/widgets/icon/VHc3d1lpVGdwRnE5QnV0eERCNUx5RCtvTTVoUkNYS3NNRmd5eVhlQW9tNXRHS3VTbGh6Y0NybkRJRS8zSGpjRDVZb1ZGMlNTSEpJYUpuZzZqNzdnd3VSN3dwM2VlQTF6ejJEaGV5UGRUbnlEcHFNd3luYTV4ZTZtUGowVWI2Q2x8M2kzdnBEeUIrUk5xOFI5TXZ3cHF3bFNQRkRJSGhUNGdrRFd0TlNtdE1OWT0=/OA==/)

[![fb-share-icon](/wp-content/plugins/ultimate-social-media-icons/images/visit_icons/fbshare_bck.png "Facebook Share")](https://www.facebook.com/sharer/sharer.php?u=https%3A%2F%2Fbelajarlinux.id%2F%3Fp%3D85%26ghostexport%3Dtrue%26submit%3DDownload+Ghost+File)

[![Tweet](/wp-content/plugins/ultimate-social-media-icons/images/visit_icons/en_US_Tweet.svg "Tweet")](https://twitter.com/intent/tweet?text=Cara+Disable+SELinux+di+CentOS+8+https://belajarlinux.id/?p=85&ghostexport=true&submit=Download Ghost File)

[![fb-share-icon](/wp-content/plugins/ultimate-social-media-icons/images/share_icons/Pinterest_Save/en_US_save.svg "Pin Share")](#)

<!--kg-card-end: html-->
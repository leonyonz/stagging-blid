---
layout: post
title: Cara Instalasi XRDP Server (Remote Dekstop) pada CentOS 8
featured: true
date: '2020-08-20 19:47:12'
tags:
- centos
- linux
---

Xrdp adalah implementasi open-source dari _Microsoft Remote Desktop Protocol (RDP)_ yang memungkinkan Anda mengontrol sistem jarak jauh secara grafis.

Tutorial kali ini akan menjelaskan caraa instalasi dan konfigurasi server Xrdp di CentOS 8.

## Instalasi DE (Desktop Environment)

Umumnya, server Linux tidak memiliki lingkungan desktop yang terpasang.

Gnome adalah lingkungan desktop default di CentOS 8. Untuk install Gnome di VM jalankan perintah berikut

    # dnf groupinstall "Server with GUI"

Sebelum install Xrdp silakan install repository EPEL terlebih dahulu, gunakan perintah berikut

    # dnf install epel-release -y

Selanjutnya instalasi paket Xrdp

    # dnf install xrdp -y

Apabila instalasi sudah selesai, silakan enable Xrdp

    # systemctl enable xrdp --now
    Created symlink /etc/systemd/system/multi-user.target.wants/xrdp.service → /usr/lib/systemd/system/xrdp.service.
    #

Pastikan Xrdp sudah running

    # systemctl status xrdp

<figure class="wp-block-image size-large"><img loading="lazy" width="1024" height="357" src="/content/images/wordpress/2020/08/image-5-1024x357.png" alt="" class="wp-image-69" srcset="/content/images/wordpress/2020/08/image-5-1024x357.png 1024w, /content/images/wordpress/2020/08/image-5-300x104.png 300w, /content/images/wordpress/2020/08/image-5-768x268.png 768w, /content/images/wordpress/2020/08/image-5.png 1157w" sizes="(max-width: 1024px) 100vw, 1024px"></figure>

Xrdp berjalan di port 3389, untuk dapat diakses melalui public silakan allow di sisi firewall, disini kami menggunakan Openstack, untuk allow port di instance opentack dapat melalui Security Group.

<figure class="wp-block-image size-large"><img loading="lazy" width="1024" height="315" src="/content/images/wordpress/2020/08/image-7-1024x315.png" alt="" class="wp-image-71" srcset="/content/images/wordpress/2020/08/image-7-1024x315.png 1024w, /content/images/wordpress/2020/08/image-7-300x92.png 300w, /content/images/wordpress/2020/08/image-7-768x236.png 768w, /content/images/wordpress/2020/08/image-7-1536x472.png 1536w, /content/images/wordpress/2020/08/image-7.png 1883w" sizes="(max-width: 1024px) 100vw, 1024px"></figure>

Untuk mencoba Xrdp silakan buka RDP jika di windows, jika di Linux bisa menggunakan Remmina, RealVNC dan yang lainnya, disini kami menggunakan RDP, silakan input IP VM Anda masing – masing

<figure class="wp-block-image size-large"><img loading="lazy" width="408" height="254" src="/content/images/wordpress/2020/08/image-8.png" alt="" class="wp-image-72" srcset="/content/images/wordpress/2020/08/image-8.png 408w, /content/images/wordpress/2020/08/image-8-300x187.png 300w" sizes="(max-width: 408px) 100vw, 408px"></figure>

Setelah Anda klik _Connect_ akan muncuk popup, silakan klik _Yes_

<figure class="wp-block-image size-large"><img loading="lazy" width="818" height="484" src="/content/images/wordpress/2020/08/image-9.png" alt="" class="wp-image-73" srcset="/content/images/wordpress/2020/08/image-9.png 818w, /content/images/wordpress/2020/08/image-9-300x178.png 300w, /content/images/wordpress/2020/08/image-9-768x454.png 768w" sizes="(max-width: 818px) 100vw, 818px"></figure>

Selanjutnya isikan username dan password login ke VM CentOS 8 Anda

<figure class="wp-block-image size-large"><img loading="lazy" width="1024" height="576" src="/content/images/wordpress/2020/08/image-10-1024x576.png" alt="" class="wp-image-74" srcset="/content/images/wordpress/2020/08/image-10-1024x576.png 1024w, /content/images/wordpress/2020/08/image-10-300x169.png 300w, /content/images/wordpress/2020/08/image-10-768x432.png 768w, /content/images/wordpress/2020/08/image-10.png 1362w" sizes="(max-width: 1024px) 100vw, 1024px"></figure>

Setelah klik OK maka Anda akan melihat DE Gnome CentOS 8

<figure class="wp-block-image size-large"><img loading="lazy" width="1024" height="575" src="/content/images/wordpress/2020/08/image-11-1024x575.png" alt="" class="wp-image-75" srcset="/content/images/wordpress/2020/08/image-11-1024x575.png 1024w, /content/images/wordpress/2020/08/image-11-300x168.png 300w, /content/images/wordpress/2020/08/image-11-768x431.png 768w, /content/images/wordpress/2020/08/image-11.png 1366w" sizes="(max-width: 1024px) 100vw, 1024px"></figure><figure class="wp-block-image size-large"><img loading="lazy" width="1024" height="575" src="/content/images/wordpress/2020/08/image-12-1024x575.png" alt="" class="wp-image-76" srcset="/content/images/wordpress/2020/08/image-12-1024x575.png 1024w, /content/images/wordpress/2020/08/image-12-300x168.png 300w, /content/images/wordpress/2020/08/image-12-768x431.png 768w, /content/images/wordpress/2020/08/image-12.png 1359w" sizes="(max-width: 1024px) 100vw, 1024px"></figure>

Instalasi Xrdp Server di CentOS 8 sudah berhasil.

Selamat mencoba 😄

Please follow and like us:

[![error](/wp-content/plugins/ultimate-social-media-icons/images/follow_subscribe.png)](https://api.follow.it/widgets/icon/VHc3d1lpVGdwRnE5QnV0eERCNUx5RCtvTTVoUkNYS3NNRmd5eVhlQW9tNXRHS3VTbGh6Y0NybkRJRS8zSGpjRDVZb1ZGMlNTSEpJYUpuZzZqNzdnd3VSN3dwM2VlQTF6ejJEaGV5UGRUbnlEcHFNd3luYTV4ZTZtUGowVWI2Q2x8M2kzdnBEeUIrUk5xOFI5TXZ3cHF3bFNQRkRJSGhUNGdrRFd0TlNtdE1OWT0=/OA==/)

[![fb-share-icon](/wp-content/plugins/ultimate-social-media-icons/images/visit_icons/fbshare_bck.png "Facebook Share")](https://www.facebook.com/sharer/sharer.php?u=https%3A%2F%2Fbelajarlinux.id%2F%3Fp%3D68%26ghostexport%3Dtrue%26submit%3DDownload+Ghost+File)

[![Tweet](/wp-content/plugins/ultimate-social-media-icons/images/visit_icons/en_US_Tweet.svg "Tweet")](https://twitter.com/intent/tweet?text=Cara+Instalasi+XRDP+Server+%28Remote+Dekstop%29+pada+CentOS+8+https://belajarlinux.id/?p=68&ghostexport=true&submit=Download Ghost File)

[![fb-share-icon](/wp-content/plugins/ultimate-social-media-icons/images/share_icons/Pinterest_Save/en_US_save.svg "Pin Share")](#)

<!--kg-card-end: html-->
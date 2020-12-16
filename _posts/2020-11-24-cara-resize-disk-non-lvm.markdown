---
layout: post
title: 'Linux: Cara Resize Disk non LVM'
featured: true
date: '2020-11-24 16:33:23'
tags:
- volume
---

[Belajar Linux ID](/) - &nbsp;Tutorial kali ini kita akan membahas bagaimana cara melakukan resize root disk non LVM &nbsp;di sistem operasi Linux.

Sebelum melakukan resize disk non lvm ada baiknya Anda melakukan backup/snapshot terhadap VM atau instance tujuan jika terdapat kesalahan pada saat resize maka Anda dapat revert atau restore kembali menggunakan backup atau snaphost tersebut.

<!--kg-card-begin: html--><script async src="https://pagead2.googlesyndication.com/pagead/js/adsbygoogle.js"></script><ins class="adsbygoogle" style="display:block; text-align:center;" data-ad-layout="in-article" data-ad-format="fluid" data-ad-client="ca-pub-1515372853161377" data-ad-slot="1986938311"></ins><script>
     (adsbygoogle = window.adsbygoogle || []).push({});
</script><!--kg-card-end: html-->

Tutorial ini dapat berjalan di semua sistem operasi Linux dengan syarat disk nya non LVM, perhatikan gambar berikut

<figure class="kg-card kg-image-card"><img src="/content/images/2020/11/image-24.png" class="kg-image" alt srcset="/content/images/size/w600/2020/11/image-24.png 600w, /content/images/2020/11/image-24.png 717w"></figure>

Gambar diatas terdapat disk sebesar 20GB dimana disk disaat merupakan root disk yang masih belum di resize.

Untuk melakukan resize volume dapat di lakukan dengan mudah berikut tahapannya:

1. Resize disk root dari sisi portal vcloud atau vmware jika provider Cloud Anda menggunakan Vmware vsphere client, jika menggunakan Openstack dapat di resize melalui Horizon. 
2. Buat snapshot VM
3. Cek Disk VM menggunakan command `fdisk -l` apabila tidak bertambah dapat menjalankan beberapa baris perintah berikut
<!--kg-card-begin: markdown-->

    ls /sys/class/scsi_host/
    
    echo "- - -" > /sys/class/scsi_host/host0/scan
    echo "- - -" > /sys/class/scsi_host/host1/scan
    echo "- - -" > /sys/class/scsi_host/host2/scan
    echo "- - -" > /sys/class/scsi_host/host3/scan
    echo "- - -" > /sys/class/scsi_host/host4/scan
    echo "- - -" > /sys/class/scsi_host/host5/scan

<!--kg-card-end: markdown-->

Atau Anda dapat reboot VM atau instance nya.

4. Cek kembali disk VM menggunakan command `fdisk -l`

<figure class="kg-card kg-image-card"><img src="/content/images/2020/11/image-25.png" class="kg-image" alt></figure>

Terlihat gambar diatas saat ini disk root sudah bertambah dari 20GB ke 30 GB

5. Selanjutnya ketikan perintah `fdisk /dev/sda` pastikan Anda tidak salah menghapus yang benar, silakan cek terlebih dahulu menggunakan perintah &nbsp;`lsblk`

<figure class="kg-card kg-image-card"><img src="/content/images/2020/11/image-26.png" class="kg-image" alt srcset="/content/images/size/w600/2020/11/image-26.png 600w, /content/images/2020/11/image-26.png 647w"></figure>

Dalam kasus ini root berada di **sda2** atau tabel **2**

<!--kg-card-begin: html--><script async src="https://pagead2.googlesyndication.com/pagead/js/adsbygoogle.js"></script><ins class="adsbygoogle" style="display:block; text-align:center;" data-ad-layout="in-article" data-ad-format="fluid" data-ad-client="ca-pub-1515372853161377" data-ad-slot="4684565489"></ins><script>
     (adsbygoogle = window.adsbygoogle || []).push({});
</script><!--kg-card-end: html-->

Pada pemilihan _Do you want to remove the signature? [Y]es/[N]o:_ pastikan memilih &nbsp;_N_

<figure class="kg-card kg-image-card"><img src="/content/images/2020/11/image-27.png" class="kg-image" alt srcset="/content/images/size/w600/2020/11/image-27.png 600w, /content/images/2020/11/image-27.png 864w" sizes="(min-width: 720px) 720px"></figure>

6. Selanjutnya jalankan command `resize2fs /dev/[mount-point]` contohnya `resize2fs /dev/sda2`

<figure class="kg-card kg-image-card"><img src="/content/images/2020/11/image-28.png" class="kg-image" alt></figure>

7. Langkah terakhir melakukan verifikasi root disk apakah sudah berubah menjadi 30GB gunakan perintah `df -h`

<figure class="kg-card kg-image-card"><img src="/content/images/2020/11/image-29.png" class="kg-image" alt></figure>

Terlihat pada gambar diatas saat ini untuk root volume sudah sudah berubah dari 20GB ke 20GB.

Selamat mencoba 😁


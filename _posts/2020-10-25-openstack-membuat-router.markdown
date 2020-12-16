---
layout: post
title: 'Openstack: Membuat Router'
featured: true
date: '2020-10-25 18:40:49'
tags:
- openstack
---

[Belajar Linux ID](/) – Tutorial kali ini kelanjutan dari tutorial sebelumnya mengenai cara membuat network di openstack yang dapat Anda lihat pada link berikut: [Openstack: Membuat Network](/openstack-membuat-network/)

Di tutorial kali ini kita akan membuat router melalui horizon, fungsi router sendiri untuk menghubungkan network yang telah kita buat sebelumnya, jika di lihat melalui _Network topologi_ saat ini sudah terdapat 2 network internal dan external

<figure class="wp-block-image size-large"><img loading="lazy" width="1024" height="505" src="/content/images/wordpress/2020/10/1-4-1024x505.png" alt="" class="wp-image-714" srcset="/content/images/wordpress/2020/10/1-4-1024x505.png 1024w, /content/images/wordpress/2020/10/1-4-300x148.png 300w, /content/images/wordpress/2020/10/1-4-768x379.png 768w, /content/images/wordpress/2020/10/1-4.png 1342w" sizes="(max-width: 1024px) 100vw, 1024px"></figure>

Untuk membuat router _Login ke Horizon \>\> Network \>\> Router \>\> Create Router_

<figure class="wp-block-image size-large"><img loading="lazy" width="1024" height="329" src="/content/images/wordpress/2020/10/2-5-1024x329.png" alt="" class="wp-image-715" srcset="/content/images/wordpress/2020/10/2-5-1024x329.png 1024w, /content/images/wordpress/2020/10/2-5-300x96.png 300w, /content/images/wordpress/2020/10/2-5-768x247.png 768w, /content/images/wordpress/2020/10/2-5.png 1363w" sizes="(max-width: 1024px) 100vw, 1024px"></figure>

Isi nama Router yang Anda inginkan contoh seperti gambar dibawah ini, klik **Create Router** untuk membuat router

<figure class="wp-block-image size-large"><img loading="lazy" width="732" height="466" src="/content/images/wordpress/2020/10/3-3.png" alt="" class="wp-image-716" srcset="/content/images/wordpress/2020/10/3-3.png 732w, /content/images/wordpress/2020/10/3-3-300x191.png 300w" sizes="(max-width: 732px) 100vw, 732px"></figure>

Hasilnya seperti berikut ini

<figure class="wp-block-image size-large"><img loading="lazy" width="1024" height="302" src="/content/images/wordpress/2020/10/4-2-1024x302.png" alt="" class="wp-image-717" srcset="/content/images/wordpress/2020/10/4-2-1024x302.png 1024w, /content/images/wordpress/2020/10/4-2-300x88.png 300w, /content/images/wordpress/2020/10/4-2-768x226.png 768w, /content/images/wordpress/2020/10/4-2.png 1361w" sizes="(max-width: 1024px) 100vw, 1024px"></figure>

Berikut detail informasi dari router yang telah dibuat

<figure class="wp-block-image size-large"><img loading="lazy" width="1024" height="492" src="/content/images/wordpress/2020/10/5-3-1024x492.png" alt="" class="wp-image-718" srcset="/content/images/wordpress/2020/10/5-3-1024x492.png 1024w, /content/images/wordpress/2020/10/5-3-300x144.png 300w, /content/images/wordpress/2020/10/5-3-768x369.png 768w, /content/images/wordpress/2020/10/5-3.png 1047w" sizes="(max-width: 1024px) 100vw, 1024px"></figure>

Selanjutnya pindah ke menu **Interface \>\> Add Interface** untuk menambahkan interface network yang sudah kita buat sebelumnya

<figure class="wp-block-image size-large"><img loading="lazy" width="1024" height="324" src="/content/images/wordpress/2020/10/6-1-1024x324.png" alt="" class="wp-image-719" srcset="/content/images/wordpress/2020/10/6-1-1024x324.png 1024w, /content/images/wordpress/2020/10/6-1-300x95.png 300w, /content/images/wordpress/2020/10/6-1-768x243.png 768w, /content/images/wordpress/2020/10/6-1.png 1362w" sizes="(max-width: 1024px) 100vw, 1024px"></figure>

Pilih network internal yang sudah dibuat sebelumnya lalu **Submit**

<figure class="wp-block-image size-large"><img loading="lazy" width="732" height="321" src="/content/images/wordpress/2020/10/7-1.png" alt="" class="wp-image-720" srcset="/content/images/wordpress/2020/10/7-1.png 732w, /content/images/wordpress/2020/10/7-1-300x132.png 300w" sizes="(max-width: 732px) 100vw, 732px"></figure>

Saat ini interface sudah berhasil di tambahkan

<figure class="wp-block-image size-large"><img loading="lazy" width="1024" height="354" src="/content/images/wordpress/2020/10/8-1-1024x354.png" alt="" class="wp-image-721" srcset="/content/images/wordpress/2020/10/8-1-1024x354.png 1024w, /content/images/wordpress/2020/10/8-1-300x104.png 300w, /content/images/wordpress/2020/10/8-1-768x265.png 768w, /content/images/wordpress/2020/10/8-1.png 1360w" sizes="(max-width: 1024px) 100vw, 1024px"></figure>

Selajutnya test ping dari controller ke IP Gateway atau IP Router yang sudah kita buat sebelumnya.

<figure class="wp-block-image size-large"><img loading="lazy" width="1024" height="472" src="/content/images/wordpress/2020/10/9-1-1024x472.png" alt="" class="wp-image-722" srcset="/content/images/wordpress/2020/10/9-1-1024x472.png 1024w, /content/images/wordpress/2020/10/9-1-300x138.png 300w, /content/images/wordpress/2020/10/9-1-768x354.png 768w, /content/images/wordpress/2020/10/9-1-1536x709.png 1536w, /content/images/wordpress/2020/10/9-1.png 1912w" sizes="(max-width: 1024px) 100vw, 1024px"></figure>

Apabila sudah reply seperti diatas maka pembuatan router nya sudah berhasil.

Selamat mencoba 😁

Please follow and like us:

[![error](/wp-content/plugins/ultimate-social-media-icons/images/follow_subscribe.png)](https://api.follow.it/widgets/icon/VHc3d1lpVGdwRnE5QnV0eERCNUx5RCtvTTVoUkNYS3NNRmd5eVhlQW9tNXRHS3VTbGh6Y0NybkRJRS8zSGpjRDVZb1ZGMlNTSEpJYUpuZzZqNzdnd3VSN3dwM2VlQTF6ejJEaGV5UGRUbnlEcHFNd3luYTV4ZTZtUGowVWI2Q2x8M2kzdnBEeUIrUk5xOFI5TXZ3cHF3bFNQRkRJSGhUNGdrRFd0TlNtdE1OWT0=/OA==/)

[![fb-share-icon](/wp-content/plugins/ultimate-social-media-icons/images/visit_icons/fbshare_bck.png "Facebook Share")](https://www.facebook.com/sharer/sharer.php?u=https%3A%2F%2Fbelajarlinux.id%2F%3Fp%3D713%26ghostexport%3Dtrue%26submit%3DDownload+Ghost+File)

[![Tweet](/wp-content/plugins/ultimate-social-media-icons/images/visit_icons/en_US_Tweet.svg "Tweet")](https://twitter.com/intent/tweet?text=Openstack%3A+Membuat+Router+https://belajarlinux.id/?p=713&ghostexport=true&submit=Download Ghost File)

[![fb-share-icon](/wp-content/plugins/ultimate-social-media-icons/images/share_icons/Pinterest_Save/en_US_save.svg "Pin Share")](#)

<!--kg-card-end: html-->
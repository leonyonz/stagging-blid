---
layout: post
title: 'Openstack: Membuat Instance Melalui Horizon'
featured: true
date: '2020-10-26 16:34:41'
tags:
- openstack
---

[Belajar Linux ID](/) – Pada tutorial kali ini kami akan bahas bagaimana cara membuat instance atau VM melalui horizon. Sebelum membuat instance pastikan Anda sudah membuat router, networ serta security group atau dapat merujuk pada link berikut, untuk kebutuhan create instance nya.

- [Openstack: Upload Image atau ISO](/openstack-upload-image-atau-iso/)
- [Openstack: Membuat Network](/openstack-membuat-network/)
- [Openstack: Membuat Router](/openstack-membuat-router/)
- [Openstack: Menambahkan SSH Key](/openstack-menambahkan-ssh-key/)
- [Openstack: Menambah dan Menggunakan Security Group](/openstack-menambahkan-dan-menggunakan-security-group/)

Berikut tahapan – tahapan membuat instance:

_Login Horizon \>\> Project \>\> Compute \>\> Instances \>\> Launch Instance_

<figure class="wp-block-image size-large"><img loading="lazy" width="1024" height="331" src="/content/images/wordpress/2020/10/1-8-1024x331.png" alt="" class="wp-image-754" srcset="/content/images/wordpress/2020/10/1-8-1024x331.png 1024w, /content/images/wordpress/2020/10/1-8-300x97.png 300w, /content/images/wordpress/2020/10/1-8-768x248.png 768w, /content/images/wordpress/2020/10/1-8.png 1363w" sizes="(max-width: 1024px) 100vw, 1024px"></figure>

Pada menu **Details** silakan isi nama instance yang ingin Anda gunakan

<figure class="wp-block-image size-large"><img loading="lazy" width="956" height="553" src="/content/images/wordpress/2020/10/2-9.png" alt="" class="wp-image-755" srcset="/content/images/wordpress/2020/10/2-9.png 956w, /content/images/wordpress/2020/10/2-9-300x174.png 300w, /content/images/wordpress/2020/10/2-9-768x444.png 768w" sizes="(max-width: 956px) 100vw, 956px"></figure>

Pada menu **Source** silakan pilih OS atau image yang ingin Anda gunakan, disini kami contohkan OS yang kami gunakan yaitu **Cirros**

<figure class="wp-block-image size-large"><img loading="lazy" width="957" height="552" src="/content/images/wordpress/2020/10/3-7.png" alt="" class="wp-image-756" srcset="/content/images/wordpress/2020/10/3-7.png 957w, /content/images/wordpress/2020/10/3-7-300x173.png 300w, /content/images/wordpress/2020/10/3-7-768x443.png 768w" sizes="(max-width: 957px) 100vw, 957px"></figure>

Pada menu **Flavor** silakan pilih spesifikasi instance yang ingin Anda gunakan

<figure class="wp-block-image size-large"><img loading="lazy" width="954" height="579" src="/content/images/wordpress/2020/10/4-6.png" alt="" class="wp-image-757" srcset="/content/images/wordpress/2020/10/4-6.png 954w, /content/images/wordpress/2020/10/4-6-300x182.png 300w, /content/images/wordpress/2020/10/4-6-768x466.png 768w" sizes="(max-width: 954px) 100vw, 954px"></figure>

Pada menu **Networks** silakan pilih network internal yang telah dibuat sebelumnya.

<figure class="wp-block-image size-large"><img loading="lazy" width="954" height="553" src="/content/images/wordpress/2020/10/5-7.png" alt="" class="wp-image-758" srcset="/content/images/wordpress/2020/10/5-7.png 954w, /content/images/wordpress/2020/10/5-7-300x174.png 300w, /content/images/wordpress/2020/10/5-7-768x445.png 768w" sizes="(max-width: 954px) 100vw, 954px"></figure>

Selanjutnya lanjut ke menu **Security Groups** , silakan pilih Security Groups yang telah dibuat sebelumnya.

<figure class="wp-block-image size-large"><img loading="lazy" width="960" height="552" src="/content/images/wordpress/2020/10/6-4.png" alt="" class="wp-image-759" srcset="/content/images/wordpress/2020/10/6-4.png 960w, /content/images/wordpress/2020/10/6-4-300x173.png 300w, /content/images/wordpress/2020/10/6-4-768x442.png 768w" sizes="(max-width: 960px) 100vw, 960px"></figure>

Pada menu **Key Pair** silakan pilih key pair yang telah di buat juga sebelumnya

<figure class="wp-block-image size-large"><img loading="lazy" width="960" height="632" src="/content/images/wordpress/2020/10/7-2.png" alt="" class="wp-image-760" srcset="/content/images/wordpress/2020/10/7-2.png 960w, /content/images/wordpress/2020/10/7-2-300x198.png 300w, /content/images/wordpress/2020/10/7-2-768x506.png 768w" sizes="(max-width: 960px) 100vw, 960px"></figure>

Jika sudah silakan, create **Launch Instance** silakan tunggu proses pembuatan Instance selesai, jika sudah selesai akan nampak seperti gambar dibawah ini

<figure class="wp-block-image size-large"><img loading="lazy" width="1024" height="355" src="/content/images/wordpress/2020/10/8-2-1024x355.png" alt="" class="wp-image-761" srcset="/content/images/wordpress/2020/10/8-2-1024x355.png 1024w, /content/images/wordpress/2020/10/8-2-300x104.png 300w, /content/images/wordpress/2020/10/8-2-768x266.png 768w, /content/images/wordpress/2020/10/8-2.png 1355w" sizes="(max-width: 1024px) 100vw, 1024px"></figure>

Saat ini instance sudah mendapatkan IP internal secara otomatis, supaya dapat diakses dari public silakan membuat floating IP pada instance silakan klik menu **Associate Floating IP**

<figure class="wp-block-image size-large"><img loading="lazy" width="1024" height="389" src="/content/images/wordpress/2020/10/9-2-1024x389.png" alt="" class="wp-image-762" srcset="/content/images/wordpress/2020/10/9-2-1024x389.png 1024w, /content/images/wordpress/2020/10/9-2-300x114.png 300w, /content/images/wordpress/2020/10/9-2-768x291.png 768w, /content/images/wordpress/2020/10/9-2.png 1352w" sizes="(max-width: 1024px) 100vw, 1024px"></figure>

Klik tanda **+**

<figure class="wp-block-image size-large"><img loading="lazy" width="730" height="294" src="/content/images/wordpress/2020/10/10-1.png" alt="" class="wp-image-763" srcset="/content/images/wordpress/2020/10/10-1.png 730w, /content/images/wordpress/2020/10/10-1-300x121.png 300w" sizes="(max-width: 730px) 100vw, 730px"></figure>

Pilih **network external \>\> Allocate IP**

<figure class="wp-block-image size-large"><img loading="lazy" width="731" height="340" src="/content/images/wordpress/2020/10/11.png" alt="" class="wp-image-765" srcset="/content/images/wordpress/2020/10/11.png 731w, /content/images/wordpress/2020/10/11-300x140.png 300w" sizes="(max-width: 731px) 100vw, 731px"></figure>

Saat ini kita sudah mendapatkan IP nya, silakan klik **Associate** untuk dapat di assign ke instance Anda

<figure class="wp-block-image size-large"><img loading="lazy" width="1024" height="305" src="/content/images/wordpress/2020/10/12-1024x305.png" alt="" class="wp-image-766" srcset="/content/images/wordpress/2020/10/12-1024x305.png 1024w, /content/images/wordpress/2020/10/12-300x89.png 300w, /content/images/wordpress/2020/10/12-768x229.png 768w, /content/images/wordpress/2020/10/12.png 1034w" sizes="(max-width: 1024px) 100vw, 1024px"></figure>

Saat ini instance sudah mendapatkan dan menggunakan IP dari network internal dan external dan silakan test ping ke IP floating

<figure class="wp-block-image size-large"><img loading="lazy" width="1024" height="438" src="/content/images/wordpress/2020/10/15-1024x438.png" alt="" class="wp-image-770" srcset="/content/images/wordpress/2020/10/15-1024x438.png 1024w, /content/images/wordpress/2020/10/15-300x128.png 300w, /content/images/wordpress/2020/10/15-768x329.png 768w, /content/images/wordpress/2020/10/15-1536x658.png 1536w, /content/images/wordpress/2020/10/15.png 1913w" sizes="(max-width: 1024px) 100vw, 1024px"></figure>

Test login ke sisi instance

<figure class="wp-block-image size-large is-resized"><img loading="lazy" src="/content/images/wordpress/2020/10/16-1024x304.png" alt="" class="wp-image-771" width="580" height="172" srcset="/content/images/wordpress/2020/10/16-1024x304.png 1024w, /content/images/wordpress/2020/10/16-300x89.png 300w, /content/images/wordpress/2020/10/16-768x228.png 768w, /content/images/wordpress/2020/10/16.png 1106w" sizes="(max-width: 580px) 100vw, 580px"></figure>

Selamat mencoba 😁

Please follow and like us:

[![error](/wp-content/plugins/ultimate-social-media-icons/images/follow_subscribe.png)](https://api.follow.it/widgets/icon/VHc3d1lpVGdwRnE5QnV0eERCNUx5RCtvTTVoUkNYS3NNRmd5eVhlQW9tNXRHS3VTbGh6Y0NybkRJRS8zSGpjRDVZb1ZGMlNTSEpJYUpuZzZqNzdnd3VSN3dwM2VlQTF6ejJEaGV5UGRUbnlEcHFNd3luYTV4ZTZtUGowVWI2Q2x8M2kzdnBEeUIrUk5xOFI5TXZ3cHF3bFNQRkRJSGhUNGdrRFd0TlNtdE1OWT0=/OA==/)

[![fb-share-icon](/wp-content/plugins/ultimate-social-media-icons/images/visit_icons/fbshare_bck.png "Facebook Share")](https://www.facebook.com/sharer/sharer.php?u=https%3A%2F%2Fbelajarlinux.id%2F%3Fp%3D753%26ghostexport%3Dtrue%26submit%3DDownload+Ghost+File)

[![Tweet](/wp-content/plugins/ultimate-social-media-icons/images/visit_icons/en_US_Tweet.svg "Tweet")](https://twitter.com/intent/tweet?text=Openstack%3A+Membuat+Instance+Melalui+Horizon+https://belajarlinux.id/?p=753&ghostexport=true&submit=Download Ghost File)

[![fb-share-icon](/wp-content/plugins/ultimate-social-media-icons/images/share_icons/Pinterest_Save/en_US_save.svg "Pin Share")](#)

<!--kg-card-end: html-->
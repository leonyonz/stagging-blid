---
layout: post
title: 'CentOS: Membuat Basic Auth Pada HAProxy'
featured: true
date: '2020-12-13 10:13:52'
tags:
- centos
- haproxy
---

Pada tutorial kali ini kami akan memberikan cara sederhana bagaimana membuat authentikasi login pada halaman Frontend HAProxy menggunakan username dan password, sehingga halaman yang tampil akan menunjukan pop up authentikasi terlebih dahulu sebelum dapat diakses.

<!--kg-card-begin: html--><script async src="https://pagead2.googlesyndication.com/pagead/js/adsbygoogle.js"></script><ins class="adsbygoogle" style="display:block; text-align:center;" data-ad-layout="in-article" data-ad-format="fluid" data-ad-client="ca-pub-1515372853161377" data-ad-slot="1986938311"></ins><script>
     (adsbygoogle = window.adsbygoogle || []).push({});
</script><!--kg-card-end: html-->

Untuk mengikuti tutorial kali ini pastikan Anda sudah melakukan instalasi HAProxy, silakan buka konfigurasi haproxy Anda.

<!--kg-card-begin: markdown-->

    # vi /etc/haproxy/haproxy.cfg

<!--kg-card-end: markdown-->

Buat user dan password yang nantinya digunakan saat authentikasi.

<!--kg-card-begin: markdown-->

    userlist auth_users
      user [user-anda] insecure-password [password-anda]

<!--kg-card-end: markdown-->

**Keterangan:**

- **userlist:** Tag pada HAProxy.
- **auth\_users:** Nama Tag.
- **user:** String untuk nama user
- **insecure-password:** String untuk password

Pada bagian Frontend tambahkan bagian ini:

<!--kg-card-begin: markdown-->

    frontend yourfront
      bind *:8000
      mode http
      acl auth_ok http_auth(auth_users)
      http-request auth unless auth_ok
      default_backend node-backend

<!--kg-card-end: markdown-->

Setelah konfigurasi disimpan, tes halaman frontend menggunakan browser.

<figure class="kg-card kg-image-card"><img src="/content/images/2020/12/image-11.png" class="kg-image" alt srcset="/content/images/size/w600/2020/12/image-11.png 600w, /content/images/size/w1000/2020/12/image-11.png 1000w, /content/images/2020/12/image-11.png 1355w" sizes="(min-width: 720px) 720px"></figure>
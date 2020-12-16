---
layout: post
title: 'Linux: Cara Menggunakan Curl'
featured: true
date: '2020-11-14 10:59:51'
tags:
- linux
- centos
- ubuntu
---

[Belajar Linux ID](/) - `Curl` adalah command-line atau utility yang tersedia di Linux. `Curl` sendiri singkatan dari `Client URL`. Biasanya `curl` digunakna untuk test koneksi ke `URL` serta dapat digunakan sebagai tool transfer data. Selain protokol `HTTP`, `curl` juga dapat digunakan pada protokol `FTP, IMAP, Telnet, SMTP`.

Sebagian besar paket `curl` sudah terinstall di distribusi Linux saat ini. Berikut ini cara install `curl` di beberapa distro Linux

<!--kg-card-begin: markdown-->
### Ubuntu dan Debian

    $ sudo apt update
    $ sudo apt install curl

### CentOS dan Fedora

    sudo yum install curl

### ArchLinux

    $ pacman -Sy curl

### OpenSUSE

    $ zypper install curl

<!--kg-card-end: markdown-->

Berikut kami contohkan bagaimana cara cek versi `curl` di Ubuntu

<!--kg-card-begin: markdown-->

    $ curl --version
    curl 7.58.0 (x86_64-pc-linux-gnu) libcurl/7.58.0 OpenSSL/1.1.1 zlib/1.2.11 libidn2/2.0.4 libpsl/0.19.1 (+libidn2/2.0.4) nghttp2/1.30.0 librtmp/2.3
    Release-Date: 2018-01-24
    Protocols: dict file ftp ftps gopher http https imap imaps ldap ldaps pop3 pop3s rtmp rtsp smb smbs smtp smtps telnet tftp
    Features: AsynchDNS IDN IPv6 Largefile GSS-API Kerberos SPNEGO NTLM NTLM_WB SSL libz TLS-SRP HTTP2 UnixSockets HTTPS-proxy PSL
    $

<!--kg-card-end: markdown-->

Sintak dalam penggunaan `curl` sebagai berikut

<!--kg-card-begin: markdown-->

    curl [options] [URL...]

<!--kg-card-end: markdown-->

Berikut opsi - opsi `curl` yang dapat Anda gunakan:

### Options
<!--kg-card-begin: markdown-->

| Opsi | Keterangan |
| --- | --- |
| -o <file></file> | --output: write to file |
| -u user:pass | --user: Authentication |
| -v | --verbose |
| -vv | Even more verbose |
| -s | --silent |
| -i | --include: Include the HTTP-header in the output |
| -I | --head: headers only |

<!--kg-card-end: markdown-->
### Request
<!--kg-card-begin: markdown-->

| Opsi | Keterangan |
| --- | --- |
| -X POST | --request |
| -L | follow link if page redirects |

<!--kg-card-end: markdown-->
### Data
<!--kg-card-begin: markdown-->

| Opsi | Keterangan |
| --- | --- |
| -d 'data' | --data: HTTP post data, URL encoded (eg, status="Hello") |
| -d @file | --data via file |
| -G | --get: send -d data via get |

<!--kg-card-end: markdown-->
### Headers
<!--kg-card-begin: markdown-->

| Opsi | Keterangan |
| --- | --- |
| -A <str></str> | --user-agent |
| -b name=val | --cookie |
| -b FILE | --cookie |
| -H "X-Foo: y" | --header |
| --compressed | use deflate/gzip |

<!--kg-card-end: markdown-->

Untuk menggunakan `curl` sangatlah mudah, misalnya kita ingin mengetahui `HTTP Headers` dari sebuah website menggunakan `curl` dapat di lakukan contoh

<!--kg-card-begin: markdown-->

    ubuntu@my-jumper:~$ curl -I https://www.ubuntu.com/
    HTTP/1.1 301 Moved Permanently
    server: nginx/1.14.0 (Ubuntu)
    date: Sat, 14 Nov 2020 10:29:21 GMT
    content-type: text/html
    content-length: 175
    location: https://ubuntu.com/
    link: <https://assets.ubuntu.com>; rel=preconnect; crossorigin, <https://assets.ubuntu.com>; rel=preconnect, <https://res.cloudinary.com>; rel=preconnect
    x-cache-status: MISS from content-cache-1ss/0
    
    ubuntu@my-jumper:~$

<!--kg-card-end: markdown--><!--kg-card-begin: html--><script async src="https://pagead2.googlesyndication.com/pagead/js/adsbygoogle.js"></script><ins class="adsbygoogle" style="display:block; text-align:center;" data-ad-layout="in-article" data-ad-format="fluid" data-ad-client="ca-pub-1515372853161377" data-ad-slot="4684565489"></ins><script>
     (adsbygoogle = window.adsbygoogle || []).push({});
</script><!--kg-card-end: html-->

Selanjutnya jika ingin mengetahui website menggunakan `HTTP/2` dapat dilakukan menggunakan `curl` contoh

<!--kg-card-begin: markdown-->

    ubuntu@my-jumper:~$
    ubuntu@my-jumper:~$ curl -I --http2 -s https://belajarlinux.id/ | grep HTTP
    HTTP/2 200
    ubuntu@my-jumper:~$

<!--kg-card-end: markdown-->

Selain itu `curl` juga dapat \*\*GET XML\*\*

<!--kg-card-begin: markdown-->

    $ curl -H "Accept: application/xml" -H "Content-Type: application/xml" -X GET "http://hostname/resource"

<!--kg-card-end: markdown-->

**GET JSON**

<!--kg-card-begin: markdown-->

    $ curl -i -H "Accept: application/json" -H "Content-Type: application/json" -X GET "http://hostname/resource"

<!--kg-card-end: markdown-->

**JSON PUT**

<!--kg-card-begin: markdown-->

    $ curl -i -H 'Content-Type: application/json' -H 'Accept: application/json' -X PUT -d '{"updated_field1":"updated_value1"}' "http://hostname/resourcex"

<!--kg-card-end: markdown-->

**POST**

<!--kg-card-begin: markdown-->

    $ curl -i -X POST -H 'Content-Type: application/x-www-form-urlencoded' --data 'key1=value1&key2=value2' url

<!--kg-card-end: markdown-->

**Debugging Mode**

<!--kg-card-begin: markdown-->

    $ curl -XGET -vvv http://hostname/resource > dev\null

<!--kg-card-end: markdown-->

**Download Multi File**

<!--kg-card-begin: markdown-->

    $curl -O http://mirrors.edge.kernel.org/archlinux/iso/2018.06.01/archlinux-2018.06.01-x86_64.iso \
    $ -O https://cdimage.debian.org/debian-cd/current/amd64/iso-cd/debian-9.4.0-amd64-netinst.iso

<!--kg-card-end: markdown-->

**Resume Download**

<!--kg-card-begin: markdown-->

    $ curl -O http://releases.ubuntu.com/18.04/ubuntu-18.04-live-server-amd64.iso

<!--kg-card-end: markdown-->

Jika tiba - tiba koneksi Anda terputus Anda dapat melanjutkannya kembali

<!--kg-card-begin: markdown-->

    $ curl -C - -O http://releases.ubuntu.com/18.04/ubuntu-18.04-live-server-amd64.iso

<!--kg-card-end: markdown-->

**Transfer file via FTP**

<!--kg-card-begin: markdown-->

    $ curl -u FTP_USERNAME:FTP_PASSWORD ftp://ftp.example.com/

<!--kg-card-end: markdown-->

Setelah masuk, perintah akan mencantumkan semua file dan direktori di direktori beranda pengguna atau user. Anda dapat download satu file dari server FTP menggunakan sintaks berikut:

<!--kg-card-begin: markdown-->

    $ curl -u FTP_USERNAME:FTP_PASSWORD ftp://ftp.example.com/file.tar.gz

<!--kg-card-end: markdown-->

Untuk mengupload file ke server FTP, gunakan `-T` diikuti dengan nama file yang ingin Anda upload:

<!--kg-card-begin: markdown-->

    $ curl -T newfile.tar.gz -u FTP_USERNAME:FTP_PASSWORD ftp://ftp.example.com/

<!--kg-card-end: markdown-->

**Send Cookies**

Terkadang Anda mungkin perlu membuat permintaan `HTTP` dengan cookie tertentu untuk mengakses sumber daya jarak jauh atau untuk men-debug masalah.

Secara default, saat meminta sumber daya dengan curl, tidak ada cookie yang dikirim atau disimpan.

<!--kg-card-begin: html--><script async src="https://pagead2.googlesyndication.com/pagead/js/adsbygoogle.js"></script><ins class="adsbygoogle" style="display:block; text-align:center;" data-ad-layout="in-article" data-ad-format="fluid" data-ad-client="ca-pub-1515372853161377" data-ad-slot="4684565489"></ins><script>
     (adsbygoogle = window.adsbygoogle || []).push({});
</script><!--kg-card-end: html-->

Untuk mengirim cookie ke server, gunakan tombol `-b` diikuti dengan nama file yang berisi cookie atau string.

Misalnya, untuk mengunduh `file rpm` **JDK Oracle Java jdk-10.0.2\_linux-x64\_bin.rpm,** Anda harus meneruskan cookie bernama `oraclelicense` dengan nilai `a`:

<!--kg-card-begin: markdown-->

    $ curl -L -b "oraclelicense=a" -O http://download.oracle.com/otn-pub/java/jdk/10.0.2+13/19aef61b38124481863b1413dce1855f/jdk-10.0.2_linux-x64_bin.rpm

<!--kg-card-end: markdown-->

**Curl Sebagai Proxy**

curl mendukung berbagai jenis proxy, termasuk `HTTP, HTTPS,` dan `SOCKS`. Untuk transfer data melalui server proxy, gunakan opsi `-x (--proxy)`, diikuti dengan URL proxy.

Perintah berikut mengunduh sumber daya yang ditentukan menggunakan proxy pada `192.168.44.1 port 8888:`

<!--kg-card-begin: markdown-->

    $ curl -x 192.168.44.1:8888 http://domainanda.id/

<!--kg-card-end: markdown-->

Jika server proxy memerlukan otentikasi, gunakan opsi `-U (--proxy-user)` diikuti dengan nama pengguna dan kata sandi dipisahkan oleh titik dua `(pengguna: kata sandi):`

<!--kg-card-begin: markdown-->

    $ curl -U username:password -x 192.168.44.1:8888 http://domainanda.id/

<!--kg-card-end: markdown-->

Selengkapnya mengenai `curl` dapat dilihat melalui dokumentasi `curl` berikut: [https://curl.se/docs/](https://curl.se/docs/)

Selamat mencoba 😁

<!--kg-card-begin: html--><script async src="https://pagead2.googlesyndication.com/pagead/js/adsbygoogle.js"></script><ins class="adsbygoogle" style="display:block; text-align:center;" data-ad-layout="in-article" data-ad-format="fluid" data-ad-client="ca-pub-1515372853161377" data-ad-slot="4684565489"></ins><script>
     (adsbygoogle = window.adsbygoogle || []).push({});
</script><!--kg-card-end: html-->
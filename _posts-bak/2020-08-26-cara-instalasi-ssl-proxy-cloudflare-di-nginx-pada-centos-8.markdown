---
layout: post
title: Cara Instalasi SSL + Proxy CloudFlare di Nginx pada CentOS 8
featured: true
date: '2020-08-26 23:15:38'
tags:
- centos
- nginx
- ssl
---

Menurut Wikipedia [Cloudflare, Inc](https://en.wikipedia.org/wiki/Cloudflare). adalah perusahaan infrastruktur web dan keamanan situs web yang menyediakan layanan _CDN ([content-delivery-network](https://en.wikipedia.org/wiki/Content_delivery_network)), [DDoS mitigation](https://en.wikipedia.org/wiki/DDoS_mitigation), [Internet security](https://en.wikipedia.org/wiki/Internet_security), dan DNS managemen([domain-name-server](https://en.wikipedia.org/wiki/Domain_name_server))._

Cloudflare juga dapat digunakan sebagai proxy server (sebagai perantara) dan cloudflare juga menyediakan SSL Free yang dapat Anda gunakan.

Sangat banyak yang telah menggunakan dan merekomendakan cloudflare dari berbagai macam aspek mulai dari ketangguhan, kecepan dan tentunya performa website yang lebih baik.

Pada tutorial kali ini kami akan memberikan cara bagaimana melakukan instalasi SSL dari Cloudflare sekaligus menggunakan proxy dari cloudflare berikut contoh topologinya

<figure class="wp-block-image size-large"><img loading="lazy" width="651" height="136" src="/content/images/wordpress/2020/08/Cfnginx-topologi.png" alt="" class="wp-image-331" srcset="/content/images/wordpress/2020/08/Cfnginx-topologi.png 651w, /content/images/wordpress/2020/08/Cfnginx-topologi-300x63.png 300w" sizes="(max-width: 651px) 100vw, 651px"></figure>

Berikut cara kerja dari topologi diatas

_Client akses website drupal.nurhamim.my.id \>\> diteruskan ke cloudflare sebagai proxy jika tidak ada isu di sisi cloudflare \>\> diteruskan ke web server nginx \>\> barulah hasil tampilan website drupal.nurhamim.my.id akan dapat di lihat oleh client._

Untuk mengikuti tutorial ini pastikan Anda sudah menambahkan domain Anda ke cloudflare dan domain Anda sudah menggunakan name server cloudflare, berikut contoh domain yang sudah menggunakan cloudflare

<figure class="wp-block-image size-large"><img loading="lazy" width="676" height="116" src="/content/images/wordpress/2020/08/image-90.png" alt="" class="wp-image-332" srcset="/content/images/wordpress/2020/08/image-90.png 676w, /content/images/wordpress/2020/08/image-90-300x51.png 300w" sizes="(max-width: 676px) 100vw, 676px"></figure>

Untuk panduan add domain ke cloudflare Anda dapat mengikuti panduan berikut: **[Creating a Cloudflare account and adding a website](https://support.cloudflare.com/hc/en-us/articles/201720164-Creating-a-Cloudflare-account-and-adding-a-website)**

Selain itu pastikan Anda sudah melakukan instalasi cms misalnya drupal seperti yang akan di praktekan kali ini, untuk instalasi drupal dapat merujuk pada link berikut: [_ **Cara Instalasi Drupal Menggunakan Nginx di CentOS 8** _](/cara-instalasi-drupal-menggunakan-nginx-di-centos-8/)

Pada tutorial ini sebagai contoh subdomain drupal.nurhamim.my.id akan menggunakan SSL dari Cloudflare.

Untuk mendapatkan SSL di Cloudflare silakan login ke _cloudflare \>\> SSL/TLS \>\> Create Certificate \>\> Next_

<figure class="wp-block-image size-large"><img loading="lazy" width="1024" height="587" src="/content/images/wordpress/2020/08/image-91-1024x587.png" alt="" class="wp-image-333" srcset="/content/images/wordpress/2020/08/image-91-1024x587.png 1024w, /content/images/wordpress/2020/08/image-91-300x172.png 300w, /content/images/wordpress/2020/08/image-91-768x440.png 768w, /content/images/wordpress/2020/08/image-91.png 1534w" sizes="(max-width: 1024px) 100vw, 1024px"></figure>

Buat dan copy file _Origin Certificate_ dan _Private key_ ke direktori SSL di sisi VM seperti berikut ini

    [root@tutorial ~]# cd /etc/ssl/certs/
    [root@tutorial certs]#
    [root@tutorial certs]# vim cf-certificate.pem

Isi file _origin certificate_

    -----BEGIN CERTIFICATE-----
    MIIEqDCCA5CgAwIBAgIUHZRhxQZPDNu/n29A4F0IEvzt988wDQYJKoZIhvcNAQEL
    BQAwgYsxCzAJBgNVBAYTAlVTMRkwFwYDVQQKExBDbG91ZEZsYXJlLCBJbmMuMTQw
    MgYDVQQLEytDbG91ZEZsYXJlIE9yaWdpbiBTU0wgQ2VydGlmaWNhdGUgQXV0aG9y
    aXR5MRYwFAYDVQQHEw1TYW4gRnJhbmNpc2NvMRMwEQYDVQQIEwpDYWxpZm9ybmlh
    MB4XDTIwMDgyNjE1NTEwMFoXDTM1MDgyMzE1NTEwMFowYjEZMBcGA1UEChMQQ2xv
    dWRGbGFyZSwgSW5jLjEdMBsGA1UECxMUQ2xvdWRGbGFyZSBPcmlnaW4gQ0ExJjAk
    BgNVBAMTHUNsb3VkRmxhcmUgT3JpZ2luIENlcnRpZmljYXRlMIIBIjANBgkqhkiG
    9w0BAQEFAAOCAQ8AMIIBCgKCAQEA28TXnYY5AIYdgFz42ZMtgER8pATcE9huVjA/
    V1nuNBAHs2x5r0zr+EA1/JWr8d60EApUvZk7nGj4A0nzRfw/GjXBRRqb6bvppGag
    mZpBVRFEg1Z+tPakr/tPDZ2HgKn1KRMlKMLXa2iDSMu/K4xJe1D6XlDRU34zmZBE
    WxQ3tGdEipOiYU8WTRObhUuR6Qe5UcUwTK7hkyy+F/r88WtEjqYYOsfgiPReEf2G
    18t+uznZqCcLUaCYhqgI3m/bm0QJfM4yUzQfWIjqw7WPw97VKYpaA1tefrgFCz8K
    WzFr8HKqMY0Kfa8t+kmSoiWAn91sFRjyUbvLPj8yi5VtxsNpRQIDAQABo4IBKjCC
    ASYwDgYDVR0PAQH/BAQDAgWgMB0GA1UdJQQWMBQGCCsGAQUFBwMCBggrBgEFBQcD
    ATAMBgNVHRMBAf8EAjAAMB0GA1UdDgQWBBRiztpcyXGwcyrmqz+o8wXAZlayfjAf
    BgNVHSMEGDAWgBQk6FNXXXw0QIep65TbuuEWePwppDBABggrBgEFBQcBAQQ0MDIw
    MAYIKwYBBQUHMAGGJGh0dHA6Ly9vY3NwLmNsb3VkZmxhcmUuY29tL29yaWdpbl9j
    YTArBgNVHREEJDAighAqLm51cmhhbWltLm15Lmlkgg5udXJoYW1pbS5teS5pZDA4
    BgNVHR8EMTAvMC2gK6AphidodHRwOi8vY3JsLmNsb3VkZmxhcmUuY29tL29yaWdp
    bl9jYS5jcmwwDQYJKoZIhvcNAQELBQADggEBAAM/iyC7Qh9P0L3Du9av3iVFPiiQ
    H9bl2REYT48rOHl5HSVsVVr7eoPyckwZiF8mtk75+v+eaaC4Q4zlHQR5AvaydvG4
    WaWuLQhBtLW4VvgDaSskVqiRTmOr7TFu9Pl/aNR+ReTW8rfN2BudUxVsgvyeqHJZ
    Ns7iaMoHZA7LwwU1SYLzQjjyv+Wer0jzO5zJcack8oBOrXd8pBFoI3DbsC4WGWoI
    UqzbiTrW6KaU59d9Mnh4UKcd5GQmTWtIv+GCbyroerwUnZ14FD4e/NLeL3pNuXoy
    FMpyedMsFQDsaX7CLCXFLXol6aCLzcJpERTm+TwYURG95Ncn9yBQv6rQAaI=
    -----END CERTIFICATE-----

Buat file _key.pem_

    [root@tutorial certs]# vim cf-key.pem

Berikut isi _private key_

    -----BEGIN PRIVATE KEY-----
    MIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQDbxNedhjkAhh2A
    XPjZky2ARHykBNwT2G5WMD9XWe40EAezbHmvTOv4QDX8lavx3rQQClS9mTucaPgD
    SfNF/D8aNcFFGpvpu+mkZqCZmkFVEUSDVn609qSv+08NnYeAqfUpEyUowtdraINI
    y78rjEl7UPpeUNFTfjOZkERbFDe0Z0SKk6JhTxZNE5uFS5HpB7lRxTBMruGTLL4X
    +vzxa0SOphg6x+CI9F4R/YbXy367OdmoJwtRoJiGqAjeb9ubRAl8zjJTNB9YiOrD
    tY/D3tUpiloDW15+uAULPwpbMWvwcqoxjQp9ry36SZKiJYCf3WwVGPJRu8s+PzKL
    lW3Gw2lFAgMBAAECggEAI+wHo1WsbQ++9DueKHA0bIYlSmkJ8Qt8M4XU4KoQM73Y
    CGWneTYtTult+aCcV59jlsidg9UvZ3hH67+zbkHWLapSMkGwcPLYdJka0KikW6uE
    I6Sodttm3WYKTKsuWiNNsZ5RwVkhvYp6hRRapdtbKnc4yWBT6t4SwJvSdIG4Pjoi
    ZdOPBKM+iMxQjarJK9q8XJzpIP5k93766ANRrYp/wWOFkktAOkfNDoaxSqSI+NaY
    gUk09qbF8+rE7rpnmXhlROxZy5mY+sOBt/j7azLnf641Bs1KxT8q9WxaNk5MvGgA
    vZv20vEaU7fACMQJeThd7GEsleupXSKNp22v9jgSMQKBgQD1UrNY3og7SmUdNOse
    NsGtyi7/Fm4oZsPufYynpCNrK6oV7SjEkDE/FwH+09LjPa66XTW6JxlfJE/uQUOs
    i0XBB2ETmfj5xGd5PghY9Mmsz9blP1GaK0UwZYz88mnHoMNpS9qugpX0you8oSez
    yCJctLIZNAGB+67pInTIwF+KFQKBgQDlVW1ISAkXH+NvzWuWE3r92IKk2yRBhPno
    wwvHoG3YfkBQ6GBe8FTfP7gEqKfP2QLM8YkfUYw793AMGJdQ70oHEQW+mfy0qhxs
    4WjnlUitPQxqvxJcyBJYE9DCBpC2Kf3vCdNN2n3bXJujVwo7uQIA4fGeMAujwpk0
    qWkeGAUecQKBgQDSWnZkVnQT+ueW0qBkiOkr3rjLi+0rAWsx3T+1I34nUAqIwJF7
    cnR3t3/DhNhId8SSEoiWNR6BQT60egvQMJ/AM1afGyCs8icThAheVo9zece3TMLo
    4f9yzzDEWAwx23yTljJN/rUccGy/cqP7eTlVqq8oAzrjvO6vAxeGZ8XEPQKBgHLW
    KSflsm+a7zd/5Jy82nycWycT+P66CK4uZQqsYfTjm28oPYGs1MMJ1Cq5DXb90vIv
    DJvbKN6qU7gq5DKJ8EbDll3QHAOXny5CXVaBoWfmRv54+Ufug4kJOyK9SN9+/YIi
    KGY2v4kFwYW0QxKO3Nr2SRgONPXmrvL41gNUwdNxAoGAIHNx0BbRTcCwjmkwIRA4
    TuhmTDWTwCoBXtNNWCRHH4Z6I8K1yvgs7hOn6KZTvFeaTHCLLcno3Onfo8jtfuhl
    Z5W0UhSYGzA0KVeNn2/ptqxb/b1PZObsbt9uaBUeYXKvYcJs0MBuEvffo6XuIyBx
    gSaXhJa8p9BJqUu5NxAySU8=
    -----END PRIVATE KEY-----

Membuat list ip proxy cloudflare di Nginx untuk mendapatkan real IP visitor (yang akses ke sisi website)

    [root@tutorial certs]#
    [root@tutorial certs]# vim /etc/nginx/cloudflare-real_ips.conf

Berikut full konfigurasi _cloudflare\_reali-ips nya_

    # Last updated at 2020-08-26 11:29
    # More info can be found here: https://www.tools4nerds.com/online-tools/cf-real-ip-from-generator
    
    set_real_ip_from 173.245.48.0/20;
    set_real_ip_from 103.21.244.0/22;
    set_real_ip_from 103.22.200.0/22;
    set_real_ip_from 103.31.4.0/22;
    set_real_ip_from 141.101.64.0/18;
    set_real_ip_from 108.162.192.0/18;
    set_real_ip_from 190.93.240.0/20;
    set_real_ip_from 188.114.96.0/20;
    set_real_ip_from 197.234.240.0/22;
    set_real_ip_from 198.41.128.0/17;
    set_real_ip_from 162.158.0.0/15;
    set_real_ip_from 104.16.0.0/12;
    set_real_ip_from 172.64.0.0/13;
    set_real_ip_from 131.0.72.0/22;
    set_real_ip_from 2400:cb00::/32;
    set_real_ip_from 2606:4700::/32;
    set_real_ip_from 2803:f800::/32;
    set_real_ip_from 2405:b500::/32;
    set_real_ip_from 2405:8100::/32;
    set_real_ip_from 2a06:98c0::/29;
    set_real_ip_from 2c0f:f248::/32;
    
    real_ip_header CF-Connecting-IP;

Ubah konfigurasi server block Nginx drupal menjadi sebagai berikut:

    [root@tutorial certs]#
    [root@tutorial certs]# vim /etc/nginx/conf.d/drupal.conf

Berikut full konfigurasi server block nya

    server {
            listen 80;
            listen 443 ssl http2;
            server_name drupal.nurhamim.my.id;
            root /usr/share/nginx/drupal;
    
            include /etc/nginx/cloudflare-real_ips.conf;
            index index.php index.html index.htm;
    
            ssl on;
            ssl_certificate /etc/ssl/certs/cf-certificate.pem;
            ssl_certificate_key /etc/ssl/certs/cf-key.pem;
    
            location / {
                    try_files $uri $uri/ /index.php?$query_string;
            }
    
            location ~ \.php {
                    include fastcgi.conf;
                    fastcgi_split_path_info ^(.+\.php)(/.+)$;
                    fastcgi_pass unix:/run/php-fpm/www.sock;
            }
            location ~ /\.ht {
                    deny all;
            }
    }

Reload Nginx dan php-fpm

    [root@tutorial certs]# systemctl reload nginx
    [root@tutorial certs]#
    [root@tutorial certs]# systemctl reload php-fpm

Silakan ke Cloudflare kembali dan set SSL/TLS menggunakan **Full**

<figure class="wp-block-image size-large"><img loading="lazy" width="959" height="550" src="/content/images/wordpress/2020/08/image-93.png" alt="" class="wp-image-335" srcset="/content/images/wordpress/2020/08/image-93.png 959w, /content/images/wordpress/2020/08/image-93-300x172.png 300w, /content/images/wordpress/2020/08/image-93-768x440.png 768w" sizes="(max-width: 959px) 100vw, 959px"></figure>

Lalu aktifkan proxy nya di menu DNS

<figure class="wp-block-image size-large"><img loading="lazy" width="920" height="36" src="/content/images/wordpress/2020/08/image-92.png" alt="" class="wp-image-334" srcset="/content/images/wordpress/2020/08/image-92.png 920w, /content/images/wordpress/2020/08/image-92-300x12.png 300w, /content/images/wordpress/2020/08/image-92-768x30.png 768w" sizes="(max-width: 920px) 100vw, 920px"></figure>

Tunggu beberapa saat proses provisioning SSL di Cloudflare. Verifikasi dengan cara ping ke drupal.nurhamim.my.id pastikan sudah menggunakan IP Cloudflare

<figure class="wp-block-image size-large"><img loading="lazy" width="991" height="318" src="/content/images/wordpress/2020/08/image-94.png" alt="" class="wp-image-336" srcset="/content/images/wordpress/2020/08/image-94.png 991w, /content/images/wordpress/2020/08/image-94-300x96.png 300w, /content/images/wordpress/2020/08/image-94-768x246.png 768w" sizes="(max-width: 991px) 100vw, 991px"></figure>

Cek menggunakan curl pastikan sub domain Anda sudah menggunakan cloudflare contohnya

<figure class="wp-block-image size-large"><img loading="lazy" width="1024" height="326" src="/content/images/wordpress/2020/08/image-95-1024x326.png" alt="" class="wp-image-337" srcset="/content/images/wordpress/2020/08/image-95-1024x326.png 1024w, /content/images/wordpress/2020/08/image-95-300x95.png 300w, /content/images/wordpress/2020/08/image-95-768x244.png 768w, /content/images/wordpress/2020/08/image-95.png 1172w" sizes="(max-width: 1024px) 100vw, 1024px"></figure>

Akses drupal.nurhamim.my.id melalui browser

<figure class="wp-block-image size-large"><img loading="lazy" width="1024" height="443" src="/content/images/wordpress/2020/08/image-96-1024x443.png" alt="" class="wp-image-338" srcset="/content/images/wordpress/2020/08/image-96-1024x443.png 1024w, /content/images/wordpress/2020/08/image-96-300x130.png 300w, /content/images/wordpress/2020/08/image-96-768x332.png 768w, /content/images/wordpress/2020/08/image-96-1536x664.png 1536w, /content/images/wordpress/2020/08/image-96.png 1908w" sizes="(max-width: 1024px) 100vw, 1024px"></figure>

Selamat saat ini subdomain Anda sudah menggunakan SSL plus proxy dari cloudflare.

Selamat mencoba 😁

Please follow and like us:

[![error](/wp-content/plugins/ultimate-social-media-icons/images/follow_subscribe.png)](https://api.follow.it/widgets/icon/VHc3d1lpVGdwRnE5QnV0eERCNUx5RCtvTTVoUkNYS3NNRmd5eVhlQW9tNXRHS3VTbGh6Y0NybkRJRS8zSGpjRDVZb1ZGMlNTSEpJYUpuZzZqNzdnd3VSN3dwM2VlQTF6ejJEaGV5UGRUbnlEcHFNd3luYTV4ZTZtUGowVWI2Q2x8M2kzdnBEeUIrUk5xOFI5TXZ3cHF3bFNQRkRJSGhUNGdrRFd0TlNtdE1OWT0=/OA==/)

[![fb-share-icon](/wp-content/plugins/ultimate-social-media-icons/images/visit_icons/fbshare_bck.png "Facebook Share")](https://www.facebook.com/sharer/sharer.php?u=https%3A%2F%2Fbelajarlinux.id%2F%3Fp%3D330%26ghostexport%3Dtrue%26submit%3DDownload+Ghost+File)

[![Tweet](/wp-content/plugins/ultimate-social-media-icons/images/visit_icons/en_US_Tweet.svg "Tweet")](https://twitter.com/intent/tweet?text=Cara+Instalasi+SSL+%2B+Proxy+CloudFlare+di+Nginx+pada+CentOS+8+https://belajarlinux.id/?p=330&ghostexport=true&submit=Download Ghost File)

[![fb-share-icon](/wp-content/plugins/ultimate-social-media-icons/images/share_icons/Pinterest_Save/en_US_save.svg "Pin Share")](#)

<!--kg-card-end: html-->
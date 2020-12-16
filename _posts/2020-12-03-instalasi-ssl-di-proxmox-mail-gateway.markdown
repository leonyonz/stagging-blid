---
layout: post
title: PMG - Instalasi SSL di Proxmox Mail Gateway
date: '2020-12-03 22:25:37'
tags:
- proxmox-mail-gateway
---

Belajar Linux ID - Tutorial kali ini kami akan membahas bagaiman cara melakukan instalasi SSL di proxmox mail gateway.

Secara default proxmox mail gateway menggunakan ssl `self-signed` dimana apabila Anda mengakses proxmox mail gateway melalui browser URL nya tidak secure contoh seperti gambar berikut

<figure class="kg-card kg-image-card"><img src="/content/images/2020/12/1-1.png" class="kg-image" alt srcset="/content/images/size/w600/2020/12/1-1.png 600w, /content/images/size/w1000/2020/12/1-1.png 1000w, /content/images/size/w1600/2020/12/1-1.png 1600w, /content/images/2020/12/1-1.png 1915w" sizes="(min-width: 720px) 720px"></figure>

Untuk melakukan instalasi SSL pastikan Anda sudah mempunyai komponen SSL seperti (CRT, KEY dan CA Intermediate) untuk mendapatkan SSL Anda dapat memesan SSL di provide Cloud misalnya di [NEO Cloud](https://www.biznetgio.com/), detailnya dapat merujuk pada link berikut: [SSL Certificate](https://www.biznetgio.com/pricelist#ssl-certificate).

<!--kg-card-begin: html--><script async src="https://pagead2.googlesyndication.com/pagead/js/adsbygoogle.js"></script><ins class="adsbygoogle" style="display:block; text-align:center;" data-ad-layout="in-article" data-ad-format="fluid" data-ad-client="ca-pub-1515372853161377" data-ad-slot="1986938311"></ins><script>
     (adsbygoogle = window.adsbygoogle || []).push({});
</script><!--kg-card-end: html-->

Jika Anda ingin menggunakan SSL yang gratis juga dapat di lakukan, kami sarankan Anda menggunakan **[ZeroSSL](https://zerossl.com/).**

Siapkan komponen SSL nya berikut:

<figure class="kg-card kg-image-card"><img src="/content/images/2020/12/image-3.png" class="kg-image" alt srcset="/content/images/size/w600/2020/12/image-3.png 600w, /content/images/2020/12/image-3.png 639w"></figure>

Kemudian, login ke server proxmox mail gateway melalui SSH dan untuk install SSL nya dapat melalui direktori `/etc/pmg/pmg-api.pem`, gunakan teks editor nano atau vi sesuai kesukaan Anda contohnya

<!--kg-card-begin: markdown-->

    root@pmg:~#
    root@pmg:~# vim /etc/pmg/pmg-api.pem

<!--kg-card-end: markdown-->

Hapus file ssl-signed dan copy paste komponen SSL (KEY, CRT dan CA Intermediate atau root CA) diatas contohnya seperti berikut ini

<!--kg-card-begin: markdown-->

    -----BEGIN RSA PRIVATE KEY-----
    MIIEowIBAAKCAQEAxscYFIfQD1ZOeC2zKRQKIStQ/smswzCGgrFt8hNu2JBHERHh
    DtCRt5GdG3Zj6gAMz2lfiQQIskSQXNaJChBFIvIlm/TTm1v/9ltsQ1xn0yuf8ito
    PtJHS5XtsAIuNpOifmyapOPry+ODu8JQ5fwx6YGva9JveLQfvNRsj0Dytk738tO5
    G7WqMpmdOT2hscNd4r992/+sSYoeyKKVYyniP8z8pkYkeKwOVxDkdWNmCHtxxFJY
    KEQlYgTZzd/f1n4ImUYTzCBzPdSYjVLh9XC5YpXIHamUNWylquVV3N8aCv6wUEZ1
    sscy8RfnixFz1bRUKn6+awFW2iESJ9Qu3DVPmwIDAQABAoIBAQCsVRupYP2e7mJl
    iqlTKc6GZzl3S31+U+mqEQ2S3AozsxIJ2IhYAbbzgUjF8GQ7EQQKJf7vmRG5C/xk
    oJJ6qRRncavtg9qZTK+i9CvuUoSo7Z9jowJjxIaPH1LMT3elVWWBWcLQxdE+GOey
    torQeU8EdKyTPAPsj60cVsYvhE1og5MA22zmAP8rx/jWgZZEoS7Fr8Br3oa+0FJf
    A6fzqsVZTZWZDsBES9R6ytKoS+bBVW3jxeQixcO974dVuwi9hMYOP4nEG1CJ5OY1
    o6Ap/iMalffgsF3ZP2Hvb3DWBz4+UF1nBXJohlpQuyiZmI2jhY75lf21AoGBAN6U
    HnOZdwxNlTVbblXMfDaAjraOWkNSclNGDZQKre5bumH9YcWHrxcGzUxk+I97XZYu
    +AeAvDlgK04uiiJAc7jJWe3tc1QFIlDLp+yk5VN3tIllAuEVLBFN8TzyxmDr/iU2
    M1A08lCFfhGZkl0WGD79cqa+natdXkj2fENK9OoPAoGAUXvz+4arL8cMxq/HEa0X
    uUb87vt6LtroOkO4eydX5AOPtqAuw2XSVc4CY+iRME+o0NoMgzqtz6TYPK0mo+yU
    aRaGfOJJ6w6Z2LnAPX+JeHMbfhtrWT/KrcUJvP02wjgk4+4QNxmdgHvn7PlMr12O
    hW5XpEztx9SmmKTVb1XpbZkCgYAeJDrXdsHbZao+FoqjjdSIYPJyoGZy1Xhr9IGk
    OaoCLGPaH0EdSdmZKa+ll8rdS1yKGQQ3p+RVdMOIi97i8o15SbMm+E/04dkazemI
    r2/q1LwbGxW/u2lDUqXHliztNSgui995DiJ+awV+hqh+eJ6B8TqUgB3D9hntkYuU
    ZVMzWwKBgCyiK9elLB9Yiamy9HFs2uPMBe+GnSYgjlPSTGwst5IzaNhWU1gpXvMe
    L1vuDLkawKV24rFSXRxEYbhEtVXvhx8u1L1nY44ruZeeaMq0TJ+q8rfU25ODplL7
    EuyUDhDveI3n4jhzXrpj/D0Ntq2zDfep8TmZP39Uxye+0Bp4KDJZ
    -----END RSA PRIVATE KEY-----
    
    -----BEGIN CERTIFICATE-----
    MIIGczCCBFugAwIBAgIQdagaPJHrUBOtk1AJAxZ8BzANBgkqhkiG9w0BAQwFADBL
    MQswCQYDVQQGEwJBVDEQMA4GA1UEChMHWmVyb1NTTDEqMCgGA1UEAxMhWmVyb1NT
    TCBSU0EgRG9tYWluIFNlY3VyZSBTaXRlIENBMB4XDTIwMTEyNDAwMDAwMFoXDTIx
    MDIyMjIzNTk1OVowHTEbMBkGA1UEAxMScG1nLm51cmhhbWltLm15LmlkMIIBIjAN
    BgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAxscYFIfQD1ZOeC2zKRQKIStQ/sms
    wzCGgrFt8hNu2JBHERHhDtCRt5GdG3Zj6gAMz2lfiQQIskSQXNaJChBFIvIlm/TT
    m1v/9ltsQ1xn0yuf8itoPtJHS5XtsAIuNpOifmyapOPry+ODu8JQ5fwx6YGva9Jv
    eLQfvNRsj0Dytk738tO5G7WqMpmdOT2hscNd4r992/+sSYoeyKKVYyniP8z8pkYk
    eKwOVxDkdWNmCHtxxFJYKEQlYgTZzd/f1n4ImUYTzCBzPdSYjVLh9XC5YpXIHamU
    NWylquVV3N8aCv6wUEZ1sscy8RfnixFz1bRUKn6+awFW2iESJ9Qu3DVPmwIDAQAB
    o4ICfzCCAnswHwYDVR0jBBgwFoAUyNl4aKLZGWjVPXLeXwo+3LWGhqYwHQYDVR0O
    BBYEFIa/t/1Ko0rAiVgl21BQ70eYZ5HPMA4GA1UdDwEB/wQEAwIFoDAMBgNVHRMB
    Af8EAjAAMB0GA1UdJQQWMBQGCCsGAQUFBwMBBggrBgEFBQcDAjBJBgNVHSAEQjBA
    MDQGCysGAQQBsjEBAgJOMCUwIwYIKwYBBQUHAgEWF2h0dHBzOi8vc2VjdGlnby5j
    AXX8Sbq4AAAEAwBIMEYCIQDrTUOngcUv5ZwEzvQ8p1xjNpqbX9cmBvbBi+Upg+Hw
    PQIhALcDa8a/4g04kzSrcfuU0Pror/DSuHOoSBNUZ8SDh46uMB0GA1UdEQQWMBSC
    EnBtZy5udXJoYW1pbS5teS5pZDANBgkqhkiG9w0BAQwFAAOCAgEAcmcLVifuU4au
    y8ENpzo8tPcBPsKfRSCPtEAT6qUrj/WY0V6WFUWtmnuuIRZofNQSAcwTv/vz2bs/
    Gft2WEl1eRAS+wkgWAEc2g3aq/MVNCTbS924RIXxQi+vaYjq7xHg0hNZY9f+QLpe
    gJq76ZKrWJbArB8UEoS7DKqv+rg8X3Ceskszi905Sv0IW45VrZ6W+tFfteINPsHE
    lc35xuKnyJNVV879qHD/rYJqjHa7kjUigxaIZit3BhmgVVRmnGuCrzHBLc052ecs
    INWXGHjeDGyjji0mPGrBURoeJomt4hty3CnJ7+iWQSGUt/Ye4mNlG7okr6L9Ng5n
    tRQHbvV5cGd5dijx/9oQ9Uko4xb9NW5baXcII+UFSk3P2SaxvMDr7GZ45kKkkuCC
    Eb4O0UrUzWQVgiMwL76HjICbQqz+pERYhkpWupHABlgmH7gJ9zp5tA/cnEB0psWH
    bOLzOoT6I7oTLA3JhCqhkhwrhW61HxddZBvpf3KZXTmDmjWTVAcpU/8+bZOpR34I
    v1O95fGVRrY9lshK2yHuxC3gcApDigiesEg1XwSH9zZMUMKTmhKRp60OLCRQyXtg
    itYCR4T+P7Vc/7NNTam76VHAn9k87aQI/QbHZga986fuIn8mIOGccPz6UlMIHjzc
    A/QsehzVLAR2z/M8ZRBO4+xyIfO90R8=
    -----END CERTIFICATE-----
    
    -----BEGIN CERTIFICATE-----
    MIIG1TCCBL2gAwIBAgIQbFWr29AHksedBwzYEZ7WvzANBgkqhkiG9w0BAQwFADCB
    iDELMAkGA1UEBhMCVVMxEzARBgNVBAgTCk5ldyBKZXJzZXkxFDASBgNVBAcTC0pl
    cnNleSBDaXR5MR4wHAYDVQQKExVUaGUgVVNFUlRSVVNUIE5ldHdvcmsxLjAsBgNV
    BAMTJVVTRVJUcnVzdCBSU0EgQ2VydGlmaWNhdGlvbiBBdXRob3JpdHkwHhcNMjAw
    MTMwMDAwMDAwWhcNMzAwMTI5MjM1OTU5WjBLMQswCQYDVQQGEwJBVDEQMA4GA1UE
    ChMHWmVyb1NTTDEqMCgGA1UEAxMhWmVyb1NTTCBSU0EgRG9tYWluIFNlY3VyZSBT
    aXRlIENBMIICIjANBgkqhkiG9w0BAQEFAAOCAg8AMIICCgKCAgEAhmlzfqO1Mdgj
    4W3dpBPTVBX1AuvcAyG1fl0dUnw/MeueCWzRWTheZ35LVo91kLI3DDVaZKW+TBAs
    JBjEbYmMwcWSTWYCg5334SF0+ctDAsFxsX+rTDh9kSrG/4mp6OShubLaEIUJiZo4
    t873TuSd0Wj5DWt3DtpAG8T35l/v+xrN8ub8PSSoX5Vkgw+jWf4KQtNvUFLDq8mF
    WhUnPL6jHAADXpvs4lTNYwOtx9yQtbpxwSt7QJY1+ICrmRJB6BuKRt/jfDJF9Jsc
    RQVlHIxQdKAJl7oaVnXgDkqtk2qddd3kCDXd74gv813G91z7CjsGyJ93oJIlNS3U
    gFbD6V54JMgZ3rSmotYbz98oZxX7MKbtCm1aJ/q+hTv2YK1yMxrnfcieKmOYBbFD
    hnW5O6RMA703dBK92j6XRN2EttLkQuujZgy+jXRKtaWMIlkNkWJmOiHmErQngHvt
    iNkIcjJumq1ddFX4iaTI40a6zgvIBtxFeDs2RfcaH73er7ctNUUqgQT5rFgJhMmF
    x76rQgB5OZUkodb5k2ex7P+Gu4J86bS15094UuYcV09hVeknmTh5Ex9CBKipLS2W
    2wKBakf+aVYnNCU6S0nASqt2xrZpGC1v7v6DhuepyyJtn3qSV2PoBiU5Sql+aARp
    wUibQMGm44gjyNDqDlVp+ShLQlUH9x8CAwEAAaOCAXUwggFxMB8GA1UdIwQYMBaA
    c3QuY29tL1VTRVJUcnVzdFJTQUNlcnRpZmljYXRpb25BdXRob3JpdHkuY3JsMHYG
    CCsGAQUFBwEBBGowaDA/BggrBgEFBQcwAoYzaHR0cDovL2NydC51c2VydHJ1c3Qu
    Y29tL1VTRVJUcnVzdFJTQUFkZFRydXN0Q0EuY3J0MCUGCCsGAQUFBzABhhlodHRw
    Oi8vb2NzcC51c2VydHJ1c3QuY29tMA0GCSqGSIb3DQEBDAUAA4ICAQAVDwoIzQDV
    ercT0eYqZjBNJ8VNWwVFlQOtZERqn5iWnEVaLZZdzxlbvz2Fx0ExUNuUEgYkIVM4
    YocKkCQ7hO5noicoq/DrEYH5IuNcuW1I8JJZ9DLuB1fYvIHlZ2JG46iNbVKA3ygA
    Ez86RvDQlt2C494qqPVItRjrz9YlJEGT0DrttyApq0YLFDzf+Z1pkMhh7c+7fXeJ
    qmIhfJpduKc8HEQkYQQShen426S3H0JrIAbKcBCiyYFuOhfyvuwVCFDfFvrjADjd
    4jX1uQXd161IyFRbm89s2Oj5oU1wDYz5sx+hoCuh6lSs+/uPuWomIq3y1GDFNafW
    +LsHBU16lQo5Q2yh25laQsKRgyPmMpHJ98edm6y2sHUabASmRHxvGiuwwE25aDU0
    2SAeepyImJ2CzB80YG7WxlynHqNhpE7xfC7PzQlLgmfEHdU+tHFeQazRQnrFkW2W
    kqRGIq7cKRnyypvjPMkjeiV9lRdAM9fSJvsB3svUuu1coIG1xxI1yegoGM4r5QP4
    RGIVvYaiI76C0djoSbQ/dkIUUXQuB8AL5jyH34g3BZaaXyvpmnV4ilppMXVAnAYG
    ON51WhJ6W0xNdNJwzYASZYH+tmCWI+N60Gv2NNMGHwMZ7e9bXgzUCZH5FaBFDGR5
    S9VWqHB73Q+OyIVvIbKYcSc2w/aSuFKGSA==
    -----END CERTIFICATE-----

<!--kg-card-end: markdown-->

Jika sudah silahkan simpan dan restart `pmgproxy` nya menggunakan command berikut

<!--kg-card-begin: html--><script async src="https://pagead2.googlesyndication.com/pagead/js/adsbygoogle.js"></script><ins class="adsbygoogle" style="display:block; text-align:center;" data-ad-layout="in-article" data-ad-format="fluid" data-ad-client="ca-pub-1515372853161377" data-ad-slot="1986938311"></ins><script>
     (adsbygoogle = window.adsbygoogle || []).push({});
</script><!--kg-card-end: html--><!--kg-card-begin: markdown-->

    root@pmg:~# systemctl restart pmgproxy.service
    root@pmg:~#

<!--kg-card-end: markdown-->

Pastikan status `pmgproxy` running

<!--kg-card-begin: markdown-->

    root@pmg:~# systemctl status pmgproxy.service
    ● pmgproxy.service - Proxmox Mail Gateway API
       Loaded: loaded (/lib/systemd/system/pmgproxy.service; enabled; vendor preset: enabled)
       Active: active (running) since Fri 2020-12-04 05:21:36 WIB; 39s ago
      Process: 26275 ExecStart=/usr/bin/pmgproxy start (code=exited, status=0/SUCCESS)
     Main PID: 26288 (pmgproxy)
        Tasks: 4 (limit: 2328)
       Memory: 141.8M
       CGroup: /system.slice/pmgproxy.service
               ├─26288 pmgproxy
               ├─26289 pmgproxy worker
               ├─26290 pmgproxy worker
               └─26291 pmgproxy worker
    
    Dec 04 05:21:34 pmg systemd[1]: Starting Proxmox Mail Gateway API...
    Dec 04 05:21:36 pmg pmgproxy[26288]: starting server
    Dec 04 05:21:36 pmg pmgproxy[26288]: starting 3 worker(s)
    Dec 04 05:21:36 pmg pmgproxy[26288]: worker 26289 started
    Dec 04 05:21:36 pmg pmgproxy[26288]: worker 26290 started
    Dec 04 05:21:36 pmg pmgproxy[26288]: worker 26291 started
    Dec 04 05:21:36 pmg systemd[1]: Started Proxmox Mail Gateway API.
    root@pmg:~#

<!--kg-card-end: markdown-->

Verifikasi SSL dengan cara akses kembali URL proxmox mail gateway melalui browser, apabila berhasil untuk URL nya akan secure menggunakan protokol https seperti berikut ini

<figure class="kg-card kg-image-card"><img src="/content/images/2020/12/2-1.png" class="kg-image" alt srcset="/content/images/size/w600/2020/12/2-1.png 600w, /content/images/size/w1000/2020/12/2-1.png 1000w, /content/images/size/w1600/2020/12/2-1.png 1600w, /content/images/2020/12/2-1.png 1908w" sizes="(min-width: 720px) 720px"></figure>

Sampai disini proxmox mail gateway Anda sudah secure atau diproteksi oleh SSL _(Secure Socket Layer)._

Selamat mencoba 😁


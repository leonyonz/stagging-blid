---
layout: post
title: High Availability PostgreSQL Cluster Menggunakan Patroni dan HAProxy
featured: true
date: '2020-09-07 22:03:38'
tags:
- centos
- database
- load-balancer
---

Pada tutorial kali ini kita akan mencoba membuat high availabiliy postgresql, seperti yang telah diinformasikan pada tutorial – tutorial sebelumnya postgresql sendiri sebuah database server open source yang dapat digunakan karena postgresql sangat power full.

Kali ini kita akan membuat cluster postgresql tujuannya untuk high availability dan menunjang kebutuhan aplikasi tentunya.

Berikut topologi yang akan kami gunakan

<figure class="wp-block-image size-large"><img loading="lazy" width="591" height="681" src="/content/images/wordpress/2020/09/High-Available-PostgreSQL-Cluster-Menggunakan-Patroni.png" alt="" class="wp-image-482" srcset="/content/images/wordpress/2020/09/High-Available-PostgreSQL-Cluster-Menggunakan-Patroni.png 591w, /content/images/wordpress/2020/09/High-Available-PostgreSQL-Cluster-Menggunakan-Patroni-260x300.png 260w" sizes="(max-width: 591px) 100vw, 591px"></figure>

Dari topologi diatas kita perlu 5 node server atau virtual machine atau instance yang dapat digunakan dengan detail sebagai berikut

<figure class="wp-block-table aligncenter"><table><tbody>
<tr>
<td class="has-text-align-center" data-align="center">Name/Hostname</td>
<td class="has-text-align-center" data-align="center">IP Address Lokal / Public</td>
<td class="has-text-align-center" data-align="center">Keterangan</td>
</tr>
<tr>
<td class="has-text-align-center" data-align="center">Hamim-pg01 /node01</td>
<td class="has-text-align-center" data-align="center">192.168.10.21</td>
<td class="has-text-align-center" data-align="center">Postgresql, Patroni</td>
</tr>
<tr>
<td class="has-text-align-center" data-align="center">Hamim-pg02 /node02</td>
<td class="has-text-align-center" data-align="center">192.168.10.24</td>
<td class="has-text-align-center" data-align="center">Postgresql, Patroni</td>
</tr>
<tr>
<td class="has-text-align-center" data-align="center">Hamim-pg03 /node03</td>
<td class="has-text-align-center" data-align="center">192.168.10.28</td>
<td class="has-text-align-center" data-align="center">Postgresql, Patroni</td>
</tr>
<tr>
<td class="has-text-align-center" data-align="center">Hamim-etcd /node04</td>
<td class="has-text-align-center" data-align="center">192.168.10.27</td>
<td class="has-text-align-center" data-align="center">Etcd</td>
</tr>
<tr>
<td class="has-text-align-center" data-align="center">Hamim-Haproxy /node05</td>
<td class="has-text-align-center" data-align="center">192.168.10.23 / 103.93.52.117</td>
<td class="has-text-align-center" data-align="center">HAProxy</td>
</tr>
</tbody></table></figure>

Keterangan:   
  
– Patroni: Digunakan untuk mengelola konfigurasi postgresql   
– Etcd: Digunakan untuk cluster postgresql  
– HAProxy: Digunakan untuk failover atau load balancing postgresql

Pertama yang harus di lakukan yaitu melakukan update sistem operasi CentOS 8 Anda di masing – masing node dan disini kami setup hostname masing – masing node seperti berikut

    #Node 01
    
    [root@node01 ~]# hostnamectl |grep hostname
       Static hostname: node01.nurhamim.my.id
    [root@node01 ~]#
    
    #Node02
    
    [root@node02 ~]# hostnamectl |grep hostname
       Static hostname: node02.nurhamim.my.id
    [root@node02 ~]#
    
    #Node03
    
    [root@node03 ~]# hostnamectl |grep hostname
       Static hostname: node03.nurhamim.my.id
    [root@node03 ~]#
    
    #Node04
    
    [root@node04 ~]# hostnamectl |grep hostname
       Static hostname: node04.nurhamim.my.id
    [root@node04 ~]#
    
    #Node05
    
    [root@node05 ~]# hostnamectl |grep hostname
       Static hostname: node05.nurhamim.my.id
    [root@node05 ~]#

Selanjutnya menambahkan repository epel di **node01, node02 dan node03** dan install repository paket manager seperti berikut

**Node01**

    [root@node01 ~]#
    [root@node01 ~]# dnf -y install epel-release -y
    
    [root@node01 ~]# dnf config-manager --set-enabled PowerTools
    [root@node01 ~]# dnf -y install yum-utils -y

**Node02**

    [root@node02 ~]#
    [root@node02 ~]# dnf -y install epel-release -y
    
    [root@node02 ~]# dnf config-manager --set-enabled PowerTools
    [root@node02 ~]# dnf -y install yum-utils -y

**Node03**

    [root@node03 ~]#
    [root@node03 ~]# dnf -y install epel-release -y
    
    [root@node03 ~]# dnf config-manager --set-enabled PowerTools
    [root@node03 ~]# dnf -y install yum-utils -y

Selanjutnya menambahkan repository postgresql 12 di **node01, node02, node03** dan disable module postgresql default CentOS 8

**Node01**

    [root@node01 ~]#
    [root@node01 ~]# dnf -y install https://download.postgresql.org/pub/repos/yum/reporpms/EL-8-x86_64/pgdg-redhat-repo-latest.noarch.rpm
    
    [root@node01 ~]# yum-config-manager --enable pgdg12
    [root@node01 ~]# dnf -qy module disable postgresql
    [root@node01 ~]#

**Node02**

    [root@node02 ~]#
    [root@node02 ~]# dnf -y install https://download.postgresql.org/pub/repos/yum/reporpms/EL-8-x86_64/pgdg-redhat-repo-latest.noarch.rpm
    
    [root@node02 ~]# yum-config-manager --enable pgdg12
    [root@node02 ~]# dnf -qy module disable postgresql
    [root@node02 ~]#

**Node03**

    [root@node03 ~]# dnf -y install https://download.postgresql.org/pub/repos/yum/reporpms/EL-8-x86_64/pgdg-redhat-repo-latest.noarch.rpm
    
    [root@node03 ~]# yum-config-manager --enable pgdg12
    [root@node03 ~]# dnf -qy module disable postgresql
    [root@node03 ~]#

Selanjutnya install postgresql12 di **node01, nod02 dan node03**

    [root@node01 ~]#
    [root@node01 ~]# dnf -y install postgresql12-server postgresql12 postgresql12-devel
    
    [root@node02 ~]#
    [root@node02 ~]# dnf -y install postgresql12-server postgresql12 postgresql12-devel
    
    [root@node03 ~]#
    [root@node03 ~]# dnf -y install postgresql12-server postgresql12 postgresql12-devel

Selanjutnya melakukan instalasi patroni. Patroni sendiri merupakan paket python dan open source yang dapat digunakan untuk mengelola konfigurasi Postgres. Selain itu dengan patroni Anda dapat melakukan konfigurasi yang komplek misalnya menangani tugas-tugas seperti replikasi, backup, dan restorasi.

Silakan install patroni di **node01, node02 dan node03**

**Node01**

    [root@node01 ~]#
    [root@node01 ~]# dnf -y install https://download-ib01.fedoraproject.org/pub/epel/7/x86_64/Packages/p/python3-psycopg2-2.7.7-2.el7.x86_64.rpm
    
    [root@node01 ~]#
    [root@node01 ~]# dnf -y install https://github.com/cybertec-postgresql/patroni-packaging/releases/download/1.6.0-1/patroni-1.6.0-1.rhel7.x86_64.rpm

**Node02**

    [root@node02 ~]#
    [root@node02 ~]# dnf -y install https://download-ib01.fedoraproject.org/pub/epel/7/x86_64/Packages/p/python3-psycopg2-2.7.7-2.el7.x86_64.rpm
    
    [root@node02 ~]#
    [root@node02 ~]# dnf -y install https://github.com/cybertec-postgresql/patroni-packaging/releases/download/1.6.0-1/patroni-1.6.0-1.rhel7.x86_64.rpm

**Node03**

    [root@node03 ~]#
    [root@node03 ~]# dnf -y install https://download-ib01.fedoraproject.org/pub/epel/7/x86_64/Packages/p/python3-psycopg2-2.7.7-2.el7.x86_64.rpm
    
    [root@node03 ~]#
    [root@node03 ~]# dnf -y install https://github.com/cybertec-postgresql/patroni-packaging/releases/download/1.6.0-1/patroni-1.6.0-1.rhel7.x86_64.rpm

Sebelum melakukan konfigurasi patroni ada baiknya kita simpan default konfigurasi patroni tujuannya untuk jaga – jaga jika dikemudian hari membutuhkannya.

Silakan copy file konfigurasi patroni di **nod01, node02 dan node03**

    [root@node01 ~]# cp -p /opt/app/patroni/etc/postgresql.yml.sample /opt/app/patroni/etc/postgresql.yml
    [root@node01 ~]#
    
    [root@node02 ~]# cp -p /opt/app/patroni/etc/postgresql.yml.sample /opt/app/patroni/etc/postgresql.yml
    [root@node02 ~]#
    
    [root@node03 ~]# cp -p /opt/app/patroni/etc/postgresql.yml.sample /opt/app/patroni/etc/postgresql.yml
    [root@node03 ~]#

Langkah selanjutnya melakukan konfigurasi patroni di **node01, node02 dan node03**

Buka file konfigurasi patroni yang beradi di _/opt/app/patroni/etc/postgresql.yml_ di masing – masing node postgresql

Berikut full konfigurasinya

    scope: postgres
    namespace: /pg_cluster/
    name: node1
    
    restapi:
        listen: 192.168.10.21:8008
        connect_address: 192.168.10.21:8008
    
    etcd:
        host: 192.168.10.27:2379
    
    bootstrap:
      dcs:
        ttl: 30
        loop_wait: 10
        retry_timeout: 10
        maximum_lag_on_failover: 1048576
        postgresql:
          use_pg_rewind: true
          use_slots: true
          parameters:
    
      initdb:
      - encoding: UTF8
      - data-checksums
    
      pg_hba:
      - host replication replicator 127.0.0.1/32 md5
      - host replication replicator 192.168.10.21/27 md5
      - host replication replicator 192.168.10.24/27 md5
      - host replication replicator 192.168.10.28/27 md5
      - host all all 0.0.0.0/0 md5
    
      users:
        admin:
          password: admin
          options:
            - createrole
            - createdb
    
    postgresql:
      listen: 192.168.10.21:5432
      connect_address: 192.168.10.21:5432
      data_dir: /var/lib/pgsql/12/data
      bin_dir: /usr/pgsql-12/bin
      pgpass: /tmp/pgpass
      authentication:
        replication:
          username: replicator
          password: reppassword
        superuser:
          username: postgres
          password: postgrespassword
    
    tags:
        nofailover: false
        noloadbalance: false
        clonefrom: false
        nosync: false

_Noted: Silakan sesuaikan penamaan dan ip di setiap node – node postgresql dan serta pastikan input ip node04 etcd karena nantinya patroni akan berkomunikasi atau terhubung dengan etcd sebagai cluster._

Berikut contoh di konfigurasi patroni di **node01, node02 dan node03**

**Node01**

    [root@node01 ~]#
    [root@node01 ~]# vim /opt/app/patroni/etc/postgresql.yml

<figure class="wp-block-image size-large"><img loading="lazy" width="517" height="1007" src="/content/images/wordpress/2020/09/1-6.png" alt="" class="wp-image-483" srcset="/content/images/wordpress/2020/09/1-6.png 517w, /content/images/wordpress/2020/09/1-6-154x300.png 154w" sizes="(max-width: 517px) 100vw, 517px"></figure>

**Node02**

    [root@node02 ~]#
    [root@node02 ~]# vim /opt/app/patroni/etc/postgresql.yml

<figure class="wp-block-image size-large"><img loading="lazy" width="516" height="1013" src="/content/images/wordpress/2020/09/2-6.png" alt="" class="wp-image-484" srcset="/content/images/wordpress/2020/09/2-6.png 516w, /content/images/wordpress/2020/09/2-6-153x300.png 153w" sizes="(max-width: 516px) 100vw, 516px"></figure>

**Node03**

    [root@node03 ~]#
    [root@node03 ~]# vim /opt/app/patroni/etc/postgresql.yml

<figure class="wp-block-image size-large"><img loading="lazy" width="540" height="704" src="/content/images/wordpress/2020/09/image-19.png" alt="" class="wp-image-487" srcset="/content/images/wordpress/2020/09/image-19.png 540w, /content/images/wordpress/2020/09/image-19-230x300.png 230w" sizes="(max-width: 540px) 100vw, 540px"></figure>

Jika patroni digunakan sebagai pengelola si postgresql maka si etcd digunakan sebagai cluster patroni dan postgresql

Etcd adalah salah satu dari beberapa solusi untuk masalah yang dihadapi oleh banyak program yang berjalan secara terdistribusi pada sekumpulan host, yang masing-masing mungkin gagal atau perlu di-boot ulang kapan saja.

Etcd cluster juga dapat memonitoring dan menentukan streaming replication postgresql node mana yang akan menjadi sebagai primary dan node mana yang akan menjadi standby.

Dari beberapa referensi untuk lebih powerfull dan jika sudah masuk ke production sangat disarankan menggunakan etcd di masing – masing node patroni dan untuk tutorial kali ini kita hanya menggunakan satu node saja. Kenapa menggunakan banyak node etcd?. Tujuannya jika terdapat salah satu node etcd down maka tidak akan memngaruhi node postgresql Anda.

Etcd Cluster disini kami akan diinstall di **Node04** dan berikut cara instalasinya

    [root@node04 ~]#
    [root@node04 ~]# dnf -y install http://mirror.centos.org/centos/7/extras/x86_64/Packages/etcd-3.3.11-2.el7.centos.x86_64.rpm

Konfigurasi etcd

    [root@node04 ~]#
    [root@node04 ~]# vim /etc/etcd/etcd.conf

Berikut full konfigurasi etcd

    #[Member]
    
    #ETCD_CORS=""
    ETCD_DATA_DIR="/var/lib/etcd/default.etcd"
    #ETCD_WAL_DIR=""
    ETCD_LISTEN_PEER_URLS="http://192.168.10.27:2380"
    ETCD_LISTEN_CLIENT_URLS="http://192.168.10.27:2379"
    #ETCD_MAX_SNAPSHOTS="5"
    #ETCD_MAX_WALS="5"
    ETCD_NAME="default"
    #ETCD_SNAPSHOT_COUNT="100000"
    #ETCD_HEARTBEAT_INTERVAL="100"
    #ETCD_ELECTION_TIMEOUT="1000"
    #ETCD_QUOTA_BACKEND_BYTES="0"
    #ETCD_MAX_REQUEST_BYTES="1572864"
    #ETCD_GRPC_KEEPALIVE_MIN_TIME="5s"
    #ETCD_GRPC_KEEPALIVE_INTERVAL="2h0m0s"
    #ETCD_GRPC_KEEPALIVE_TIMEOUT="20s"
    #
    #[Clustering]
    ETCD_INITIAL_ADVERTISE_PEER_URLS="http://192.168.10.27:2380"
    ETCD_ADVERTISE_CLIENT_URLS="http://192.168.10.27:2379"
    #ETCD_DISCOVERY=""
    #ETCD_DISCOVERY_FALLBACK="proxy"
    #ETCD_DISCOVERY_PROXY=""
    #ETCD_DISCOVERY_SRV=""
    ETCD_INITIAL_CLUSTER="default=http://192.168.10.27:2380"
    ETCD_INITIAL_CLUSTER_TOKEN="etcd-cluster"
    ETCD_INITIAL_CLUSTER_STATE="new"
    #ETCD_STRICT_RECONFIG_CHECK="true"
    #ETCD_ENABLE_V2="true"
    #
    #[Proxy]
    #ETCD_PROXY="off"
    #ETCD_PROXY_FAILURE_WAIT="5000"
    #ETCD_PROXY_REFRESH_INTERVAL="30000"
    #ETCD_PROXY_DIAL_TIMEOUT="1000"
    #ETCD_PROXY_WRITE_TIMEOUT="5000"
    #ETCD_PROXY_READ_TIMEOUT="0"
    #
    #[Security]
    #ETCD_CERT_FILE=""
    #ETCD_KEY_FILE=""
    #ETCD_CLIENT_CERT_AUTH="false"
    #ETCD_TRUSTED_CA_FILE=""
    #ETCD_AUTO_TLS="false"
    #ETCD_PEER_CERT_FILE=""
    #ETCD_PEER_KEY_FILE=""
    #ETCD_PEER_CLIENT_CERT_AUTH="false"
    #ETCD_PEER_TRUSTED_CA_FILE=""
    #ETCD_PEER_AUTO_TLS="false"
    #
    #[Logging]
    #ETCD_DEBUG="false"
    #ETCD_LOG_PACKAGE_LEVELS=""
    #ETCD_LOG_OUTPUT="default"
    #
    #[Unsafe]
    #ETCD_FORCE_NEW_CLUSTER="false"
    #
    #[Version]
    #ETCD_VERSION="false"
    #ETCD_AUTO_COMPACTION_RETENTION="0"
    #
    #[Profiling]
    #ETCD_ENABLE_PPROF="false"
    #ETCD_METRICS="basic"
    #
    #[Auth]
    #ETCD_AUTH_TOKEN="simple"

_Noted: Silakan sesuaikan IP dengan IP Node04 dan uncoment rule yang dibutuhkan seperti diatas._

Selanjutnya, enable dan start etcd cluster

    [root@node04 ~]#
    [root@node04 ~]# systemctl enable etcd
    Created symlink /etc/systemd/system/multi-user.target.wants/etcd.service → /usr/lib/systemd/system/etcd.service.
    [root@node04 ~]# systemctl start etcd
    [root@node04 ~]# systemctl status etcd

<figure class="wp-block-image size-large"><img loading="lazy" width="1024" height="400" src="/content/images/wordpress/2020/09/4-4-1024x400.png" alt="" class="wp-image-488" srcset="/content/images/wordpress/2020/09/4-4-1024x400.png 1024w, /content/images/wordpress/2020/09/4-4-300x117.png 300w, /content/images/wordpress/2020/09/4-4-768x300.png 768w, /content/images/wordpress/2020/09/4-4.png 1036w" sizes="(max-width: 1024px) 100vw, 1024px"></figure>

Berikutnya enable dan start service patroni di **node01, node02 dan node03**

**Node01**

    [root@node01 ~]#
    [root@node01 ~]# systemctl enable patroni
    Created symlink /etc/systemd/system/multi-user.target.wants/patroni.service → /usr/lib/systemd/system/patroni.service.
    [root@node01 ~]# systemctl start patroni
    [root@node01 ~]# systemctl status patroni -l

**Node02**

    [root@node02 ~]#
    [root@node02 ~]# systemctl enable patroni
    Created symlink /etc/systemd/system/multi-user.target.wants/patroni.service → /usr/lib/systemd/system/patroni.service.
    [root@node02 ~]# systemctl start patroni
    [root@node02 ~]# systemctl status patroni -l

**Node03**

    [root@node03 ~]#
    [root@node03 ~]# systemctl enable patroni
    Created symlink /etc/systemd/system/multi-user.target.wants/patroni.service → /usr/lib/systemd/system/patroni.service.
    [root@node03 ~]# systemctl start patroni
    [root@node03 ~]# systemctl status patroni -l

Selanjutnya kita akan install HAProxy. Buat apa HAProxy?

Saat mengembangkan aplikasi yang menggunakan database, mungkin sulit untuk melacak titik akhir database jika terus berubah. Menggunakan HAProxy akan menyederhanakan dengan dengan memberikan satu titik akhir atau jalur kemana Anda menghubungkan aplikasi ke database.

HAProxy juga akan sebagai failover atau load balancer tugasnya meneruskan koneksi ke node mana pun yang saat ini menjadi master atau primary (postgresql). Patroni sebagai manajemen postgresql akan memastikan bahwa, pada waktu tertentu, hanya node master postgresql yang akan muncul sebagai online, dan memaksa HAProxy untuk terhubung ke node yang benar.

Jalankan perintah berikut di **Node05** untuk instalasi HAProxy

    [root@node05 ~]#
    [root@node05 ~]# dnf -y install haproxy

Konfigurasi HAProxy:

    [root@node05 ~]#
    [root@node05 ~]# vim /etc/haproxy/haproxy.cfg

Berikut full konfigurasi HAProxy

    global
    
            maxconn 100
            log 127.0.0.1 local2
    
    defaults
            log global
            mode tcp
            retries 2
            timeout client 30m
            timeout connect 4s
            timeout server 30m
            timeout check 5s
    
    listen stats
        mode http
        bind *:2233
        stats hide-version
        stats refresh 30s
        stats show-node
        stats auth username:password
        stats enable
        stats uri /
    
    listen postgres
        bind *:5000
        option httpchk
        http-check expect status 200
        default-server inter 3s fall 3 rise 2 on-marked-down shutdown-sessions
        server node1 192.168.10.21:5432 maxconn 100 check port 8008
        server node2 192.168.10.24:5432 maxconn 100 check port 8008
        server node3 192.168.10.28:5432 maxconn 100 check port 8008

_Noted: Set default HAProxy menjadi tcp dan input node postgresql_

Simpan pastikan tidak ada konfigurasi yang salah, lalu restart HAProxy dan pastikan statusnya running

    [root@node05 ~]# haproxy -c -V -f /etc/haproxy/haproxy.cfg
    Configuration file is valid
    [root@node05 ~]#
    [root@node05 ~]# systemctl restart haproxy
    [root@node05 ~]# systemctl status haproxy -l

Langkah terakhir kita akan mencoba melakukan percobaan login ke postgresql menggunakan IP Load Balancer atau HAProxy dan menggunakan port 5000 yang sudah di set up di sisi HAProxy sebelumnya

<figure class="wp-block-image size-large"><img loading="lazy" width="743" height="187" src="/content/images/wordpress/2020/09/7.png" alt="" class="wp-image-489" srcset="/content/images/wordpress/2020/09/7.png 743w, /content/images/wordpress/2020/09/7-300x76.png 300w" sizes="(max-width: 743px) 100vw, 743px"></figure>

Seperti yang Anda lihat pada gambar diatas saat ini client atau user dapat akses ke sisi database postgresql melalui IP HAProxy.

Silakan akses IP Public HAProxy Anda melalui browser menggunakan port 2233 sesuai konfigurasi HAProxy diatas dan hasilnya seperti berikut

<figure class="wp-block-image size-large"><img loading="lazy" width="1024" height="278" src="/content/images/wordpress/2020/09/5-2-1024x278.png" alt="" class="wp-image-490" srcset="/content/images/wordpress/2020/09/5-2-1024x278.png 1024w, /content/images/wordpress/2020/09/5-2-300x81.png 300w, /content/images/wordpress/2020/09/5-2-768x208.png 768w, /content/images/wordpress/2020/09/5-2-1536x417.png 1536w, /content/images/wordpress/2020/09/5-2.png 1917w" sizes="(max-width: 1024px) 100vw, 1024px"></figure>

Seperti yang Anda lihat pada gambar di atas, baris (node1) disorot dengan warna hijau. Ini menunjukkan bahwa (node1 192.168.10.21) saat ini bertindak sebagai master atau primary dan sisanya (node02, node03) bertindak sebagai standby.

Jika Anda mematikan node master dengan perintah _systemctl stop patroni_ atau dengan mematikan server sepenuhnya, dashboard akan terlihat seperti di bawah ini:

Proses Load Balancing / Failover

<figure class="wp-block-image size-large"><img loading="lazy" width="1024" height="290" src="/content/images/wordpress/2020/09/ha03-1024x290.png" alt="" class="wp-image-493" srcset="/content/images/wordpress/2020/09/ha03-1024x290.png 1024w, /content/images/wordpress/2020/09/ha03-300x85.png 300w, /content/images/wordpress/2020/09/ha03-768x217.png 768w, /content/images/wordpress/2020/09/ha03-1536x435.png 1536w, /content/images/wordpress/2020/09/ha03.png 1912w" sizes="(max-width: 1024px) 100vw, 1024px"></figure>

Saat ini node02 bertindak sebagai master

<figure class="wp-block-image size-large"><img loading="lazy" width="1024" height="275" src="/content/images/wordpress/2020/09/6-1024x275.png" alt="" class="wp-image-491" srcset="/content/images/wordpress/2020/09/6-1024x275.png 1024w, /content/images/wordpress/2020/09/6-300x81.png 300w, /content/images/wordpress/2020/09/6-768x206.png 768w, /content/images/wordpress/2020/09/6-1536x412.png 1536w, /content/images/wordpress/2020/09/6.png 1908w" sizes="(max-width: 1024px) 100vw, 1024px"></figure>

Di bagian Postgres pada gambar di atas, baris (node1) sekarang berwarna merah dan baris (node2) disorot dengan warna hijau. Ini menunjukkan bahwa (node2 192.168.10.24) saat ini bertindak sebagai master.

Catatan: Dalam kasus ini, kebetulan server Postgres kedua dipromosikan menjadi master. Ini mungkin tidak selalu terjadi jika Anda memiliki lebih dari dua node di cluster. Kemungkinan yang sama bahwa server ketiga dapat dipromosikan menjadi master, contoh seperti gambar dibawah ini

<figure class="wp-block-image size-large"><img loading="lazy" width="1024" height="296" src="/content/images/wordpress/2020/09/ha04-1024x296.png" alt="" class="wp-image-494" srcset="/content/images/wordpress/2020/09/ha04-1024x296.png 1024w, /content/images/wordpress/2020/09/ha04-300x87.png 300w, /content/images/wordpress/2020/09/ha04-768x222.png 768w, /content/images/wordpress/2020/09/ha04-1536x444.png 1536w, /content/images/wordpress/2020/09/ha04.png 1917w" sizes="(max-width: 1024px) 100vw, 1024px"></figure>

Dimaan node01 dan node03 dipromosikan sebagai master.

Selamat mencoba 😁

Please follow and like us:

[![error](/wp-content/plugins/ultimate-social-media-icons/images/follow_subscribe.png)](https://api.follow.it/widgets/icon/VHc3d1lpVGdwRnE5QnV0eERCNUx5RCtvTTVoUkNYS3NNRmd5eVhlQW9tNXRHS3VTbGh6Y0NybkRJRS8zSGpjRDVZb1ZGMlNTSEpJYUpuZzZqNzdnd3VSN3dwM2VlQTF6ejJEaGV5UGRUbnlEcHFNd3luYTV4ZTZtUGowVWI2Q2x8M2kzdnBEeUIrUk5xOFI5TXZ3cHF3bFNQRkRJSGhUNGdrRFd0TlNtdE1OWT0=/OA==/)

[![fb-share-icon](/wp-content/plugins/ultimate-social-media-icons/images/visit_icons/fbshare_bck.png "Facebook Share")](https://www.facebook.com/sharer/sharer.php?u=https%3A%2F%2Fbelajarlinux.id%2F%3Fp%3D481%26ghostexport%3Dtrue%26submit%3DDownload+Ghost+File)

[![Tweet](/wp-content/plugins/ultimate-social-media-icons/images/visit_icons/en_US_Tweet.svg "Tweet")](https://twitter.com/intent/tweet?text=High+Availability+PostgreSQL+Cluster+Menggunakan+Patroni+dan+HAProxy+https://belajarlinux.id/?p=481&ghostexport=true&submit=Download Ghost File)

[![fb-share-icon](/wp-content/plugins/ultimate-social-media-icons/images/share_icons/Pinterest_Save/en_US_save.svg "Pin Share")](#)

<!--kg-card-end: html-->
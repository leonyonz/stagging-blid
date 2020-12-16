---
layout: post
title: Cara Instalasi dan Konfigurasi MariaDB Galera Cluster di CentOS 8
featured: true
date: '2020-08-31 20:38:13'
tags:
- centos
- database
- galera-cluster
---

 **MariaDB Galera Cluster** adalah salah satu DBMS _(Database Management system)_ yang open source artinya dapat digunakan secara bebas dan tentunya sangat populer serta mempunyai mekanisme replikasi.

**MariaDB Galera Cluster** salah satu tipe cluster synchronous multi-master untuk MariaDB dan hanya tersedia di sistem operasi GNU/Linux. Galera Cluster hanya mendukung**[XtraDB/InnoDB](https://mariadb.com/kb/en/xtradb-and-innodb/)** storage engine dan untuk**[MyISAM](https://mariadb.com/kb/en/myisam/)** masih dalam experimental, dengan menggunakan Galera Cluster salah satu cara untuk implementasi high-availability database server, karena semua database server akan menjadi server aktif yang dapat melayani baca (read) atau tulis (write) ke database.

Galera Cluster sendiri dikembangkan oleh **[Codership](https://galeracluster.com/)**, sebuha perusahaan yang berada di _Finlandia._ Terdapat 3 versi Galera Cluster diantaranya:

1. _MySQL Galera Cluster: Galera asli yang dikembangkan oleh Codership_
2. _MariaDB Galera Cluster: Hasil fork dari Codership_
3. _Percona XtraDB cluster: Yang lainnya dari Codership_

Pada tutorial kali ini kami akan menggunakan MariaDB Galera Cluster, berikut ini beberapa fitur dan keuntungan jika menggunakan MariaDB Galera Cluster:

- _High availability. Jika ada salah satu node di cluster down (gagal), node yang lain dapat terus menyediakan layanan tanpa memerlukan prosedur failover manual._
- _High data consistency_. _Galera Cluster menggunakan replikasi synchronous, jadi tidak ada slave lag atau data divergen yang diperbolehkan antar node dan tidak ada data yang hilang setelah node crash. Transaksi dilakukan dalam urutan yang sama di semua node._
- _Topologi yang digunakan yakni Active-active multi-master_
- _Karena active – active maka untuk proses read dan write dapat di node manapun_.
- _Dalam hal scalability untuk proses read dan write sangat bagus, dan tidak perlu lagi membagi read dan write ke node yang berbeda_
- _Dapat di kontrol secara otomatis, jika terdapat node yang down akan secara otomatis di keluarkan dari cluster_
- _Dengan menggunakan MariaDB Galera Cluster untuk penambahan node dapat di lakukan secara otomatis_ 
- _Penggunaan MariaDB Galera Cluster dapat memungkinkan kita mempunyai multi node slave_
- _Latensi yang kecil._

Tutorial kali ini akan menggunakan 3 node dengan topologi seperti berikut

<figure class="aligncenter size-large"><img loading="lazy" width="259" height="222" src="/content/images/wordpress/2020/08/galera1.png" alt="" class="wp-image-382"></figure>

Berikut detail informasi baik hostname dan IP di masing – masing node diatas

1. **Node01**  
Hostname: galera01.nurhamim.my.id  
IP: 192.168.10.9
2. **Node02**  
Hostname: galera02.nurhamim.my.id  
IP: 192.168.10.18
3. **Node03**  
Hostname: galera03.nurhamim.my.id  
IP: 192.168.10.21

Tutorial ini akan dibagi menjadi 3 bagian diantaranya

### # **Instalasi Galera di masing – masing Node**

Secara default di repository default CentOS 8 sudah ada Galera dengan mariadb versi 10.3 yang dapat Anda gunakan, untuk melihat module mariadb di CentOS 8 jalankan perintah berikut

    [root@galera01 ~]#
    [root@galera01 ~]# dnf module list mariadb
    Last metadata expiration check: 0:06:56 ago on Sun 30 Aug 2020 03:54:54 PM UTC.
    CentOS-8 - AppStream
    Name Stream Profiles Summary mariadb 10.3 [d] client, galera, server [d] MariaDB Module            
    Hint: [d]efault, [e]nabled, [x]disabled, [i]nstalled
    [root@galera01 ~]#

Jalankan command berikut untuk instalasi mariadb galera cluster di _node01_

    [root@galera01 ~]#
    [root@galera01 ~]# dnf install mariadb-server-galera -y

Ulangi langkah di atas di _node02_

    [root@galera02 ~]#
    [root@galera02 ~]# dnf install mariadb-server-galera -y

Dan berikut di _node03_

    [root@galera03 ~]#
    [root@galera03 ~]# dnf install mariadb-server-galera -y

### # Konfigurasi di masing – masing Node

Sebelum melakukan konfigurasi pastikan Anda sudah menambahkan beberapa port berikut (4567,4568,4444) di sisi firewall disini kami menggunakan openstack, untuk allow port dapat di lakukan melalui security group

<figure class="wp-block-image size-large"><img loading="lazy" width="1024" height="127" src="/content/images/wordpress/2020/08/port-allow-1024x127.png" alt="" class="wp-image-383" srcset="/content/images/wordpress/2020/08/port-allow-1024x127.png 1024w, /content/images/wordpress/2020/08/port-allow-300x37.png 300w, /content/images/wordpress/2020/08/port-allow-768x95.png 768w, /content/images/wordpress/2020/08/port-allow.png 1250w" sizes="(max-width: 1024px) 100vw, 1024px"></figure>

Jika Anda menggunakan firewalld berikut command yang dapat Anda gunakan

    # firewall-cmd --permanent --add-service=mysql
    success
    # firewall-cmd --permanent --add-port={4567,4568,4444}/tcp
    success
    # firewall-cmd --reload
    success

_ **Keterangan:** _

- _Port 4567 : Digunakan untuk lalu lintas replikasi Galera Cluster. Replikasi multicast menggunakan transport pada port UDP dan TCP._
- _Port 4568 : Digunakan untuk Transfer Status Tambahan , atau IST, proses di mana keadaan yang hilang diterima oleh node lain di cluster._
- _Port 4444 : Digunakan untuk semua State Snapshot Transfer lainnya , atau SST, mekanisme di mana link joiner mendapatkan status dan data dari link distribusi._

#### **Node01**

Buat file log untuk mariadb dan berikan hak owner mysql

    [root@galera01 ~]# touch /var/log/mariadb.log
    [root@galera01 ~]# chown mysql:mysql /var/log/mariadb.log

Default konfigurasi galera berada di direktori _/etc/my.cnf.d/galera.cnf_

    [root@galera01 ~]#
    [root@galera01 ~]# vim /etc/my.cnf.d/galera.cnf

Silakan _uncoment pagar_ dan tambahkan serta sesuaikan konfigurasi berikut:

    [mysqld]
    log_error=/var/log/mariadb.log
    
    
    binlog_format=ROW
    default-storage-engine=innodb
    innodb_autoinc_lock_mode=2
    bind-address=0.0.0.0
    wsrep_on=ON
    wsrep_provider=/usr/lib64/galera/libgalera_smm.so
    wsrep_cluster_name="belajarlinux-cluster"
    wsrep_cluster_address="gcomm://192.168.10.9,192.168.10.18,192.168.10.21"
    wsrep_sst_method=rsync
    wsrep_node_address="192.168.10.9"
    wsrep_node_name="galera01"

Selanjutnya start Galera Cluster di _Node01_

    [root@galera01 ~]#
    [root@galera01 ~]# galera_new_cluster
    [root@galera01 ~]#

Enable mariadb server

    [root@galera01 ~]#
    [root@galera01 ~]# systemctl enable --now mariadb
    Created symlink /etc/systemd/system/mysql.service → /usr/lib/systemd/system/mariadb.service.
    Created symlink /etc/systemd/system/mysqld.service → /usr/lib/systemd/system/mariadb.service.
    Created symlink /etc/systemd/system/multi-user.target.wants/mariadb.service → /usr/lib/systemd/system/mariadb.service.
    [root@galera01 ~]

Selanjutnya mengatur password root mariadb

    [root@galera01 ~]# mysql_secure_installation
    Enter current password for root (enter for none):
    Set root password? [Y/n] Y
    Remove anonymous users? [Y/n] Y
    Disallow root login remotely? [Y/n] Y
    Remove test database and access to it? [Y/n] Y
    Reload privilege tables now? [Y/n] Y

#### **Node02**

Di _node02_ langkah – langkahnya hampir sama dengan langkah di _node01_, Anda hanya perlu membuat file log mariadb beserta permissionnya seperti berikut

    [root@galera02 ~]#
    [root@galera02 ~]# touch /var/log/mariadb.log
    [root@galera02 ~]# chown mysql:mysql /var/log/mariadb.log

Dan menambahkan, serta menyesuaikan konfigurasi galera cluster

    [root@galera02 ~]#
    [root@galera02 ~]# vim /etc/my.cnf.d/galera.cnf

    [mysqld]
    log_error=/var/log/mariadb.log
    
    
    binlog_format=ROW
    default-storage-engine=innodb
    innodb_autoinc_lock_mode=2
    bind-address=0.0.0.0
    wsrep_on=ON
    wsrep_provider=/usr/lib64/galera/libgalera_smm.so
    wsrep_cluster_name="belajarlinux-cluster"
    wsrep_cluster_address="gcomm://192.168.10.9,192.168.10.18,192.168.10.21"
    wsrep_node_address="192.168.10.18"

_Noted: Di node02 Anda tidak perlu menambahkan wsrep\_node\_name dan pada wsrep\_node\_address silakan isi dengan IP node02_

Enable mariadb

    [root@galera02 ~]#
    [root@galera02 ~]# systemctl enable --now mariadb
    Created symlink /etc/systemd/system/mysql.service → /usr/lib/systemd/system/mariadb.service.
    Created symlink /etc/systemd/system/mysqld.service → /usr/lib/systemd/system/mariadb.service.
    Created symlink /etc/systemd/system/multi-user.target.wants/mariadb.service → /usr/lib/systemd/system/mariadb.service.
    [root@galera02 ~]#

#### **Node03**

Buat file log dan berikan permission mysql

    [root@galera03 ~]#
    [root@galera03 ~]# touch /var/log/mariadb.log
    [root@galera03 ~]# chown mysql:mysql /var/log/mariadb.log
    [root@galera03 ~]#

Konfigurasi galera di _node03_

    [root@galera03 ~]#
    [root@galera03 ~]# vim /etc/my.cnf.d/galera.cnf

Berikut detailnya

    [mysqld]
    log_error=/var/log/mariadb.log
    
    
    binlog_format=ROW
    default-storage-engine=innodb
    innodb_autoinc_lock_mode=2
    bind-address=0.0.0.0
    wsrep_on=ON
    wsrep_provider=/usr/lib64/galera/libgalera_smm.so
    wsrep_cluster_name="belajarlinux-cluster"
    wsrep_cluster_address="gcomm://192.168.10.9,192.168.10.18,192.168.10.21"
    wsrep_node_address="192.168.10.21"

_Noted: Di node03 Anda tidak perlu menambahkan wsrep\_node\_name dan pada wsrep\_node\_address silakan isi dengan IP node03_

Enable MariaDB

    [root@galera03 ~]#
    [root@galera03 ~]# systemctl enable --now mariadb
    Created symlink /etc/systemd/system/mysql.service → /usr/lib/systemd/system/mariadb.service.
    Created symlink /etc/systemd/system/mysqld.service → /usr/lib/systemd/system/mariadb.service.
    Created symlink /etc/systemd/system/multi-user.target.wants/mariadb.service → /usr/lib/systemd/system/mariadb.service.
    [root@galera03 ~]#

Dan berikut beberapa penjelasan dari rule – rule diatas

- _wsrep\_cluster\_address : untuk mendifinisikan ip address server mana saja yang nanti akan masuk kedalam lingkungan grup cluster_
- _wsrep\_cluster\_name : nama untuk grup cluster, namanya harus sama pada setiap server yang masuk kedalam wsrep\_cluster\_address_
- _wsrep\_node\_address : diisikan dengan alamat ip server masing-masing node (jika Adnda setting di galera01 maka isikan dengan ip galera01, jika Anda setting di galera02 isikan dengan ip galera02 dan seterusnya._
- _wsrep\_sst\_method : metode yang digunakan untuk replikasi database nya_

### # Verifikasi Galera Cluster

Silakan login ke database mariadb _node01_

    [root@galera01 ~]#
    [root@galera01 ~]# mysql -u root -p
    Enter password:
    Welcome to the MariaDB monitor. Commands end with ; or \g.
    Your MariaDB connection id is 21
    Server version: 10.3.17-MariaDB MariaDB Server
    
    Copyright (c) 2000, 2018, Oracle, MariaDB Corporation Ab and others.
    
    Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.
    
    MariaDB [(none)]> 

Verifikasi jumlan node yang sudah ditambahkan

    MariaDB [(none)]> show status like 'wsrep_cluster_size';
    +--------------------+-------+
    | Variable_name | Value |
    +--------------------+-------+
    | wsrep_cluster_size | 3 |
    +--------------------+-------+
    1 row in set (0.003 sec)
    
    MariaDB [(none)]>

_wsrep\_cluster\_size_ _= 3_ menandakan jumlah node cluster ada 3 node atau VM.

Selanjutnya cek status galera cluster, gunakan perintah berikut

    MariaDB [(none)]>
    MariaDB [(none)]> show status like 'wsrep_%';
    +-------------------------------+---------------------------------------------------------+
    | Variable_name | Value |
    +-------------------------------+---------------------------------------------------------+
    | wsrep_applier_thread_count | 1 |
    | wsrep_apply_oooe | 0.000000 |
    | wsrep_apply_oool | 0.000000 |
    | wsrep_apply_window | 1.000000 |
    | wsrep_causal_reads | 0 |
    | wsrep_cert_deps_distance | 1.000000 |
    | wsrep_cert_index_size | 6 |
    | wsrep_cert_interval | 0.000000 |
    | wsrep_cluster_conf_id | 3 |
    | wsrep_cluster_size | 3 |
    | wsrep_cluster_state_uuid | 2e4402c1-eae0-11ea-ac64-8b88004f6b7a |
    | wsrep_cluster_status | Primary |
    | wsrep_cluster_weight | 3 |
    | wsrep_commit_oooe | 0.000000 |
    | wsrep_commit_oool | 0.000000 |
    | wsrep_commit_window | 1.000000 |
    | wsrep_connected | ON |
    | wsrep_desync_count | 0 |
    | wsrep_evs_delayed | |
    | wsrep_evs_evict_list | |
    | wsrep_evs_repl_latency | 0/0/0/0/0 |
    | wsrep_evs_state | OPERATIONAL |
    | wsrep_flow_control_paused | 0.000000 |
    | wsrep_flow_control_paused_ns | 0 |
    | wsrep_flow_control_recv | 0 |
    | wsrep_flow_control_sent | 0 |
    | wsrep_gcomm_uuid | 2e424576-eae0-11ea-9c6b-e65b48c5cd07 |
    | wsrep_incoming_addresses | 192.168.10.9:3306,192.168.10.18:3306,192.168.10.21:3306 |
    | wsrep_last_committed | 12 |
    | wsrep_local_bf_aborts | 0 |
    | wsrep_local_cached_downto | 1 |
    | wsrep_local_cert_failures | 0 |
    | wsrep_local_commits | 0 |
    | wsrep_local_index | 0 |
    | wsrep_local_recv_queue | 0 |
    | wsrep_local_recv_queue_avg | 0.071429 |
    | wsrep_local_recv_queue_max | 2 |
    | wsrep_local_recv_queue_min | 0 |
    | wsrep_local_replays | 0 |
    | wsrep_local_send_queue | 0 |
    | wsrep_local_send_queue_avg | 0.000000 |
    | wsrep_local_send_queue_max | 1 |
    | wsrep_local_send_queue_min | 0 |
    | wsrep_local_state | 4 |
    | wsrep_local_state_comment | Synced |
    | wsrep_local_state_uuid | 2e4402c1-eae0-11ea-ac64-8b88004f6b7a |
    | wsrep_open_connections | 0 |
    | wsrep_open_transactions | 0 |
    | wsrep_protocol_version | 9 |
    | wsrep_provider_name | Galera |
    | wsrep_provider_vendor | Codership Oy <info@codership.com> |
    | wsrep_provider_version | 3.26(rXXXX) |
    | wsrep_ready | ON |
    | wsrep_received | 14 |
    | wsrep_received_bytes | 2666 |
    | wsrep_repl_data_bytes | 2996 |
    | wsrep_repl_keys | 9 |
    | wsrep_repl_keys_bytes | 264 |
    | wsrep_repl_other_bytes | 0 |
    | wsrep_replicated | 8 |
    | wsrep_replicated_bytes | 3808 |
    | wsrep_rollbacker_thread_count | 1 |
    | wsrep_thread_count | 2 |
    +-------------------------------+---------------------------------------------------------+
    63 rows in set (0.003 sec)
    
    MariaDB [(none)]>

### # Percobaan Galera Cluster

Berikut ini ada beberapa percobaan yang akan di lakukan diantaranya sebagai berikut:

Login masing – masing node database mariadb

<figure class="wp-block-image size-large"><img loading="lazy" width="1024" height="329" src="/content/images/wordpress/2020/08/1-7-1024x329.png" alt="" class="wp-image-384" srcset="/content/images/wordpress/2020/08/1-7-1024x329.png 1024w, /content/images/wordpress/2020/08/1-7-300x96.png 300w, /content/images/wordpress/2020/08/1-7-768x246.png 768w, /content/images/wordpress/2020/08/1-7-1536x493.png 1536w, /content/images/wordpress/2020/08/1-7.png 1913w" sizes="(max-width: 1024px) 100vw, 1024px"></figure>

Membuat database di _ **node01** _ dan lihat hasilnya di _ **node02 dan node03** _

<figure class="wp-block-image size-large"><img loading="lazy" width="1024" height="272" src="/content/images/wordpress/2020/08/2-7-1024x272.png" alt="" class="wp-image-385" srcset="/content/images/wordpress/2020/08/2-7-1024x272.png 1024w, /content/images/wordpress/2020/08/2-7-300x80.png 300w, /content/images/wordpress/2020/08/2-7-768x204.png 768w, /content/images/wordpress/2020/08/2-7-1536x408.png 1536w, /content/images/wordpress/2020/08/2-7.png 1918w" sizes="(max-width: 1024px) 100vw, 1024px"></figure>

Membuat database di **_node02_** dan lihat hasilnya di **_node01 dan node03_**

<figure class="wp-block-image size-large"><img loading="lazy" width="671" height="221" src="/content/images/wordpress/2020/08/3-5.png" alt="" class="wp-image-388" srcset="/content/images/wordpress/2020/08/3-5.png 671w, /content/images/wordpress/2020/08/3-5-300x99.png 300w" sizes="(max-width: 671px) 100vw, 671px"></figure>

Membuat database di **_node03_** dan lihat hasilnya di **_node01 dan node0_2**

<figure class="wp-block-image size-large"><img loading="lazy" width="1024" height="353" src="/content/images/wordpress/2020/08/4-6-1024x353.png" alt="" class="wp-image-386" srcset="/content/images/wordpress/2020/08/4-6-1024x353.png 1024w, /content/images/wordpress/2020/08/4-6-300x103.png 300w, /content/images/wordpress/2020/08/4-6-768x265.png 768w, /content/images/wordpress/2020/08/4-6-1536x529.png 1536w, /content/images/wordpress/2020/08/4-6.png 1918w" sizes="(max-width: 1024px) 100vw, 1024px"></figure>

Selanjutnya kita akan mencoba membuat beberapa kombinasi percobaan di masing – masing node mulai dari percobaan, rewad -write, dan read saja.

Membuat database yang sudah dilengkapi dengan tabel dan yang lainnya di sisi _node01_

    [root@galera01 ~]#
    [root@galera01 ~]# mysql -u root -p -e 'CREATE DATABASE playground;
    > CREATE TABLE playground.equipment ( id INT NOT NULL AUTO_INCREMENT, type VARCHAR(50), quant INT, color VARCHAR(25), PRIMARY KEY(id));
    > INSERT INTO playground.equipment (type, quant, color) VALUES ("slide", 2, "blue");'
    Enter password:
    [root@galera01 ~]#

Test read dan write di sisi _node02_

    [root@galera02 ~]#
    [root@galera02 ~]# mysql -u root -p -e 'SELECT * FROM playground.equipment;'
    Enter password:
    +----+-------+-------+-------+
    | id | type | quant | color |
    +----+-------+-------+-------+
    | 1 | slide | 2 | blue |
    +----+-------+-------+-------+
    [root@galera02 ~]#
    [root@galera02 ~]# mysql -u root -p -e 'INSERT INTO playground.equipment (type, quant, color) VALUES ("swing", 10, "yellow");'
    Enter password:
    [root@galera02 ~]#

Test read dan write di sisi _node03_

    [root@galera03 ~]#
    [root@galera03 ~]# mysql -u root -p -e 'SELECT * FROM playground.equipment;'
    Enter password:
    +----+-------+-------+--------+
    | id | type | quant | color |
    +----+-------+-------+--------+
    | 1 | slide | 2 | blue |
    | 2 | swing | 10 | yellow |
    +----+-------+-------+--------+
    [root@galera03 ~]#
    [root@galera03 ~]# mysql -u root -p -e 'INSERT INTO playground.equipment (type, quant, color) VALUES ("seesaw", 3, "green");'
    Enter password:
    [root@galera03 ~]#

Test read saja di _node01_

    [root@galera01 ~]#
    [root@galera01 ~]# mysql -u root -p -e 'SELECT * FROM playground.equipment;'
    Enter password:
    +----+--------+-------+--------+
    | id | type | quant | color |
    +----+--------+-------+--------+
    | 1 | slide | 2 | blue |
    | 2 | swing | 10 | yellow |
    | 3 | seesaw | 3 | green |
    +----+--------+-------+--------+
    [root@galera01 ~]#

Selamat mariadb galera cluster Anda sudah berhasil teristall dan dapat digunakan.

Selamat mencoba 😁

Please follow and like us:

[![error](/wp-content/plugins/ultimate-social-media-icons/images/follow_subscribe.png)](https://api.follow.it/widgets/icon/VHc3d1lpVGdwRnE5QnV0eERCNUx5RCtvTTVoUkNYS3NNRmd5eVhlQW9tNXRHS3VTbGh6Y0NybkRJRS8zSGpjRDVZb1ZGMlNTSEpJYUpuZzZqNzdnd3VSN3dwM2VlQTF6ejJEaGV5UGRUbnlEcHFNd3luYTV4ZTZtUGowVWI2Q2x8M2kzdnBEeUIrUk5xOFI5TXZ3cHF3bFNQRkRJSGhUNGdrRFd0TlNtdE1OWT0=/OA==/)

[![fb-share-icon](/wp-content/plugins/ultimate-social-media-icons/images/visit_icons/fbshare_bck.png "Facebook Share")](https://www.facebook.com/sharer/sharer.php?u=https%3A%2F%2Fbelajarlinux.id%2F%3Fp%3D381%26ghostexport%3Dtrue%26submit%3DDownload+Ghost+File)

[![Tweet](/wp-content/plugins/ultimate-social-media-icons/images/visit_icons/en_US_Tweet.svg "Tweet")](https://twitter.com/intent/tweet?text=Cara+Instalasi+dan+Konfigurasi+MariaDB+Galera+Cluster+di+CentOS+8+https://belajarlinux.id/?p=381&ghostexport=true&submit=Download Ghost File)

[![fb-share-icon](/wp-content/plugins/ultimate-social-media-icons/images/share_icons/Pinterest_Save/en_US_save.svg "Pin Share")](#)

<!--kg-card-end: html-->
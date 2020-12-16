---
layout: post
title: 'Openstack: Install Openstack All-in-One with Packstack'
featured: true
date: '2020-10-24 18:53:18'
tags:
- openstack
---

**[Belajar Linux ID](/)** – Pada tutorial kali ini kita akan membahas bagaimana cara install openstack queen single node menggunakan **Packstack.**

**Packstack** merupakan utilitas yang menggunakan modul [puppet](https://puppet.com/) untuk menyebarkan berbagai layanan dari Openstack pada server secara otomatis melalui SSH. Instalasi packstack dapat di lakukan di sistem operasi berikut:   
  
_– Red Hat Enterprise Linux (RHEL) 7&nbsp;(minimum requirement)  
– CentOS 7  
– Scientific Linux x86\_64_    
  
_[Baca juga: [OPENSTACK 01: DEFINISI DAN ARSITEKTUR](/openstack-definisi-dan-arsitektur/)]_

Untuk detail requirement hardware Anda dapat merujuk pada link resmi packstack berikut: **[Prasyarat](https://www.rdoproject.org/install/packstack/)**

Berikut requirement hardware yang kami gunakan untuk instalasi Openstack queen menggunakan packstack:  
  
_– CPU: 8 Core  
– RAM: 8 GB  
– Disk: 60 GB_

Untuk OS yang kami gunakan yaitu CentOS 7. Berikut tahapan – tahapan instasinya:

Pertama silakan akses SSH ke VM Anda, dan silakan update sistem operasi CentOS 7

    [root@hamim-stack ~]#
    [root@hamim-stack ~]# yum update -y

Konfigurasi hostname

    [root@hamim-stack ~]#
    [root@hamim-stack ~]# hostnamectl set-hostname packstack.nurhamim.my.id
    [root@hamim-stack ~]#
    [root@hamim-stack ~]# hostnamectl |grep Static
       Static hostname: packstack.nurhamim.my.id
    [root@hamim-stack ~]#

Disable Selinux

    [root@hamim-stack ~]#
    [root@hamim-stack ~]# sed -i 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/selinux/config
    [root@hamim-stack ~]# cat /etc/selinux/config |grep SELINUX
    # SELINUX= can take one of these three values:
    SELINUX=disabled
    # SELINUXTYPE= can take one of three two values:
    SELINUXTYPE=targeted
    [root@hamim-stack ~]#

Install repository openstack versi queen

    [root@hamim-stack ~]#
    [root@hamim-stack ~]# yum install -y centos-release-openstack-queens

Enable paket repository openstack

    [root@hamim-stack ~]# yum-config-manager enable openstack-queens
    Loaded plugins: fastestmirror
    [root@hamim-stack ~]#

Update kembali CentOS 7 Anda

    [root@hamim-stack ~]#
    [root@hamim-stack ~]# yum update -y

Jika sudah, selanjutnya install openstack packstack

    [root@hamim-stack ~]#
    [root@hamim-stack ~]# yum install -y openstack-packstack

Selanjutnya install packstack all-in-one

    [root@hamim-stack ~]#
    [root@hamim-stack ~]# packstack --allinone
    Welcome to the Packstack setup utility
    
    The installation log file is available at: /var/tmp/packstack/20200913-162522-c8kzCN/openstack-setup.log
    Packstack changed given value to required value /root/.ssh/id_rsa.pub
    
    Installing:
    Clean Up [DONE]
    Discovering ip protocol version [DONE]
    Setting up ssh keys [DONE]
    Preparing servers [DONE]
    Pre installing Puppet and discovering hosts' details [DONE]
    Preparing pre-install entries [DONE]
    Setting up CACERT [DONE]
    Preparing AMQP entries [DONE]
    Preparing MariaDB entries [DONE]
    Fixing Keystone LDAP config parameters to be undef if empty[DONE]
    Preparing Keystone entries [DONE]
    Preparing Glance entries [DONE]
    Checking if the Cinder server has a cinder-volumes vg[DONE]
    Preparing Cinder entries [DONE]
    Preparing Nova API entries [DONE]
    Creating ssh keys for Nova migration [DONE]
    Gathering ssh host keys for Nova migration [DONE]
    Preparing Nova Compute entries [DONE]
    Preparing Nova Scheduler entries [DONE]
    Preparing Nova VNC Proxy entries [DONE]
    Preparing OpenStack Network-related Nova entries [DONE]
    Preparing Nova Common entries [DONE]
    Preparing Neutron LBaaS Agent entries [DONE]
    Preparing Neutron API entries [DONE]
    Preparing Neutron L3 entries [DONE]
    Preparing Neutron L2 Agent entries [DONE]
    Preparing Neutron DHCP Agent entries [DONE]
    Preparing Neutron Metering Agent entries [DONE]
    Checking if NetworkManager is enabled and running [DONE]
    Preparing OpenStack Client entries [DONE]
    Preparing Horizon entries [DONE]
    Preparing Swift builder entries [DONE]
    Preparing Swift proxy entries [DONE]
    Preparing Swift storage entries [DONE]
    Preparing Gnocchi entries [DONE]
    Preparing Redis entries [DONE]
    Preparing Ceilometer entries [DONE]
    Preparing Aodh entries [DONE]
    Preparing Puppet manifests [DONE]
    Copying Puppet modules and manifests [DONE]
    Applying 192.168.20.5_controller.pp
    Testing if puppet apply is finished: 192.168.20.5_controller.pp [|]
    
    Copying Puppet modules and manifests [DONE]
    Applying 192.168.20.5_controller.pp
    192.168.20.5_controller.pp: [DONE]
    Applying 192.168.20.5_network.pp
    192.168.20.5_network.pp: [DONE]
    Applying 192.168.20.5_compute.pp
    192.168.20.5_compute.pp: [DONE]
    Applying Puppet manifests [DONE]
    Finalizing [DONE]

<figure class="wp-block-image size-large"><img loading="lazy" width="819" height="814" src="/content/images/wordpress/2020/10/1.png" alt="" class="wp-image-670" srcset="/content/images/wordpress/2020/10/1.png 819w, /content/images/wordpress/2020/10/1-300x298.png 300w, /content/images/wordpress/2020/10/1-150x150.png 150w, /content/images/wordpress/2020/10/1-768x763.png 768w" sizes="(max-width: 819px) 100vw, 819px"></figure>

Instalasi ini membutuhkan waktu yang cukup lama karena kita akan menginstall semua paket openstack yang ada di packstack. Apabila berhasil Anda akan mendapatka informasi seperti berikut:

     ****Installation completed successfully******
    
    Additional information:
     * A new answerfile was created in: /root/packstack-answers-20200913-162523.txt
     * Time synchronization installation was skipped. Please note that unsynchronized time on server instances might be problem for some OpenStack components.
     * File /root/keystonerc_admin has been created on OpenStack client host 192.168.20.5. To use the command line tools you need to source the file.
     * To access the OpenStack Dashboard browse to http://192.168.20.5/dashboard .
    Please, find your login credentials stored in the keystonerc_admin in your home directory.
     * Because of the kernel update the host 192.168.20.5 requires reboot.
     * The installation log file is available at: /var/tmp/packstack/20200913-162522-c8kzCN/openstack-setup.log
     * The generated manifests are available at: /var/tmp/packstack/20200913-162522-c8kzCN/manifests
    [root@hamim-stack ~]#

<figure class="wp-block-image size-large"><img loading="lazy" width="1024" height="326" src="/content/images/wordpress/2020/10/2-1024x326.png" alt="" class="wp-image-671" srcset="/content/images/wordpress/2020/10/2-1024x326.png 1024w, /content/images/wordpress/2020/10/2-300x95.png 300w, /content/images/wordpress/2020/10/2-768x244.png 768w, /content/images/wordpress/2020/10/2.png 1100w" sizes="(max-width: 1024px) 100vw, 1024px"></figure>

Jika sudah Anda dapat akses IP atau hostname yang sudah di pointing ke IP Public VM Anda, hasilnya akan seperti berikut ini

<figure class="wp-block-image size-large"><img loading="lazy" width="1024" height="368" src="/content/images/wordpress/2020/10/3-1024x368.png" alt="" class="wp-image-672" srcset="/content/images/wordpress/2020/10/3-1024x368.png 1024w, /content/images/wordpress/2020/10/3-300x108.png 300w, /content/images/wordpress/2020/10/3-768x276.png 768w, /content/images/wordpress/2020/10/3-1536x553.png 1536w, /content/images/wordpress/2020/10/3.png 1918w" sizes="(max-width: 1024px) 100vw, 1024px"></figure>

Gambar diatas merupakan tampilan dari Horizon dan untuk mendapatkan username dan password login ke horizon, gunakan perintah berikut:

    [root@hamim-stack ~]#
    [root@hamim-stack ~]# cat /root/keystonerc_admin
    unset OS_SERVICE_TOKEN
        export OS_USERNAME=admin
        export OS_PASSWORD='28cd8b935903441a'
        export OS_REGION_NAME=RegionOne
        export OS_AUTH_URL=http://192.168.20.5:5000/v3
        export PS1='[\u@\h \W(keystone_admin)]\$ '
    
    export OS_PROJECT_NAME=admin
    export OS_USER_DOMAIN_NAME=Default
    export OS_PROJECT_DOMAIN_NAME=Default
    export OS_IDENTITY_API_VERSION=3
        [root@hamim-stack ~]#

Silakan login ke horizon menggunakan _username dan password_ di atas, apabila berhasil akan nampak seperti berikut

<figure class="wp-block-image size-large"><img loading="lazy" width="1024" height="300" src="/content/images/wordpress/2020/10/4-1024x300.png" alt="" class="wp-image-673" srcset="/content/images/wordpress/2020/10/4-1024x300.png 1024w, /content/images/wordpress/2020/10/4-300x88.png 300w, /content/images/wordpress/2020/10/4-768x225.png 768w, /content/images/wordpress/2020/10/4-1536x450.png 1536w, /content/images/wordpress/2020/10/4.png 1917w" sizes="(max-width: 1024px) 100vw, 1024px"></figure>

Berikut contoh overview dari atau menu yang ada di openstack Horizon

<figure class="wp-block-image size-large"><img loading="lazy" width="1024" height="500" src="/content/images/wordpress/2020/10/5-1024x500.png" alt="" class="wp-image-674" srcset="/content/images/wordpress/2020/10/5-1024x500.png 1024w, /content/images/wordpress/2020/10/5-300x146.png 300w, /content/images/wordpress/2020/10/5-768x375.png 768w, /content/images/wordpress/2020/10/5-1536x750.png 1536w, /content/images/wordpress/2020/10/5.png 1919w" sizes="(max-width: 1024px) 100vw, 1024px"></figure>

Jika terdapat pertanyaan silakan tulis di kolom komentar ya \*-\*

Selamat mencoba&nbsp;😁

Please follow and like us:

[![error](/wp-content/plugins/ultimate-social-media-icons/images/follow_subscribe.png)](https://api.follow.it/widgets/icon/VHc3d1lpVGdwRnE5QnV0eERCNUx5RCtvTTVoUkNYS3NNRmd5eVhlQW9tNXRHS3VTbGh6Y0NybkRJRS8zSGpjRDVZb1ZGMlNTSEpJYUpuZzZqNzdnd3VSN3dwM2VlQTF6ejJEaGV5UGRUbnlEcHFNd3luYTV4ZTZtUGowVWI2Q2x8M2kzdnBEeUIrUk5xOFI5TXZ3cHF3bFNQRkRJSGhUNGdrRFd0TlNtdE1OWT0=/OA==/)

[![fb-share-icon](/wp-content/plugins/ultimate-social-media-icons/images/visit_icons/fbshare_bck.png "Facebook Share")](https://www.facebook.com/sharer/sharer.php?u=https%3A%2F%2Fbelajarlinux.id%2F%3Fp%3D667%26ghostexport%3Dtrue%26submit%3DDownload+Ghost+File)

[![Tweet](/wp-content/plugins/ultimate-social-media-icons/images/visit_icons/en_US_Tweet.svg "Tweet")](https://twitter.com/intent/tweet?text=Openstack%3A+Install+Openstack+All-in-One+with+Packstack+https://belajarlinux.id/?p=667&ghostexport=true&submit=Download Ghost File)

[![fb-share-icon](/wp-content/plugins/ultimate-social-media-icons/images/share_icons/Pinterest_Save/en_US_save.svg "Pin Share")](#)

<!--kg-card-end: html-->
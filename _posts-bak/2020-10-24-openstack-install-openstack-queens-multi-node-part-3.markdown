---
layout: post
title: 'Openstack: Install Openstack Queens Multi-Node Part 3'
featured: true
date: '2020-10-24 21:21:35'
tags:
- openstack
---

[Belajar Linux ID](/) – Tutorial kali ini merupakan kelanjutkan dari part 2 sebelumnya berikut: [OPENSTACK: INSTALL OPENSTACK QUEENS MULTI-NODE PART 2](/openstack-install-openstack-queens-multi-node-part-2/) dan menjadi part terakhir dalam instalasi Openstack multi node menggunakan packstack kali ini.

Pada part terakhir ini kita akan membahas mengenai _Post Deploy_ sampai Openstack dapat diakses melalui Horizon (Dashboard).

Lakukan konfigurasi berikut di sisi **Node Controller**

Lakukan set DHCP Agent

    [root@hamim-controller ~]#
    [root@hamim-controller ~]# crudini --set /etc/neutron/dhcp_agent.ini DEFAULT enable_isolated_metadata True
    [root@hamim-controller ~]# systemctl restart neutron-dhcp-agent

Restart DHCP Agent dan pastikan status nya running

    [root@hamim-controller ~]# systemctl status neutron-dhcp-agent
    � neutron-dhcp-agent.service - OpenStack Neutron DHCP Agent
       Loaded: loaded (/usr/lib/systemd/system/neutron-dhcp-agent.service; enabled; vendor preset: disabled)
       Active: active (running) since Tue 2020-09-22 05:36:09 UTC; 4s ago
     Main PID: 11657 (neutron-dhcp-ag)
       CGroup: /system.slice/neutron-dhcp-agent.service
               ��11657 /usr/bin/python2 /usr/bin/neutron-dhcp-agent --config-file /usr/share/neutron/neutron-dist.conf --config-file /etc/neutron/neutron.conf --config-file /etc/neutron/dhcp_...
    
    Sep 22 05:36:09 hamim-controller.nurhamim.my.id systemd[1]: Stopped OpenStack Neutron DHCP Agent.
    Sep 22 05:36:09 hamim-controller.nurhamim.my.id systemd[1]: Started OpenStack Neutron DHCP Agent.
    [root@hamim-controller ~]#

Konfigurasi Horizon

    [root@hamim-controller ~]#
    [root@hamim-controller ~]# vim /etc/httpd/conf.d/15-horizon_vhost.conf

Sesuaikan Hostname atau domain atau subdomain yang Anda inginkan

<figure class="wp-block-image size-large"><img loading="lazy" width="527" height="205" src="/content/images/wordpress/2020/10/install-openstack01.png" alt="" class="wp-image-689" srcset="/content/images/wordpress/2020/10/install-openstack01.png 527w, /content/images/wordpress/2020/10/install-openstack01-300x117.png 300w" sizes="(max-width: 527px) 100vw, 527px"></figure>

Restart web server Apache

    [root@hamim-controller ~]#
    [root@hamim-controller ~]# systemctl restart httpd

Aktifkan virtlogd di sisi **Node Compute**

    [root@hamim-compute ~]#
    [root@hamim-compute ~]# systemctl status virtlogd
    ● virtlogd.service - Virtual machine log manager
       Loaded: loaded (/usr/lib/systemd/system/virtlogd.service; indirect; vendor preset: disabled)
       Active: inactive (dead)
         Docs: man:virtlogd(8)
               https://libvirt.org
    [root@hamim-compute ~]#
    [root@hamim-compute ~]# systemctl enable virtlogd
    [root@hamim-compute ~]# systemctl restart virtlogd
    [root@hamim-compute ~]# systemctl status virtlogd
    ● virtlogd.service - Virtual machine log manager
       Loaded: loaded (/usr/lib/systemd/system/virtlogd.service; indirect; vendor preset: disabled)
       Active: active (running) since Tue 2020-09-22 05:42:47 UTC; 3s ago
         Docs: man:virtlogd(8)
               https://libvirt.org
     Main PID: 14515 (virtlogd)
        Tasks: 1
       CGroup: /system.slice/virtlogd.service
               └─14515 /usr/sbin/virtlogd
    
    Sep 22 05:42:47 hamim-compute.nurhamim.my.id systemd[1]: Started Virtual machine log manager.
    [root@hamim-compute ~]#

Set Proxy Client di **Node Compute**

    [root@hamim-compute ~]#
    [root@hamim-compute ~]# crudini --set /etc/nova/nova.conf vnc vncserver_proxyclient_address 10.36.36.20

Restart _openstack-compute-nova_

    [root@hamim-compute ~]# systemctl restart openstack-nova-compute
    [root@hamim-compute ~]# systemctl status openstack-nova-compute
    ● openstack-nova-compute.service - OpenStack Nova Compute Server
       Loaded: loaded (/usr/lib/systemd/system/openstack-nova-compute.service; enabled; vendor preset: disabled)
       Active: active (running) since Tue 2020-09-22 05:44:27 UTC; 1s ago
     Main PID: 14527 (nova-compute)
        Tasks: 22
       CGroup: /system.slice/openstack-nova-compute.service
               └─14527 /usr/bin/python2 /usr/bin/nova-compute
    
    Sep 22 05:44:23 hamim-compute.nurhamim.my.id systemd[1]: Starting OpenStack Nova Compute Server...
    Sep 22 05:44:27 hamim-compute.nurhamim.my.id systemd[1]: Started OpenStack Nova Compute Server.
    [root@hamim-compute ~]#

Saat ini instalasi Openstack sudah selesai dilakukan, selanjutya silakan akses Horizon melalui browser Anda

<figure class="wp-block-image size-large"><img loading="lazy" width="1024" height="507" src="/content/images/wordpress/2020/10/install-openstack02-1024x507.png" alt="" class="wp-image-690" srcset="/content/images/wordpress/2020/10/install-openstack02-1024x507.png 1024w, /content/images/wordpress/2020/10/install-openstack02-300x149.png 300w, /content/images/wordpress/2020/10/install-openstack02-768x380.png 768w, /content/images/wordpress/2020/10/install-openstack02.png 1363w" sizes="(max-width: 1024px) 100vw, 1024px"></figure>

Untuk login ke Horizon gunakan username dan password yang di dapatkan melalui **Node Controller** berikut caranya

    [root@hamim-controller ~]#
    [root@hamim-controller ~]# cat /root/keystonerc_admin
    unset OS_SERVICE_TOKEN
        export OS_USERNAME=admin
        export OS_PASSWORD='password'
        export OS_REGION_NAME=RegionOne
        export OS_AUTH_URL=http://10.36.36.10:5000/v3
        export PS1='[\u@\h \W(keystone_admin)]\$ '
    
    export OS_PROJECT_NAME=admin
    export OS_USER_DOMAIN_NAME=Default
    export OS_PROJECT_DOMAIN_NAME=Default
    export OS_IDENTITY_API_VERSION=3
        [root@hamim-controller ~]#
    [root@hamim-controller ~]#

Jika berhasil, akan nampak tampilan default horizon openstack

<figure class="wp-block-image size-large"><img loading="lazy" width="1024" height="433" src="/content/images/wordpress/2020/10/install-openstack03-1024x433.png" alt="" class="wp-image-691" srcset="/content/images/wordpress/2020/10/install-openstack03-1024x433.png 1024w, /content/images/wordpress/2020/10/install-openstack03-300x127.png 300w, /content/images/wordpress/2020/10/install-openstack03-768x325.png 768w, /content/images/wordpress/2020/10/install-openstack03.png 1362w" sizes="(max-width: 1024px) 100vw, 1024px"></figure>

Sekian part akhir untuk instalasi opesntack, jika terdapat pertanyaan dapat di uraikan di kolom komentar ya \*\_\*

Selamat mencoba 😁

Please follow and like us:

[![error](/wp-content/plugins/ultimate-social-media-icons/images/follow_subscribe.png)](https://api.follow.it/widgets/icon/VHc3d1lpVGdwRnE5QnV0eERCNUx5RCtvTTVoUkNYS3NNRmd5eVhlQW9tNXRHS3VTbGh6Y0NybkRJRS8zSGpjRDVZb1ZGMlNTSEpJYUpuZzZqNzdnd3VSN3dwM2VlQTF6ejJEaGV5UGRUbnlEcHFNd3luYTV4ZTZtUGowVWI2Q2x8M2kzdnBEeUIrUk5xOFI5TXZ3cHF3bFNQRkRJSGhUNGdrRFd0TlNtdE1OWT0=/OA==/)

[![fb-share-icon](/wp-content/plugins/ultimate-social-media-icons/images/visit_icons/fbshare_bck.png "Facebook Share")](https://www.facebook.com/sharer/sharer.php?u=https%3A%2F%2Fbelajarlinux.id%2F%3Fp%3D687%26ghostexport%3Dtrue%26submit%3DDownload+Ghost+File)

[![Tweet](/wp-content/plugins/ultimate-social-media-icons/images/visit_icons/en_US_Tweet.svg "Tweet")](https://twitter.com/intent/tweet?text=Openstack%3A+Install+Openstack+Queens+Multi-Node+Part+3+https://belajarlinux.id/?p=687&ghostexport=true&submit=Download Ghost File)

[![fb-share-icon](/wp-content/plugins/ultimate-social-media-icons/images/share_icons/Pinterest_Save/en_US_save.svg "Pin Share")](#)

<!--kg-card-end: html-->
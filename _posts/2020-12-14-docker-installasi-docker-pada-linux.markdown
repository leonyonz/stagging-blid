---
layout: post
title: 'Docker: Cara Instalasi Docker Pada Linux'
featured: true
date: '2020-12-14 15:21:36'
tags:
- docker
- ubuntu
- centos
---

Pada kali ini Belajar Linux ID ingin berbagi tutorial tentang cara Cara Instalasi Docker Pada Linux (Ubuntu, CentOS, Debian).

Apabila kalian belum mengetahui apa itu Docker, maka kalian perlu membaca kembali artikel kami sebelumnya [Docker: Pengenalan Terhadap Docker](/pengenalan-terhadap-docker/).

**Ubuntu/Debian**

Untuk melakukan instalasi pada Ubuntu/Debian, langkah pertama adalah melakukan update paket repository pada server.

<!--kg-card-begin: markdown-->

    $ sudo apt update
    Hit:1 http://archive.ubuntu.com/ubuntu focal InRelease
    Hit:2 http://security.ubuntu.com/ubuntu focal-security InRelease
    Hit:3 http://archive.ubuntu.com/ubuntu focal-updates InRelease
    Hit:4 http://archive.ubuntu.com/ubuntu focal-backports InRelease
    Reading package lists... Done
    Building dependency tree
    Reading state information... Done
    All packages are up to date.

<!--kg-card-end: markdown-->

Selanjutnya adalah melakukan instalasi paket Docker.io, berikut perintahnya:

<!--kg-card-begin: markdown-->

    $ sudo apt install docker.io
    Reading package lists... Done
    Building dependency tree
    Reading state information... Done
    The following additional packages will be installed:
      bridge-utils cgroupfs-mount containerd dns-root-data dnsmasq-base libidn11 pigz runc ubuntu-fan
    Suggested packages:
      ifupdown aufs-tools debootstrap docker-doc rinse zfs-fuse | zfsutils
    The following NEW packages will be installed:
      bridge-utils cgroupfs-mount containerd dns-root-data dnsmasq-base docker.io libidn11 pigz runc ubuntu-fan
    0 upgraded, 10 newly installed, 0 to remove and 0 not upgraded.
    Need to get 69.7 MB of archives.
    After this operation, 334 MB of additional disk space will be used.
    Do you want to continue? [Y/n]

<!--kg-card-end: markdown-->

Apabila sudah berhasil diinstall, maka perlu diaktifkan servicenya terlebih dahulu sebelum dapat digunakan:

<!--kg-card-begin: markdown-->

    $ sudo systemctl enable docker
    Created symlink /etc/systemd/system/multi-user.target.wants/docker.service → /lib/systemd/system/docker.service.

<!--kg-card-end: markdown--><!--kg-card-begin: markdown-->

    $ sudo systemctl start docker

<!--kg-card-end: markdown--><!--kg-card-begin: markdown-->

    $ sudo systemctl status docker
    ● docker.service - Docker Application Container Engine
         Loaded: loaded (/lib/systemd/system/docker.service; enabled; vendor preset: enabled)
         Active: active (running) since Mon 2020-12-14 08:14:42 UTC; 2s ago
    TriggeredBy: ● docker.socket
           Docs: https://docs.docker.com
       Main PID: 2937 (dockerd)
          Tasks: 8
         Memory: 98.1M
         CGroup: /system.slice/docker.service
                 └─2937 /usr/bin/dockerd -H fd:// --containerd=/run/containerd/containerd.sock
    
    Dec 14 08:14:41 ubuntu dockerd[2937]: time="2020-12-14T08:14:41.735966044Z" level=warning msg="Your kernel does not>
    Dec 14 08:14:41 ubuntu dockerd[2937]: time="2020-12-14T08:14:41.736098645Z" level=warning msg="Your kernel does not>
    Dec 14 08:14:41 ubuntu dockerd[2937]: time="2020-12-14T08:14:41.736222773Z" level=warning msg="Your kernel does not>
    Dec 14 08:14:41 ubuntu dockerd[2937]: time="2020-12-14T08:14:41.736687448Z" level=info msg="Loading containers: sta>
    Dec 14 08:14:41 ubuntu dockerd[2937]: time="2020-12-14T08:14:41.911539881Z" level=info msg="Default bridge (docker0>
    Dec 14 08:14:42 ubuntu dockerd[2937]: time="2020-12-14T08:14:42.038669792Z" level=info msg="Loading containers: don>
    Dec 14 08:14:42 ubuntu dockerd[2937]: time="2020-12-14T08:14:42.108968558Z" level=info msg="Docker daemon" commit=a>
    Dec 14 08:14:42 ubuntu dockerd[2937]: time="2020-12-14T08:14:42.110204125Z" level=info msg="Daemon has completed in>
    Dec 14 08:14:42 ubuntu systemd[1]: Started Docker Application Container Engine.
    Dec 14 08:14:42 ubuntu dockerd[2937]: time="2020-12-14T08:14:42.149800907Z" level=info msg="API listen on /run/dock>

<!--kg-card-end: markdown-->

**CentOS**

Untuk melakukan instalasi pada CentOS, langkah pertama adalah melakukan instalasi paket yum-utils terlebih dahulu.

<!--kg-card-begin: html--><script async src="https://pagead2.googlesyndication.com/pagead/js/adsbygoogle.js"></script><ins class="adsbygoogle" style="display:block; text-align:center;" data-ad-layout="in-article" data-ad-format="fluid" data-ad-client="ca-pub-1515372853161377" data-ad-slot="1986938311"></ins><script>
     (adsbygoogle = window.adsbygoogle || []).push({});
</script><!--kg-card-end: html--><!--kg-card-begin: markdown-->

    $ sudo yum install -y yum-utils
    Loaded plugins: fastestmirror
    Loading mirror speeds from cached hostfile
     * base: mirror.papua.go.id
     * extras: mirror.papua.go.id
     * updates: mirror.papua.go.id
    Package yum-utils-1.1.31-54.el7_8.noarch already installed and latest version
    Nothing to do

<!--kg-card-end: markdown-->

Selanjutnya setelah paket yum-utils diinstall, perlu menambahkan repository docker terlebih dahulu:

<!--kg-card-begin: markdown-->

    $ sudo yum-config-manager \
    > --add-repo \
    > https://download.docker.com/linux/centos/docker-ce.repo
    Loaded plugins: fastestmirror
    adding repo from: https://download.docker.com/linux/centos/docker-ce.repo
    grabbing file https://download.docker.com/linux/centos/docker-ce.repo to /etc/yum.repos.d/docker-ce.repo
    repo saved to /etc/yum.repos.d/docker-ce.repo
    
    docker-ce-stable | 3.5 kB 00:00[33/136]
    (1/2): docker-ce-stable/7/x86_64/updateinfo | 55 B 00:00:00
    (2/2): docker-ce-stable/7/x86_64/primary_db | 50 kB 00:00:00
    Resolving Dependencies

<!--kg-card-end: markdown-->

Apabila repo dari Docker telah ditambahkan, maka selanjutnya adalah melakukan instalasi Docker pada server.

<!--kg-card-begin: markdown-->

    $ sudo yum install docker-ce docker-ce-cli containerd.io [90/187]
    Loaded plugins: fastestmirror
    Loading mirror speeds from cached hostfile
     * base: mirror.papua.go.id
     * extras: mirror.papua.go.id
     * updates: mirror.papua.go.id
    docker-ce-stable | 3.5 kB 00:00:00
    (1/2): docker-ce-stable/7/x86_64/updateinfo | 55 B 00:00:00
    (2/2): docker-ce-stable/7/x86_64/primary_db | 50 kB 00:00:00
    Resolving Dependencies

<!--kg-card-end: markdown-->

Apabila sudah berhasil diinstall, maka perlu diaktifkan servicenya terlebih dahulu sebelum dapat digunakan:

    $ sudo systemctl enable docker
    Created symlink /etc/systemd/system/multi-user.target.wants/docker.service → /lib/systemd/system/docker.service.

<!--kg-card-begin: markdown-->

    $ sudo systemctl start docker

<!--kg-card-end: markdown--><!--kg-card-begin: markdown-->

    $ sudo systemctl status docker
    ● docker.service - Docker Application Container Engine
         Loaded: loaded (/lib/systemd/system/docker.service; enabled; vendor preset: enabled)
         Active: active (running) since Mon 2020-12-14 08:14:42 UTC; 2s ago
    TriggeredBy: ● docker.socket
           Docs: https://docs.docker.com
       Main PID: 2937 (dockerd)
          Tasks: 8
         Memory: 98.1M
         CGroup: /system.slice/docker.service
                 └─2937 /usr/bin/dockerd -H fd:// --containerd=/run/containerd/containerd.sock
    
    Dec 14 08:14:41 ubuntu dockerd[2937]: time="2020-12-14T08:14:41.735966044Z" level=warning msg="Your kernel does not>
    Dec 14 08:14:41 ubuntu dockerd[2937]: time="2020-12-14T08:14:41.736098645Z" level=warning msg="Your kernel does not>
    Dec 14 08:14:41 ubuntu dockerd[2937]: time="2020-12-14T08:14:41.736222773Z" level=warning msg="Your kernel does not>
    Dec 14 08:14:41 ubuntu dockerd[2937]: time="2020-12-14T08:14:41.736687448Z" level=info msg="Loading containers: sta>
    Dec 14 08:14:41 ubuntu dockerd[2937]: time="2020-12-14T08:14:41.911539881Z" level=info msg="Default bridge (docker0>
    Dec 14 08:14:42 ubuntu dockerd[2937]: time="2020-12-14T08:14:42.038669792Z" level=info msg="Loading containers: don>
    Dec 14 08:14:42 ubuntu dockerd[2937]: time="2020-12-14T08:14:42.108968558Z" level=info msg="Docker daemon" commit=a>
    Dec 14 08:14:42 ubuntu dockerd[2937]: time="2020-12-14T08:14:42.110204125Z" level=info msg="Daemon has completed in>
    Dec 14 08:14:42 ubuntu systemd[1]: Started Docker Application Container Engine.
    Dec 14 08:14:42 ubuntu dockerd[2937]: time="2020-12-14T08:14:42.149800907Z" level=info msg="API listen on /run/dock>

<!--kg-card-end: markdown-->

**Uji Docker**

Apabila semua langkah diatas sudah dilakukan, maka selanjutnya adalah melakukan uji coba menjalankan container, berikut perintah yang dapat digunakan.

<!--kg-card-begin: markdown-->

    $ sudo docker run hello-world
    Unable to find image 'hello-world:latest' locally
    latest: Pulling from library/hello-world
    0e03bdcc26d7: Pull complete
    Digest: sha256:1a523af650137b8accdaed439c17d684df61ee4d74feac151b5b337bd29e7eec
    Status: Downloaded newer image for hello-world:latest
    
    Hello from Docker!
    This message shows that your installation appears to be working correctly.
    
    To generate this message, Docker took the following steps:
     1. The Docker client contacted the Docker daemon.
     2. The Docker daemon pulled the "hello-world" image from the Docker Hub.
        (amd64)
     3. The Docker daemon created a new container from that image which runs the
        executable that produces the output you are currently reading.
     4. The Docker daemon streamed that output to the Docker client, which sent it
        to your terminal.
    
    To try something more ambitious, you can run an Ubuntu container with:
     $ docker run -it ubuntu bash
    
    Share images, automate workflows, and more with a free Docker ID:
     https://hub.docker.com/
    
    For more examples and ideas, visit:
     https://docs.docker.com/get-started/

<!--kg-card-end: markdown-->

<!--kg-card-begin: html--><script async src="https://pagead2.googlesyndication.com/pagead/js/adsbygoogle.js"></script><ins class="adsbygoogle" style="display:block; text-align:center;" data-ad-layout="in-article" data-ad-format="fluid" data-ad-client="ca-pub-1515372853161377" data-ad-slot="1986938311"></ins><script>
     (adsbygoogle = window.adsbygoogle || []).push({});
</script><!--kg-card-end: html-->
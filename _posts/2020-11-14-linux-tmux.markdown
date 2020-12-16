---
layout: post
title: 'Linux: Cara Menggunakan TMUX'
featured: true
date: '2020-11-14 02:57:06'
tags:
- ubuntu
- centos
- linux
---

[Belajar Linux ID](/) - Pada tutorial sebelumnya kita sudah membahas mengenai [`screen`](/linux-cara-menggunakan-command-screen/) di Linux, sebenar nya `tmux` ini salah satu alternatif dari [`screen`](/linux-cara-menggunakan-command-screen/) dan jika di komparasi [`screen`](/linux-cara-menggunakan-command-screen/) dengan `tmux` tentunya memiliki kelebihan dan kekurangannya masing - masing yang dapat Anda lihat pada link berikut: [`tmux vs. screen`](https://superuser.com/questions/236158/tmux-vs-screen).

`Tmux` adalah terminal multiplexer, sebuah aplikasi atau bisa dibilang sebagai alat tempur sysadmin, sangat cocok digunakan untuk multi tasking di terminal Linux, dengan `tmux` kita dapat membuat, membagi dan memindahkan jendela linux bahkan dapat melakukan sinkronisasi task di dalam terminal Linux.

<!--kg-card-begin: html--><script async src="https://pagead2.googlesyndication.com/pagead/js/adsbygoogle.js"></script><ins class="adsbygoogle" style="display:block; text-align:center;" data-ad-layout="in-article" data-ad-format="fluid" data-ad-client="ca-pub-1515372853161377" data-ad-slot="1986938311"></ins><script>
     (adsbygoogle = window.adsbygoogle || []).push({});
</script><!--kg-card-end: html-->

Untuk menggunakan `tmux` Anda dapat install terlebih dahulu, berikut cara install `tmux` di beberapa distro Linux

<!--kg-card-begin: markdown-->
### Fedora

    $ sudo dnf -y install tmux

### CentOS

    $ sudo yum -y install tmux

### Ubuntu / Debian

    $ sudo apt-get update
    $ sudo apt-get install tmux

### Arch

    $ sudo pacman -S tmux --noconfirm

<!--kg-card-end: markdown-->

Jika sudah melakukan instalasi `tmux`, selanjutnya Anda dapat menggunakan `tmux`, berikut tips dan cara menggunakan `tmux`.

Untuk memulai pertama kali ketikan perintah `tmux` di terminal Linux Anda, dan berikut detail perintah - perintah yang sering digunakan di `tmux`

### Sessions
<!--kg-card-begin: markdown-->

    $ tmux new
    $ tmux new -s session_name 
    
    $ tmux attach # Default session
    $ tmux attach -t session_name
    
    $ tmux switch -t session_name
    
    $ tmux ls # List sessions
    
    $ tmux detach

<!--kg-card-end: markdown-->
#### Windows
<!--kg-card-begin: markdown-->

    $ tmux new-window

<!--kg-card-end: markdown-->
#### Scrolling
<!--kg-card-begin: markdown-->

    C-b [ # Enter scroll mode then press up and down

<!--kg-card-end: markdown-->
#### Copy/paste
<!--kg-card-begin: markdown-->

    C-b [ # 1. Enter scroll mode first.
    Space # 2. Start selecting and move around.
    Enter # 3. Press enter to copy.
    C-b ] # Paste

<!--kg-card-end: markdown-->
### Panes
<!--kg-card-begin: markdown-->

    C-b % # vert
    C-b " # horiz
    C-b hkjl # navigation
    C-b HJKL # resize
    C-b o # next window
    C-b q # show pane numbers
    C-b x # close pane
    
    C-b { or } # move windows around

<!--kg-card-end: markdown-->
### Windows
<!--kg-card-begin: markdown-->

    C-b c # New window
    C-b 1 # Go to window 1
    C-b n # Go to next window
    C-b p # Go to previous window
    C-b w # List all window

<!--kg-card-end: markdown-->
### Detach/attach
<!--kg-card-begin: markdown-->

    C-b d # Detach
    C-b ( ) # Switch through sessions
    $ tmux attach

<!--kg-card-end: markdown-->
#### Synchronize Panes
<!--kg-card-begin: markdown-->

    : setw synchronize-panes on

<!--kg-card-end: markdown--><!--kg-card-begin: html--><script async src="https://pagead2.googlesyndication.com/pagead/js/adsbygoogle.js"></script><ins class="adsbygoogle" style="display:block; text-align:center;" data-ad-layout="in-article" data-ad-format="fluid" data-ad-client="ca-pub-1515372853161377" data-ad-slot="1986938311"></ins><script>
     (adsbygoogle = window.adsbygoogle || []).push({});
</script><!--kg-card-end: html-->
#### Enable Mouse
<!--kg-card-begin: markdown-->

    : set -g mouse on

<!--kg-card-end: markdown-->

Itulah beberapa perintah atau command yang sering digunakan di `tmux` Anda dapat eskplorasi secara mandiri terkait `tmux` jika membutuhkan cheat sheet `tmux` Anda dapat merujuk pada link berikut: **[Tmux Cheat Sheet](https://tmuxcheatsheet.com/)**

Selamat mencoba 😁

<!--kg-card-begin: html--><script async src="https://pagead2.googlesyndication.com/pagead/js/adsbygoogle.js"></script><ins class="adsbygoogle" style="display:block; text-align:center;" data-ad-layout="in-article" data-ad-format="fluid" data-ad-client="ca-pub-1515372853161377" data-ad-slot="1986938311"></ins><script>
     (adsbygoogle = window.adsbygoogle || []).push({});
</script><!--kg-card-end: html-->
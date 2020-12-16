---
layout: post
title: Implementasi Cache Proxy Nginx pada WordPress di CentOS 8
featured: true
date: '2020-08-27 23:25:19'
tags:
- centos
- cms
- nginx
---

Pada tutorial kali ini kami akan memberikan cara bagaimana mempercepat website WordPress Anda dengan menggunakan proxy cache Nginx.

Untuk mengikuti tutorial ini pastikan Anda sudah instalasi WordPress disini kami juga sudah memasang SSL untuk WordPress atau Anda dapat mengikuti referensi berikut:

- _**[Cara Instalasi WordPress menggunakan Nginx di CentOS 8](/cara-instalasi-wordpress-menggunakan-nginx-di-centos-8/)**_
- _**[Cara Instalasi SSL Letsencrypt pada WordPress Menggunakan Nginx di CentOS 8](/cara-instalasi-ssl-letsencrypt-pada-wordpress-menggunakan-nginx-di-centos-8/)**_

Pertama silakan instalasi plugin di WordPress Anda pada menu _Plugins \>\> Add New_

<figure class="wp-block-image size-large"><img loading="lazy" width="1024" height="522" src="/content/images/wordpress/2020/08/1-5-1024x522.png" alt="" class="wp-image-355" srcset="/content/images/wordpress/2020/08/1-5-1024x522.png 1024w, /content/images/wordpress/2020/08/1-5-300x153.png 300w, /content/images/wordpress/2020/08/1-5-768x392.png 768w, /content/images/wordpress/2020/08/1-5.png 1031w" sizes="(max-width: 1024px) 100vw, 1024px"></figure>

Install dan aktivasi plugin Nginx Helper

<figure class="wp-block-image size-large"><img loading="lazy" width="1020" height="497" src="/content/images/wordpress/2020/08/2-5.png" alt="" class="wp-image-356" srcset="/content/images/wordpress/2020/08/2-5.png 1020w, /content/images/wordpress/2020/08/2-5-300x146.png 300w, /content/images/wordpress/2020/08/2-5-768x374.png 768w" sizes="(max-width: 1020px) 100vw, 1020px"></figure>

Klik setting pada plugin Nginx Helper

<figure class="wp-block-image size-large"><img loading="lazy" width="1018" height="496" src="/content/images/wordpress/2020/08/3-4.png" alt="" class="wp-image-357" srcset="/content/images/wordpress/2020/08/3-4.png 1018w, /content/images/wordpress/2020/08/3-4-300x146.png 300w, /content/images/wordpress/2020/08/3-4-768x374.png 768w" sizes="(max-width: 1018px) 100vw, 1018px"></figure>

Konfigurasi plugin seperti berikut

<figure class="wp-block-image size-large"><img loading="lazy" width="698" height="716" src="/content/images/wordpress/2020/08/4-5.png" alt="" class="wp-image-358" srcset="/content/images/wordpress/2020/08/4-5.png 698w, /content/images/wordpress/2020/08/4-5-292x300.png 292w" sizes="(max-width: 698px) 100vw, 698px"></figure>

Selanjutnya membuat file caching di nginx

    [root@tutorial ~]#
    [root@tutorial ~]# vim /etc/nginx/conf.d/caching.conf

isi file caching seperti berikut

    # Caching
    fastcgi_cache_path /var/run/nginx-cache levels=1:2 keys_zone=WORDPRESS:100m inactive=60m;
    fastcgi_cache_key "$scheme$request_method$host$request_uri";

Selanjutnya mengubah konfigurasi server block WordPress

    [root@tutorial ~]#
    [root@tutorial ~]# vim /etc/nginx/conf.d/wordpress.conf

Berikut full konfigurasi server block isi dari konfigurasi ini sudah termasuk tuning dari segi konfigurasi nginx

    server {
            listen 80;
            listen 443 ssl http2;
            server_name wordpress.nurhamim.my.id;
            root /usr/share/nginx/wordpress;
    
            index index.php index.html index.htm;
    
            ssl_certificate /etc/letsencrypt/live/wordpress.nurhamim.my.id/fullchain.pem;
            ssl_certificate_key /etc/letsencrypt/live/wordpress.nurhamim.my.id/privkey.pem;
            ssl_trusted_certificate /etc/letsencrypt/live/wordpress.nurhamim.my.id/chain.pem;
            include snippets/ssl.conf;
            include snippets/letsencrypt.conf;
    
            gzip on;
            gzip_comp_level 5;
            gzip_min_length 256;
            gzip_proxied any;
            gzip_vary on;
            gzip_types
                    application/atom+xml
                    application/javascript
                    application/json
                    application/ld+json
                    application/manifest+json
                    application/rss+xml
                    application/vnd.geo+json
                    application/vnd.ms-fontobject
                    application/x-font-ttf
                    application/x-web-app-manifest+json
                    application/xhtml+xml
                    application/xml
                    font/opentype
                    image/bmp
                    image/svg+xml
                    image/x-icon
                    text/cache-manifest
                    text/css
                    text/plain
                    text/vcard
                    text/vnd.rim.location.xloc
                    text/vtt
                    text/x-component
                    text/x-cross-domain-policy;
    
    
            location / {
                    try_files $uri $uri/ /index.php?$query_string;
            }
    
            # Restrictions
            # Disable logging for favicon and robots.txt
            location = /favicon.ico {
                    log_not_found off;
                    access_log off;
            }
    
            location = /robots.txt {
                    allow all;
                    log_not_found off;
                    access_log off;
                    try_files $uri /index.php?$args;
            }
    
            # Deny all attempts to access hidden files such as .htaccess, .htpasswd, .DS_Store (Mac).
            # Keep logging the requests to parse later (or to pass to firewall utilities such as fail2ban)
            location ~ /\. {
                    deny all;
            }
    
            # Deny access to any files with a .php extension in the uploads directory
            # Works in sub-directory installs and also in multisite network
            # Keep logging the requests to parse later (or to pass to firewall utilities such as fail2ban)
            location ~* /(?:uploads|files)/.*\.php$ {
                    deny all;
            }
            # End Restrictions
    
            # Caching
            set $skip_cache 0;
    
            # POST requests and urls with a query string should always go to PHP
            if ($request_method = POST) {
            set $no_cache 1;
            }
            if ($query_string != "") {
            set $skip_cache 1;
            }
    
            # Don't cache uris containing the following segments
            if ($request_uri ~* "(/wp-admin/|/xmlrpc.php|/wp-(app|cron|login|register|mail).php|wp-.*.php|/feed/|index.php|wp-comments-popup.php|wp-links-opml.php|wp-locations.php|sitemap(_index)?.xml|[a-z0-9_-]+-sitemap([0-9]+)?.xml)") {
            set $skip_cache 1;
            }
    
            # Don't use the cache for logged in users or recent commenters
            if ($http_cookie ~* "comment_author|wordpress_[a-f0-9]+|wp-postpass|wordpress_no_cache|wordpress_logged_in") {
            set $skip_cache 1;
            }
            #end Caching
    
            ## WordPress single site rules.
            #location / {
            # try_files $uri $uri/ /index.php?$args;
            #}
    
            # Add trailing slash to */wp-admin requests.
            rewrite /wp-admin$ $scheme://$host$uri/ permanent;
    
            # Directives to send expires headers and turn off 404 error logging.
            location ~* ^.+\.(eot|otf|woff|woff2|ttf|rss|atom|zip|tgz|gz|rar|bz2|doc|xls|exe|ppt|tar|mid|midi|wav|bmp|rtf)$ {
                    access_log off; log_not_found off; expires max;
            }
    
            #Media: images, icons, video, audio send expires headers.
            location ~* \.(?:jpg|jpeg|gif|png|ico|cur|gz|svg|svgz|mp4|ogg|ogv|webm)$ {
                    expires 1M;
                    access_log off;
                    add_header Cache-Control "public";
            }
    
            # CSS and Javascript send expires headers.
            location ~* \.(?:css|js)$ {
                    expires 1y;
                    access_log off;
                    add_header Cache-Control "public";
            }
    
            # HTML send expires headers.
            location ~* \.(html)$ {
                    expires 7d;
                    access_log off;
                    add_header Cache-Control "public";
            }
    
            # Browser caching of static assets.
            location ~* \.(jpg|jpeg|png|gif|ico|css|js|pdf)$ {
                    expires 7d;
                    add_header Cache-Control "public, no-transform";
            }
    
            location ~ \.php {
                    include fastcgi.conf;
                    fastcgi_split_path_info ^(.+\.php)(/.+)$;
                    fastcgi_pass unix:/run/php-fpm/www.sock;
                    # enable cache
                    add_header X-WP-Cache $upstream_cache_status;
                    fastcgi_cache_bypass $skip_cache;
                    fastcgi_no_cache $skip_cache;
                    fastcgi_cache WORDPRESS;
                    fastcgi_cache_valid 200 60m;
            }
    
            location ~ /\.ht {
                    deny all;
            }
    }

Pastikan tidak ada konfigurasi yang salah di sisi server block nginx

    [root@tutorial ~]#
    [root@tutorial ~]# nginx -t
    nginx: the configuration file /etc/nginx/nginx.conf syntax is ok
    nginx: configuration file /etc/nginx/nginx.conf test is successful
    [root@tutorial ~]#

Selanjutnya reload Nginx

    [root@tutorial ~]# nginx -s reload
    [root@tutorial ~]#

Jika sudah silakan di curl jika hasilnya seperti berikut menandakan cache WordPress sudah berjalan dengan normal

<figure class="wp-block-image size-large"><img loading="lazy" width="816" height="505" src="/content/images/wordpress/2020/08/5-4.png" alt="" class="wp-image-359" srcset="/content/images/wordpress/2020/08/5-4.png 816w, /content/images/wordpress/2020/08/5-4-300x186.png 300w, /content/images/wordpress/2020/08/5-4-768x475.png 768w" sizes="(max-width: 816px) 100vw, 816px"></figure>

Selamat mencoba 😁

Please follow and like us:

[![error](/wp-content/plugins/ultimate-social-media-icons/images/follow_subscribe.png)](https://api.follow.it/widgets/icon/VHc3d1lpVGdwRnE5QnV0eERCNUx5RCtvTTVoUkNYS3NNRmd5eVhlQW9tNXRHS3VTbGh6Y0NybkRJRS8zSGpjRDVZb1ZGMlNTSEpJYUpuZzZqNzdnd3VSN3dwM2VlQTF6ejJEaGV5UGRUbnlEcHFNd3luYTV4ZTZtUGowVWI2Q2x8M2kzdnBEeUIrUk5xOFI5TXZ3cHF3bFNQRkRJSGhUNGdrRFd0TlNtdE1OWT0=/OA==/)

[![fb-share-icon](/wp-content/plugins/ultimate-social-media-icons/images/visit_icons/fbshare_bck.png "Facebook Share")](https://www.facebook.com/sharer/sharer.php?u=https%3A%2F%2Fbelajarlinux.id%2F%3Fp%3D354%26ghostexport%3Dtrue%26submit%3DDownload+Ghost+File)

[![Tweet](/wp-content/plugins/ultimate-social-media-icons/images/visit_icons/en_US_Tweet.svg "Tweet")](https://twitter.com/intent/tweet?text=Implementasi+Cache+Proxy+Nginx+pada+WordPress+di+CentOS+8+https://belajarlinux.id/?p=354&ghostexport=true&submit=Download Ghost File)

[![fb-share-icon](/wp-content/plugins/ultimate-social-media-icons/images/share_icons/Pinterest_Save/en_US_save.svg "Pin Share")](#)

<!--kg-card-end: html-->
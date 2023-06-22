---
author: haracane
layout: post
title: ngx_small_lightをMacで使ってみた
date: 2015-01-07 08:08:19J
tags:
- Nginx
keywords: Nginx
description: 画像のリサイズ等を動的に行ってくれるngx_small_lightをMacのNginxに組み込んでみたのでそのメモです。
---
<!-- tag_links -->
[Nginx](/tags/nginx/)

<!-- content -->
## ngx_small_lightでやりたいこと

[ngx_small_light](https://github.com/cubicdaiya/ngx_small_light)を使うと<http://localhost:8000/images/100x100/sample.png>というURLからsample.pngを100x100にリサイズした画像を取得できるようになったりします。

## ImageMagick, PCREをインストールする

ngx_small_lightに必要なライブラリをインストールします。

    $ brew install imagemagick pcre

## ngx_small_lightをセットアップする

Nginxのビルド前に`setup`を実行してngx_small_lightの`config`ファイルを作成します。

    $ cd ~/src
    $ git clone git@github.com:cubicdaiya/ngx_small_light
    $ cd ngx_small_light
    $ ./setup

## Nginxをビルドする

まずNginxをダウンロード＆解凍します。

    $ cd ~/src
    $ curl -O http://nginx.org/download/nginx-1.6.2.tar.gz
    $ tar zxvf nginx-1.6.2.tar.gz
    $ cd nginx-1.6.2

続いて`--add-module`オプションでngx_small_lightのディレクトリを指定して`configure`を実行します。

    $ ./configure --with-http_ssl_module \
                  --with-pcre \
                  --with-ipv6 \
                  --with-cc-opt="-I`brew --prefix pcre`/include -I`brew --prefix openssl`/include" \
                  --with-ld-opt="-L/usr/local/lib -L`brew --prefix pcre`/lib -L`brew --prefix openssl`/lib" \
                  --conf-path=/usr/local/etc/nginx/nginx.conf \
                  --pid-path=/usr/local/var/run/nginx.pid \
                  --lock-path=/usr/local/var/run/nginx.lock \
                  --http-client-body-temp-path=/usr/local/var/run/nginx/client_body_temp \
                  --http-proxy-temp-path=/usr/local/var/run/nginx/proxy_temp \
                  --http-fastcgi-temp-path=/usr/local/var/run/nginx/fastcgi_temp \
                  --http-uwsgi-temp-path=/usr/local/var/run/nginx/uwsgi_temp \
                  --http-scgi-temp-path=/usr/local/var/run/nginx/scgi_temp \
                  --http-log-path=/usr/local/var/log/nginx/access.log \
                  --error-log-path=/usr/local/var/log/nginx/error.log \
                  --with-http_gzip_static_module \
                  --with-http_realip_module \
                  --with-http_stub_status_module \
                  --add-module=`cd ../ngx_small_light;pwd`

ちなみに、他のオプションは`brew install nginx`でインストールしたNginxの`nginx -V`実行結果を参考にしています。

あとは`make` & `sudo make install`でインストール完了です。

    $ make
    $ sudo make install

## Nginxの設定をする

Nginxをインストールしたらngx_small_lightを使うための設定ファイルを作成します。

    #/usr/local/etc/nginx/sites-enabled/small-light.conf
    server {
      listen 8000;
      server_name 127.0.0.1;

      small_light on;

      location ~ "^((?:/[^/]+)+)/([0-9]+)x([0-9]+)/([^/]+)$" {
        proxy_pass $scheme://127.0.0.1:8000/small_light(dw=$2,dh=$3,cw=$2,ch=$3,cc=ffffff)/$1/original/$4;
      }

      location ~ ^/small_light[^/]*/(.+)$ {
        set $file $1;
        rewrite ^ /$file;
      }
    }

## 動作確認をする

設定が済んだらNginxを起動します。

    $ /usr/local/nginx/sbin/nginx

<http://localhost:8000/images/original/sample.png>に画像があれば、<http://localhost:8000/images/100x100/sample.png>にアクセスするとリサイズされた画像が表示されるはずです。

## 参考リンク

もっと色々な設定をしたい場合は下記のドキュメントが参考になると思います。

[カンタン画像サムネイル作成「Smalllight」](www.slideshare.net/livedoor/smalllight2)
: Smalllightの使い方を説明したスライドです。

[ngx_small_light設定ガイド](https://github.com/cubicdaiya/ngx_small_light/wiki/Configuration)
: Nginxの設定等についてのドキュメントです。

[SmalllightのPatternString](https://code.google.com/p/smalllight/wiki/PatternString)
: 各パラメタの説明ドキュメントです。

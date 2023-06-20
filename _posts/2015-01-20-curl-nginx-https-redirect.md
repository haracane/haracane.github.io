---
layout: post
title: curlコマンドでNginxのX-Forwarded-ProtoでのHTTPSリダイレクトのテストをする
date: 2015-01-20 07:40:40J
tags: Nginx
keywords: Nginx
description: NginxでX-Forwarded-Protoの値を見てhttpsだったらhttpにリダイレクトする設定をしてcurlコマンドでテストしてみました。
---
[Nginx](/tags/nginx/)

SSLの処理は前段のロードバランサで行っていて、Nginxではhttpサーバとして動いている場合の例です。

## Nginxのlocationディレクティブ設定

ヘッダで`X-Forwarded-Proto: https`が設定されていたらhttpにリダイレクトします。

    location ^~ /content/ {
      if ($http_x_forwarded_proto = "https") {
        return 301 http://$host$request_uri;
      }
    }

## curlコマンドでテスト

ヘッダに`X-Forwarded-Proto: https`を指定してHEADリクエストを送って301リダイレクトされることを確認します。

    $ curl --header 'X-Forwarded-Proto: https' --head https://localhost/content/
    HTTP/1.1 301 Moved Permanently
    Server: nginx/1.7.9
    Date: Tue, 19 Jan 2015 03:38:19 GMT
    Content-Type: text/html
    Content-Length: 184
    Connection: keep-alive
    Location: http://localhost/content/

httpの場合は200 OKになることも確認します。

    $ curl --header 'X-Forwarded-Proto: http' --head http://localhost:9000/content/
    HTTP/1.1 200 OK
    Server: nginx/1.7.9
    Date: Tue, 19 Jan 2015 03:43:31 GMT
    Content-Type: text/html; charset=UTF-8
    Connection: keep-alive

## ifディレクティブには注意

[nginxのifに要注意](http://www.techscore.com/blog/2012/10/31/nginx%E3%81%AEif%E3%81%AB%E8%A6%81%E6%B3%A8%E6%84%8F/)に書いてある通り、Nginxでifディレクティブを使う場合は気をつける必要があります。

ただし、[Nginx Communityの記事](http://wiki.nginx.org/IfIsEvil)にも`return ...;`か`rewrite ... last;`を使う場合はOKと書いてあったので今回はifディレクティブで設定しました。

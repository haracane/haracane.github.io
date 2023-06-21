---
author: haracane
layout: post
title: Nginx+RailsをProduction環境で動かす
date: 2014-09-22 10:14:59J
tags:
- Nginx
- Ruby
- Rails
keywords: Nginx,Ruby,Rails
description: Nginx+RailsをProduction環境で動かす。
image: rails.png
---
[Nginx](/tags/nginx/) / [Ruby](/tags/ruby/) / [Rails](/tags/rails/)

Nginxでサーバ設定。

{% raw %}
<pre><code>server {
  listen 80;
  server_name localhost;
  root /path/to/project/public;

  location / {
    if ( -f $request_filename ) { break; }
    proxy_set_header X-Real-IP  $remote_addr;
    proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    proxy_set_header Host $http_host;
    proxy_pass http://localhost:8080;
  }

  location ~* \.(ico|css|js|gif|jpe?g|png|woff|ttf|svg)(\?[0-9]+)?$ {
    expires 1y;
  }
}
</code></pre>
{% endraw %}

RailsをProduction環境で起動

    $ rails s -e production -p 8080

http://localhost/ から確認できます。

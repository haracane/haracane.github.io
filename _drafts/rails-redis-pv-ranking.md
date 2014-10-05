---
layout: post
title:  Rails＋RedisでPVの多い順に記事ランキングする
date: 2014-10-02 18:41:50J
tags: Redis Rails Ruby
keywords: Redis Rails Ruby
description: キャッシュバック賃貸の「住まいの調査隊」リリースのお知らせ時にRedisの利用事例を簡単にご紹介しましたが、こちらの記事ではその詳細をまとめておきます。
---

{{ page.description }}

PV順のランキングを取得するにはRedisのソート済みセットを利用します。

以下では

まず、[redis-rb](https://github.com/redis/redis-rb)をインストールしておきましょう。

### Redisオブジェクトの初期化

Railsなので初期化はinitializerで行います。

{% highlight ruby %}
REDIS = Redis.new(host: "localhost", port: 6379)
{% endhighlight %}

### PV数のカウント

PV数の

{% highlight ruby %}
{% endhighlight %}

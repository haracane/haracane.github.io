---
layout: post
title:  キャッシュバック賃貸の新サービス「住まいの調査隊」でのRails＆Redis活用
date: 2014-10-02 07:11:10J
tags: Redis Rails Ruby
keywords: Redis Rails Ruby
description: 10/1にキャッシュバック賃貸から、住まいに関するアンケート調査結果を発信する「住まいの調査隊」をリリースしました。「住まいの調査隊」ではRails+Redisで人気記事ランキングを行っているので、その事例を簡単にご紹介します。
---

10/1に[キャッシュバック賃貸](http://cbchintai.com/)から、住まいに関するアンケート調査結果を発信する「[住まいの調査隊](http://cbchintai.com/research/)」をリリースしました。

「住まいの調査隊」ではRails+Redisで人気記事ランキングを行っているので、その事例を簡単にご紹介します。

## 住まいの調査隊とは

テーマ毎にアンケート調査を実施し、その結果をまとめた記事を発信するサービスです。

「お部屋選びで後悔したことは？」、「一生賃貸派？持家購入派？」といった引っ越し・住まいに関するユーザ目線の記事を読むことができます。

第一弾の記事では「[あなたが絶対に譲れない賃貸住宅の条件は？](http://cbchintai.com/research/reports/2/)」がテーマとなっていて、「通勤・通学にかかる時間」が1位となっています。

## Redisの活用：ソート済みセット

「住まいの調査隊」では右サイドバーに人気記事を表示しているのですが、ここでRedisのソート済みセットを利用しています。

Redisにはkeyに対して複数のmemberとscoreを登録できるソート済みリストという機能があり、こちらを利用するとランキングを簡単に取得できます。

まず、RubyからRedisを利用するには[redis-rb](https://github.com/redis/redis-rb)をインストールします。

### PV数のカウント

redis-rbを使って記事のPVをカウントするには`zincrby`メソッドを使います。

{% highlight ruby %}
redis = Redis.new(host: "localhost", port: 6379)
redis.zincrby("article_pv_counts", 1, article.id)
{% endhighlight %}

### PVランキングの取得

ランキングの取得には`zrevrange`メソッドを使います。

{% highlight ruby %}
popular_article_ids = redis.zrevrange("article_pv_counts", 0, 9)
{% endhighlight %}

とするとPV数のトップ10ランキングを取得できます。

あとはこのidを使ってデータベースから記事データを取得すればOKです。

## まとめ

「[住まいの調査隊](http://cbchintai.com/research/)」ではこちらで紹介したRedisでの人気記事ランキング以外に、おすすめ記事やカテゴリからも記事を探せるようになっています。

読んでみて面白いと思った記事があったら、「いいね」やRTなどをお願いします。

なお、[アンケート調査依頼も受け付けています](http://cbchintai.com/research/requests/new/)ので、気になるテーマがあったら気軽にご応募ください。

以上、リリースのご報告とRedis活用事例のご紹介でした。

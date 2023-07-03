---
author: haracane
layout: post
title: つぶやきを追え ～『爆発するソーシャルメディア』との戦い～ (前編)
description: 前回の記事でOKWaveさんのHBase事例のご紹介をしましたが、このイベントでは最後のセッションで僕もTwitter分析の事例を発表させていただいたので今日はそちらをご紹介します。
tags:
- Hadoop
- RabbitMQ
date: '2012-12-22 21:00:00+0900'
---
<!-- tag_links -->
[Hadoop](/tags/hadoop/) / [RabbitMQ](/tags/rabbitmq/)

<!-- content -->
[前回の記事](http://hatacomp.hateblo.jp/entry/dont-stop-hbase)でOKWaveさんのHBase事例のご紹介をしましたが、[このイベント](http://oss.nttdata.co.jp/hadoop/event/201212/)では最後のセッションで僕もTwitter分析の事例を発表させていただいたので今日はそちらをご紹介します。

発表タイトルは「Hadoop&RabbitMQを利用したTwitter全量リアルタイム解析」。

タイトルそのままにTwitter全量データをリアルタイムに解析するシステムの紹介です。

## 1. 自己紹介

まずは自己紹介から。
Hadoop等を使ってソーシャルメディア分析をしています。

![スライド](https://lh3.googleusercontent.com/-Fl28qPmhozA/UNUuQp9bGMI/AAAAAAAAAPU/Geswlp5a_zs/slide-01.png)

## 2. BuzzFinderとは

次にクチコミ分析サービスBuzzFinderの概要をご紹介。
この発表との関連では「Twitter全量」と「リアルタイム」がポイントです。

![スライド](https://lh4.googleusercontent.com/-akpPRO0biuc/UNUuRr1sgbI/AAAAAAAAAPc/Ptwd-Q0LQEQ/slide-04.png)

詳しくは[NTTコム オンライン・マーケティング・ソリューションのBuzzFinder紹介ページ](http://www.nttcoms.com/service/buzzfinder.html)が参考になります。

## 3. Twitterデータの特徴

## 3.1. ツイート量の傾向

1日の中のTwitterデータ量の変動パターン。結構変動が大きいです。

![スライド](https://lh5.googleusercontent.com/--lzREdJymqs/UNUuSNVH5qI/AAAAAAAAAPg/aVzCGIs5K98/slide-06.png)

## 3.2. ツイートの増加量

発表の中では紹介しませんでしたが、Twitter公式ブログでは[2010年2月までのツイート増加量のグラフ](http://blog.twitter.com/2010/02/measuring-tweets.html)が発表されています。

[http://blog.twitter.com/2010/02/measuring-tweets.html:image:large]

また、[2012年3月21日時点ではツイート量が3.4億ツイート/日に達している](http://blog.twitter.com/2012/03/twitter-turns-six.html)ようです。

## 3.3. Twitterデータからわかる情報

ツイート量の次は[Twitter Streaming API](https://dev.twitter.com/docs/streaming-apis)から取得できるデータ。
Twitter APIから提供されるデータはJSON形式となっていて、ツイート本文以外にユーザの自己紹介文なども取得することができます。

![スライド](https://lh3.googleusercontent.com/-KGTOyFsLWE4/UNUuSozLDuI/AAAAAAAAAPw/04Q4bBj2Vyk/slide-07.png)

## 4. Twitterデータの日本語解析

ツイート本文とユーザの自己紹介文＆場所を分析しています。
日本語解析にはNTT研究所の「リッチインデクシング技術」を利用しています。

![スライド](https://lh4.googleusercontent.com/-4QrwPKlaN80/UNUuTLf2NII/AAAAAAAAAP8/LV5X81TpfH0/slide-09.png)

リッチインデクシング技術については菊井玄一郎さん、松尾義博さんのNTT技術ジャーナル[「テキストからの知識抽出による新しいWeb情報アクセスに向けて」](http://www.ntt.co.jp/journal/0806/files/jn200806008.pdf)が参考になります。

## 4.1. ツイート本文の日本語解析

ツイート本文の日本語解析はキーワード/関連語/ポジティブ・ネガティブ抽出をしています。

![スライド](https://lh5.googleusercontent.com/-MycJxEOmrbA/UNUuTaeyDVI/AAAAAAAAAQY/R8JZLL2DICU/slide-10.png)

## 4.2. 自己紹介文・場所の日本語解析

自己紹介文と場所情報からは年齢/性別/職業/都道府県の抽出をしています。

![スライド](https://lh3.googleusercontent.com/-AwqG3ynWeF0/UNUuTiUnDRI/AAAAAAAAAQI/lFQ7clyGQas/slide-11.png)

## といったところで

長くなってきたので今日はここまで。
次回はBuzzFinderでのTwitterデータ処理フローをご紹介します。

## バックナンバー

- つぶやきを追え ～『爆発するソーシャルメディア』との戦い (前編)
- [つぶやきを追え ～『爆発するソーシャルメディア』との戦い (中編)](/2012/12/23/fight-against-socialmedia-2)
- [つぶやきを追え ～『爆発するソーシャルメディア』との戦い (後編)](/2012/12/31/fight-against-socialmedia-3)

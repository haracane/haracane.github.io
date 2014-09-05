---
layout: post
title:  "つぶやきを追え ～『爆発するソーシャルメディア』との戦い～ (前編)"
description: "前回の記事でOKWaveさんのHBase事例のご紹介をしましたが、このイベントでは最後のセッションで僕もTwitter分析の事例を発表させていただいたので今日はそちらをご紹介します。"
tags: Hadoop RabbitMQ
date:   2013-02-16 21:00:00J
---

[http://hatacomp.hateblo.jp/entry/dont-stop-hbase:title=前回の記事]でOKWaveさんのHBase事例のご紹介をしましたが、[http://oss.nttdata.co.jp/hadoop/event/201212/:title=このイベント]では最後のセッションで僕もTwitter分析の事例を発表させていただいたので今日はそちらをご紹介します。

発表タイトルは「Hadoop&RabbitMQを利用したTwitter全量リアルタイム解析」。

タイトルそのままにTwitter全量データをリアルタイムに解析するシステムの紹介です。

* 1. 自己紹介

まずは自己紹介から。
Hadoop等を使ってソーシャルメディア分析をしています。

<span itemtype="http://schema.org/Photograph" itemscope="itemscope"><img class="magnifiable" src="https://lh3.googleusercontent.com/-Fl28qPmhozA/UNUuQp9bGMI/AAAAAAAAAPU/Geswlp5a_zs/slide-01.png" itemprop="image"></span>

* 2. BuzzFinderとは

次にクチコミ分析サービスBuzzFinderの概要をご紹介。
この発表との関連では「Twitter全量」と「リアルタイム」がポイントです。

<span itemtype="http://schema.org/Photograph" itemscope="itemscope"><img class="magnifiable" src="https://lh4.googleusercontent.com/-akpPRO0biuc/UNUuRr1sgbI/AAAAAAAAAPc/Ptwd-Q0LQEQ/slide-04.png" itemprop="image"></span>

詳しくは[http://www.nttcoms.com/service/buzzfinder.html:title=NTTコム オンライン・マーケティング・ソリューションのBuzzFinder紹介ページ]が参考になります。

* 3. Twitterデータの特徴

** 3.1. ツイート量の傾向

1日の中のTwitterデータ量の変動パターン。結構変動が大きいです。

<span itemtype="http://schema.org/Photograph" itemscope="itemscope"><img class="magnifiable" src="https://lh5.googleusercontent.com/--lzREdJymqs/UNUuSNVH5qI/AAAAAAAAAPg/aVzCGIs5K98/slide-06.png" itemprop="image"></span>

** 3.2. ツイートの増加量

発表の中では紹介しませんでしたが、Twitter公式ブログでは[http://blog.twitter.com/2010/02/measuring-tweets.html:title=2010年2月までのツイート増加量のグラフ]が発表されています。

[http://blog.twitter.com/2010/02/measuring-tweets.html:image:large]

また、[http://blog.twitter.com/2012/03/twitter-turns-six.html:title=2012年3月21日時点ではツイート量が3.4億ツイート/日に達している]ようです。

** 3.3. Twitterデータからわかる情報

ツイート量の次は[https://dev.twitter.com/docs/streaming-apis:title=Twitter Streaming API]から取得できるデータ。
Twitter APIから提供されるデータはJSON形式となっていて、ツイート本文以外にユーザの自己紹介文なども取得することができます。

<span itemtype="http://schema.org/Photograph" itemscope="itemscope"><img class="magnifiable" src="https://lh3.googleusercontent.com/-KGTOyFsLWE4/UNUuSozLDuI/AAAAAAAAAPw/04Q4bBj2Vyk/slide-07.png" itemprop="image"></span>

* 4. Twitterデータの日本語解析

ツイート本文とユーザの自己紹介文＆場所を分析しています。
日本語解析にはNTT研究所の「リッチインデクシング技術」を利用しています。

<span itemtype="http://schema.org/Photograph" itemscope="itemscope"><img class="magnifiable" src="https://lh4.googleusercontent.com/-4QrwPKlaN80/UNUuTLf2NII/AAAAAAAAAP8/LV5X81TpfH0/slide-09.png" itemprop="image"></span>

リッチインデクシング技術については菊井玄一郎さん、松尾義博さんのNTT技術ジャーナル[http://www.ntt.co.jp/journal/0806/files/jn200806008.pdf:title=「テキストからの知識抽出による新しいWeb情報アクセスに向けて」]が参考になります。

** 4.1. ツイート本文の日本語解析

ツイート本文の日本語解析はキーワード/関連語/ポジティブ・ネガティブ抽出をしています。

<span itemtype="http://schema.org/Photograph" itemscope="itemscope"><img class="magnifiable" src="https://lh5.googleusercontent.com/-MycJxEOmrbA/UNUuTaeyDVI/AAAAAAAAAQY/R8JZLL2DICU/slide-10.png" itemprop="image"></span>

** 4.2. 自己紹介文・場所の日本語解析

自己紹介文と場所情報からは年齢/性別/職業/都道府県の抽出をしています。

<span itemtype="http://schema.org/Photograph" itemscope="itemscope"><img class="magnifiable" src="https://lh3.googleusercontent.com/-AwqG3ynWeF0/UNUuTiUnDRI/AAAAAAAAAQI/lFQ7clyGQas/slide-11.png" itemprop="image"></span>

* といったところで

長くなってきたので今日はここまで。
次回はBuzzFinderでのTwitterデータ処理フローをご紹介します。

* バックナンバー

- つぶやきを追え ～『爆発するソーシャルメディア』との戦い (前編)
- [http://hatacomp.hateblo.jp/entry/fight-against-socialmedia-2:title=つぶやきを追え ～『爆発するソーシャルメディア』との戦い (中編)]
- [http://hatacomp.hateblo.jp/entry/fight-against-socialmedia-3:title=つぶやきを追え ～『爆発するソーシャルメディア』との戦い (後編)]

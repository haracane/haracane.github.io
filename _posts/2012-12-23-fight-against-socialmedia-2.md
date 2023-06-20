---
layout: post
title:  "つぶやきを追え ～『爆発するソーシャルメディア』との戦い～ (中編)"
description: "前回に引き続き『Hadoop&RabbitMQを利用したTwitter全量リアルタイム解析』(2012/12/10 Hadoopエンタープライズソリューションセミナー)の発表内容をご紹介します。"
tags: Hadoop RabbitMQ Cassandra
date:   2012-12-23 21:00:00J
---
[Hadoop](/tags/hadoop/) / [RabbitMQ](/tags/rabbitmq/) / [Cassandra](/tags/cassandra/)

[前回](http://hatacomp.hateblo.jp/entry/fight-against-socialmedia-1)に引き続き『Hadoop&RabbitMQを利用したTwitter全量リアルタイム解析』(2012/12/10 Hadoopエンタープライズソリューションセミナー)の発表内容をご紹介します。

前回の内容は
- BuzzFinderとは
- Twitterデータのデータ量と情報内容
- BuzzFinderでの日本語解析処理
でしたが、今回はメインテーマである大規模データ処理フローです。

## 5. BuzzFinderでのTwitterデータ処理フロー

まずはバーン！と全体フロー。
![全体フロー](https://lh5.googleusercontent.com/-dvQus-6e1qQ/UNUuURv2QyI/AAAAAAAAAQo/b3bn1dnu1bA/slide-13.png)

ここでは
+ Twitterデータを取得
+ 取得したデータをTwitter解析クラスタで解析。Twitter解析クラスタはHadoop＆RabbitMQで構成
+ 解析データはPostgreSQLとCassandraに蓄積
+ RailsサーバはPostgreSQLとCassandraから取得したデータをXML/JSON形式でAPI出力
という流れでデータを処理しています。

## 6. Twitter解析クラスタの構成

次はTwitter解析クラスタの中身です。

![スライド](https://lh3.googleusercontent.com/-1OoLJVHa2Mo/UNUuUk0fLGI/AAAAAAAAAQs/2ZX8WSrtqcc/slide-14.png)

Twitter解析クラスタは
- 「速報性」を重視したリアルタイム処理クラスタ
- 「データ網羅性」を重視したバッチ処理クラスタ
の2つのクラスタで構成していて、どちらも解析したデータはPostgreSQLとCassandraに蓄積しています。

## 6.1 Twitter解析バッチ処理クラスタ

バッチ処理クラスタのデータフローはこのようになっています。

![スライド](https://lh4.googleusercontent.com/-TFSPGMrK0AU/UNUuVZadcPI/AAAAAAAAARI/eXfbgLjI-Zs/slide-16.png) 

## 6.2. Twitter解析リアルタイム処理クラスタ

一方、リアルタイム処理クラスタではMap処理にRabbitMQを利用。

![スライド](https://lh5.googleusercontent.com/-Hj3vfQU4qO0/UNUubRfGxyI/AAAAAAAAASs/A4yPljEwT_M/slide-19.png)

### 補足: RabbitMQとは

RabbitMQとはメッセージキューソフトウェアと呼ばれるミドルウェアで、受け取ったメッセージを順番に出力します。

![スライド](https://lh4.googleusercontent.com/-al5LXQcnWP4/UNUuVj5IbaI/AAAAAAAAARM/9JaZXq08B_Y/slide-18.png)

RabbitMQにメッセージを送ることを「Publish」と、メッセージを取得することを「Subscribe」と言いますが、上の図ではメッセージA, メッセージB, メッセージCをPublishした順番にSubscribeしています。

## 7. バッチ処理からリアルタイム処理への移行

BuzzFinderのバッチ処理は日本語解析Map処理、データ抽出Map処理、集計Reduce処理の3段構成で行っています。

![スライド](https://lh6.googleusercontent.com/-15vpkW-iMp8/UNUuWoRCe_I/AAAAAAAAARc/FV3Z8EJEpsQ/slide-21.png)

この処理では日本語解析Map処理が段違いに重い処理となっていて、リアルタイム処理化の際にはこのMap処理を高速化することがポイントとなります。

そこでMap処理にRabbitMQを使ってストリーム処理化したのがこちらのアーキテクチャです。

![スライド](https://lh5.googleusercontent.com/-v4UusNzEHCc/UNUuXTcqXPI/AAAAAAAAARk/eAhQBMKizHI/slide-22.png)

Hadoopで行っていたMap処理をすべてRabbitMQ経由で行うことでストリーム処理化しています。

## 7.1. Map処理のRabbitMQ移行

Map処理のHadoopからRabbitMQへの移行では、Hadoop Streamingで実行していたMapperプログラムをRabbitMQ経由に変更しています。

![スライド](https://lh3.googleusercontent.com/-eTQa5XhpKdM/UNUuXsSb4lI/AAAAAAAAAR4/-KDfnkDNi-0/slide-23.png)

こちらの図のように、Hadoopではある程度溜まった入力データを一気に処理していましたが、RabbitMQ経由の場合はメッセージキューにたまった入力データをデーモンプロセスが一つずつ処理しています。
こうすることでMap処理のストリーム処理化を実現しています。

## 今回のまとめ

今回の記事ではBuzzFinderでのTwitterデータ処理フローをご紹介しました。

![スライド](https://lh4.googleusercontent.com/--26axsMTrpM/UNUuY0OzwkI/AAAAAAAAASE/T6R-2i9g3J0/slide-24.png)

BuzzFinderのリアルタイム処理はHadoopバッチ処理とRabbitMQストリーム処理の組み合わせになっているところが大きな特徴です。

次回は最終回となりますが、BuzzFinderでの実際の解析例をご紹介する予定です。

## バックナンバー
- [つぶやきを追え ～『爆発するソーシャルメディア』との戦い (前編)](/2012/12/22/fight-against-socialmedia-1)
- つぶやきを追え ～『爆発するソーシャルメディア』との戦い (中編)
- [つぶやきを追え ～『爆発するソーシャルメディア』との戦い (後編)](/2012/12/31/fight-against-socialmedia-3)

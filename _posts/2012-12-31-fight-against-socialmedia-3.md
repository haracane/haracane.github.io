---
author: haracane
layout: post
title: つぶやきを追え ～『爆発するソーシャルメディア』との戦い～ (後編)
description: 前編、中編に続いて『Hadoop&RabbitMQを利用したTwitter全量リアルタイム解析』(2012/12/10 Hadoopエンタープライズソリューションセミナー)レポートの最終回です。
tags:
- Hadoop
- RabbitMQ
meta_keywords: Hadoop,RabbitMQ
date: '2012-12-31 21:00:00+0900'
---
<!-- tag_links -->
[Hadoop](/tags/hadoop/) / [RabbitMQ](/tags/rabbitmq/)

<!-- content -->
[前編](http://hatacomp.hateblo.jp/entry/fight-against-socialmedia-1)、[中編](http://hatacomp.hateblo.jp/entry/fight-against-socialmedia-2)に続いて『Hadoop&RabbitMQを利用したTwitter全量リアルタイム解析』(2012/12/10 Hadoopエンタープライズソリューションセミナー)レポートの最終回です。

前編ではBuzzFinderサービス＆日本語解析技術について、
中編ではデータ処理フローについてご紹介しましたが、
今回はBuzzFinderでの解析例をご紹介します。

## 8. Twitter分析結果

## 8.1 「地震」のツイート数

今回の講演では「地震」を例に分析を行いました。
グラフを見ると地震発生日などにつぶやきが増えています。

![スライド](https://lh4.googleusercontent.com/-zjP5IXAORkc/UNUuZol8HvI/AAAAAAAAASY/E1aPp161-yo/slide-26.png)

## 8.2 関連語分析

こちらは関連語分析の結果です。
身近で実際に地震が起きると感情表現が増えています。

![スライド](https://lh4.googleusercontent.com/-VO5xSz1AGE0/UNUuZ7M7NJI/AAAAAAAAASQ/N4-RK7-RCo0/slide-27.png)

## 8.3 評判分析

評判分析を行うと首都圏の地震発生時に最もネガティブとなっています。

![スライド](https://lh6.googleusercontent.com/-NIFeoP4EMWE/UNUuahHKgmI/AAAAAAAAASc/W_7JV8YnA9U/slide-28.png)

## 8.4 地域分析

地域分析では震源地のツイートが多いという(自然な)結果が出ています。

![スライド](https://lh5.googleusercontent.com/-NmEILflzHqo/UNUuaxko1JI/AAAAAAAAASg/yWZZzzVcL7M/slide-29.png)

## 8.5 性別分析

性別の分布を見てみると、実際の地震では女性率が上がるようです。

![スライド](https://lh3.googleusercontent.com/-BscOXOB3lw8/UNUubDdVBvI/AAAAAAAAASw/k991pbgM-Kw/slide-30.png)

## 8.6 年齢分析

年齢面では実際の地震の場合に若年層の割合が増えています。

![スライド](https://lh6.googleusercontent.com/-2kcHGX0Pi14/UNUubr4uLEI/AAAAAAAAAS0/ariFq7Fze4U/slide-31.png)

## 8.7 職業分析

職業を見ると、実際の地震で学生が増えています。
こちらはやはり若年層と同様の傾向となっています。

![スライド](https://lh5.googleusercontent.com/-ZT2c1IUFsR4/UNUucBbDvoI/AAAAAAAAAS8/clBIbvKJ2Wg/slide-32.png)

## 9. まとめ

今回の連載ではBuzzFinderというサービスにおける

- リッチインデクシング技術による日本語解析
- HadoopとRabbitMQを使ったデータ処理フロー
- 「地震」についての解析例

をご紹介しました。
こちらの内容がデータ処理を行う参考になれば幸いです。

また、データ処理に関するプロジェクトをどんどんやっていきたいと思っていますので
ご協力できそうな話がありましたらお声掛けください。

## バックナンバー
- [つぶやきを追え ～『爆発するソーシャルメディア』との戦い (前編)](/2012/12/22/fight-against-socialmedia-1)
- [つぶやきを追え ～『爆発するソーシャルメディア』との戦い (中編)](/2012/12/23/fight-against-socialmedia-2)
- つぶやきを追え ～『爆発するソーシャルメディア』との戦い (後編)

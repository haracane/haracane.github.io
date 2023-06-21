---
author: haracane
layout: post
title: S3に置いたGzip圧縮済みCSVファイルをRubyで読み込んでみた
date: 2015-03-25 20:44:12J
tags:
- AWS
- S3
- Ruby
keywords: AWS S3 Ruby
description: Rubyでaws-sdkを使ってS3に置いたGzip圧縮したCSVファイル読み込む手順をご紹介します。
---
[AWS](/tags/aws/) / [S3](/tags/s3/) / [Ruby](/tags/ruby/)

## S3のキーを設定する

S3にアクセスするためにまずキーの設定を行います。

{% highlight ruby %}
AWS.config(
  access_key_id: 'アクセスキーID',
  secret_access_key: 'シークレットアクセスキー'
)
{% endhighlight %}

## AWS::S3オブジェクトを作る

キーを設定したら`AWS::S3`を使ってS3からデータを読み込むクライアントを作ります。

{% highlight ruby %}
s3 = AWS::S3.new
{% endhighlight %}

## バケットを取得する

続いてバケット名前を指定してバケットオブジェクトを取得します

{% highlight ruby %}
bucket = s3.buckets['my-bucket']
{% endhighlight %}

## ファイルを取得する

次はバケット内のファイルを取得します。

{% highlight ruby %}
file = bucket.objects['books.csv.gz']
{% endhighlight %}

## ファイルを読み込む

取得したファイルをパイプストリームに書き込みます。

{% highlight ruby %}
reader, writer = IO.pipe

file.read { |chunk| writer.write chunk }

writer.close
{% endhighlight %}

## Gzip圧縮データを解凍する

読み込んだデータはGzip圧縮してあるので`GzipReader`を使って解凍します。

{% highlight ruby %}
require 'zlib'

text = Zlib::GzipReader.new(reader).read
reader.close

{% endhighlight %}

## おまけ: Gzip圧縮した文字列を解凍する

上の例のように圧縮データはストリームに書き込むのが基本ですが、サイズが小さければ連結して`StringIO`経由で解凍してもOKです。

{% highlight ruby %}
data = ''

file.read { |chunk| data << chunk }

text = Zlib::GzipReader.new(StringIO.new(data)).read
{% endhighlight %}

## 解凍したCSVデータを読み込む

解凍したデータはCSV形式になっているので`CSV.parse`で読み込みます。

{% highlight ruby %}
CSV.parse(text).each do |row|
  puts row.inspect
end
{% endhighlight %}

これで無事読み込めました。

今回はこれでおしまいです。

S3に置いたGzip圧縮済みCSVファイルをRubyで読み込んでみた

※ この記事は[江の島エンジニアBlog](http://blog.enogineer.com/)の「[S3に置いたGzip圧縮済みCSVファイルをRubyで読み込んでみた](http://blog.enogineer.com/2015/03/25/load-s3-gz-csv/)」の転載です。

Rubyでaws-sdkを使ってS3に置いたGzip圧縮したCSVファイル読み込む手順をご紹介します。

## S3のキーを設定する

S3にアクセスするためにまずキーの設定を行います。

```ruby
AWS.config(
  access_key_id: 'アクセスキーID',
  secret_access_key: 'シークレットアクセスキー'
)
```

## AWS::S3オブジェクトを作る

キーを設定したら`AWS::S3`を使ってS3からデータを読み込むクライアントを作ります。

```ruby
s3 = AWS::S3.new
```

## バケットを取得する

続いてバケット名前を指定してバケットオブジェクトを取得します

```ruby
bucket = s3.buckets['my-bucket']
```

## ファイルを取得する

次はバケット内のファイルを取得します。

```ruby
file = bucket.objects['books.csv.gz']
```

## ファイルを読み込む

取得したファイルをパイプストリームに書き込みます。

```ruby
reader, writer = IO.pipe

file.read { |chunk| writer.write chunk }

writer.close
```

## Gzip圧縮データを解凍する

読み込んだデータはGzip圧縮してあるので`GzipReader`を使って解凍します。

```ruby
require 'zlib'

text = Zlib::GzipReader.new(reader).read
reader.close

```

## おまけ: Gzip圧縮した文字列を解凍する

上の例のように圧縮データはストリームに書き込むのが基本ですが、サイズが小さければ連結して`StringIO`経由で解凍してもOKです。

```ruby
data = ''

file.read { |chunk| data << chunk }

text = Zlib::GzipReader.new(StringIO.new(data)).read
```

## 解凍したCSVデータを読み込む

解凍したデータはCSV形式になっているので`CSV.parse`で読み込みます。

```ruby
CSV.parse(text).each do |row|
  puts row.inspect
end
```

これで無事読み込めました。

今回はこれでおしまいです。

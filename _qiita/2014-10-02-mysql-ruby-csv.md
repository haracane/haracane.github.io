MySQLからエクスポートしたCSVをRubyで読み込む

※ この記事は[江の島エンジニアBlog](http://blog.enogineer.com/)の「[MySQLからエクスポートしたCSVをRubyで読み込む](http://blog.enogineer.com/2014/10/02/mysql-ruby-csv/)」の転載です。

MySQLのテーブルをCSV経由でRubyで読み込もうとしたら一筋縄ではいかなかったのでメモしておきます。



まず、素直に

    SELECT * FROM articles INTO OUTFILE '/tmp/articles.csv'
    FIELDS TERMINATED BY ','
    OPTIONALLY ENCLOSED BY '"'

と実行してRubyで

```ruby
require 'csv'

CSV.foreach('/tmp/articles.csv', 'r') do |data|
  Articles.create(id: data[0].to_i, title: data[1], content: data[2])
end
```

と読み込もうとしたら
 
    CSV::MalformedCSVError: Missing or stray quote in line 1

というエラーメッセージが。

CSVファイルの中身を見てみるとバックスラッシュでエスケープをしていたので、ダブルクォートでエスケープするように

    SELECT * FROM articles INTO OUTFILE '/tmp/articles.csv'
    FIELDS TERMINATED BY ','
    OPTIONALLY ENCLOSED BY '"'
    ESCAPED BY '"'

としてみても単純にバックスラッシュがダブルクォートに変わるだけで

    CSV::MalformedCSVError: Illegal quoting

というエラーメッセージが出てしまう。

しょうがないのでsedで力技で置換しました。

最終的には元々の

    SELECT * FROM articles INTO OUTFILE '/tmp/articles.csv'
    FIELDS TERMINATED BY ','
    OPTIONALLY ENCLOSED BY '"'

でエクスポートして

    sed 's/\\"/""/g' -i /tmp/articles.csv
    sed 's/\\$//g' -i /tmp/articles.csv

としてエスケープを修正することで無事Rubyで読み込めました。

本当はもっと良い方法があるんじゃないかと思うんですが。。

この置換はあくまでその場しのぎの手抜きなので、ちゃんとやるときはActiveRecordを使うとか別の方法を考えましょう。
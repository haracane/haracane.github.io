MySQLでクエリの実行時間を手っ取り早く計測する

※ この記事は[江の島エンジニアBlog](http://blog.enogineer.com/)の「[MySQLでクエリの実行時間を手っ取り早く計測する](http://blog.enogineer.com/2015/03/26/mysql-time/)」の転載です。

MySQLでインデックスがちゃんと効いているか確認する時などに実際にクエリを走らせることがあるのですが、だいたいこんな感じで手っ取り早く済ませてますというTipsです。

## クエリを組み立てる

    $ SQL='SELECT * FROM records;'

計測したいクエリを設定します。

## 実行SQLファイルを作る

    $ (for i in $(seq 1 100000); do echo "$SQL"; done) > test.sql

10万回クエリを実行するSQLファイルを作ります。

## timeコマンドで計測する

    $ time (cat test.sql | mysql -u mysql database > /dev/null)

SQLファイルを実行して時間を計測します。

## 1行にまとめると

    $ time ((for i in $(seq 1 100000); do echo "SELECT * FROM records;";done) | mysql -u mysql database > /dev/null)

こんな感じになります。
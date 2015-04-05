MySQLのBULK INSERTでデッドロック回避のためにINSERT順に気をつける

※ この記事は[江の島エンジニアBlog](http://blog.enogineer.com/)の「[MySQLのBULK INSERTでデッドロック回避のためにINSERT順に気をつける](http://blog.enogineer.com/2015/04/05/mysql-deadlock/)」の転載です。

Railsでactiverecord-importを使ってバルクインサートをする時にDeadlockエラーが出たので対処しました。バルクインサートをする時にはINSERT順を気をつけないといけませんねという話です。

## MySQLのBULK INSERTでエラー発生

ログ集計した結果をテーブルにBULK INSERTしていたら

```ActiveRecord::StatementInvalid: Mysql2::Error: Deadlock found when trying to get lock; try restarting transaction: INSERT INTO `books` (`id`,`name`) VALUES
```

というエラーが発生しました。

## BULK INSERTのエラー原因調査

エラー原因を調べてみるとインサート順がインデックスに沿っていないとデッドロックが発生してしまうようです。（参考: [mysql deadlocks with concurrent inserts](http://thushw.blogspot.in/2010/11/mysql-deadlocks-with-concurrent-inserts.html)）

### デッドロックが発生してしまうケース

まず、テーブルが

|id|name|
|--|----|
|1|ActiveRecordの本|
|2|PostgreSQLの本|

となっていて、`name`カラムがUNIQUEキーになっていたとします。

ここで、`books`テーブルに対してプロセス１とプロセス２が

```sql
INSERT INTO `books` (`id`,`name`) VALUES (NULL,'Rubyの本'),(NULL,'Capybaraの本');
```

```sql
INSERT INTO `books` (`id`,`name`) VALUES (NULL,'MySQLの本'),(NULL,'Railsの本');
```

というBULK INSERT処理を同時に実行しようとするとデッドロックが起こる場合があります。

### デッドロックが発生するまでの処理内容

上記のようなBULK INSERTを実行すると以下のような処理でデッドロックが発生してしまう場合があります。

1. プロセス１が`Rubyの本`をINSERTするために`PostgreSQLの本`から`Rubyの本`までのギャップロックAを取得
2. プロセス２が`MySQLの本`をINSERTするために`ActiveRecordの本`から`MySQLの本`までのギャップロックBを取得
3. プロセス２が`Railsの本`をINSERTするために`PostgreSQLの本`から`Railsの本`までのギャップロックCを取得しようとする
  * プロセス１が取得している`PostgreSQLの本`から`Rubyの本`までのギャップロックAの解放を待つ
4. プロセス１が`Capybaraの本`をINSERTするために`ActiveRecordの本`から`Capybaraの本`までのギャップロックDを取得しようとする
  * プロセス１が取得している`ActiveRecordの本`から`MySQLの本`までのギャップロックBの解放を待つ

図にすると


|レコード|プロセス１|プロセス２|
|-------|:--------:|:--------:|
|ActiveRecordの本| | ギャップロックB |
|Capybaraの本| ギャップロックD | ‖ |
|MySQLの本| ギャップロックD | ギャップロックB |
|PostgreSQLの本| ギャップロックA | ギャップロックC |
|Railsの本| ‖ | ギャップロックC |
|Rubyの本| ギャップロックA | |

という感じになります。

ご覧の通り

* プロセス１がプロセス２のギャップロックBの解放を待つ
* プロセス２がプロセス１のギャップロックAの解放を待つ

という形でデッドロックが発生してしまいます。

## デッドロックの回避方法

デッドロックを回避するにはBULK INSERTする時の順番を気をつければOKです。

今回の場合だと

```sql
INSERT INTO `books` (`id`,`name`) VALUES (NULL,'Capybaraの本'), (NULL,'Rubyの本');
```

```sql
INSERT INTO `books` (`id`,`name`) VALUES (NULL,'MySQLの本'),(NULL,'Railsの本');
```

とすればOKです。

こうすると今回の例のような場合でも

|レコード|プロセス１|プロセス２|
|-------|:--------:|:--------:|
|ActiveRecordの本| | ギャップロックB |
|Capybaraの本| ギャップロックA | ‖ |
|MySQLの本| ギャップロックA | ギャップロックB |
|PostgreSQLの本| ギャップロックD | ギャップロックC |
|Railsの本| ‖ | ギャップロックC |
|Rubyの本| ギャップロックD | |

という感じになって解放待ちのギャップロックを辿ってもループしなくなるのでデッドロックを回避できます。

ということでBULK INSERTの際はINSERTの順番に気をつけましょう。

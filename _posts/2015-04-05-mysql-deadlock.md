---
author: haracane
layout: post
title: MySQLのBULK INSERTでデッドロックを回避する
date: 2015-04-05 09:50:41J
tags:
- MySQL
- Rails
- Ruby
keywords: MySQL Rails Ruby
description: Railsでactiverecord-importを使ってバルクインサートをする時にDeadlockエラーが出たので対処しました。バルクインサートをする時にはINSERT順を気をつけないといけませんねという話です。
image: "/assets/images/posts/mysql.png"
---
<!-- tag_links -->
[MySQL](/tags/mysql/) / [Rails](/tags/rails/) / [Ruby](/tags/ruby/)

<!-- content -->
## MySQLのBULK INSERTでエラー発生

ログ集計した結果をテーブルにBULK INSERTしていたら

```ActiveRecord::StatementInvalid: Mysql2::Error: Deadlock found when trying to get lock; try restarting transaction: INSERT INTO `books` (`id`,`name`) VALUES ...
```

というデッドロックエラーが発生しました。

## BULK INSERTのエラー原因調査

ということでデッドロックの原因を調べてみたのですが、インサート順がインデックスに沿っていないことがまずかったようです。（参考: [mysql deadlocks with concurrent inserts](http://thushw.blogspot.in/2010/11/mysql-deadlocks-with-concurrent-inserts.html)）

### デッドロックが発生してしまうケース

例えば以下のような場合にまずいことになります。

まず、テーブルが

|id|name|
|--|----|
|1|ActiveRecordの本|
|2|PostgreSQLの本|

となっていて、`name`カラムがUNIQUEキーになっていたとします。

ここで、`books`テーブルに対してプロセスAとプロセスBが

{% highlight sql %}
INSERT INTO `books` (`id`,`name`) VALUES (NULL,'Rubyの本'),(NULL,'Capybaraの本');
{% endhighlight %}

{% highlight sql %}
INSERT INTO `books` (`id`,`name`) VALUES (NULL,'MySQLの本'),(NULL,'Railsの本');
{% endhighlight %}

というBULK INSERT処理を同時に実行しようとするとデッドロックが起こる場合があります。

### デッドロックが発生するまでの処理内容

デッドロックは以下のような処理順の場合に発生してしまいます。

1. プロセスAが`Rubyの本`をINSERTするために`PostgreSQLの本`から`Rubyの本`までのギャップロックA1を取得
2. プロセスBが`MySQLの本`をINSERTするために`ActiveRecordの本`から`MySQLの本`までのギャップロックB1を取得
3. プロセスBが`Railsの本`をINSERTするために`PostgreSQLの本`から`Railsの本`までのギャップロックB2を取得しようとする
  * プロセスAが取得している`PostgreSQLの本`から`Rubyの本`までのギャップロックA1の解放を待つ
4. プロセスAが`Capybaraの本`をINSERTするために`ActiveRecordの本`から`Capybaraの本`までのギャップロックA2を取得しようとする
  * プロセスBが取得している`ActiveRecordの本`から`MySQLの本`までのギャップロックB1の解放を待つ

図にすると

|レコード|プロセスA|プロセスB|
|-------|:--------:|:--------:|
|ActiveRecordの本| | ギャップロックB1 |
|Capybaraの本| ギャップロックA2 | ‖ |
|MySQLの本| ギャップロックA2 | ギャップロックB1 |
|PostgreSQLの本| ギャップロックA1 | ギャップロックB2 |
|Railsの本| ‖ | ギャップロックB2 |
|Rubyの本| ギャップロックA1 | |

という感じになります。

ご覧の通り

* プロセスAがギャップロックB1の解放を待つ
* プロセスBがギャップロックA1の解放を待つ

という形でデッドロックが発生してしまいます。

## デッドロックの回避方法

このようなデッドロックはBULK INSERTする時の順番を気をつければ回避できます。

今回の場合だと

{% highlight sql %}
INSERT INTO `books` (`id`,`name`) VALUES (NULL,'Capybaraの本'), (NULL,'Rubyの本');
{% endhighlight %}

{% highlight sql %}
INSERT INTO `books` (`id`,`name`) VALUES (NULL,'MySQLの本'),(NULL,'Railsの本');
{% endhighlight %}

とすればOKです。

こうすると今回の例のような場合でも

|レコード|プロセスA|プロセスB|
|-------|:--------:|:--------:|
|ActiveRecordの本| | ギャップロックB1 |
|Capybaraの本| ギャップロックA1 | ‖ |
|MySQLの本| ギャップロックA1 | ギャップロックB1 |
|PostgreSQLの本| ギャップロックA2 | ギャップロックB2 |
|Railsの本| ‖ | ギャップロックB2 |
|Rubyの本| ギャップロックA2 | |

という感じになって解放待ちのギャップロックを辿ってもループしなくなるのでデッドロックを回避できます。

ということでBULK INSERTの際はINSERTの順番に気をつけましょう。

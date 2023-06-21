---
author: haracane
layout: post
title: MySQLでインデックスや外部キー制約をリネームする
date: 2015-03-26 08:49:49J
tags: tips MySQL
keywords: MySQL
description: テーブルを置き換える場合などにはテーブル名だけでなく、インデックスや外部キー制約も名前変更する必要があります。MySQL5.7系だとRENAME INDEXができるのですが、5.6系だと残念ながら削除＆追加するしかないので、その方法をまとめておきます。
mark: Tips
image: mysql.png
---
[tips](/tags/tips/) / [MySQL](/tags/mysql/)

`new_`というプレフィックスのついたインデックスや外部キー制約から`new_`を外す場合の例を紹介します。

## インデックスの追加

{% highlight sql %}
ALTER TABLE posts ADD KEY index_posts_on_category_id(category_id);
ALTER TABLE posts ADD UNIQUE KEY index_posts_on_url(url);
{% endhighlight %}

`ADD KEY`または`ADD UNIQUE KEY`で追加します。

## インデックスの削除

{% highlight sql %}
ALTER TABLE posts DROP KEY new_index_posts_on_category_id;
ALTER TABLE posts DROP KEY new_index_posts_on_url;
{% endhighlight %}

`DROP KEY`で削除します。

## 外部キー制約の追加

{% highlight sql %}
ALTER TABLE posts
  ADD CONSTRAINT
    posts_blog_id_fk
      FOREIGN KEY(blog_id)
      REFERENCES blogs;
{% endhighlight %}

`ADD CONSTRAINT * FOREIGN KEY(*) REFERENCES *`で追加します。

## 外部キー制約の削除

{% highlight sql %}
ALTER TABLE posts DROP FOREIGN KEY new_posts_blog_id_fk;
{% endhighlight %}

`DROP FOREIGN KEY`で削除します。

## まとめてみると

それぞれの追加＆削除をまとめて実行するならこんな感じになります。

{% highlight sql %}
ALTER TABLE posts
  ADD KEY index_posts_on_category_id(category_id),
  ADD UNIQUE KEY index_posts_on_url(url),
  DROP KEY new_index_posts_on_category_id,
  DROP KEY new_index_posts_on_url,
  ADD CONSTRAINT
    posts_blog_id_fk
      FOREIGN KEY(blog_id)
      REFERENCES blogs,
  DROP FOREIGN KEY new_posts_blog_id_fk;
{% endhighlight %}

以上、MySQLでのインデックス＆外部キー制約のリネーム方法でした。

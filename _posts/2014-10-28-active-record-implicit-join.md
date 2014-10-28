---
layout: post
title: ActiveRecordでincludesとwhereを同時に使う時はJOINするテーブル名の指定に気をつける
date: 2014-10-28 19:48:23J
tags: Rails Ruby
keywords: ActiveRecord includes where Rails Ruby
description: ActiveRecordでincludesとwhereを合わせて使ったらDEPRECATION WARNINGが出たので記事に残しておきます。最終的にはArelを使って対応しました。
---

{% highlight ruby %}
Post.includes(:comments).where("comments.content like '%いいね%'")
{% endhighlight %}

のようにPostモデルのデータを取得しようとしたら

    DEPRECATION WARNING: It looks like you are eager loading table(s) (one of: admin_help_questions, admin_help_answers) that are referenced in a string SQL snippet. For example:

        Post.includes(:comments).where("comments.title = 'foo'")

    Currently, Active Record recognizes the table in the string, and knows to JOIN the comments table to the query, rather than loading comments in a separate query. However, doing this without writing a full-blown SQL parser is inherently flawed. Since we don't want to write an SQL parser, we are removing this functionality. From now on, you must explicitly tell Active Record when you are referencing a table from a string:

        Post.includes(:comments).where("comments.title = 'foo'").references(:comments)

    If you don't rely on implicit join references you can disable the feature entirely by setting `config.active_record.disable_implicit_join_references = true`. (called from _app_views_admin_helps_index_html_slim__3903631066707545561_70231419906340 at /Users/haracane/git/cbchintai.com/app/views/admin/helps/index.html.slim:36)

というDEPRECATION WARNINGが出ました。

要約すると「文字列中のテーブル名を自動認識しなくする予定だから`comments.content`のテーブル名は`references(:comments)`で指定してね」ということのようです。

ただ、そもそも文字列でSQLを書いてるから文句を言われているので今回は

{% highlight ruby %}
Post.includes(:comments).where(Comment.arel_table(:content).matches('%いいね%'))
{% endhighlight %}

とArelを使うことで対応しました。

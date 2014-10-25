---
layout: post
title: newアクションで記事投稿フォームを作る
date: 2014-10-03 07:03:28J
tags: Rails Ruby
keywords: RESTful new Rails Ruby
categories: rails-restful
description: これまでindexアクションとshowアクションでRESTfulな記事一覧＆表示機能を実装してきましたが、今回からは記事投稿機能を実装します。まずはnewアクションで投稿フォームの作成を行います。
image: rails.png
---



### 記事投稿フォーム表示機能のルーティング設定

まずはroutes.rbでルーティング設定を行います。

記事投稿フォーム表示にはnewアクションを使うので

{% highlight ruby %}
# config/routes.rb
resources :articles, only: [:new]
{% endhighlight %}

と設定します。

設定してからルーティングを確認すると

    $ rake routes
    new_article GET /articles/new(.:format) articles#new

という行が出力されます。

1. Prefixは`new_article`で、`new_article_path`といったヘルパーでパスを取得できる
2. `/articles/new(.:format)`への`GET`リクエストでアクセスできる
3. `articles`コントローラの`new`アクションを実行する

ということがわかります。

### 記事投稿フォーム表示機能のコントローラ

コントローラではnewアクションを実装します。

newアクションでは表示用の記事データを取得する必要があるので

{% highlight ruby %}
# app/controllers/articles_controller.rb
def new
  @article = Article.new
end
{% endhighlight %}

というように投稿フォーム用のArticleオブジェクトを作成します。

### 記事投稿フォーム表示機能のビュー

newアクションのビューでは記事投稿フォームを表示します。

{% highlight slim %}
/ app/views/articles/new.html.slim
= form_for @article, url: articles_path do |f|
  = f.text_field :title
  = f.text_area :content
  = f.submit "投稿する"
{% endhighlight %}

次は今回作成した記事投稿フォームから送信したデータを受け取って記事を作成する[createアクションの実装]({% post_url 2014-10-03-rails-restful-create %})を行います。

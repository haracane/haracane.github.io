---
author: haracane
layout: post
title: newアクションで記事投稿フォームを作る
date: 2014-10-03 07:03:28J
tags:
- Rails
- Ruby
keywords: RESTful new Rails Ruby
categories: rails-restful
description: これまでindexアクションとshowアクションでRESTfulな記事一覧＆表示機能を実装してきましたが、今回からは記事投稿機能を実装します。まずはnewアクションで投稿フォームの作成を行います。
image: rails.png
---
[Rails](/tags/rails/) / [Ruby](/tags/ruby/)

## 記事投稿フォーム表示機能のルーティング設定

まずはroutes.rbでルーティング設定を行います。

記事投稿フォーム表示にはnewアクションを使うので

{% highlight ruby %}
# config/routes.rb
namespace :blog do
  resources :posts, only: [:new]
end
{% endhighlight %}

と設定します。

設定してからルーティングを確認すると

    $ rake routes
    new_blog_post GET /blog/posts/new(.:format) blog/posts#new

という行が出力されます。

1. Prefixは`new_blog_post`で、`new_blog_post_path`といったヘルパーでパスを取得できる
2. `/blog/posts/new(.:format)`への`GET`リクエストでアクセスできる
3. `blog_posts`コントローラの`new`アクションを実行する

ということがわかります。

## 記事投稿フォーム表示機能のコントローラ

コントローラではnewアクションを実装します。

newアクションでは表示用の記事データを取得する必要があるので

{% highlight ruby %}
# app/controllers/blog/posts_controller.rb
def new
  @post = Blog::Post.new
end
{% endhighlight %}

というように投稿フォーム用のBlog::Postオブジェクトを作成します。

## 記事投稿フォーム表示機能のビュー

newアクションのビューでは記事投稿フォームを表示します。

{% highlight slim %}
/ app/views/blog/posts/new.html.slim
= form_for @post, url: blog_posts_path do |f|
  = f.text_field :title
  = f.text_area :content
  = f.submit "投稿する"
{% endhighlight %}

次は今回作成した記事投稿フォームから送信したデータを受け取って記事を作成する[createアクションの実装]({% post_url 2014-10-04-rails-restful-create %})を行います。

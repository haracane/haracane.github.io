---
author: haracane
layout: post
title: editアクションで記事編集フォームを作る
date: 2014-10-03 07:05:37J
tags:
- Rails
- Ruby
keywords: RESTful edit Rails Ruby
categories:
- rails-restful
description: 記事の投稿・閲覧ができるようになったので、次はeditアクションでRESTfulな記事編集フォーム表示を行います。
image: rails.png
---
<!-- tag_links -->
[Rails](/tags/rails/) / [Ruby](/tags/ruby/)

<!-- content -->
## 記事編集フォーム表示機能のルーティング設定

まずはroutes.rbでeditアクションのルーティング設定を行います。

{% highlight ruby %}
# config/routes.rb
namespace :blog do
  resources :posts, only: [:edit]
end
{% endhighlight %}

と設定します。

設定してからルーティング情報を出力すると

    $ rake routes
    edit_blog_post GET /blog/posts/:id/edit(.:format) blog/posts#edit

となります。

確認すると

1. Prefixは`edit_blog_post`で、`edit_blog_post_path(blog_post.id)`といったヘルパーでパスを取得できる
2. `/blog/posts/:id/edit(.:format)`への`GET`リクエストでアクセスできる
3. `blog_posts`コントローラの`edit`アクションを実行する

ということがわかります。

## 記事編集フォーム表示機能のコントローラ

コントローラではeditアクションを実装します。

editアクションでは編集用の記事データを取得して編集フォームを表示します。

{% highlight ruby %}
# app/controllers/blog/posts_controller.rb
before_action :set_blog_post, only: [:edit]

def edit
end

private
  def set_blog_post
    @post = Blog::Post.find(params[:id])
  end
{% endhighlight %}

このset_blog_postメソッドは[showアクションの実装]({% post_url 2014-10-04-rails-restful-show %})の時に作成したメソッドを利用します。

## 記事編集フォーム表示機能のビュー

editアクションのビューでは取得済みの記事データを表示します。

{% highlight slim %}
/ app/views/blog/posts/edit.html.slim
= form_for @post, url: blog_post_path do |f|
  = f.text_field :title
  = f.text_area :content
  = f.submit "変更する"
{% endhighlight %}

Railsの場合は@postオブジェクトのtitleの値を自動的にフォームに反映してくれるのでvalueを明示的に指定する必要はありません。

次は記事編集フォームから送信した記事データを[updateアクションで更新]({% post_url 2014-10-04-rails-restful-update %})します。

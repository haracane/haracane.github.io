---
layout: post
title:  showアクションで記事表示機能を作る
date: 2014-10-03 07:02:32J
tags: Rails Ruby
keywords: RESTful show Rails Ruby
categories: rails-restful
description: 前回はindexアクションでRESTfulな記事一覧機能を実装しましたが、今回はshowアクションで各記事の表示を行います。
image: rails.png
---



## 記事表示機能のルーティング設定

まずはroutes.rbでルーティング設定を行います。

記事表示にはshowアクションを使うので

{% highlight ruby %}
# config/routes.rb
namespace :blog do
  resources :posts, only: [:show]
end
{% endhighlight %}

と設定します。

設定してからルーティングを確認すると

    $ rake routes
    blog_post GET /blog/posts/:id(.:format) blog/posts#show

という行が出力されます。

読み方は[indexアクションの時]({% post_url 2014-10-04-rails-restful-index %})と同じで

1. Prefixは`blog_post`で、`blog_post_path(blog_post.id)`といったヘルパーでパスを取得できる
2. `/blog/posts/:id(.:format)`への`GET`リクエストでアクセスできる
3. `blog_posts`コントローラの`show`アクションを実行する

ということがわかります。

## 記事表示機能のコントローラ

コントローラではshowアクションを実装します。

showアクションでは表示用の記事データを取得する必要があるので

{% highlight ruby %}
# app/controllers/blog/posts_controller.rb
before_action :set_blog_post, only: [:show]

def show
end

private
  def set_blog_post
    @post = Blog::Post.find(params[:id])
  end
{% endhighlight %}

というようにデータを取得します。

なお、idからの記事データの取得は他のアクションでも行う操作なのでbefore_actionで行うようにしています。

## 記事表示機能のビュー

showアクションのビューでは取得済みの記事データを表示します。

記事の内容を表示するのであれば

{% highlight slim %}
/ app/views/blog/posts/show.html.slim
h1 = @post.title
p = @post.content
{% endhighlight %}

と書くことができます。

ここまでで記事閲覧機能は完成しました。

次は[newアクションでの記事入力フォーム表示]({% post_url 2014-10-04-rails-restful-new %})を行います。

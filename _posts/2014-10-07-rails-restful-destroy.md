---
layout: post
title: destroyアクションで記事を削除する
date: 2014-10-03 07:07:40J
tags: Rails Ruby
keywords: RESTful destroy Rails Ruby
categories: rails-restful
description: 前回までにRailsで記事削除・作成・更新を行ってきましたが、今回はdestroyアクションでRESTfulに記事データを削除します。
image: rails.png
---

## 記事削除機能のルーティング設定

まずはroutes.rbでdestroyアクションのルーティング設定を行います。

{% highlight ruby %}
# config/routes.rb
namespace :blog do
  resources :posts, only: [:destroy]
end
{% endhighlight %}

と設定します。

設定してからルーティング情報を出力すると

    $ rake routes
    blog_post DELETE /blog/posts/:id(.:format) blog/posts#destroy

となります。

確認すると

1. Prefixは`blog_post`で、`blog_post_path(blog_post.id)`といったヘルパーでパスを取得できる
2. `/blog/posts/:id(.:format)`への`DELETE`リクエストでアクセスできる
3. `blog_posts`コントローラの`destroy`アクションを実行する

ということがわかります。

## 記事削除機能のコントローラ

コントローラではdestroyアクションを実装します。

destroyアクションでは指定されたidの記事を削除します。

{% highlight ruby %}
# app/controllers/blog/posts_controller.rb
before_action :set_blog_post, only: [:destroy]

def destroy
  if @post.delete
    flash[:success] = "deleted"
  end
  redirect_to blog_posts_path
end

private
  def set_blog_post
    @post = Blog::Post.find(params[:id])
  end
{% endhighlight %}

## 記事削除機能のビュー

destroyアクションでも[createアクション]({% post_url 2014-10-03-rails-restful-create %})と[updateアクション]({% post_url 2014-10-03-rails-restful-update %})同様にビューは用意しておらず、削除に成功しても失敗しても記事一覧にリダイレクトするようにしています。

今回でRails4でのRESTfulな記事管理機能の実装はおしまいです。

ひとつひとつはそれほど難しいことではないので、よく理解してRESTfulなシステムを作っていきましょう。

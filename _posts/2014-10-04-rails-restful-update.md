---
author: haracane
layout: post
title: updateアクションで記事を更新する
date: 2014-10-03 07:06:40J
tags: Rails Ruby
keywords: RESTful update Rails Ruby
categories: rails-restful
description: 前回は投稿済みの記事の編集フォームを表示できるようにしました。今回は編集フォームからデータを受け取ってupdateアクションで記事データを更新します。
image: rails.png
---
[Rails](/tags/rails/) / [Ruby](/tags/ruby/)

## 記事更新機能のルーティング設定

まずはroutes.rbでupdateアクションのルーティング設定を行います。

{% highlight ruby %}
# config/routes.rb
namespace :blog do
  resources :posts, only: [:update]
end
{% endhighlight %}

と設定します。

設定してからルーティング情報を出力すると

    $ rake routes
    blog_post PATCH /blog/posts/:id(.:format) blog/posts#update

となります。

確認すると

1. Prefixは`blog_post`で、`blog_post_path(blog_post.id)`といったヘルパーでパスを取得できる
2. `/blog/posts/:id(.:format)`への`PATCH`リクエストでアクセスできる
3. `blog_posts`コントローラの`update`アクションを実行する

ということがわかります。

## 記事更新機能のコントローラ

コントローラではupdateアクションを実装します。

updateアクションでは更新用の記事データをロードして、受け取ったパラメタで更新・保存します。

{% highlight ruby %}
# app/controllers/blog/posts_controller.rb
before_action :set_blog_post, only: [:update]

def update
  if @post.update(blog_post_params)
    flash[:success] = "updated"
    redirect_to blog_posts_path
  else
    render 'edit'
  end
end

private
  def set_blog_post
    @post = Blog::Post.find(params[:id])
  end

  def blog_post_params
    params.require(:blog_post).permit(:title, :content)
  end
{% endhighlight %}

[editアクション]({% post_url 2014-10-04-rails-restful-edit %})と[createアクション]({% post_url 2014-10-04-rails-restful-create %})を組み合わせたようになっていますね。

## 記事更新機能のビュー

updateアクションでも[createアクション]({% post_url 2014-10-04-rails-restful-create %})と同様にビューは用意しておらず、更新に成功したら記事一覧に、失敗したら再度記事編集フォームを表示するようにしています。

次回は[destroyアクションで記事を削除]({% post_url 2014-10-07-rails-restful-destroy %})します。

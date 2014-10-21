---
layout: post
title: updateアクションで記事を更新する
date: 2014-10-03 07:06:40J
tags: Rails Ruby
keywords: RESTful update Rails Ruby
categories: rails-restful
description: 前回は投稿済みの記事の編集フォームを表示できるようにしました。今回は編集フォームからデータを受け取ってupdateアクションで記事データを更新します。
---



### 記事更新機能のルーティング設定

まずはroutes.rbでupdateアクションのルーティング設定を行います。

{% highlight ruby %}
# config/routes.rb
resources :articles, only: [:update]
{% endhighlight %}

と設定します。

設定してからルーティング情報を出力すると

    $ rake routes
    article PATCH /articles/:id(.:format) articles#update

となります。

確認すると

1. Prefixは`article`で、`article_path(article.id)`といったヘルパーでパスを取得できる
2. `/articles/:id(.:format)`への`PATCH`リクエストでアクセスできる
3. `articles`コントローラの`update`アクションを実行する

ということがわかります。

### 記事更新機能のコントローラ

コントローラではupdateアクションを実装します。

updateアクションでは更新用の記事データをロードして、受け取ったパラメタで更新・保存します。

{% highlight ruby %}
# app/controllers/articles_controller.rb
before_action :set_article, only: [:edit]

def update
  if @article.update(article_params)
    flash[:success] = "updated"
    redirect_to articles_path
  else
    render 'edit'
  end
end

private
  def set_article
    @article = Article.find(params[:id])
  end

  def article_params
    params.require(:article).permit(:title, :content)
  end
{% endhighlight %}

[editアクション]({% post_url 2014-10-03-rails-restful-edit %})と[createアクション]({% post_url 2014-10-03-rails-restful-create %})を組み合わせたようになっていますね。

### 記事更新機能のビュー

updateアクションでも[createアクション]({% post_url 2014-10-03-rails-restful-create %})と同様にビューは用意しておらず、更新に成功したら記事一覧に、失敗したら再度記事編集フォームを表示するようにしています。

次回は[destroyアクションで記事を削除]({% post_url 2014-10-03-rails-restful-destroy %})します。

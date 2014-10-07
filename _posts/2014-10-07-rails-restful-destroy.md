---
layout: post
title: destroyアクションで記事を削除する
date: 2014-10-03 07:07:40J
tags: Rails Ruby
keywords: RESTful destroy Rails Ruby
categories: rails-restful
description: 前回までにRailsで記事削除・作成・更新を行ってきましたが、今回はdestroyアクションでRESTfulに記事データを削除します。
---

{{ page.description }}

### 記事削除機能のルーティング設定

まずはroutes.rbでdestroyアクションのルーティング設定を行います。

{% highlight ruby %}
# config/routes.rb
resources :articles, only: [:destroy]
{% endhighlight %}

と設定します。

設定してからルーティング情報を出力すると

    $ rake routes
    article DELETE /articles/:id(.:format) articles#destroy

となります。

確認すると

1. Prefixは`article`で、`article_path(article.id)`といったヘルパーでパスを取得できる
2. `/articles/:id(.:format)`への`DELETE`リクエストでアクセスできる
3. `articles`コントローラの`destroy`アクションを実行する

ということがわかります。

### 記事削除機能のコントローラ

コントローラではdestroyアクションを実装します。

destroyアクションでは指定されたidの記事を削除します。

{% highlight ruby %}
# app/controllers/articles_controller.rb
before_action :set_article, only: [:destroy]

def destroy
  if @article.delete
    flash[:success] = "deleted"
  end
  redirect_to articles_path
end

private
  def set_article
    @article = Article.find(params[:id])
  end
{% endhighlight %}

### 記事削除機能のビュー

destroyアクションでも[createアクション]({% post_url 2014-10-03-rails-restful-create %})と[updateアクション]({% post_url 2014-10-03-rails-restful-update %})同様にビューは用意しておらず、削除に成功しても失敗しても記事一覧にリダイレクトするようにしています。

今回でRails4でのRESTfulな記事管理機能の実装はおしまいです。

ひとつひとつはそれほど難しいことではないので、よく理解してRESTfulなシステムを作っていきましょう。

---
layout: post
title: editアクションで記事編集フォームを作る
date: 2014-10-03 07:05:37J
tags: Rails Ruby
keywords: RESTful edit Rails Ruby
categories: rails-restful
description: 記事の投稿・閲覧ができるようになったので、次はeditアクションでRESTfulな記事編集フォーム表示を行います。
---

{{ page.description }}

### 記事編集フォーム表示機能のルーティング設定

まずはroutes.rbでeditアクションのルーティング設定を行います。

{% highlight ruby %}
# config/routes.rb
resources :articles, only: [:edit]
{% endhighlight %}

と設定します。

設定してからルーティング情報を出力すると

    $ rake routes
    edit_article GET /articles/:id/edit(.:format) articles#edit

となります。

確認すると

1. Prefixは`edit_article`で、`edit_article_path(article.id)`といったヘルパーでパスを取得できる
2. `/articles/:id/edit(.:format)`への`GET`リクエストでアクセスできる
3. `articles`コントローラの`edit`アクションを実行する

ということがわかります。

### 記事編集フォーム表示機能のコントローラ

コントローラではeditアクションを実装します。

editアクションでは編集用の記事データを取得して編集フォームを表示します。

{% highlight ruby %}
# app/controllers/articles_controller.rb
before_action :set_article, only: [:edit]

def edit
end

private
  def set_article
    @article = Article.find(params[:id])
  end
{% endhighlight %}

このset_articleメソッドは[showアクションの実装]({% post_url 2014-10-03-rails-restful-show %})の時に作成したメソッドを利用します。

### 記事編集フォーム表示機能のビュー

editアクションのビューでは取得済みの記事データを表示します。

{% highlight slim %}
/ app/views/articles/edit.html.slim
= form_for @article, url: article_path do |f|
  = f.text_field :title
  = f.text_area :content
  = f.submit "変更する"
{% endhighlight %}

Railsの場合は@articleオブジェクトのtitleの値を自動的にフォームに反映してくれるのでvalueを明示的に指定する必要はありません。

次は記事編集フォームから送信した記事データを[updateアクションで更新]({% post_url 2014-10-03-rails-restful-update %})します。

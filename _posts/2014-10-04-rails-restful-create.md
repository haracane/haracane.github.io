---
layout: post
title:  createアクションで記事を作成する
date: 2014-10-03 07:04:32J
tags: Rails Ruby
keywords: RESTful create Rails Ruby
categories: rails-restful
description: 前回はnewアクションでRESTfulな記事投稿フォーム表示機能を実装しました。今回はその投稿フォームから受け取ったデータで記事を作成するcreateアクションでの実装を行います。
---



### 記事作成機能のルーティング設定

まずはroutes.rbでcreateアクションのルーティング設定を行います。

{% highlight ruby %}
# config/routes.rb
resources :articles, only: [:create]
{% endhighlight %}

と設定します。

設定してからルーティングを確認すると

    $ rake routes
    articles POST /articles(.:format) articles#create

という行が出力されます。

このURIは実は[indexアクション]({% post_url 2014-10-03-rails-restful-index %})と同じなのですが、createアクションの場合はGETメソッドではなくPOSTメソッドのリクエストを受け付けるというところが違います。

このようにリクエストメソッドによって動作を変えるところがRESTの大事なポイントです。

ルーティング情報を確認すると

1. Prefixは`articles`で、`articles_path`といったヘルパーでパスを取得できる
2. `/articles(.:format)`への`POST`リクエストでアクセスできる
3. `articles`コントローラの`create`アクションを実行する

ということがわかります。

### 記事作成機能のコントローラ

コントローラではcreateアクションを実装します。

createアクションでは受け取ったパラメタからArticleオブジェクトを作成してデータベースに保存します。

{% highlight ruby %}
# app/controllers/articles_controller.rb
def create
  @article = Article.new(article_params)
  if @article.save
    flash[:success] = 'created'
    redirect_to articles_path
  else
    render :new
  end
end

private
  def article_params
    params.require(:article).permit(:title, :content)
  end
{% endhighlight %}

article_paramsというメソッドはRails4の[Strong Parameters](https://github.com/rails/strong_parameters)という機能を使ってマスアサインメント脆弱性を回避しているのですが、詳しい説明はここでは省略します。

### 記事作成機能のビュー

記事作成機能にはビューは用意していません。

記事作成に成功したら記事一覧ページにリダイレクトするように、失敗したら再度記事投稿フォームを表示するようにしています。

ここまでで記事の投稿・閲覧が行えるようになりました。

次回は[editアクションでの記事編集フォーム表示]({% post_url 2014-10-03-rails-restful-edit %})を行います。

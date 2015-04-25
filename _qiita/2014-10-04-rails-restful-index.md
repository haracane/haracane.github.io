indexアクションで記事一覧機能を作る

※ この記事は[江の島エンジニアBlog](http://blog.enogineer.com/)の「[indexアクションで記事一覧機能を作る](http://blog.enogineer.com/2014/10/04/rails-restful-index/)」の転載です。

RailsにはRESTfulなURIを生成してくれる便利な機能があり、キャッシュバック賃貸でもよく使っています。今回はその機能を利用した記事一覧機能の作り方をご紹介します。

RailsにはRESTfulなURIを生成してくれる便利な機能があり、[キャッシュバック賃貸](http://cbchintai.com/)でもよく使っています。

今回はその機能を利用した記事一覧機能の作り方をご紹介します。

## 記事一覧機能のルーティング設定

まずはroutes.rbでルーティング設定を行います。

RailsではresourcesメソッドでRESTfulなURIを生成できます。

一覧表示にはindexアクションを使うので

```ruby
# config/routes.rb
namespace :blog do
  resources :posts, only: [:index]
end
```

と設定します。

設定してからルーティングを確認すると

    $ rake routes
    blog_posts GET  /blog/posts(.:format) blog/posts#index

という行が出力されます。

ここからは

1. Prefixは`blog_posts`で、`blog_posts_path`といったヘルパーでパスを取得できる
2. `/blog/posts(.:format)`への`GET`リクエストでアクセスできる
3. `blog_posts`コントローラの`index`アクションを実行する

ということがわかります。


## 記事一覧機能のコントローラ

コントローラではindexアクションを実装します。

indexアクションでは一覧用の記事データを取得する必要があるので

```ruby
# app/controllers/blog/posts_controller.rb
def index
  @posts = Blog::Post.all
end
```

というようにBlog::Postモデルのリストを取得します。

## 記事一覧機能のビュー

indexアクションのビューでは取得済みの記事データを表示します。

各記事へのリンクを表示するのであれば

```slim
/ app/views/blog/posts/index.html.slim
ul
  - @posts.each do |blog_post|
    li = link_to blog_post.title, blog_post_path(blog_post.id)
```

と書くことができます。

次は[showアクションでの記事表示]({% post_url 2014-10-03-rails-restful-show %})を行います。
createアクションで記事を作成する

※ この記事は[江の島エンジニアBlog](http://blog.enogineer.com/)の「[createアクションで記事を作成する](http://blog.enogineer.com/2014/10/04/rails-restful-create/)」の転載です。

前回はnewアクションでRESTfulな記事投稿フォーム表示機能を実装しました。今回はその投稿フォームから受け取ったデータで記事を作成するcreateアクションでの実装を行います。



## 記事作成機能のルーティング設定

まずはroutes.rbでcreateアクションのルーティング設定を行います。

```ruby
# config/routes.rb
resources :posts, only: [:create]
```

と設定します。

設定してからルーティングを確認すると

    $ rake routes
    blog_posts POST /blog/posts(.:format) blog/posts#create

という行が出力されます。

このURIは実は[indexアクション]({% post_url 2014-10-03-rails-restful-index %})と同じなのですが、createアクションの場合はGETメソッドではなくPOSTメソッドのリクエストを受け付けるというところが違います。

このようにリクエストメソッドによって動作を変えるところがRESTの大事なポイントです。

ルーティング情報を確認すると

1. Prefixは`blog_posts`で、`blog_posts_path`といったヘルパーでパスを取得できる
2. `/blog/posts(.:format)`への`POST`リクエストでアクセスできる
3. `blog_posts`コントローラの`create`アクションを実行する

ということがわかります。

## 記事作成機能のコントローラ

コントローラではcreateアクションを実装します。

createアクションでは受け取ったパラメタからBlog::Postオブジェクトを作成してデータベースに保存します。

```ruby
# app/controllers/blog/posts_controller.rb
def create
  @post = Blog::Post.new(blog_post_params)
  if @post.save
    flash[:success] = 'created'
    redirect_to blog_posts_path
  else
    render :new
  end
end

private
  def blog_post_params
    params.require(:blog_post).permit(:title, :content)
  end
```

blog_post_paramsというメソッドはRails4の[Strong Parameters](https://github.com/rails/strong_parameters)という機能を使ってマスアサインメント脆弱性を回避しているのですが、詳しい説明はここでは省略します。

## 記事作成機能のビュー

記事作成機能にはビューは用意していません。

記事作成に成功したら記事一覧ページにリダイレクトするように、失敗したら再度記事投稿フォームを表示するようにしています。

ここまでで記事の投稿・閲覧が行えるようになりました。

次回は[editアクションでの記事編集フォーム表示]({% post_url 2014-10-03-rails-restful-edit %})を行います。

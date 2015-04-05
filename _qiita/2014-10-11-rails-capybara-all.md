allメソッドで要素リストを取得する

※ この記事は[江の島エンジニアBlog](http://blog.enogineer.com/)の「[allメソッドで要素リストを取得する](http://blog.enogineer.com/2014/10/11/rails-capybara-all/)」の転載です。

指定したCSSセレクタにマッチする全てのオブジェクトをallメソッドで取得します。

「{{ site.data["category_params"]["rails-capybara"]["title"]}}」第{{page.order_in_category}}回の今回は{{ page.description }}

`find`メソッドでは１個の要素しか取得できませんでしたが、`all`では全要素を取得できます。

例えば

```ruby
all('a')
```

とするとページ内の全てのaタグを取得することができます。

マッチャと組み合わせると

```ruby
subject { all('.breadcrumbs a') }
it { should have(3).items }
```

のようにマッチするCSSセレクタの数を確認したりできます。

次回は[nativeメソッドを使ったネイティブオブジェクトの取得]({% post_url 2014-10-11-rails-capybara-native %})を行います。

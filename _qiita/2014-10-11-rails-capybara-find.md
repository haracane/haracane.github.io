findメソッドでオブジェクトを取得する

※ この記事は[江の島エンジニアBlog](http://blog.enogineer.com/)の「[findメソッドでオブジェクトを取得する](http://blog.enogineer.com/2014/10/11/rails-capybara-find/)」の転載です。

オブジェクトを取得するfindメソッドの使い方を説明します。

「{{ site.data["category_params"]["rails-capybara"]["title"]}}」第{{page.order_in_category}}回の今回は{{ page.description }}

`find`メソッドではCSSセレクタで要素を指定して

```ruby
find('div.content')
```

のように要素を取得します。

この`find`メソッドを使うと例えば

```ruby
subject { find('div.content') }
it { should have_link 'Rails＋RSpecでCapybara入門', href: '/categories/rails-capybara/' }
```

のように要素を指定してマッチャを使うことができます。

次回は[find_buttonメソッドを使ったボタン要素の取得]({% post_url 2014-10-11-rails-capybara-find-button %})を行います。

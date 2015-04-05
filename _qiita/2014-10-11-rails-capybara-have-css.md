have_cssマッチャで指定したタグの内容を確認する

※ この記事は[江の島エンジニアBlog](http://blog.enogineer.com/)の「[have_cssマッチャで指定したタグの内容を確認する](http://blog.enogineer.com/2014/10/11/rails-capybara-have-css/)」の転載です。

タグを指定してページ内容を確認できるhave_cssマッチャの使い方を紹介します。

「{{ site.data["category_params"]["rails-capybara"]["title"]}}」第{{page.order_in_category}}回の今回は{{ page.description }}

`have_css`マッチャで指定したタグの内容の確認を行うには

```ruby
it { should have_css 'h1', text: '江の島エンジニアBlog' }
```

のようにマッチャを使います。

タグの指定にはCSSセレクタを指定できるので

次回は[have_buttonマッチャを使った指定したボタンの確認]({% post_url 2014-10-11-rails-capybara-have-button %})を行います。

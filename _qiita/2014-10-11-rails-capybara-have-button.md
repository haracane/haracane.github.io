have_buttonマッチャで指定したボタンを確認する

※ この記事は[江の島エンジニアBlog](http://blog.enogineer.com/)の「[have_buttonマッチャで指定したボタンを確認する](http://blog.enogineer.com/2014/10/11/rails-capybara-have-button/)」の転載です。

投稿フォームの確認などで必要になるhave_buttonマッチャでの指定したボタンの確認テストを行います。

「{{ site.data["category_params"]["rails-capybara"]["title"]}}」第{{page.order_in_category}}回の今回は{{ page.description }}

`have_button`マッチャで指定したボタンの確認を行うには

```ruby
it { should have_button '投稿する' }
```

のようにマッチャを使います。

ボタンの確認は特に難しいこともないのでこれでおしまいです。

次回は[have_fieldマッチャを使った指定した入力フィールドの確認]({% post_url 2014-10-11-rails-capybara-have-field %})を行います。

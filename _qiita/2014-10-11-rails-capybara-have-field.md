have_fieldマッチャで指定した入力フィールドを確認する

※ この記事は[江の島エンジニアBlog](http://blog.enogineer.com/)の「[have_fieldマッチャで指定した入力フィールドを確認する](http://blog.enogineer.com/2014/10/11/rails-capybara-have-field/)」の転載です。

フォームの入力フィールドをhave_fieldマッチャで確認テストを行います。

「{{ site.data["category_params"]["rails-capybara"]["title"]}}」第{{page.order_in_category}}回の今回は{{ page.description }}

`have_field`マッチャでname属性が"title"の入力フィールドがあることを確認するには

```ruby
it { should have_field 'title' }
```

のようにマッチャを使います。

フィールドの入力内容の確認をしたい場合は`with`オプションを使います。

```ruby
it { should have_field 'title', with: 'Rails4＋RSpecでCapybara入門' }
```

次回は[have_checked_fieldマッチャを使った指定したチェックボックス/ラジオボタンの確認]({% post_url 2014-10-11-rails-capybara-have-checked-field %})を行います。

have_unchecked_fieldマッチャで指定したチェックボックス/ラジオボタンを確認する

※ この記事は[江の島エンジニアBlog](http://blog.enogineer.com/)の「[have_unchecked_fieldマッチャで指定したチェックボックス/ラジオボタンを確認する](http://blog.enogineer.com/2014/10/11/rails-capybara-have-unchecked-field/)」の転載です。

選択されていないチェックボックスやラジオボタンがあることをhave_unchecked_fieldマッチャで確認します。

「{{ site.data["category_params"]["rails-capybara"]["title"]}}」第{{page.order_in_category}}回の今回は{{ page.description }}

`have_unchecked_field`マッチャで指定したチェックボックス/ラジオボタンの確認を行うには

```ruby
it { should have_unchecked_field 'publish', with: '公開しない' }
```

のようにマッチャを使います。

この場合は「公開しない」のチェックボックスまたはラジオボタンが選択されていないを確認しています。

次回は[have_selectマッチャを使った指定したセレクトボックスの選択内容の確認]({% post_url 2014-10-11-rails-capybara-have-select %})を行います。

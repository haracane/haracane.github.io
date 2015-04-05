have_checked_fieldマッチャで指定したチェックボックス/ラジオボタンを確認する

※ この記事は[江の島エンジニアBlog](http://blog.enogineer.com/)の「[have_checked_fieldマッチャで指定したチェックボックス/ラジオボタンを確認する](http://blog.enogineer.com/2014/10/11/rails-capybara-have-checked-field/)」の転載です。

選択されているチェックボックスやラジオボタンがあることをhave_checked_fieldマッチャで確認します。

「{{ site.data["category_params"]["rails-capybara"]["title"]}}」第{{page.order_in_category}}回の今回は{{ page.description }}

`have_checked_field`マッチャでname属性が"publish"のチェックボックス/ラジオボタンがあることを確認するには

```ruby
it { should have_checked_field 'publish', with '公開する' }
```

のようにマッチャを使います。

この場合は「公開する」のチェックボックスまたはラジオボタンが選択されていることを確認しています。

チェックボックス/ラジオボタンの確認は特に難しいこともないのでこれでおしまいです。

次回はhave_checked_fieldの反対の[have_unchecked_fieldマッチャを使った指定したチェックボックス/ラジオボタンの確認]({% post_url 2014-10-11-rails-capybara-have-unchecked-field %})を行います。

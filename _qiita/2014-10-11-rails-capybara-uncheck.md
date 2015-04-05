uncheckメソッドでチェックボックスを選択解除する

※ この記事は[江の島エンジニアBlog](http://blog.enogineer.com/)の「[uncheckメソッドでチェックボックスを選択解除する](http://blog.enogineer.com/2014/10/11/rails-capybara-uncheck/)」の転載です。

チェックボックスを選択解除するuncheckメソッドの使い方を説明します。

「{{ site.data["category_params"]["rails-capybara"]["title"]}}」第{{page.order_in_category}}回の今回は{{ page.description }}

`uncheck`メソッドでid属性が"publish"のチェックボックスを選択解除するには

```ruby
uncheck 'publish'
```

のようにメソッドを使います。

ここまででCapybaraでのフォーム入力はおしまいです。

次回からは[findメソッドを使った少し進んだCapybaraの使い方]({% post_url 2014-10-11-rails-capybara-find %})などを紹介します。

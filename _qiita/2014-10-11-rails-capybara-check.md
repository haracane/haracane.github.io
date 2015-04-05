checkメソッドでチェックボックスを選択する

※ この記事は[江の島エンジニアBlog](http://blog.enogineer.com/)の「[checkメソッドでチェックボックスを選択する](http://blog.enogineer.com/2014/10/11/rails-capybara-check/)」の転載です。

チェックボックスを選択するcheckメソッドの使い方を説明します。

「{{ site.data["category_params"]["rails-capybara"]["title"]}}」第{{page.order_in_category}}回の今回は{{ page.description }}

`check`メソッドでid属性が"publish"のチェックボックスを選択するには

```ruby
check 'publish'
```

のようにメソッドを使います。

次回はcheckメソッドの反対の[uncheckメソッドを使ったチェックボックスの選択解除]({% post_url 2014-10-11-rails-capybara-uncheck %})を行います。

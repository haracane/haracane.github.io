chooseメソッドでラジオボタンから要素を選択する

※ この記事は[江の島エンジニアBlog](http://blog.enogineer.com/)の「[chooseメソッドでラジオボタンから要素を選択する](http://blog.enogineer.com/2014/10/11/rails-capybara-choose/)」の転載です。

ラジオボタンを選択するchooseメソッドを紹介します。

「{{ site.data["category_params"]["rails-capybara"]["title"]}}」第{{page.order_in_category}}回の今回は{{ page.description }}

## chooseメソッドで指定したラジオボタンから要素を選択する

`choose`メソッドで「公開する」のラベルがついたラジオボタンを選択するには

```ruby
choose '公開する'
```

のようにメソッドを使います。

次回は[checkメソッドを使ったチェックボックスの選択]({% post_url 2014-10-11-rails-capybara-check %})を行います。

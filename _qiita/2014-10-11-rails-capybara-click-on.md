click_onメソッドでボタンをクリックする

※ この記事は[江の島エンジニアBlog](http://blog.enogineer.com/)の「[click_onメソッドでボタンをクリックする](http://blog.enogineer.com/2014/10/11/rails-capybara-click-on/)」の転載です。

ボタンをクリックするclick_onメソッドを紹介します。

「{{ site.data["category_params"]["rails-capybara"]["title"]}}」第{{page.order_in_category}}回の今回は{{ page.description }}

## click_onメソッドで指定したボタンをクリックする

`click_on`メソッドでname属性が"category"のボタンをクリックするには

```ruby
click_on '新規投稿'
```

のようにメソッドを使います。

実際はフォームに入力してからボタンをクリックしてデータを送信することがほとんどですので、次回以降ではフォーム入力のやり方を紹介します。

次回は[fill_inメソッドを使ったフォームの入力]({% post_url 2014-10-11-rails-capybara-fill-in %})を行います。

selectメソッドでセレクトボックスから要素を選択する

※ この記事は[江の島エンジニアBlog](http://blog.enogineer.com/)の「[selectメソッドでセレクトボックスから要素を選択する](http://blog.enogineer.com/2014/10/11/rails-capybara-select/)」の転載です。

セレクトボックスから要素を選択するselectメソッドを紹介します。

「{{ site.data["category_params"]["rails-capybara"]["title"]}}」第{{page.order_in_category}}回の今回は{{ page.description }}

`select`メソッドでname属性が"category"のセレクトボックスから要素を選択するには

```ruby
select 'category', 'Capybara'
```

のようにメソッドを使います。

次回は[chooseメソッドを使ったラジオボタンの選択]({% post_url 2014-10-11-rails-capybara-choose %})を行います。

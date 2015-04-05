find_by_idメソッドでid要素を取得する

※ この記事は[江の島エンジニアBlog](http://blog.enogineer.com/)の「[find_by_idメソッドでid要素を取得する](http://blog.enogineer.com/2014/10/11/rails-capybara-find-by-id/)」の転載です。

idで指定した要素のオブジェクトをfind_by_idメソッドで取得します。

「{{ site.data["category_params"]["rails-capybara"]["title"]}}」第{{page.order_in_category}}回の今回は{{ page.description }}

`find_by_id`メソッドではidを指定して

```ruby
find_by_id('main')
```

のように要素を取得します。

これは`find`メソッドを使って

```ruby
find('#main')
```

としても同じなのですが、より意図が明確な`find_by_id`を使うようにしましょう。

次回は[find_linkメソッドを使ったリンク要素の取得]({% post_url 2014-10-11-rails-capybara-find-link %})を行います。

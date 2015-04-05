find_buttonメソッドでボタン要素を取得する

※ この記事は[江の島エンジニアBlog](http://blog.enogineer.com/)の「[find_buttonメソッドでボタン要素を取得する](http://blog.enogineer.com/2014/10/11/rails-capybara-find-button/)」の転載です。

ボタン要素のオブジェクトをfind_buttonメソッドで取得します。

「{{ site.data["category_params"]["rails-capybara"]["title"]}}」第{{page.order_in_category}}回の今回は{{ page.description }}

`find_button`メソッドではボタンの表示テキストを指定して

```ruby
find_button('投稿する')
```

のように要素を取得します。

マッチャと組み合わせる時は`native`メソッドを組み合わせることが多いのですが、`native`メソッドについては別の回に紹介します。

次回は[find_fieldメソッドを使ったフィールド要素の取得]({% post_url 2014-10-11-rails-capybara-find-field %})を行います。

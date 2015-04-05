find_linkメソッドでリンク要素を取得する

※ この記事は[江の島エンジニアBlog](http://blog.enogineer.com/)の「[find_linkメソッドでリンク要素を取得する](http://blog.enogineer.com/2014/10/11/rails-capybara-find-link/)」の転載です。

リンク要素のオブジェクトをfind_linkメソッドで取得します。

「{{ site.data["category_params"]["rails-capybara"]["title"]}}」第{{page.order_in_category}}回の今回は{{ page.description }}

`find_link`メソッドではリンクテキストを指定して

```ruby
find_link('トップ')
```

のように要素を取得します。

こちらも`find_button`と同じように`native`メソッドを組み合わせることが多いのですが、`native`メソッドについては別の回に紹介します。

find系のメソッドについてはこちらでおしまいです。

次回は[allメソッドを使った要素リストの取得]({% post_url 2014-10-11-rails-capybara-all %})を行います。

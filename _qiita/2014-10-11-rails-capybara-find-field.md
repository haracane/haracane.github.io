find_fieldメソッドでフィールド要素を取得する

※ この記事は[江の島エンジニアBlog](http://blog.enogineer.com/)の「[find_fieldメソッドでフィールド要素を取得する](http://blog.enogineer.com/2014/10/11/rails-capybara-find-field/)」の転載です。

フィールド要素のオブジェクトをfind_fieldメソッド取得します。

「{{ site.data["category_params"]["rails-capybara"]["title"]}}」第{{page.order_in_category}}回の今回は{{ page.description }}

`find_field`メソッドではボタンの表示テキストを指定して

```ruby
find_field('投稿する')
```

のように要素を取得します。

マッチャと組み合わせると

```ruby
subject { find_field('title') }
its(:text) { should 'find_fieldメソッドでフィールド要素を取得する' }
```

のように入力テキストの内容を確認したりできます。

次回は[find_by_idメソッドを使ったid要素の取得]({% post_url 2014-10-11-rails-capybara-find-by-id %})を行います。

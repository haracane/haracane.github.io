nativeメソッドでネイティブオブジェクトを取得する

※ この記事は[江の島エンジニアBlog](http://blog.enogineer.com/)の「[nativeメソッドでネイティブオブジェクトを取得する](http://blog.enogineer.com/2014/10/11/rails-capybara-native/)」の転載です。

ネイティブオブジェクトを取得するnativeメソッドの使い方を説明します。

「{{ site.data["category_params"]["rails-capybara"]["title"]}}」第{{page.order_in_category}}回の今回は{{ page.description }}

`find`メソッドで取得したオブジェクトで`native`メソッドを実行するとNokogiri::XML::Elementオブジェクトを取得できます。

```ruby
find('h1').native
```

こちらを使うと例えば要素に指定されているclassの確認などを行えます。

```ruby
it { expect(find_button('投稿する').native["class"]).to eq 'btn' }
```

`native`メソッドを使うと何でもできてしまうのですが、あまり使いすぎるとテストが読みにくくなるので必要な時だけ使うようにしましょう。

次回は[Capybaraでmeta要素をテストする方法]({ post_url 2014-10-11-rails-capybara-meta-content })を紹介します。

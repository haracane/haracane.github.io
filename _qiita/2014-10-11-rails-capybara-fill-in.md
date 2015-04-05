fill_inメソッドでフォームにテキストを入力する

※ この記事は[江の島エンジニアBlog](http://blog.enogineer.com/)の「[fill_inメソッドでフォームにテキストを入力する](http://blog.enogineer.com/2014/10/11/rails-capybara-fill-in/)」の転載です。

フォームにテキストを入力するfill_inメソッドの使い方を説明します。

「{{ site.data["category_params"]["rails-capybara"]["title"]}}」第{{page.order_in_category}}回の今回は{{ page.description }}

`fill_in`メソッドでname属性が"title"の入力フィールド/テキストエリアにテキストを入力するには

```ruby
fill_in 'title', 'Rails4＋RSpecでCapybara入門'
```

のようにメソッドを使います。

普通はフォーム入力→送信→結果確認という遷移をテストするので、その場合は

```ruby
before do
  fill_in 'title', 'Rails4＋RSpecでCapybara入門'
  click_on '投稿する'
end

subject { page }
it { should have_title '投稿完了' }
```

のようにテストケースを書きます。

次回は[selectメソッドを使ったセレクトボックスの選択]({% post_url 2014-10-11-rails-capybara-select %})を行います。

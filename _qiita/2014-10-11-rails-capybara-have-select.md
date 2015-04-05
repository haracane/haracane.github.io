have_selectマッチャで指定したセレクトボックスの選択内容を確認する

※ この記事は[江の島エンジニアBlog](http://blog.enogineer.com/)の「[have_selectマッチャで指定したセレクトボックスの選択内容を確認する](http://blog.enogineer.com/2014/10/11/rails-capybara-have-select/)」の転載です。

セレクトボックスの内容をhave_selectマッチャで確認します。

「{{ site.data["category_params"]["rails-capybara"]["title"]}}」第{{page.order_in_category}}回の今回は{{ page.description }}

`have_select`マッチャでname属性が"category"のセレクトボックスがあることを確認するには

```ruby
it { should have_select 'category', selected: 'Capybara' }
```

のようにマッチャを使います。

何も選択されていないことを確認するには空のリストを指定して

```ruby
it { should have_select 'category', selected: [] }
```

というようにします。

次回からはCapybaraでのフォーム入力を行います。

まずは[click_onメソッドでのフォーム送信]({% post_url 2014-10-11-rails-capybara-click-on %})から始めます。

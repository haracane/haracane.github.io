Basic認証が必要なページをテストする

※ この記事は[江の島エンジニアBlog](http://blog.enogineer.com/)の「[Basic認証が必要なページをテストする](http://blog.enogineer.com/2014/10/11/rails-capybara-basic-auth/)」の転載です。

CapybaraでBasic認証をパスする方法を紹介します。

「{{ site.data["category_params"]["rails-capybara"]["title"]}}」第{{page.order_in_category}}回の今回は{{ page.description }}

Basic認証をパスするには`driver`というメソッドを使って

```ruby
page.driver.browser.authorize('username', 'password'])
```

を実行します。

例えば

```ruby
before do
  page.driver.browser.authorize('username', 'password'])
  visit '/secret/'
end
subject { page }

it { should have_title '秘密のページ' }
```

とテストを書けばBasic認証が設定された秘密のページの内容をテストすることができます。

次回は[ログインが必要なページのテスト]({% post_url 2014-10-11-rails-capybara-login %})を行います。

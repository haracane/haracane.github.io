find＆nativeメソッドでmeta要素をテストする

※ この記事は[江の島エンジニアBlog](http://blog.enogineer.com/)の「[find＆nativeメソッドでmeta要素をテストする](http://blog.enogineer.com/2014/10/11/rails-capybara-meta-content/)」の転載です。

keywordsやdescriptionなどのmeta要素をテストする方法を紹介します。

「{{ site.data["category_params"]["rails-capybara"]["title"]}}」第{{page.order_in_category}}回の今回は{{ page.description }}

Capybaraを使ってmeta要素のテストをするには、まず`find`メソッドでmeta要素を取得します

```ruby
let(:meta) { page.find('meta[name="description"]', visible: false) }
```

ここの例ではdescriptionが設定されているmeta要素を取得しています。

なお、`visible: false`はmeta要素のように画面表示しない要素を取得する場合に必要となるオプションです。

続いてこの内容を`native`メソッドを使って取得します

```ruby
subject { meta.native["content"] }
```

これでmeta要素のdescription内容を取得できるので、あとは

```ruby
it { should match /Capybara入門/ }
```

のように内容を確認すればOKです。

次回は[Basic認証を設定しているページのテスト]({% post_url 2014-10-11-rails-capybara-basic-auth %})を行います。

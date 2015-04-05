have_titleマッチャでタイトル内容を確認する

※ この記事は[江の島エンジニアBlog](http://blog.enogineer.com/)の「[have_titleマッチャでタイトル内容を確認する](http://blog.enogineer.com/2014/10/11/rails-capybara-have-title/)」の転載です。

Capybaraの導入とhave_titleマッチャでのタイトル内容テストを行います。

この連載ではRails4でCapybaraを使ったテストのやり方を順番に紹介します。

「{{ site.data["category_params"]["rails-capybara"]["title"]}}」第{{page.order_in_category}}回の今回は{{ page.description }}

## Capybaraとは

CapybaraはWebページのテストを簡単にしてくれるツールです。

どう簡単になるかはなかなか説明が難しいのですが、この連載を読み進めてもらって簡単さを感じてもらえるといいなと思っています。がんばります。

## Capybaraのインストール

いつも通りGemfileに

    gem 'capybara'

を追加して`bundle install`を実行すればOKです。

## Capybaraでのテストコードを作る

テストコードは`spec/features`以下に作るのがお決まりのようです。

例えばこんな感じでテストコードのひな形を用意します。

```ruby
# spec/features/view_top_page_spec.rb
require 'rails_helper'

describe 'view top page', type: :feature do
end
```

## Capybaraでサイトにアクセスする

Capybaraではサイトにアクセスして、その内容を確認するという形でテストを行います。

まずはサイトにアクセスする必要があるのですが、それには`visit`メソッドを使います。

例えばトップページにアクセスするのであれば

```ruby
visit '/'
```

と書きます。

もし他の`/about.html`などにアクセスするのであれば

```ruby
visit '/about.html'
```

と書けばOKです。

## have_titleマッチャでタイトル内容を確認する

`visit`メソッドでページにアクセスすると`page`メソッドでページ内容を取得できるようになるので、次はページ内容の確認をします。

`have_title`マッチャでのタイトル内容確認を行うので

```ruby
expect(page).to have_title '江の島エンジニアBlog'
```

のようにマッチャを使います。

これでCapybaraでのタイトル内容確認はOKです。

ここまでのテストコードをまとめると

```ruby
# spec/features/view_top_page_spec.rb
require 'rails_helper'

describe 'view top page', type: :feature do
  scenario do
    visit '/'
    expect(page).to have_title '江の島エンジニアBlog'
  end
end
```

となります。

なお、`scenario`は`it`のエイリアスなので`it`を使っても良いのですがCapybaraでのテストコードでは`scenario`を使うのが通例となっています。

## テストを実行する

実際にテストを実行すると

    $ bundle exec rspec spec/features/view_top_page_spec.rb
    view top page
      should have title "江の島エンジニアBlog"

    Finished in 2.29 seconds (files took 6.57 seconds to load)
    1 example, 0 failures

と無事タイトル確認のテストが成功しました。

## まとめ

Capybaraの導入とタイトル内容確認テストを行いました。

次回は[have_contentマッチャでのコンテンツ内容の確認]({% post_url 2014-10-11-rails-capybara-have-content %})をします。

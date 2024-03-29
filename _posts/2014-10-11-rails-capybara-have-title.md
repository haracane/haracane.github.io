---
author: haracane
layout: post
title: have_titleマッチャでタイトル内容を確認する
date: 2014-10-11 08:32:44J
tags:
- Capybara
- RSpec
- Rails
- Ruby
keywords: have_title Capybara 入門 RSpec Rails Ruby
categories:
- rails-capybara
description: Capybaraの導入とhave_titleマッチャでのタイトル内容テストを行います。
image: "/assets/images/posts/rspec.png"
---
<!-- tag_links -->
[Capybara](/tags/capybara/) / [RSpec](/tags/rspec/) / [Rails](/tags/rails/) / [Ruby](/tags/ruby/)

<!-- category_links -->
連載: [Rails4＋RSpec＋Capybaraでよく使うマッチャ＆メソッド22個+α]({% post_url 2014-10-30-rails-capybara-index %})

<!-- content -->
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

{% highlight ruby %}
# spec/features/view_top_page_spec.rb
require 'rails_helper'

describe 'view top page', type: :feature do
end
{% endhighlight %}

## Capybaraでサイトにアクセスする

Capybaraではサイトにアクセスして、その内容を確認するという形でテストを行います。

まずはサイトにアクセスする必要があるのですが、それには`visit`メソッドを使います。

例えばトップページにアクセスするのであれば

{% highlight ruby %}
visit '/'
{% endhighlight %}

と書きます。

もし他の`/about.html`などにアクセスするのであれば

{% highlight ruby %}
visit '/about.html'
{% endhighlight %}

と書けばOKです。

## have_titleマッチャでタイトル内容を確認する

`visit`メソッドでページにアクセスすると`page`メソッドでページ内容を取得できるようになるので、次はページ内容の確認をします。

`have_title`マッチャでのタイトル内容確認を行うので

{% highlight ruby %}
expect(page).to have_title '江の島エンジニアBlog'
{% endhighlight %}

のようにマッチャを使います。

これでCapybaraでのタイトル内容確認はOKです。

ここまでのテストコードをまとめると

{% highlight ruby %}
# spec/features/view_top_page_spec.rb
require 'rails_helper'

describe 'view top page', type: :feature do
  scenario do
    visit '/'
    expect(page).to have_title '江の島エンジニアBlog'
  end
end
{% endhighlight %}

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

<!-- category_siblings -->
### 関連記事

{% include categories/rails-capybara.md %}

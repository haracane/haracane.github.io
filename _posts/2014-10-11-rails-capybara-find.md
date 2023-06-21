---
author: haracane
layout: post
title: findメソッドでオブジェクトを取得する
date: 2014-10-11 08:46:45J
tags:
- Capybara
- RSpec
- Rails
- Ruby
keywords: find Capybara 入門 RSpec Rails Ruby
categories: rails-capybara
description: オブジェクトを取得するfindメソッドの使い方を説明します。
image: rspec.png
---
[Capybara](/tags/capybara/) / [RSpec](/tags/rspec/) / [Rails](/tags/rails/) / [Ruby](/tags/ruby/)

「{{ site.data["category_params"]["rails-capybara"]["title"]}}」第{{page.order_in_category}}回の今回は{{ page.description }}

`find`メソッドではCSSセレクタで要素を指定して

{% highlight ruby %}
find('div.content')
{% endhighlight %}

のように要素を取得します。

この`find`メソッドを使うと例えば

{% highlight ruby %}
subject { find('div.content') }
it { should have_link 'Rails＋RSpecでCapybara入門', href: '/categories/rails-capybara/' }
{% endhighlight %}

のように要素を指定してマッチャを使うことができます。

次回は[find_buttonメソッドを使ったボタン要素の取得]({% post_url 2014-10-11-rails-capybara-find-button %})を行います。

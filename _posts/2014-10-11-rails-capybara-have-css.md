---
author: haracane
layout: post
title: have_cssマッチャで指定したタグの内容を確認する
date: 2014-10-11 08:35:44J
tags:
- Capybara
- RSpec
- Rails
- Ruby
keywords: have_css Capybara 入門 RSpec Rails Ruby
categories: rails-capybara
description: タグを指定してページ内容を確認できるhave_cssマッチャの使い方を紹介します。
image: rspec.png
---
[Capybara](/tags/capybara/) / [RSpec](/tags/rspec/) / [Rails](/tags/rails/) / [Ruby](/tags/ruby/)

「{{ site.data["category_params"]["rails-capybara"]["title"]}}」第{{page.order_in_category}}回の今回は{{ page.description }}

`have_css`マッチャで指定したタグの内容の確認を行うには

{% highlight ruby %}
it { should have_css 'h1', text: '江の島エンジニアBlog' }
{% endhighlight %}

のようにマッチャを使います。

タグの指定にはCSSセレクタを指定できるので

次回は[have_buttonマッチャを使った指定したボタンの確認]({% post_url 2014-10-11-rails-capybara-have-button %})を行います。

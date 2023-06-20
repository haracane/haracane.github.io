---
layout: post
title: have_buttonマッチャで指定したボタンを確認する
date: 2014-10-11 08:36:44J
tags: Capybara RSpec Rails Ruby
keywords: have_button Capybara 入門 RSpec Rails Ruby
categories: rails-capybara
description: 投稿フォームの確認などで必要になるhave_buttonマッチャでの指定したボタンの確認テストを行います。
image: rspec.png
---
[Capybara](/tags/capybara/) / [RSpec](/tags/rspec/) / [Rails](/tags/rails/) / [Ruby](/tags/ruby/)

「{{ site.data["category_params"]["rails-capybara"]["title"]}}」第{{page.order_in_category}}回の今回は{{ page.description }}

`have_button`マッチャで指定したボタンの確認を行うには

{% highlight ruby %}
it { should have_button '投稿する' }
{% endhighlight %}

のようにマッチャを使います。

ボタンの確認は特に難しいこともないのでこれでおしまいです。

次回は[have_fieldマッチャを使った指定した入力フィールドの確認]({% post_url 2014-10-11-rails-capybara-have-field %})を行います。

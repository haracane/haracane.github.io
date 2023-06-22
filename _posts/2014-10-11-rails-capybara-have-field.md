---
author: haracane
layout: post
title: have_fieldマッチャで指定した入力フィールドを確認する
date: 2014-10-11 08:37:44J
tags:
- Capybara
- RSpec
- Rails
- Ruby
keywords: have_field Capybara 入門 RSpec Rails Ruby
categories:
- rails-capybara
description: フォームの入力フィールドをhave_fieldマッチャで確認テストを行います。
image: rspec.png
---
<!-- tag_links -->
[Capybara](/tags/capybara/) / [RSpec](/tags/rspec/) / [Rails](/tags/rails/) / [Ruby](/tags/ruby/)

<!-- content -->
「{{ site.data["category_params"]["rails-capybara"]["title"]}}」第{{page.order_in_category}}回の今回は{{ page.description }}

`have_field`マッチャでname属性が"title"の入力フィールドがあることを確認するには

{% highlight ruby %}
it { should have_field 'title' }
{% endhighlight %}

のようにマッチャを使います。

フィールドの入力内容の確認をしたい場合は`with`オプションを使います。

{% highlight ruby %}
it { should have_field 'title', with: 'Rails4＋RSpecでCapybara入門' }
{% endhighlight %}

次回は[have_checked_fieldマッチャを使った指定したチェックボックス/ラジオボタンの確認]({% post_url 2014-10-11-rails-capybara-have-checked-field %})を行います。

---
layout: post
title: have_fieldマッチャで指定した入力フィールドを確認する
date: 2014-10-07 08:37:44J
tags: Capybara RSpec Rails Ruby
keywords: have_field Capybara 入門 RSpec Rails Ruby
categories: rails-capybara
description: 今回はhave_fieldマッチャでの指定した入力フィールドの確認テストを行います。
---

「{{ site.data["category_params"]["rails-capybara"]["title"]}}」第{{page.order_in_category}}回の{{ page.description }}

`have_field`マッチャでname属性が"title"の入力フィールドがあることを確認するには

{% highlight ruby %}
it { should have_field 'title' }
{% endhighlight %}

のようにマッチャを使います。

フィールドの入力内容の確認をしたい場合は`with`オプションを使います。

{% highlight ruby %}
it { should have_field 'title', with: 'Rails4＋RSpecでCapybara入門' }
{% endhighlight %}

次回は[have_checked_fieldマッチャを使った指定したチェックボックス/ラジオボタンの確認]({% post_url 2014-10-07-rails-capybara-have-checked-field %})を行います。

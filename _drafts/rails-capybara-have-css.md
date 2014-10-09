---
layout: post
title: have_cssマッチャで指定したタグの内容を確認する
date: 2014-10-07 08:35:44J
tags: Capybara RSpec Rails Ruby
keywords: have_css Capybara 入門 RSpec Rails Ruby
categories: rails-capybara
description: 今回はhave_cssマッチャでの指定したタグの内容の確認テストを行います。
---

「{{ site.data["category_params"]["rails-capybara"]["title"]}}」第{{page.order_in_category}}回の{{ page.description }}

`have_css`マッチャで指定したタグの内容の確認を行うには

{% highlight ruby %}
it { should have_css 'h1', text: '江の島エンジニアBlog' }
{% endhighlight %}

のようにマッチャを使います。

タグの指定にはCSSセレクタを指定できるので

次回は[have_buttonマッチャを使った指定したボタンの確認]({% post_url 2014-10-07-rails-capybara-have-button %})を行います。

---
layout: post
title: findメソッドでオブジェクトを取得する
date: 2014-10-07 08:46:44J
tags: Capybara RSpec Rails Ruby
keywords: find Capybara 入門 RSpec Rails Ruby
categories: rails-capybara
description: 今回はfindメソッドで指定したオブジェクトを取得します。
---

「{{ site.data["category_params"]["rails-capybara"]["title"]}}」第{{page.order_in_category}}回の{{ page.description }}

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

次回は[find_buttonメソッドを使ったボタン要素の取得]({% post_url 2014-10-07-rails-capybara-find-button %})を行います。

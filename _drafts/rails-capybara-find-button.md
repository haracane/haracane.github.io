---
layout: post
title: find_buttonメソッドでボタン要素を取得する
date: 2014-10-07 08:47:44J
tags: Capybara RSpec Rails Ruby
keywords: find_button Capybara 入門 RSpec Rails Ruby
categories: rails-capybara
description: 今回はfind_buttonメソッドで指定したボタン要素を取得します。
---

「{{ site.data["category_params"]["rails-capybara"]["title"]}}」第{{page.order_in_category}}回の{{ page.description }}

`find_button`メソッドではボタンの表示テキストを指定して

{% highlight ruby %}
find_button('投稿する')
{% endhighlight %}

のように要素を取得します。

マッチャと組み合わせる時は`native`メソッドを組み合わせることが多いのですが、`native`メソッドについては別の回に紹介します。

次回は[find_fieldメソッドを使ったフィールド要素の取得]({% post_url 2014-10-07-rails-capybara-find-field %})を行います。

---
author: haracane
layout: post
title: find_buttonメソッドでボタン要素を取得する
date: 2014-10-11 08:47:44J
tags:
- Capybara
- RSpec
- Rails
- Ruby
keywords: find_button Capybara 入門 RSpec Rails Ruby
categories:
- rails-capybara
description: ボタン要素のオブジェクトをfind_buttonメソッドで取得します。
image: rspec.png
---
<!-- tag_links -->
[Capybara](/tags/capybara/) / [RSpec](/tags/rspec/) / [Rails](/tags/rails/) / [Ruby](/tags/ruby/)

<!-- category_links -->
連載: [Rails4＋RSpec＋Capybaraでよく使うマッチャ＆メソッド22個+α]({% post_url 2014-10-30-rails-capybara-index %})

<!-- content -->
「{{ site.data["category_params"]["rails-capybara"]["title"]}}」第{{page.order_in_category}}回の今回は{{ page.description }}

`find_button`メソッドではボタンの表示テキストを指定して

{% highlight ruby %}
find_button('投稿する')
{% endhighlight %}

のように要素を取得します。

マッチャと組み合わせる時は`native`メソッドを組み合わせることが多いのですが、`native`メソッドについては別の回に紹介します。

次回は[find_fieldメソッドを使ったフィールド要素の取得]({% post_url 2014-10-11-rails-capybara-find-field %})を行います。

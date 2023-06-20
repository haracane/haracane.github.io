---
layout: post
title: chooseメソッドでラジオボタンから要素を選択する
date: 2014-10-11 08:44:44J
tags: Capybara RSpec Rails Ruby
keywords: choose Capybara 入門 RSpec Rails Ruby
categories: rails-capybara
description: ラジオボタンを選択するchooseメソッドを紹介します。
image: rspec.png
---
[Capybara](/tags/capybara/) / [RSpec](/tags/rspec/) / [Rails](/tags/rails/) / [Ruby](/tags/ruby/)

「{{ site.data["category_params"]["rails-capybara"]["title"]}}」第{{page.order_in_category}}回の今回は{{ page.description }}

## chooseメソッドで指定したラジオボタンから要素を選択する

`choose`メソッドで「公開する」のラベルがついたラジオボタンを選択するには

{% highlight ruby %}
choose '公開する'
{% endhighlight %}

のようにメソッドを使います。

次回は[checkメソッドを使ったチェックボックスの選択]({% post_url 2014-10-11-rails-capybara-check %})を行います。

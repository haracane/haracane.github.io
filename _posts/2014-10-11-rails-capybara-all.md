---
author: haracane
layout: post
title: allメソッドで要素リストを取得する
date: 2014-10-11 08:51:44J
tags:
- Capybara
- RSpec
- Rails
- Ruby
keywords: all Capybara 入門 RSpec Rails Ruby
categories:
- rails-capybara
description: 指定したCSSセレクタにマッチする全てのオブジェクトをallメソッドで取得します。
image: rspec.png
---
[Capybara](/tags/capybara/) / [RSpec](/tags/rspec/) / [Rails](/tags/rails/) / [Ruby](/tags/ruby/)

「{{ site.data["category_params"]["rails-capybara"]["title"]}}」第{{page.order_in_category}}回の今回は{{ page.description }}

`find`メソッドでは１個の要素しか取得できませんでしたが、`all`では全要素を取得できます。

例えば

{% highlight ruby %}
all('a')
{% endhighlight %}

とするとページ内の全てのaタグを取得することができます。

マッチャと組み合わせると

{% highlight ruby %}
subject { all('.breadcrumbs a') }
it { should have(3).items }
{% endhighlight %}

のようにマッチするCSSセレクタの数を確認したりできます。

次回は[nativeメソッドを使ったネイティブオブジェクトの取得]({% post_url 2014-10-11-rails-capybara-native %})を行います。

---
author: haracane
layout: post
title: uncheckメソッドでチェックボックスを選択解除する
date: 2014-10-11 08:46:44J
tags:
- Capybara
- RSpec
- Rails
- Ruby
keywords: uncheck Capybara 入門 RSpec Rails Ruby
categories:
- rails-capybara
description: チェックボックスを選択解除するuncheckメソッドの使い方を説明します。
image: rspec.png
---
<!-- tag_links -->
[Capybara](/tags/capybara/) / [RSpec](/tags/rspec/) / [Rails](/tags/rails/) / [Ruby](/tags/ruby/)

<!-- category_links -->
連載: [Rails4＋RSpec＋Capybaraでよく使うマッチャ＆メソッド22個+α]({% post_url 2014-10-30-rails-capybara-index %})

<!-- content -->
「{{ site.data["category_params"]["rails-capybara"]["title"]}}」第{{page.order_in_category}}回の今回は{{ page.description }}

`uncheck`メソッドでid属性が"publish"のチェックボックスを選択解除するには

{% highlight ruby %}
uncheck 'publish'
{% endhighlight %}

のようにメソッドを使います。

ここまででCapybaraでのフォーム入力はおしまいです。

次回からは[findメソッドを使った少し進んだCapybaraの使い方]({% post_url 2014-10-11-rails-capybara-find %})などを紹介します。

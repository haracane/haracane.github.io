---
author: haracane
layout: post
title: click_onメソッドでボタンをクリックする
date: 2014-10-11 08:41:44J
tags:
- Capybara
- RSpec
- Rails
- Ruby
keywords: click_on Capybara 入門 RSpec Rails Ruby
categories:
- rails-capybara
description: ボタンをクリックするclick_onメソッドを紹介します。
image: rspec.png
---
<!-- tag_links -->
[Capybara](/tags/capybara/) / [RSpec](/tags/rspec/) / [Rails](/tags/rails/) / [Ruby](/tags/ruby/)

<!-- category_links -->
連載: [Rails4＋RSpec＋Capybaraでよく使うマッチャ＆メソッド22個+α]({% post_url 2014-10-30-rails-capybara-index %})

<!-- content -->
「{{ site.data["category_params"]["rails-capybara"]["title"]}}」第{{page.order_in_category}}回の今回は{{ page.description }}

## click_onメソッドで指定したボタンをクリックする

`click_on`メソッドでname属性が"category"のボタンをクリックするには

{% highlight ruby %}
click_on '新規投稿'
{% endhighlight %}

のようにメソッドを使います。

実際はフォームに入力してからボタンをクリックしてデータを送信することがほとんどですので、次回以降ではフォーム入力のやり方を紹介します。

次回は[fill_inメソッドを使ったフォームの入力]({% post_url 2014-10-11-rails-capybara-fill-in %})を行います。

<!-- category_siblings -->
### 関連記事

{% include categories/rails-capybara.md %}

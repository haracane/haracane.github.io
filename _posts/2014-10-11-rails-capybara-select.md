---
author: haracane
layout: post
title: selectメソッドでセレクトボックスから要素を選択する
date: 2014-10-11 08:43:44J
tags:
- Capybara
- RSpec
- Rails
- Ruby
keywords: select Capybara 入門 RSpec Rails Ruby
categories:
- rails-capybara
description: セレクトボックスから要素を選択するselectメソッドを紹介します。
image: rspec.png
---
<!-- tag_links -->
[Capybara](/tags/capybara/) / [RSpec](/tags/rspec/) / [Rails](/tags/rails/) / [Ruby](/tags/ruby/)

<!-- category_links -->
連載: [Rails4＋RSpec＋Capybaraでよく使うマッチャ＆メソッド22個+α]({% post_url 2014-10-30-rails-capybara-index %})

<!-- content -->
「{{ site.data["category_params"]["rails-capybara"]["title"]}}」第{{page.order_in_category}}回の今回は{{ page.description }}

`select`メソッドでname属性が"category"のセレクトボックスから要素を選択するには

{% highlight ruby %}
select 'category', 'Capybara'
{% endhighlight %}

のようにメソッドを使います。

次回は[chooseメソッドを使ったラジオボタンの選択]({% post_url 2014-10-11-rails-capybara-choose %})を行います。

<!-- category_siblings -->
### 関連記事

{% include categories/rails-capybara.md %}

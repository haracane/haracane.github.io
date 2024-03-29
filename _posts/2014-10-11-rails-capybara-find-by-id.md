---
author: haracane
layout: post
title: find_by_idメソッドでid要素を取得する
date: 2014-10-11 08:49:44J
tags:
- Capybara
- RSpec
- Rails
- Ruby
keywords: find_by_id Capybara 入門 RSpec Rails Ruby
categories:
- rails-capybara
description: idで指定した要素のオブジェクトをfind_by_idメソッドで取得します。
image: "/assets/images/posts/rspec.png"
---
<!-- tag_links -->
[Capybara](/tags/capybara/) / [RSpec](/tags/rspec/) / [Rails](/tags/rails/) / [Ruby](/tags/ruby/)

<!-- category_links -->
連載: [Rails4＋RSpec＋Capybaraでよく使うマッチャ＆メソッド22個+α]({% post_url 2014-10-30-rails-capybara-index %})

<!-- content -->
「{{ site.data["category_params"]["rails-capybara"]["title"]}}」第{{page.order_in_category}}回の今回は{{ page.description }}

`find_by_id`メソッドではidを指定して

{% highlight ruby %}
find_by_id('main')
{% endhighlight %}

のように要素を取得します。

これは`find`メソッドを使って

{% highlight ruby %}
find('#main')
{% endhighlight %}

としても同じなのですが、より意図が明確な`find_by_id`を使うようにしましょう。

次回は[find_linkメソッドを使ったリンク要素の取得]({% post_url 2014-10-11-rails-capybara-find-link %})を行います。

<!-- category_siblings -->
### 関連記事

{% include categories/rails-capybara.md %}

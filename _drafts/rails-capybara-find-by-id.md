---
layout: post
title: find_by_idメソッドでid要素を取得する
date: 2014-10-07 08:49:44J
tags: Capybara RSpec Rails Ruby
keywords: find_by_id Capybara 入門 RSpec Rails Ruby
categories: rails-capybara
description: 今回はfind_by_idメソッドで指定したid要素を取得します。
---

「{{ site.data["category_params"]["rails-capybara"]["title"]}}」第{{page.order_in_category}}回の{{ page.description }}

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

次回は[find_linkメソッドを使ったリンク要素の取得]({% post_url 2014-10-07-rails-capybara-find-link %})を行います。

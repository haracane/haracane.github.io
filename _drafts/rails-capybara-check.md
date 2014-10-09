---
layout: post
title: checkメソッドでチェックボックスを選択する
date: 2014-10-07 08:45:44J
tags: Capybara RSpec Rails Ruby
keywords: check Capybara 入門 RSpec Rails Ruby
categories: rails-capybara
description: 今回はcheckメソッドで指定したチェックボックスを選択します。
---

「{{ site.data["category_params"]["rails-capybara"]["title"]}}」第{{page.order_in_category}}回の{{ page.description }}

`check`メソッドでid属性が"publish"のチェックボックスを選択するには

{% highlight ruby %}
check 'publish'
{% endhighlight %}

のようにメソッドを使います。

次回はcheckメソッドの反対の[uncheckメソッドを使ったチェックボックスの選択解除]({% post_url 2014-10-07-rails-capybara-uncheck %})を行います。

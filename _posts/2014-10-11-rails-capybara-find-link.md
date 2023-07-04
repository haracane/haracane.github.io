---
author: haracane
layout: post
title: find_linkメソッドでリンク要素を取得する
date: 2014-10-11 08:50:44J
tags:
- Capybara
- RSpec
- Rails
- Ruby
keywords: find_link Capybara 入門 RSpec Rails Ruby
categories:
- rails-capybara
description: リンク要素のオブジェクトをfind_linkメソッドで取得します。
image: "/assets/images/posts/rspec.png"
---
<!-- tag_links -->
[Capybara](/tags/capybara/) / [RSpec](/tags/rspec/) / [Rails](/tags/rails/) / [Ruby](/tags/ruby/)

<!-- category_links -->
連載: [Rails4＋RSpec＋Capybaraでよく使うマッチャ＆メソッド22個+α]({% post_url 2014-10-30-rails-capybara-index %})

<!-- content -->
「{{ site.data["category_params"]["rails-capybara"]["title"]}}」第{{page.order_in_category}}回の今回は{{ page.description }}

`find_link`メソッドではリンクテキストを指定して

{% highlight ruby %}
find_link('トップ')
{% endhighlight %}

のように要素を取得します。

こちらも`find_button`と同じように`native`メソッドを組み合わせることが多いのですが、`native`メソッドについては別の回に紹介します。

find系のメソッドについてはこちらでおしまいです。

次回は[allメソッドを使った要素リストの取得]({% post_url 2014-10-11-rails-capybara-all %})を行います。

<!-- category_siblings -->
### 関連記事

{% include categories/rails-capybara.md %}

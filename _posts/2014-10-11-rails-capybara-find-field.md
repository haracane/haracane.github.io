---
author: haracane
layout: post
title: find_fieldメソッドでフィールド要素を取得する
date: 2014-10-11 08:48:44J
tags:
- Capybara
- RSpec
- Rails
- Ruby
keywords: find_field Capybara 入門 RSpec Rails Ruby
categories:
- rails-capybara
description: フィールド要素のオブジェクトをfind_fieldメソッド取得します。
image: "/assets/images/posts/rspec.png"
---
<!-- tag_links -->
[Capybara](/tags/capybara/) / [RSpec](/tags/rspec/) / [Rails](/tags/rails/) / [Ruby](/tags/ruby/)

<!-- category_links -->
連載: [Rails4＋RSpec＋Capybaraでよく使うマッチャ＆メソッド22個+α]({% post_url 2014-10-30-rails-capybara-index %})

<!-- content -->
「{{ site.data["category_params"]["rails-capybara"]["title"]}}」第{{page.order_in_category}}回の今回は{{ page.description }}

`find_field`メソッドではボタンの表示テキストを指定して

{% highlight ruby %}
find_field('投稿する')
{% endhighlight %}

のように要素を取得します。

マッチャと組み合わせると

{% highlight ruby %}
subject { find_field('title') }
its(:text) { should 'find_fieldメソッドでフィールド要素を取得する' }
{% endhighlight %}

のように入力テキストの内容を確認したりできます。

次回は[find_by_idメソッドを使ったid要素の取得]({% post_url 2014-10-11-rails-capybara-find-by-id %})を行います。

<!-- category_siblings -->
### 関連記事

{% include categories/rails-capybara.md %}

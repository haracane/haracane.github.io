---
author: haracane
layout: post
title: have_selectマッチャで指定したセレクトボックスの選択内容を確認する
date: 2014-10-11 08:40:44J
tags:
- Capybara
- RSpec
- Rails
- Ruby
keywords: have_select Capybara 入門 RSpec Rails Ruby
categories:
- rails-capybara
description: セレクトボックスの内容をhave_selectマッチャで確認します。
image: rspec.png
---
<!-- tag_links -->
[Capybara](/tags/capybara/) / [RSpec](/tags/rspec/) / [Rails](/tags/rails/) / [Ruby](/tags/ruby/)

<!-- category_links -->
連載: [Rails4＋RSpec＋Capybaraでよく使うマッチャ＆メソッド22個+α]({% post_url 2014-10-30-rails-capybara-index %})

<!-- content -->
「{{ site.data["category_params"]["rails-capybara"]["title"]}}」第{{page.order_in_category}}回の今回は{{ page.description }}

`have_select`マッチャでname属性が"category"のセレクトボックスがあることを確認するには

{% highlight ruby %}
it { should have_select 'category', selected: 'Capybara' }
{% endhighlight %}

のようにマッチャを使います。

何も選択されていないことを確認するには空のリストを指定して

{% highlight ruby %}
it { should have_select 'category', selected: [] }
{% endhighlight %}

というようにします。

次回からはCapybaraでのフォーム入力を行います。

まずは[click_onメソッドでのフォーム送信]({% post_url 2014-10-11-rails-capybara-click-on %})から始めます。

<!-- category_siblings -->
### 関連記事

{% include categories/rails-capybara.md %}

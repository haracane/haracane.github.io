---
author: haracane
layout: post
title: have_unchecked_fieldマッチャで指定したチェックボックス/ラジオボタンを確認する
date: 2014-10-11 08:39:44J
tags:
- Capybara
- RSpec
- Rails
- Ruby
keywords: have_unchecked_field Capybara 入門 RSpec Rails Ruby
categories:
- rails-capybara
description: 選択されていないチェックボックスやラジオボタンがあることをhave_unchecked_fieldマッチャで確認します。
image: "/assets/images/posts/rspec.png"
---
<!-- tag_links -->
[Capybara](/tags/capybara/) / [RSpec](/tags/rspec/) / [Rails](/tags/rails/) / [Ruby](/tags/ruby/)

<!-- category_links -->
連載: [Rails4＋RSpec＋Capybaraでよく使うマッチャ＆メソッド22個+α]({% post_url 2014-10-30-rails-capybara-index %})

<!-- content -->
「{{ site.data["category_params"]["rails-capybara"]["title"]}}」第{{page.order_in_category}}回の今回は{{ page.description }}

`have_unchecked_field`マッチャで指定したチェックボックス/ラジオボタンの確認を行うには

{% highlight ruby %}
it { should have_unchecked_field 'publish', with: '公開しない' }
{% endhighlight %}

のようにマッチャを使います。

この場合は「公開しない」のチェックボックスまたはラジオボタンが選択されていないを確認しています。

次回は[have_selectマッチャを使った指定したセレクトボックスの選択内容の確認]({% post_url 2014-10-11-rails-capybara-have-select %})を行います。

<!-- category_siblings -->
### 関連記事

{% include categories/rails-capybara.md %}

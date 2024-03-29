---
author: haracane
layout: post
title: have_checked_fieldマッチャで指定したチェックボックス/ラジオボタンを確認する
date: 2014-10-11 08:38:44J
tags:
- Capybara
- RSpec
- Rails
- Ruby
keywords: have_checked_field Capybara 入門 RSpec Rails Ruby
categories:
- rails-capybara
description: 選択されているチェックボックスやラジオボタンがあることをhave_checked_fieldマッチャで確認します。
image: "/assets/images/posts/rspec.png"
---
<!-- tag_links -->
[Capybara](/tags/capybara/) / [RSpec](/tags/rspec/) / [Rails](/tags/rails/) / [Ruby](/tags/ruby/)

<!-- category_links -->
連載: [Rails4＋RSpec＋Capybaraでよく使うマッチャ＆メソッド22個+α]({% post_url 2014-10-30-rails-capybara-index %})

<!-- content -->
「{{ site.data["category_params"]["rails-capybara"]["title"]}}」第{{page.order_in_category}}回の今回は{{ page.description }}

`have_checked_field`マッチャでname属性が"publish"のチェックボックス/ラジオボタンがあることを確認するには

{% highlight ruby %}
it { should have_checked_field 'publish', with '公開する' }
{% endhighlight %}

のようにマッチャを使います。

この場合は「公開する」のチェックボックスまたはラジオボタンが選択されていることを確認しています。

チェックボックス/ラジオボタンの確認は特に難しいこともないのでこれでおしまいです。

次回はhave_checked_fieldの反対の[have_unchecked_fieldマッチャを使った指定したチェックボックス/ラジオボタンの確認]({% post_url 2014-10-11-rails-capybara-have-unchecked-field %})を行います。

<!-- category_siblings -->
### 関連記事

{% include categories/rails-capybara.md %}

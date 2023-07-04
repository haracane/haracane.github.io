---
author: haracane
layout: post
title: have_linkマッチャでリンク内容を確認する
date: 2014-10-11 08:34:44J
tags:
- Capybara
- RSpec
- Rails
- Ruby
keywords: have_link Capybara 入門 RSpec Rails Ruby
categories:
- rails-capybara
description: ページ内のリンクをhave_linkマッチャで確認します。
image: "/assets/images/posts/rspec.png"
---
<!-- tag_links -->
[Capybara](/tags/capybara/) / [RSpec](/tags/rspec/) / [Rails](/tags/rails/) / [Ruby](/tags/ruby/)

<!-- category_links -->
連載: [Rails4＋RSpec＋Capybaraでよく使うマッチャ＆メソッド22個+α]({% post_url 2014-10-30-rails-capybara-index %})

<!-- content -->
「{{ site.data["category_params"]["rails-capybara"]["title"]}}」第{{page.order_in_category}}回の今回は{{ page.description }}

`have_link`マッチャでリンク内容確認を行うには

{% highlight ruby %}
it { should have_link '江の島エンジニアBlog', href: '/' }
{% endhighlight %}

のようにマッチャを使います。

リンクがないことを確認したい場合は`should_not`を使います。

{% highlight ruby %}
it { should_not have_link 'プロフィール' }
{% endhighlight %}

リンクではないテキストがあることを確認したい場合は`have_content`と組み合わせて

{% highlight ruby %}
it { should have_content 'プロフィール' }
it { should_not have_link 'プロフィール' }
{% endhighlight %}

のようにテストを書きます。

次回は[have_cssマッチャを使った指定したタグの内容の確認]({% post_url 2014-10-11-rails-capybara-have-css %})を行います。

<!-- category_siblings -->
### 関連記事

{% include categories/rails-capybara.md %}

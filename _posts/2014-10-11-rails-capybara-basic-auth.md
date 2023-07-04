---
author: haracane
layout: post
title: Basic認証が必要なページをテストする
date: 2014-10-11 08:54:44J
tags:
- Capybara
- RSpec
- Rails
- Ruby
keywords: Basic認証 Capybara 入門 RSpec Rails Ruby
categories:
- rails-capybara
description: CapybaraでBasic認証をパスする方法を紹介します。
image: "/assets/images/posts/rspec.png"
---
<!-- tag_links -->
[Capybara](/tags/capybara/) / [RSpec](/tags/rspec/) / [Rails](/tags/rails/) / [Ruby](/tags/ruby/)

<!-- category_links -->
連載: [Rails4＋RSpec＋Capybaraでよく使うマッチャ＆メソッド22個+α]({% post_url 2014-10-30-rails-capybara-index %})

<!-- content -->
「{{ site.data["category_params"]["rails-capybara"]["title"]}}」第{{page.order_in_category}}回の今回は{{ page.description }}

Basic認証をパスするには`driver`というメソッドを使って

{% highlight ruby %}
page.driver.browser.authorize('username', 'password'])
{% endhighlight %}

を実行します。

例えば

{% highlight ruby %}
before do
  page.driver.browser.authorize('username', 'password'])
  visit '/secret/'
end
subject { page }

it { should have_title '秘密のページ' }
{% endhighlight %}

とテストを書けばBasic認証が設定された秘密のページの内容をテストすることができます。

次回は[ログインが必要なページのテスト]({% post_url 2014-10-11-rails-capybara-login %})を行います。

<!-- category_siblings -->
### 関連記事

{% include categories/rails-capybara.md %}

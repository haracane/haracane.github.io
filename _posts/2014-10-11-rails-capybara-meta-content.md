---
layout: post
title: find＆nativeメソッドでmeta要素をテストする
date: 2014-10-11 08:53:44J
tags: Capybara RSpec Rails Ruby
keywords: find native Capybara 入門 RSpec Rails Ruby
categories: rails-capybara
description: keywordsやdescriptionなどのmeta要素をテストする方法を紹介します。
image: rspec.png
---
[Capybara](/tags/capybara/) / [RSpec](/tags/rspec/) / [Rails](/tags/rails/) / [Ruby](/tags/ruby/)

「{{ site.data["category_params"]["rails-capybara"]["title"]}}」第{{page.order_in_category}}回の今回は{{ page.description }}

Capybaraを使ってmeta要素のテストをするには、まず`find`メソッドでmeta要素を取得します

{% highlight ruby %}
let(:meta) { page.find('meta[name="description"]', visible: false) }
{% endhighlight %}

ここの例ではdescriptionが設定されているmeta要素を取得しています。

なお、`visible: false`はmeta要素のように画面表示しない要素を取得する場合に必要となるオプションです。

続いてこの内容を`native`メソッドを使って取得します

{% highlight ruby %}
subject { meta.native["content"] }
{% endhighlight %}

これでmeta要素のdescription内容を取得できるので、あとは

{% highlight ruby %}
it { should match /Capybara入門/ }
{% endhighlight %}

のように内容を確認すればOKです。

次回は[Basic認証を設定しているページのテスト]({% post_url 2014-10-11-rails-capybara-basic-auth %})を行います。

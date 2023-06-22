---
author: haracane
layout: post
title: nativeメソッドでネイティブオブジェクトを取得する
date: 2014-10-11 08:52:44J
tags:
- Capybara
- RSpec
- Rails
- Ruby
keywords: native Capybara 入門 RSpec Rails Ruby
categories:
- rails-capybara
description: ネイティブオブジェクトを取得するnativeメソッドの使い方を説明します。
image: rspec.png
---
[Capybara](/tags/capybara/) / [RSpec](/tags/rspec/) / [Rails](/tags/rails/) / [Ruby](/tags/ruby/)

「{{ site.data["category_params"]["rails-capybara"]["title"]}}」第{{page.order_in_category}}回の今回は{{ page.description }}

`find`メソッドで取得したオブジェクトで`native`メソッドを実行するとNokogiri::XML::Elementオブジェクトを取得できます。

{% highlight ruby %}
find('h1').native
{% endhighlight %}

こちらを使うと例えば要素に指定されているclassの確認などを行えます。

{% highlight ruby %}
it { expect(find_button('投稿する').native["class"]).to eq 'btn' }
{% endhighlight %}

`native`メソッドを使うと何でもできてしまうのですが、あまり使いすぎるとテストが読みにくくなるので必要な時だけ使うようにしましょう。

次回は[Capybaraでmeta要素をテストする方法]({ post_url 2014-10-11-rails-capybara-meta-content })を紹介します。

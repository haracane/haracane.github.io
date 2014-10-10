---
layout: post
title: fill_inメソッドでフォームにテキストを入力する
date: 2014-10-11 08:42:44J
tags: Capybara RSpec Rails Ruby
keywords: fill_in Capybara 入門 RSpec Rails Ruby
categories: rails-capybara
description: フォームにテキストを入力するfill_inメソッドの使い方を説明します。
---

「{{ site.data["category_params"]["rails-capybara"]["title"]}}」第{{page.order_in_category}}回の今回は{{ page.description }}

`fill_in`メソッドでname属性が"title"の入力フィールド/テキストエリアにテキストを入力するには

{% highlight ruby %}
fill_in 'title', 'Rails4＋RSpecでCapybara入門'
{% endhighlight %}

のようにメソッドを使います。

普通はフォーム入力→送信→結果確認という遷移をテストするので、その場合は

{% highlight ruby %}
before do
  fill_in 'title', 'Rails4＋RSpecでCapybara入門'
  click_on '投稿する'
end

subject { page }
it { should have_title '投稿完了' }
{% endhighlight %}

のようにテストケースを書きます。

次回は[selectメソッドを使ったセレクトボックスの選択]({% post_url 2014-10-11-rails-capybara-select %})を行います。

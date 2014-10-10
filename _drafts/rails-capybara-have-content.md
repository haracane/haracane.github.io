---
layout: post
title: have_contentマッチャでコンテンツ内容を確認する
date: 2014-10-11 08:33:44J
tags: Capybara RSpec Rails Ruby
keywords: have_content Capybara 入門 RSpec Rails Ruby
categories: rails-capybara
description: ページ内容をhave_contentマッチャで確認します。
---

「{{ site.data["category_params"]["rails-capybara"]["title"]}}」第{{page.order_in_category}}回の今回は{{ page.description }}

ちなみにここでいうコンテンツはページ内のテキストとなります。

`have_content`マッチャでのコンテンツ内容確認を行うには

{% highlight ruby %}
expect(page).to have_content 'Rails4でCapybara入門'
{% endhighlight %}

のようにマッチャを使います。

`scenario`ブロックで書くと

{% highlight ruby %}
scenario do
  visit '/'
  expect(page).to have_content 'Rails4でCapybara入門'
end
{% endhighlight %}

となります。

前回の`have_title`マッチャも合わせて使うと

{% highlight ruby %}
scenario do
  visit '/'
  expect(page).to have_title '江の島エンジニアBlog'
  expect(page).to have_content 'Rails4でCapybara入門'
end
{% endhighlight %}

となります。

### テストを分ける

上記では`scenario`ブロックの中で`have_title`マッチャと`have_content`マッチャを使いましたが、これだと`have_title`が失敗した時に`have_content`が成功なのか失敗なのかがわかりません。

そういう場合はテストケースを分けて

{% highlight ruby %}
scenario do
  visit '/'
  expect(page).to have_title '江の島エンジニアBlog'
end

scenario do
  visit '/'
  expect(page).to have_content 'Rails4でCapybara入門'
end
{% endhighlight %}

とすると良いです。

### beforeを使う

テストケースを分けた場合、`visit`を2回実行していてDRYではないので`before`ブロックを使って`visit`メソッドをまとめます。

{% highlight ruby %}
before { visit '/' }

scenario do
  expect(page).to have_title '江の島エンジニアBlog'
end

scenario do
  expect(page).to have_content 'Rails4でCapybara入門'
end
{% endhighlight %}

これでどちらの`scenario`も実行前に`before`ブロック内の`visit`メソッドが実行されます。

### itを使う

各`scenario`ブロックの中が1行なので、こういう時は`it`と`subject`と`should`を使ってすっきり書けます。

{% highlight ruby %}
before { visit '/' }
subject { page }

it { should have_title '江の島エンジニアBlog' }
it { should have_content 'Rails4でCapybara入門' }
{% endhighlight %}

### テストを実行する

今回作成したテストを実行すると

    view top page
      should have title "江の島エンジニアBlog"
      should have content "Rails4でCapybara入門"

となりちゃんと両方ともテストに成功しました。

次回は[have_linkマッチャを使ったリンクの確認]({% post_url 2014-10-11-rails-capybara-have-link %})を行います。

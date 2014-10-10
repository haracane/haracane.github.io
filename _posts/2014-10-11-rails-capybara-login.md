---
layout: post
title: ログインが必要なページをテストする
date: 2014-10-11 08:55:44J
tags: Capybara RSpec Rails Ruby
keywords: ログイン Capybara 入門 RSpec Rails Ruby
categories: rails-capybara
description: Capybaraのテストでログイン処理を行う方法を紹介します。
---

「{{ site.data["category_params"]["rails-capybara"]["title"]}}」第{{page.order_in_category}}回の今回は{{ page.description }}

Capybaraでテストする場合、`fill_in`や`click_on`を使ってログイン処理を行います。

例えば

{% highlight ruby %}
let!(:user) { FactoryGirl.create(:user, name: 'capybara', password: 'rails')}

before do
  visit '/login/'
  fill_in 'username', with: 'capybara'
  fill_in 'password', with: 'rails'
  click_on 'ログイン'

  visit '/'
end

subject { page }

it { should have_content 'capybaraさんがログイン中'}
{% endhighlight %}

とすればcapybaraユーザがパスワードに「rails」を入力してログインした場合のトップページの内容をテストすることができます。

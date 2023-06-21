---
author: haracane
layout: post
title:  Capybaraでよく使うマッチャ＆メソッド
date: 2014-09-11 07:09:07J
tags: Capybara RSpec Ruby Rails
keywords: Capybara,RSpec,Ruby,Rails
description: Capybaraを使う時に検索して調べることが多いのでマッチャ等を利用例にまとめました。
image: rspec.png
---
[Capybara](/tags/capybara/) / [RSpec](/tags/rspec/) / [Ruby](/tags/ruby/) / [Rails](/tags/rails/)

Capybaraの使い方を知りたい場合は[Ruby on Railsチュートリアルのテスト例](http://railstutorial.jp/chapters/static-pages?version=4.0#sec-first_tests)が参考になると思います。

以下はCapybaraで色々なマッチャを使ってみた例です。これくらいのマッチャを使えばだいたいのことはできると思います。

{% highlight ruby %}
require "rails_helper"

feature "post an article", type: :feature do
  before do
    ## Create data
  end

  feature "sign in" do
    include Warden::Test::Helpers

    before(:all) { Warden.test_mode! }
    after(:all)  { Warden.test_reset! }
    let(:user) { create :user }
    before { login_as user }

    feature "edit an article" do
      before { visit "/" }
      subject { page }

      it { should have_title "title" }
      it { should have_content "content" }
      it { should have_link("top", href: "/") }
      it { should have_css("h1", text: "title") }
      it { should have_css(".user[data-url='http://twitter.com/jack/']") }

      it { should have_button("search") }
      it { should have_field("title", with: "title") }
      it { should have_checked_field("language", with: "japanese") }
      it { should have_unchecked_field("language", with: "english") }
      it { should have_select("select", selected: "option") }
      it { should have_select("no_select", selected: []) }

      feature "fill in form" do
        scenario do
          fill_in "title_id", with: "title"
          select  "option_name", from: "select_id"
          choose "radio_button_label"
          check "checkbox_id"
          uncheck "checkbox_id"
          attach_file 'attach_file_id', '/path/to/image/file.jpg'
          click_on "submit"
          ...
        end
      end
    end
  end
end
{% endhighlight %}


その他の利用例はこんな感じ。

{% highlight ruby %}
its(:current_url) { should eq "http://example.com/" }
its(:current_host) { should eq "example.com" }
its(:current_path) { should eq "/" }
it { expect(find_button("検索").native["class"]).to match /btn/ }
it { expect(find_field("title").native["class"]).to match /title/ }
it { expect(find_field("title").text).to be_empry) }
it { expect(find_by_id("content").native.children).to have(5).items }
it { expect(find_link("top").native["class"]).to match /link/ }
{% endhighlight %}

ドキュメントを読むならこのあたりでしょうか。

[Capybara::Node::Actions](http://rubydoc.info/github/jnicklas/capybara/master/Capybara/Node/Actions)
: click_buttonやfill_in等の操作メソッド

[Capybara::Node::DocumentMatchers](http://rubydoc.info/github/jnicklas/capybara/master/Capybara/Node/DocumentMatchers)
: has_title?等のタイトル用のマッチャ

[Capybara::Node::Matchers](http://rubydoc.info/github/jnicklas/capybara/master/Capybara/Node/Matchers)
: has_link?等の本文用のマッチャ

[Capybara::Node::Finders](http://rubydoc.info/github/jnicklas/capybara/master/Capybara/Node/Finders)
: all、find等のファインダ

以上、Capybaraを使う時になるべく検索しないで済むようにする記事でした。

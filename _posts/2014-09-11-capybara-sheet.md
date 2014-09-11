---
layout: post
title:  Capybaraでよく使うメソッドの利用例
date: 2014-09-11 07:09:07J
tags: Capybara RSpec Ruby Rails Capybara
keywords: Capybara,RSpec,Ruby,Rails
description: Capybaraを使う時に検索して調べることが多いのでマッチャ等を利用例にまとめておきました。
---

{{ page.description }}

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

    feature "edit a post" do
      before { visit "/" }
      subject { page }

      it { should have_title "title" }
      it { should have_content "content" }
      it { should have_link("top", href: "/") }
      it { should have_css("h1", text: "title") }

      it { should have_button("search") }
      it { should have_field("title", with: "title") }
      it { should have_checked_field("language", with: "japanese") }
      it { should have_unchecked_field("language", with: "english") }
      it { should have_select("select", selected: "option") }

      feature "fill in form" do
        before do
          fill_in "title", with: "title"
          select  "option", from: "select"
          choose "checkbox-label"
        end

        feature "submit" do
          scenario do
            click_on "submit"
            ...
          end
        end
      end
    end

    feature "sign out" do
      scenario do
        logout
        ...
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
it { expect(page.find_button("検索").native["class"]).to match /btn/ }
it { expect(page.find_field("title").native["class"]).to eq /title/ }
it { expect(page.find_by_id("content").native["class"]).to match /content/ }
it { expect(page.find_link("top").native["class"]).to match /link/ }
{% endhighlight %}

ドキュメントを読むならこのあたりでしょうか。

[Capybara::Node::Actions](http://rubydoc.info/github/jnicklas/capybara/master/Capybara/Node/Actions)
: click_onやfill_in等の操作メソッド

[Capybara::Node::DocumentMatchers](http://rubydoc.info/github/jnicklas/capybara/master/Capybara/Node/DocumentMatchers)
: has_title?等のタイトル用のマッチャ

[Capybara::Node::Matchers](http://rubydoc.info/github/jnicklas/capybara/master/Capybara/Node/Matchers)
: has_content?等のマッチャ

[Capybara::Node::Finders](http://rubydoc.info/github/jnicklas/capybara/master/Capybara/Node/Finders)
: all、find等のファインダ

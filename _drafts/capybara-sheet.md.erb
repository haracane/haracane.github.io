---
layout: post
title:  Capybaraでよく使うメソッドの利用例
date: 2014-09-11 07:09:07J
tags: Capybara RSpec Ruby Rails Capybara
keywords: Capybara,RSpec,Ruby,Rails
description: Capybaraを使う時に検索して調べることが多いのでマッチャ等をまとめておきました。
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
      scenario { expect(page).to have_title "title" }
      scenario { expect(page).to have_content "content" }
      scenario { expect(page).to have_link("top", href: "/") }
      scenario { expect(page).to have_css(".header", text: "header") }

      scenario { expect(page).to have_button("search") }
      scenario { expect(page).to have_field("title") }
      scenario { expect(page).to have_checked_field("japanese") }
      scenario { expect(page).to have_unchecked_field("english") }
      scenario { expect(page).to have_select("select") }

      scenario { expect(page.find("#title").value).to match /title/ }
      scenario { expect(page.all("#select option")[0]).to be_selected }
      scenario { expect(page.find("#checkbox")).to be_checked }

      feature "fill in form" do
        before do
          fill_in "title", with: "title"
          select  "option", from: "select"
          choose "checkbox-label"
        end

        feature "submit" do
          before { click_on "submit" }
          scenario { ... }
        end
      end
    end

    feature "sign out" do
      before { logout }
      scenario { ... }
    end
  end
end
{% endhighlight %}


その他のscenario例
{% highlight ruby %}
scenario { expect(page.current_url).to eq "http://example.com/" }
scenario { expect(page.current_host).to eq "example.com" }
scenario { expect(page.current_path).to eq "/" }
scenario { expect(page.find_button("検索").native["class"]).to match /btn/ }
scenario { expect(page.find_field("title").native["class"]).to eq /title/ }
scenario { expect(page.find_by_id("content").native["class"]).to match /content/ }
scenario { expect(page.find_link("top").native["class"]).to match /link/ }
{% endhighlight %}
---
author: haracane
layout: post
title: Rails4＋RSpec＋Capybaraでよく使うマッチャ＆メソッド22個+α
date: 2014-10-30 19:52:42J
tags:
- Capybara
- RSpec
- Rails
- Ruby
keywords: Capybara RSpec Rails Ruby
description: Rails4のレスポンスをRSpecでテストする際にCapybaraを使っているのですが、マッチャやメソッドの使い方を調べることが多いのでまとめてみました。
categories:
- index
sub_category:
image: "/assets/images/posts/rspec.png"
---
<!-- tag_links -->
[Capybara](/tags/capybara/) / [RSpec](/tags/rspec/) / [Rails](/tags/rails/) / [Ruby](/tags/ruby/)

<!-- content -->
例えば①ログインする、②表示内容を確認する、③フォーム入力する、という流れをCapybaraでテストするとこんな感じになります。

{% highlight ruby %}
require 'rails_helper'

feature 'post an article', type: :feature do
  before do
    ## Create data
  end

  feature 'sign in' do
    include Warden::Test::Helpers

    before(:all) { Warden.test_mode! }
    after(:all)  { Warden.test_reset! }
    let(:user) { create :user }
    before { login_as user }

    feature 'edit an article' do
      before { visit '/' }
      subject { page }

      it { should have_title 'title' }
      it { should have_content 'content' }
      it { should have_link('top', href: '/') }
      it { should have_css('h1', text: 'title') }
      it { should have_css(".user[data-url='http://twitter.com/jack/']") }

      it { should have_button('search') }
      it { should have_field('title', with: 'title') }
      it { should have_checked_field('language', with: 'japanese') }
      it { should have_unchecked_field('language', with: 'english') }
      it { should have_select('select', selected: 'option') }
      it { should have_select('no_select', selected: []) }

      feature 'fill in form' do
        scenario do
          fill_in 'title_id', with: 'title'
          select  'option_name', from: 'select_id'
          choose 'radio_button_label'
          check 'checkbox_id'
          uncheck 'checkbox_id'
          attach_file 'attach_file_id', '/path/to/image/file.jpg'
          click_on 'submit'
          ...
        end
      end
    end
  end
end
{% endhighlight %}

他にも便利なメソッドが色々用意されています。

{% highlight ruby %}
before { first('submit').click }
its(:current_url) { should eq 'http://example.com/' }
its(:current_host) { should eq 'example.com' }
its(:current_path) { should eq '/' }
it { expect(find('input[type=hidden][name="p[code]"]').native[:value]).to eq '1' }
it { expect(find_button('検索').native[:class]).to match /btn/ }
it { expect(find_field('title').native[:class]).to match /title/ }
it { expect(find_field('title').text).to be_empry) }
it { expect(find_by_id('content').native.children).to have(5).items }
it { expect(find_link('top').native[:class]).to match /link/ }
it { expect(all('li')).to have(5).items }
{% endhighlight %}

それぞれメソッドやマッチャの使い方については以下の記事をご覧ください。

---
layout: default
title: Rails4＋RSpec＋Capybaraでよく使うマッチャ＆メソッド22個+α
---
# Rails4＋RSpec＋Capybaraでよく使うマッチャ＆メソッド22個+α

{% include categories/rails-capybara.md %}

<!-- category_siblings -->
### 関連記事

{% include categories/index.md %}

---
author: haracane
layout: post
title: RSpecカスタムマッチャでデータベースのNOT NULL制約をテストする
date: 2014-09-08 07:53:09J
tags:
- RSpec
- Ruby
- Rails
keywords: RSpec,Ruby,Rails,MySQL,PostgreSQL
description: Railsでモデルを作る時にNOT NULL制約テストを簡単に書きたかったのでカスタムマッチャを作りました。
image: rspec.png
categories: model-spec-custom-matchers
---
[RSpec](/tags/rspec/) / [Ruby](/tags/ruby/) / [Rails](/tags/rails/)

Railsを使っているとDBのフィールドにNOT NULL制約をつけることがよくありますが、テストしようとするとデータを保存してエラーが起きることを確認したりして相当面倒です。

なのでRSpecカスタムマッチャを作りました。

たとえばPersonモデルのnameフィールドのNOT NULL制約をテストする場合は

{% highlight ruby %}
describe Person do
  subject { FactoryGirl.create(:person) }
  it { should have_not_null_constraint_on(:title) }
end
{% endhighlight %}

と書いてあげれば

    $ bundle exec rspec spec/models/person_spec.rb
    Person
      should have NOT NULL constraint on name

という実行結果になります。

カスタムマッチャはこんな感じです。

{% highlight ruby %}
RSpec::Matchers.define :have_not_null_constraint_on do |field|
  match do |model|
    model.send("#{field}=", nil)
    begin
      model.save!(validate: false)
      false
    rescue ActiveRecord::StatementInvalid
      true
    end
  end

  description { "have NOT NULL constraint on #{field}" }
  failure_message { "expected to have NOT NULL constraint on #{field}, but not" }
end
{% endhighlight %}

DBのNOT NULL制約はよく使うので重宝しそうです。

### 関連記事
* [RSpecカスタムマッチャでデータベースのUNIQUE制約を簡単にテストする](/2014/09/09/rspec-db-unique-constraint/)
* [RSpecカスタムマッチャでデータベースの外部キー制約を簡単にテストする](/2014/09/10/rspec-db-foreign-key-constraint/)

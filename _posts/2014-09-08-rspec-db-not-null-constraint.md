---
layout: post
title:  【RSpec】データベースのNOT NULL制約テストを簡単にするカスタムマッチャ
date: 2014-09-08 21:00:37J
tags: RSpec,Ruby,Rails
keywords: RSpec,Ruby,Rails,MySQL,PostgreSQL
description: Railsでモデルを作る時にNOT NULL制約テストを簡単に書きたかったのでカスタムマッチャを作りました。
---

{{ page.description }}

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

たとえばPersonモデルのnameフィールドのNOT NULL制約をテストする場合は

{% highlight ruby %}
describe Person do
  it { should have_not_null_constraint_on(:title) }
end
{% endhighlight %}

と書いてあげればOKです。

テストを実行すると結果は

    $ bundle exec rspec spec/models/person_spec.rb
    Person
      should have UNIQUE constraint on name

となります。

DBのNOT NULL制約はよく使うので重宝しそうです。
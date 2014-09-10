---
layout: post
title:  RSpecカスタムマッチャでデータベースの外部キー制約を簡単にテストする
date: 2014-09-10 07:59:50J
tags: RSpec Ruby Rails
keywords: RSpec,Ruby,Rails,MySQL,PostgreSQL
description: Railsでモデルを作る時に外部キー制約テストも簡単に書きたかったのでカスタムマッチャを作りました。
---

{{ page.description }}

[前々回のNOT NULL制約カスタムマッチャの記事](/2014/09/08/rspec-db-not-null-constraint/)と[前回のUNIQUE制約カスタムマッチャの記事](/2014/09/09/rspec-db-unique-constraint/)に続いて、最後のDB制約カスタムマッチャです。

例えば

{% highlight ruby %}
describe Person do
  it { should have_foreign_key_constraint_on(:school_id) }
end
{% endhighlight %}

と書くと

    $ bundle exec rspec spec/models/person_spec.rb
    Person
      should have FOREIGN KEY constraint on school_id

とテストできるようになります。

カスタムマッチャは

{% highlight ruby %}
RSpec::Matchers.define :have_foreign_key_constraint_on do |field|
  match do |model|
    model.send("#{field}=", 0)
    begin
      model.save!(validate: false)
      false
    rescue ActiveRecord::InvalidForeignKey
      true
    end
  end

  description { "have FOREIGN KEY constraint on #{field}" }
  failure_message { "expected to have FOREIGN KEY constraint on #{field}, but not" }
end
{% endhighlight %}

となります。

以上、[NOT NULL制約カスタムマッチャ](/2014/09/08/rspec-db-not-null-constraint/), [UNIQUE制約カスタムマッチャ](/2014/09/09/rspec-db-unique-constraint/)と一緒に使えるDB制約カスタムマッチャでした。

#### 関連記事
* [RSpecカスタムマッチャでデータベースのNOT NULL制約を簡単にテストする](/2014/09/08/rspec-db-not-null-constraint/)
* [RSpecカスタムマッチャでデータベースのUNIQUE制約を簡単にテストする](/2014/09/09/rspec-db-unique-constraint/)

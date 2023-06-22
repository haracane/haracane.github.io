---
author: haracane
layout: post
title: RSpecカスタムマッチャでデータベースのUNIQUE制約をテストする
date: 2014-09-09 07:53:09J
tags:
- RSpec
- Ruby
- Rails
keywords: RSpec,Ruby,Rails,MySQL,PostgreSQL
description: Railsでモデルを作る時にUNIQUE制約テストも簡単に書きたかったのでカスタムマッチャを作りました
image: rspec.png
categories:
- model-spec-custom-matchers
---
<!-- tag_links -->
[RSpec](/tags/rspec/) / [Ruby](/tags/ruby/) / [Rails](/tags/rails/)

<!-- category_links -->
連載: [Rails4のActiveRecord向けRSpecカスタムマッチャ5選]({% post_url 2014-10-30-model-spec-custom-matchers-index %})

<!-- content -->
前回、[NOT NULL制約カスタムマッチャの記事](/2014/09/08/rspec-db-not-null-constraint/)を書きましたが、UNIQUE制約のテストもやっぱり面倒なのでUNIQUE制約のRSpecカスタムマッチャも作りました。

たとえばPersonモデルのnameフィールドのUNIQUE制約をテストする場合は

{% highlight ruby %}
describe Person do
  it { should have_not_null_constraint_on(:name) }
end
{% endhighlight %}

と書いてあげれば

    $ bundle exec rspec spec/models/person_spec.rb
    Person
      should have UNIQUE constraint on name

とテスト実行できます。

以下がUNIQUE制約のカスタムマッチャで、FactoryGirlの利用を前提としています。

{% highlight ruby %}
RSpec::Matchers.define :have_unique_constraint_on do |*fields|
  match do |model|
    name = model.class.table_name.singularize
    record = FactoryGirl.create(name)
    other_record = FactoryGirl.build(name)

    fields.each do |field|
      other_record.send("#{field}=", record.send(field))
    end

    begin
      other_record.save!(validate: false)
      false
    rescue ActiveRecord::RecordNotUnique
      true
    end
  end

  description { "have UNIQUE constraint on #{fields.join(", ")}" }
  failure_message { "expected to have UNIQUE constraint on #{fields.join(", ")}, but not" }
end
{% endhighlight %}

ということで、[NOT NULL制約カスタムマッチャ](/2014/09/08/rspec-db-not-null-constraint/)と一緒に活躍してくれるであろうUNIQUE制約カスタムマッチャでした。

### 関連記事
* [RSpecカスタムマッチャでデータベースのNOT NULL制約を簡単にテストする](/2014/09/08/rspec-db-not-null-constraint/)
* [RSpecカスタムマッチャでデータベースの外部キー制約を簡単にテストする](/2014/09/10/rspec-db-foreign-key-constraint/)

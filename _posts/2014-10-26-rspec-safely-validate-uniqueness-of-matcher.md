---
author: haracane
layout: post
title: Rails4のuniqueness validationテストでInvalidForeignKeyエラーにならないカスタムマッチャを作る
date: 2014-10-26 10:09:50J
tags:
- RSpec
- Rails
- Ruby
keywords: RSpec,validate_uniqueness_of,ActiveRecord,Rails
description: Rails4で外部キー制約を持つモデルでvalidate_uniqueness_ofマッチャを使うとInvalidForeignKeyエラーが起きてしまい、ちゃんとテストできないのでsafely_validate_uniqueness_ofカスタムマッチャを作りました。
image: rspec.png
categories:
- model-spec-custom-matchers
---
<!-- tag_links -->
[RSpec](/tags/rspec/) / [Rails](/tags/rails/) / [Ruby](/tags/ruby/)

<!-- category_links -->
連載: [Rails4のActiveRecord向けRSpecカスタムマッチャ5選]({% post_url 2014-10-30-model-spec-custom-matchers-index %})

<!-- content -->
外部キー制約のあるモデルに対して[shoulda-matchers](https://github.com/thoughtbot/shoulda-matchers)
の`validate_uniqueness_of`カスタムマッチャを使うと

    Failure/Error: it { should validate_uniqueness_of(:code) }
    ActiveRecord::InvalidForeignKey:
     Mysql2::Error: Cannot add or update a child row: a foreign key constraint fails

というエラーが出てしまい、ちゃんとテストできないので`safely_validate_uniqueness_of`というカスタムマッチャを作りました。

このカスタムマッチャを使うと

{% highlight ruby %}
describe Person do
  it { should safely_validate_uniqueness_of(:code) }
  it { should safely_validate_uniqueness_of(:group_id, :number) }
end
{% endhighlight %}

と書くことで

    $ bundle exec rspec spec/models/person_spec.rb
    Person
      should require unique value for code
      should require unique value for group_id, number

とテストできるようになります。

カスタムマッチャは

{% highlight ruby %}
RSpec::Matchers.define :safely_validate_uniqueness_of do |*fields|
  match do |model|
    name = model.class.table_name.singularize
    record = create(name)
    other_record = build(name)

    fields.each do |field|
      other_record.send("#{field}=", record.send(field))
    end

    begin
      other_record.save!
      false
    rescue ActiveRecord::RecordInvalid
      true
    end
  end

  description { "require unique value for #{fields.join(", ")}" }
  failure_message { "expected to require unique value for #{fields.join(", ")}, but not" }
end
{% endhighlight %}

となります。

ほんとは[shoulda-matchers](https://github.com/thoughtbot/shoulda-matchers)にPR投げた方が良いんですけどね。

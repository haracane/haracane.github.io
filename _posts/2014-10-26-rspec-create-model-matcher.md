---
layout: post
title:  RSpecカスタムマッチャでFactoryGirlでのモデル生成をテストする
date: 2014-10-26 07:59:50J
tags: RSpec Ruby Rails
keywords: RSpec,FactoryGirl,ActiveRecord,Rails
description: Rails4でFactoryGirlがちゃんとしたモデルを生成することを確認したかったのでcreate_modelカスタムマッチャを作りました。
image: rspec.png
categories: model-spec-custom-matchers
---
[RSpec](/tags/rspec/) / [Ruby](/tags/ruby/) / [Rails](/tags/rails/)

このカスタムマッチャを使うと

{% highlight ruby %}
describe Person do
  it { should create_model }
  it { should create_model.for(2).times }
end
{% endhighlight %}

と書くことで

    $ bundle exec rspec spec/models/person_spec.rb
    Person
      should create 2 records
      should create 1 record

とテストできるようになります。

カスタムマッチャは

{% highlight ruby %}
RSpec::Matchers.define :create_model do
  def for(n)
    @number = n
    self
  end

  def times
    @create_count = @number
    self
  end

  match do |model|
    klass = model.class
    name = klass.table_name.singularize

    @create_count ||= 1

    before_count = klass.count

    @create_count.times { create(name) }

    @created_count = klass.count - before_count
    @created_count == @create_count
  end

  description { "create #{@created_count} #{"record".pluralize(@created_count)}" }
  failure_message { "expected to create #{@created_count} #{"record".pluralize(@created_count)}, but created #{@created_count}" }
end
{% endhighlight %}

となります。

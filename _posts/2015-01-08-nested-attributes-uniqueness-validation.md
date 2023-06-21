---
author: haracane
layout: post
title: has-many関連のuniqueness validationをするカスタムバリデータを作ってみた
date: 2015-01-08 08:07:11J
tags: Rails ActiveRecord
keywords: Rails ActiveRecord Uniqueness Validation
description: ActiveRecordのUniquenessValidatorはネストしたパラメタ内の重複オブジェクトの一意性を検出してくれないので、カスタムバリデータを作って対応しました。
image: rails.png
---
[Rails](/tags/rails/) / [ActiveRecord](/tags/activerecord/)

## UniquenessValidatorの問題

ActiveRecordのUniquenessValidatorはDBに保存済みのレコードと重複した場合はvalidationしてくれますが、
ネストしたパラメタで重複したオブジェクトを作ろうとしてもスルーしてしまいます。

例えば以下のパラメタが入力された場合に`tag_id`の重複をvalidationできません。

{% highlight ruby %}
{
  "posts_attributes" => {
    "0" => {
      "post_tags_attributes" => {
        "0" => {"tag_id" => 1},
        "1" => {"tag_id" => 1}
      }
    }
  }
}
{% endhighlight %}

## カスタムバリデータでuniqueness validationを行う

今回はこんな感じでvalidationできるようにします。

{% highlight ruby %}
# app/models/blog/post.rb
class Blog::Post < ActiveRecord::Base
  MAX_POST_TAGS_LENGTH = 5

  has_many :post_tags, foreign_key: :blog_post_id
  has_many :tags, through: :post_tags

  validates :post_tags, nested_attributes_uniqueness: {fields: [:blog_tag_id]}

  accepts_nested_attributes_for :post_tags, allow_destroy: true
end
{% endhighlight %}

## NestedAttributesUniquenessValidatorの実装

入力パラメタ内での重複をチェックするカスタムバリデータの実装はこんな感じです。

{% highlight ruby %}
# app/validators/nested_attributes_uniqueness_validator.rb
class NestedAttributesUniquenessValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, values)
    fields = options[:fields] || [:self]

    if unique_constraint_is_violated?(values, fields)
      record.errors.add(attribute, :not_unique)
    end
  end

  private

  def unique_constraint_is_violated?(records, fields)
    fields = fields.map(&:to_s)
    values_collection =
      records.
        map { |record| record.attributes.values_at(*fields) }.
        select { |values| values.none?(&:nil?) }
    values_collection.size != values_collection.uniq.size
  end
end
{% endhighlight %}

ついでにエラーメッセージも設定しておきます。
{% highlight yaml %}
ja:
  activerecord:
    errors:
      models:
        blog/post:
          attributes:
            post_tags:
              not_unique: 'が重複しています'
    models:
      blog/post: ブログ記事
    attributes:
      blog/post:
        id: 管理ID
        post_tags: タグ
{% endhighlight %}

## NestedAttributesUniquenessValidatorのテスト

カスタムバリデータのテストはこんな感じ。

{% highlight ruby %}
# spec/validators/nested_attributes_uniqueness_validator_spec.rb
describe NestedAttributesUniquenessValidator do
  let(:validator) do
    NestedAttributesUniquenessValidator.new(
      attributes: [:post_tags],
      fields: [:tag_id]
    )
  end

  subject(:record) do
    double(:post, errors: double(:errors, add: nil))
  end

  describe '#validate_each' do
    let(:first_value) { double(:post_tag, attributes: {'tag_id' => 1}) }
    after { validator.validate_each(record, :post_tags, [first_value, second_value]) }

    context 'with unique values' do
      let(:second_value) { double(:post_tag, attributes: {'tag_id' => 2}) }
      it { should_not receive(:errors) }
    end

    context 'with not unique values' do
      let(:second_value) { double(:post_tag, attributes: {'tag_id' => 1}) }
      it { should receive(:errors).once }
    end
  end
end
{% endhighlight %}

## まとめ

RailsのNested Attributesに欲しい機能が足りないようだったので今回はカスタムバリデータを作りました。

もっといいやり方をご存知でしたらツッコミ歓迎です。よろしくお願いします。

追記: 「[has-many関連のuniqueness validationをテストするカスタムマッチャも作ってみた]({% post_url 2015-01-08-rspec-validate-objects-uniquness-of-matcher %})」を追加しました。

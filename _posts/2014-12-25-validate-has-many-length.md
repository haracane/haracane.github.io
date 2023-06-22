---
author: haracane
layout: post
title: Rails4でhas_manyな関連オブジェクトの上限数を設定＆テストする
date: 2014-12-25 07:26:16J
tags:
- ActiveRecord
- Rails
- Ruby
keywords: ActiveRecord Rails Ruby
description: ActiveRecordのhas_manyな関連オブジェクトに上限数を設定したかったのでやってみました。
image: rails.png
---
<!-- tag_links -->
[ActiveRecord](/tags/activerecord/) / [Rails](/tags/rails/) / [Ruby](/tags/ruby/)

<!-- content -->
この記事では`Blog::Post#tags`の数を5つまでに制限する場合のサンプルコードを紹介します。

## モデルでのValidation設定

まずモデル側で`post_tags`に`LengthValidation`を設定します。

{% highlight ruby %}
# app/models/blog/post.rb
class Blog::Post < ActiveRecord::Base
  MAX_POST_TAGS_LENGTH = 5

  has_many :post_tags
  has_many :tags, through: :post_tags

  validates :post_tags, length: {maximum: MAX_POST_TAGS_LENGTH}
end
{% endhighlight %}

## ロケール辞書の設定

Validation対象のフィールド名やエラーメッセージを設定します。

{% highlight yaml %}
# config/locales/models/blog/post/ja.yml
ja:
  activerecord:
    errors:
      models:
        blog/post:
          attributes:
            post_tags:
              too_long: 'は%{count}個までしか登録できません'
    models:
      blog/post: ブログ記事
    attributes:
      blog/post:
        id: 管理ID
        post_tags: タグ
{% endhighlight %}

## テストケースの追加

正しくValidationできることをテストします。

{% highlight ruby %}
#spec/models/blog/post_spec.rb
describe Blog::Post, type: :model do
  context 'with validations' do
    it do
      should validate_objects_length_of(:post_tags).
               is_at_most(Blog::Post::MAX_POST_TAGS_LENGTH).
               with_message("タグは#{Blog::Post::MAX_POST_TAGS_LENGTH}個までしか登録できません")
    end
  end
end
{% endhighlight %}

## `validate_objects_length_of`カスタムマッチャの追加

テストでさらっと`validate_objects_length_of`マッチャを使いましたが、これはカスタムマッチャなので下記のコードを`spec/support/matchers.rb`に追加します。

{% highlight ruby %}
# spec/support/matchers.rb
RSpec::Matchers.define :validate_objects_length_of do |field|
  def is_at_most(size)
    @max_size = size
    self
  end

  def with_message(message)
    @message = message
    self
  end

  match do |model|
    model_factory_name = model.class.table_name.singularize
    association_name = field

    association =
      model.
        class.
        reflect_on_all_associations(:has_many).
        find { |i_association| i_association.name == association_name }

    if association.nil?
      @failure_appendix = "(#{association_name.inspect} has-many association does not exist)"
      return false
    end

    factory_args = [association.table_name.singularize]

    record = create(model_factory_name)

    if @max_size
      ((record.send(association_name).size)..@max_size).each do |size|
        unless record.valid?
          @failure_appendix = "(invalid with #{size} #{'object'.pluralize(size)})"
          return false
        end
        record.send(association_name) << build(*factory_args)
      end

      if record.valid?
        size = @max_size + 1
        @failure_appendix = "(valid with #{size} #{'object'.pluralize(size)})"
        return false
      end
    end

    if @message
      if record.errors.full_messages != [@message]
        @failure_appendix = "(with message #{record.errors.full_messages.inspect})"
        return false
      end
    end

    true
  end

  description do
    description_prefix = "validate #{field} has a length of"
    conditions = []
    conditions << "at most #{@max_size}" if @max_size
    conditions << "with message #{@message.inspect}" if @message
    "#{description_prefix} #{conditions.join(', ')}"
  end

  failure_message { "expected to #{description}, but not#{@failure_appendix}" }
end
{% endhighlight %}

テストを実行すると

    Blog::Post
      with validations
        should validate post_tags has a length of at most 5, with message "タグは5個までしか登録できません"

    Finished in 0.24698 seconds (files took 5.23 seconds to load)
    1 example, 0 failures

となって無事成功しました。

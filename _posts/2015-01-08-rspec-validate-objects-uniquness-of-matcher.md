---
layout: post
title: has-many関連のuniqueness validationをテストするカスタムマッチャも作ってみた
date: 2015-01-08 08:16:39J
tags: RSpec ActiveRecord Rails Ruby
keywords:  RSpec ActiveRecord Rails Ruby
description: 前回の記事でカスタムバリデータを作ってhas-many関連のuniqueness validationを行いましたが、続いてテスト用にvalidate_objects_uniqueness_ofカスタムマッチャを作りました。
image: rspec.png
---
[RSpec](/tags/rspec/) / [ActiveRecord](/tags/activerecord/) / [Rails](/tags/rails/) / [Ruby](/tags/ruby/)

※前回の記事: [has-many関連のuniqueness validationをするカスタムバリデータを作ってみた]({% post_url 2015-01-08-nested-attributes-uniqueness-validation %})

## validate_objects_uniqueness_ofカスタムマッチャの使い方

validate_objects_uniqueness_ofマッチャはこんな感じで使います。

{% highlight ruby %}
# spec/models/blog/post_spec.rb
describe Blog::Post, type: :model do
  context 'with validations' do
    it do
      should validate_objects_uniqueness_of(:post_tags).
               with_fields(:blog_tag_id).
               with_message("タグが重複しています")
    end
  end
end
{% endhighlight %}

## validate_objects_uniqueness_ofカスタムマッチャの定義

マッチャの定義はこんな感じです。

{% highlight ruby %}
# spec/support/matchers.rb
RSpec::Matchers.define :validate_objects_uniqueness_of do |field|
  include UnexpectedMessageDetectable
  include ModelFactoryNameAcquirable
  include AssociationAccessible

  def with_fields(*association_fields)
    @association_fields = association_fields
    self
  end

  match do |model|
    @model = model
    @field = field

    return false if fail_with_null_association?

    field_factory_name = association.table_name.singularize

    record = build(model_factory_name)
    values = [build(field_factory_name), build(field_factory_name)]

    return false if fail_with_uniqueness_violation?(record, values)

    record = build(model_factory_name)

    first_value = build(field_factory_name)
    params = first_value.attributes.select { |key, _| @association_fields.include?(key.to_sym) }
    second_value = build(field_factory_name, params)

    return false if fail_with_uniqueness_conformation?(record, [first_value, second_value])
    return false if fail_with_unexpected_message?(record)

    true
  end

  description do
    description_prefix = "require unique objects for #{field}"
    conditions = []
    conditions << "with fields #{@association_fields.join(', ')}" if @association_fields
    conditions << association_options_description if association_options_description
    conditions << unexpected_message_option_description if unexpected_message_option_description
    "#{description_prefix} #{conditions.join(', ')}"
  end

  failure_message { "expected to #{description}, but not#{@failure_appendix}" }

  private

  def fail_with_uniqueness_conformation?(record, values)
    return false unless add_values_to_record(record, values).valid?
    @failure_appendix = "(unique with #{values.inspect})"
    true
  end

  def fail_with_uniqueness_violation?(record, values)
    return false if add_values_to_record(record, values).valid?
    @failure_appendix = "(not unique with #{values.inspect})"
    true
  end

  def add_values_to_record(record, values)
    values.each do |value|
      record.send(association_name) << value
    end
    record
  end
end
{% endhighlight %}

## カスタムマッチャでincludeしているモジュールの定義

validates_objects_uniqueness_ofマッチャでは3つの独自モジュールを`include`しています。

`UnexpectedMessageDetectable`では`with_message`オプションでエラーメッセージのvalidationを行えるようにします。

{% highlight ruby %}
module UnexpectedMessageDetectable
  attr_reader :expected_message

  def with_message(message)
    @expected_message = message
    self
  end

  private

  def fail_with_unexpected_message?(record)
    return false if expected_message.nil?
    return false if record.errors.full_messages.include?(expected_message)

    @failure_appendix = "(with message #{record.errors.full_messages.inspect})"
    true
  end

  def unexpected_message_option_description
    "with message #{expected_message.inspect}" if expected_message
  end
end
{% endhighlight %}

続いて`AssociationAccessible`では`with_factory`オプションで`FactoryGirl.create`に渡す引数を指定したり、`with_association`オプションでオブジェクトの追加先のhas-many関連名を指定したりできるようにします。

{% highlight ruby %}
module AssociationAccessible
  def with_association(association)
    association_options[:name] = association
    self
  end

  def with_factory(*args)
    association_options[:factory_args] = args
    self
  end

  private

  def fail_with_null_association?
    return false if association
    @failure_appendix = "(#{association_name.inspect} has-many association does not exist)"
    true
  end

  def association_options
    @association_options ||= {}
  end

  def association_name
    @association_name ||= association_options[:name] || @field
  end

  def association
    @association ||=
      @model.
      class.
      reflect_on_all_associations.
      find { |i_association| i_association.name == association_name }
  end

  def factory_args
    @factory_args ||= association_options[:factory_args] || [association.table_name.singularize]
  end

  def association_options_description
    conditions = []
    conditions << "with association #{association_options[:name].inspect}" if association_options[:name]
    conditions << "with FactoryGirl args (#{association_options[:factory_args].inspect})" if association_options[:factory_args]
    conditions.present? ? conditions.join(', ') : nil
  end
end
{% endhighlight %}

`ModelFactoryNameAcquirable`では`model_factory_name`メソッドでモデルに対応するファクトリ名を取得できるようにします。

{% highlight ruby %}
module ModelFactoryNameAcquirable
  private

  def model_factory_name
    @model_factory_name ||= @model.class.table_name.singularize
  end
end
{% endhighlight %}

## テストを実行

テストを実行するとこんな感じになります。

    Blog::Post
      with validations
        should require unique objects for post_tags with fields blog_tag_id, with message "タグが重複しています"

    Finished in 0.57578 seconds (files took 6.8 seconds to load)
    1 example, 0 failures

うまくテストできました。

## まとめ

カスタムバリデータを作ると対応するマッチャも欲しくなるので作ってみました。
コードは結構長くなってしまいましたが。。
せっかく作ったのでよろしければご利用ください。

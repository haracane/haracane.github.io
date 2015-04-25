RSpecカスタムマッチャでデータベースのUNIQUE制約をテストする

※ この記事は[江の島エンジニアBlog](http://blog.enogineer.com/)の「[RSpecカスタムマッチャでデータベースのUNIQUE制約をテストする](http://blog.enogineer.com/2014/09/09/rspec-db-unique-constraint/)」の転載です。

Railsでモデルを作る時にUNIQUE制約テストも簡単に書きたかったのでカスタムマッチャを作りました

前回、[NOT NULL制約カスタムマッチャの記事](/2014/09/08/rspec-db-not-null-constraint/)を書きましたが、UNIQUE制約のテストもやっぱり面倒なのでUNIQUE制約のRSpecカスタムマッチャも作りました。

たとえばPersonモデルのnameフィールドのUNIQUE制約をテストする場合は

```ruby
describe Person do
  it { should have_not_null_constraint_on(:name) }
end
```

と書いてあげれば

    $ bundle exec rspec spec/models/person_spec.rb
    Person
      should have UNIQUE constraint on name

とテスト実行できます。

以下がUNIQUE制約のカスタムマッチャで、FactoryGirlの利用を前提としています。

```ruby
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
```

ということで、[NOT NULL制約カスタムマッチャ](/2014/09/08/rspec-db-not-null-constraint/)と一緒に活躍してくれるであろうUNIQUE制約カスタムマッチャでした。

### 関連記事
* [RSpecカスタムマッチャでデータベースのNOT NULL制約を簡単にテストする](/2014/09/08/rspec-db-not-null-constraint/)
* [RSpecカスタムマッチャでデータベースの外部キー制約を簡単にテストする](/2014/09/10/rspec-db-foreign-key-constraint/)
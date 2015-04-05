RSpecカスタムマッチャでデータベースの外部キー制約をテストする

※ この記事は[江の島エンジニアBlog](http://blog.enogineer.com/)の「[RSpecカスタムマッチャでデータベースの外部キー制約をテストする](http://blog.enogineer.com/2014/09/10/rspec-db-foreign-key-constraint/)」の転載です。

Railsでモデルを作る時に外部キー制約テストも簡単に書きたかったのでカスタムマッチャを作りました。

[前々回のNOT NULL制約カスタムマッチャの記事](/2014/09/08/rspec-db-not-null-constraint/)と[前回のUNIQUE制約カスタムマッチャの記事](/2014/09/09/rspec-db-unique-constraint/)でDBの制約テストを簡単にしてきましたが、DB制約のRSpecカスタムマッチャも作りました。

例えば

```ruby
describe Person do
  subject { FactoryGirl.create(:person) }
  it { should have_foreign_key_constraint_on(:school_id) }
end
```

と書くと

    $ bundle exec rspec spec/models/person_spec.rb
    Person
      should have FOREIGN KEY constraint on school_id

とテストできるようになります。

カスタムマッチャは

```ruby
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
```

となります。

以上、[NOT NULL制約カスタムマッチャ](/2014/09/08/rspec-db-not-null-constraint/), [UNIQUE制約カスタムマッチャ](/2014/09/09/rspec-db-unique-constraint/)と一緒に使えるDB制約カスタムマッチャでした。

### 関連記事
* [RSpecカスタムマッチャでデータベースのNOT NULL制約を簡単にテストする](/2014/09/08/rspec-db-not-null-constraint/)
* [RSpecカスタムマッチャでデータベースのUNIQUE制約を簡単にテストする](/2014/09/09/rspec-db-unique-constraint/)

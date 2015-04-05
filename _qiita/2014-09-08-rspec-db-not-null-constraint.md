RSpecカスタムマッチャでデータベースのNOT NULL制約をテストする

※ この記事は[江の島エンジニアBlog](http://blog.enogineer.com/)の「[RSpecカスタムマッチャでデータベースのNOT NULL制約をテストする](http://blog.enogineer.com/2014/09/08/rspec-db-not-null-constraint/)」の転載です。

Railsでモデルを作る時にNOT NULL制約テストを簡単に書きたかったのでカスタムマッチャを作りました。

Railsを使っているとDBのフィールドにNOT NULL制約をつけることがよくありますが、テストしようとするとデータを保存してエラーが起きることを確認したりして相当面倒です。

なのでRSpecカスタムマッチャを作りました。

たとえばPersonモデルのnameフィールドのNOT NULL制約をテストする場合は

```ruby
describe Person do
  subject { FactoryGirl.create(:person) }
  it { should have_not_null_constraint_on(:title) }
end
```

と書いてあげれば

    $ bundle exec rspec spec/models/person_spec.rb
    Person
      should have NOT NULL constraint on name

という実行結果になります。

カスタムマッチャはこんな感じです。

```ruby
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
```

DBのNOT NULL制約はよく使うので重宝しそうです。

### 関連記事
* [RSpecカスタムマッチャでデータベースのUNIQUE制約を簡単にテストする](/2014/09/09/rspec-db-unique-constraint/)
* [RSpecカスタムマッチャでデータベースの外部キー制約を簡単にテストする](/2014/09/10/rspec-db-foreign-key-constraint/)

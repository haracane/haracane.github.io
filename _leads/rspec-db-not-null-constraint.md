RSpecカスタムマッチャでデータベースのNOT NULL制約を簡単にテストする

[データベースのNOT NULL制約テストを簡単にするRSpecのカスタムマッチャ](http://blog.enogineer.com/2014/09/08/rspec-db-not-null-constraint/)を作りました。

たとえばPersonモデルのnameフィールドのNOT NULL制約をテストする場合は

```Ruby
describe Person do
  it { should have_not_null_constraint_on(:title) }
end
```

とすればNOT NULL制約をテストできます。

テストを実行すると結果は

    $ bundle exec rspec spec/models/person_spec.rb
    Person
      should have NOT NULL constraint on name

となります。

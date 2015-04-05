RSpecカスタムマッチャでFactoryGirlでのモデル生成をテストする

※ この記事は[江の島エンジニアBlog](http://blog.enogineer.com/)の「[RSpecカスタムマッチャでFactoryGirlでのモデル生成をテストする](http://blog.enogineer.com/2014/10/26/rspec-create-model-matcher/)」の転載です。

Rails4でFactoryGirlがちゃんとしたモデルを生成することを確認したかったのでcreate_modelカスタムマッチャを作りました。

このカスタムマッチャを使うと

```ruby
describe Person do
  it { should create_model }
  it { should create_model.for(2).times }
end
```

と書くことで

    $ bundle exec rspec spec/models/person_spec.rb
    Person
      should create 2 records
      should create 1 record

とテストできるようになります。

カスタムマッチャは

```ruby
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
```

となります。

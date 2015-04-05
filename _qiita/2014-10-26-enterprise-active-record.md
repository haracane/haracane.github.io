Rails4でエンタープライズなActiveRecordモデルを作るための6のステップ

※ この記事は[江の島エンジニアBlog](http://blog.enogineer.com/)の「[Rails4でエンタープライズなActiveRecordモデルを作るための6のステップ](http://blog.enogineer.com/2014/10/26/enterprise-active-record/)」の転載です。

Railsではモデルのひな形を自動生成してくれますが、そのままでは開発現場では使えません。この記事ではRails4のActiveRecordをエンタープライズ用途に使えるようにするために実行している6のステップを紹介します。

## 1. 階層を分けてモデルを作る

まずは`rails g`コマンドでモデルを作ります。たいていの場合はお互いに関連のある複数のモデルを作ることになりますが、それらモデルは同じ階層の下に置くようにします。

例えば

    $ rails g model Blog::User name:string profile:text
    $ rails g model Blog::Post user:references permalink:string title:string content:text

というようにモデルを作成します。

## 2. データベース制約を追加する

Railsが生成するmigrationにはデータベース制約が設定されていないので、そのままではエンタープライズ用途には使えません。

基本的にNOT NULL制約とUNIQUE制約は必ず設定しますし、外部キーがあれば[Foreigner](https://github.com/matthuhiggins/foreigner)を使って外部キー制約も必ず設定します。

```ruby
class CreateBlogPosts < ActiveRecord::Migration
  def change
    create_table :blog_posts do |t|
      t.references :user, index: true, null: false
      t.string :permalink, null: false, limit: 64
      t.string :title, null: false, limit: 128
      t.text :content, null: false

      t.timestamps
    end

    add_index :blog_posts, :permalink, unique: true

    add_foreign_key :blog_posts, :blog_users, column: :user_id
  end
end
```

## 3. モデルにvalidationを追加する

生成されたモデルにはvalidationが設定されていないので追加します。

```ruby
class Blog::Post < ActiveRecord::Base
  belongs_to :user

  validates :permalink, presence: true, uniqueness: true, length: {maximum: 64}
  validates :title, presence: true, length: {maximum: 128}
  validates :content, presence: true

  # 他のよく使うバリデーション例
  # validates :x, uniquness: {scope: :title}
  # validates :x, numericality: {only_integer: true, greater_than_or_equal_to: 0, less_than_or_equal_to: 100}
  # validates :x, inclusion: [:a, :b]
  # validates :x, inclusion: {in: [:a, :b], allow_blank: true}
end
```

## 4. FactoryGirlを定義する

[FactoryGirl](https://github.com/thoughtbot/factory_girl)を導入しているとFactoryGirl用のファイルも生成してくれますが、こちらもそのままでは不十分なのでNOT NULL制約とUNIQUE制約への対応を行います。

```ruby
FactoryGirl.define do
  factory :blog_post, :class => 'Blog::Post' do
    user
    sequence(:permalink) { |n| "permalink_#{n}" }
    title "title"
    content "content"
  end
end
```

## 5. モデルテスト用のマッチャを追加する

続いてモデルのテストを行いますが、その前に必要なマッチャを追加します。

まずは[shoulda-matchers](https://github.com/thoughtbot/shoulda-matchers)を追加しますが、これだけでは不十分なのでいくつかカスタムマッチャを追加します。

今回使うカスタムマッチャは[Rails4のモデル用カスタムマッチャ](/categories/model-spec-custom-matchers)の以下のカスタムマッチャを追加します。

[have_not_null_constraint_onマッチャ]({% post_url 2014-09-08-rspec-db-not-null-constraint %})
: データベースのNOT NULL制約をテストします

[have_unique_constraint_onマッチャ]({% post_url 2014-09-09-rspec-db-unique-constraint %})
: データベースのUNIQUE制約をテストします

[have_foreign_key_constraint_onマッチャ]({% post_url 2014-09-10-rspec-db-foreign-key-constraint %})
: データベースの外部キー制約をテストします

[create_modelマッチャ]({% post_url 2014-10-26-rspec-create-model-matcher %})
: FactoryGirlでのモデル生成をテストします

[safely_validate_uniqueness_ofマッチャ]({% post_url 2014-10-26-rspec-safely-validate-uniqueness-of-matcher %})
: InvalidForeignKeyエラーにならないようにuniqueness validationをテストします

## 6. モデルテストを追加する

カスタムマッチャも追加して準備が整ったのでモデルのテストを追加します。

テストするのは大きく分けてFactoryGirl、Association、Validation、データベース制約の4種類になります。

```ruby
describe Blog::Post, type: :model do
  subject { build(:blog_post) }

  context 'with FactoryGirl' do
    it { should create_model }
    it { should create_model.for(2).times } #uniqueなオブジェクトを生成することを確認
  end

  context 'with associations' do
    it { should belong_to(:user) }
  end

  context 'with validations' do
    it { should validate_presence_of(:user_id) }
    it { should validate_presence_of(:permalink) }
    it { should validate_presence_of(:title) }
    it { should validate_presence_of(:content) }

    it { should ensure_length_of(:permalink).is_at_most(64) }
    it { should ensure_length_of(:title).is_at_most(128) }

    it { should safely_validate_uniqueness_of(:permalink) }

    # 他のよく使うvalidation matcher例
    # it { should allow_value(:a, :b).for(:x) }
    # it { should ensure_length_of(:x).is_at_least(8) }
    # it { should ensure_length_of(:x).is_equal_to(8) }
    # it { should validate_numericality_of(:x).only_integer }
    # it { should validate_numericality_of(:x).is_greater_than_or_equal_to(0) }
    # it { should validate_numericality_of(:x).is_less_than_or_equal_to(100) }
  end

  context 'with DB' do
    it { should have_not_null_constraint_on(:user_id) }
    it { should have_not_null_constraint_on(:permalink) }
    it { should have_not_null_constraint_on(:title) }
    it { should have_not_null_constraint_on(:content) }

    it { should have_unique_constraint_on(:permalink) }

    it { should have_foreign_key_constraint_on(:user_id) }
  end
end
```

`Blog::User`モデルについても一通りちゃんと設定してテストを実行すると

    $ rspec spec/models/blog/post_spec.rb
    Blog::Post
      with associations
        should belong to user
      with validations
        should ensure permalink has a length of at most 64
        should require content to be set
        should ensure title has a length of at most 128
        should require title to be set
        should require permalink to be set
        should require unique value for permalink
        should require user_id to be set
      with DB
        should have NOT NULL constraint on content
        should have UNIQUE constraint on permalink
        should have NOT NULL constraint on permalink
        should have NOT NULL constraint on title
        should have FOREIGN KEY constraint on user_id
        should have NOT NULL constraint on user_id
      with FactoryGirl
        should create 2 records
        should create 1 record

    Finished in 2.15 seconds (files took 12.15 seconds to load)
    16 examples, 0 failures

となってうまくテストできていることが確認できます。

## まとめ

Railsではひな形を自動的に作ってくれてとても便利なのですが、それだけで十分なモデルができるわけではないのでエンタープライズ用途での利用に最低限必要な修正をご紹介しました。

もっとこうした方がいいよ！ということなどありましたら[@haracane](http://twitter.com/haracane)宛に教えてくれるとありがたいです。

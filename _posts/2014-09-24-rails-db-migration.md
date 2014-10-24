---
layout: post
title:  ActiveRecordモデルの設計例
date: 2014-09-24 09:35:27J
tags: Ruby Rails
keywords: Ruby,Rails
description: Railsのmigration例
---

モデル作成コマンドは

    $ rails g model blog/user code:string name:string profile:text school:references birthday:datetime deleted_at:timestamp

マイグレーションファイルは

{% highlight ruby %}
class CreateBlogUsers < ActiveRecord::Migration
  def change
    create_table :blog_users do |t|
      t.string :code, limit: 8
      t.string :name
      t.text :profile
      t.references :group, index: true, null: false
      t.datetime :birthday
      t.timestamp :deleted_at

      t.timestamps
    end

    add_index :blog_users, :code, unique: true, name: index_users_on_code

    add_foreign_key :blog_users, :blog_groups, column: :group_id
  end
end
{% endhighlight %}

という感じ。

モデルは

{% highlight ruby %}
class Blog::User
  validates :code, presence: true, uniqueness: true, length: {maximum: 16}
end
{% endhighlight %}

テストは

{% highlight ruby %}
describe Blog::User, type: :model do
  subject { build(:user) }

  context 'with FactoryGirl' do
    it { should create_model(:user) }
    it { should create_model(:user).for(2).times }
  end

  context 'with associations' do
    it { should belong_to(:group) }
  end

  context 'with validations' do
    it { should ensure_length_of(:code).is_at_most(16) }
    it { should validate_presence_of(:code) }
    it { should validate_uniqueness_of(:code) }
  end

  context 'with DB' do
    it { should have_not_null_constraint_on(:code) }
    it { should have_unique_constraint_on(:code) }
    it { should have_foreign_key_constraint_on(:school_id) }
  end
end
{% endhighlight %}

という感じです。

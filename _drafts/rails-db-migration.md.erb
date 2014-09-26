---
layout: post
title:  Railsのmigration例
date: 2014-09-24 09:35:27J
tags: Ruby Rails
keywords: Ruby,Rails
description: Railsのmigration例
---

### モデル作成

モデル作成コマンドは

    $ rails g model User code:string name:string profile:text school:references birthday:datetime deleted_at:timestamp

マイグレーションファイルは

{% highlight ruby %}
class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :code, limit: 16
      t.string :name, limit: 32
      t.text :profile
      t.references :school, index: true, null: false
      t.datetime :birthday
      t.timestamp :deleted_at

      t.timestamps
    end

    add_index :users, :code, unique: true, name: index_users_on_code

    add_foreign_key :users, :schools
  end
end
{% endhighlight %}

という感じ。

### カラム追加

こんな感じのマイグレーションファイルを作成。

{% highlight ruby %}
class AddAgeToUsers < ActiveRecord::Migration
  def migrate(direction)
    super
    if direction == :up
      Research::Report.update_all(age: 0)
    end
  end

  def change
    add_column :users, :age, :integer, null: false
  end
end
{% endhighlight %}

---
layout: post
title:  Railsのmigration例
date: 2014-09-24 09:35:27J
tags: Ruby Rails
keywords: Ruby,Rails
description: Railsのmigration例
---

モデル作成コマンドは

    $ rails g model User code:string name:string profile:text school:references birthday:datetime deleted_at:timestamp

マイグレーションファイルは

{% highlight ruby %}
class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :code
      t.string :name
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

---
author: haracane
layout: post
title: RailsとElasticsearchとkaminariの組み合わせで気をつけること
date: 2016-12-17 09:32:21J
tags: Rails Elasticsearch
description: RailsでElasticsearchと言えばelasticsearch-rails gemの出番ですが、kaminariと組み合わせる時に気をつけた方が良いことをまとめてみました。小ネタです。
image: rails.png
---
[Rails](/tags/rails/) / [Elasticsearch](/tags/elasticsearch/)

この記事は[Ruby on Rails Advent Calendar 2016](http://qiita.com/advent-calendar/2016/ruby_on_rails)の17日目です。

RailsでElasticsearchといえば[elasticsearch-rails](https://github.com/elastic/elasticsearch-rails)ですね。

今回はelasticsearch-railsと[kaminari](https://github.com/amatsuda/kaminari)を合わせて使う時に押さえておいた方が良いことをまとめてみました。

ただ、基本的には[ドキュメントにも書いてある](https://github.com/elastic/elasticsearch-rails/blob/master/elasticsearch-model/README.md#search-results-as-database-records)ことなのでちゃんとドキュメントを読んでおいた方が良いです。

## 検索結果をArelオブジェクトとして扱うと順番が変わる

まず前準備として、これは[ドキュメントにも書いてあること](https://github.com/elastic/elasticsearch-rails/blob/master/elasticsearch-model/README.md#search-results-as-database-records)なのですが

{% highlight ruby %}
records = User.search(sort: {id: :desc}).records
records.class # => Elasticsearch::Model::Response::Records
records.ids # => ["3", "2", "1"]
{% endhighlight %}

という結果を取得した時に

{% highlight ruby %}
arel = records.includes(:user_category)
arel.class # => Tag::ActiveRecord_Relation
arel.map(&:id) # => [1, 2, 3]
{% endhighlight %}

と、Arelオブジェクトとして評価してしまうと順番が維持されません。

ドキュメントには`to_a`を使うようにと書いてあるのでそうしましょう。

{% highlight ruby %}
User.search(sort: {id: :desc}).records.includes(:user_category).to_a.map(&:id) # => [3, 2, 1]
{% endhighlight %}

## elasticsearch-railsとkaminariと合わせて使う

こちらも[ドキュメントに書いてある](https://github.com/elastic/elasticsearch-rails/blob/master/elasticsearch-model/README.md#pagination)のですが、elasticsearch-railsは[kaminari](https://github.com/amatsuda/kaminari)や[will_paginate](https://github.com/mislav/will_paginate)と合わせて使うことができます。

例えばこんな感じです

{% highlight ruby %}
records = User.search(sort: {id: :desc}).page(1).per(10).records
records.current_page # => 1
records.limit_value  # => 10
records.total_count  # => 3
{% endhighlight %}

ここまでは特に問題ありません。

## 検索結果をArelオブジェクトとして扱う＆kaminariと合わせて使う

検索結果をArelオブジェクトとして扱いたくて、さらにページングもやりたいという時は問題が起きます。

普通に書くと

{% highlight ruby %}
records = User.search(sort: {id: :desc}).page(1).per(10).records.includes(:user_category).to_a
{% endhighlight %}

となりますが、`to_a`で返ってくるのは`Array`オブジェクトなので、ページング情報が失われてしまいます。

この場合は少し面倒ですが、こんな感じにする必要があります。

{% highlight ruby %}
records = User.search(sort: {id: :desc}).page(1).per(10).records
records.class # => Elasticsearch::Model::Response::Records
kaminari_options = {
  limit: records.limit_value,
  offset: records.offset_value,
  total_count: records.total_count
}
arel = records.includes(:user_category)
paginatable_array = Kaminari.paginate_array(arel.to_a, kaminari_options)
paginatable_array.class # => Kaminari::PaginatableArray
paginatable_array.map(&:id) # => [3, 2, 1]
{% endhighlight %}

ただ、これをそのままメソッド化してしまうと`Arel`オブジェクトのメソッドチェーンを自由にできないので、こんな感じにしておくと良いと思います。

{% highlight ruby %}
class BaseSearcher
  def initialize(params)
    @params = params
  end

  def search(options = {}, &block)
    page = options[:page] || 1
    per = options[:per] || 10
    model.search(@params).page(page).per(per).records
    kaminari_options = {
      limit: records.limit_value,
      offset: records.offset_value,
      total_count: records.total_count
    }
    records = yield(records) if block_given?
    Kaminari.paginate_array(arel.to_a, kaminari_options)
  end
end

module Users
  class Searcher < BaseSearcher
    def model
      User
    end
  end
end
{% endhighlight %}

使い方はこんな感じですね

{% highlight ruby %}
records = Users::Searcher.new(sort: {id: :desc}).search(page: 1, per: 10) { |scope| scope.includes(:user_category) }
records.map(&:id)    # => [3, 2, 1]
records.current_page # => 1
records.limit_value  # => 10
records.total_count  # => 3
{% endhighlight %}

## まとめ

ドキュメントはちゃんと読みましょう。

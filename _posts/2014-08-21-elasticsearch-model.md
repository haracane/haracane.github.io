---
layout: post
title:  "elasticsearch-rails0.1.4を使ってRails4.1.5でN-gram検索する"
description: "RailsからElasticsearchを使う場合に推奨となっているelasticsearch-rails gemを使ってN-gram検索機能を作ってみます."
date:   2014-08-21 06:36:46J
tags: Elasticsearch Ruby Rails
---

RailsからElasticsearchを使う場合に推奨となっている[elasticsearch-rails gem](https://github.com/elasticsearch/elasticsearch-rails)を使ってN-gram検索機能を作ってみます.

この記事ではレシピ検索をする場合を例に検索機能を追加します.

## 検索機能を追加するモデルを作る

まずは基本となるRecipeモデルを作成します

    $ rails new search_recipe
    $ cd search_recipe
    $ bundle install
    $ bundle exec rails g model recipe title:string description:text url:string
    $ bundle exec rake db:create
    $ bundle exec rake db:migrate

Recipeデータもいくつか追加しておきましょう.

    $ bundle exec rails console
    > Recipe.create(title: "ミックス赤玉で豚玉を作ってみた", description: "業務スーパーで買ったのは卵(ミックス赤玉)だけですが、豚玉炒めを作りました。", url: "http://gsrecipe.com/2014/08/09/butatama/")
    Recipe.create(title: "パルメザンチーズで濃厚カルボナーラ", description: "業務スーパーのパルメザンチーズ(200g入り！)と卵でカルボナーラを作りました。", url: "http://gsrecipe.com/2014/08/10/carbonara/")
    Recipe.create(title: "ミックス赤玉で卵焼き", description: "またまた卵ですが業務スーパーのミックス赤玉で卵焼きを作りました。", url: "http://gsrecipe.com/2014/08/13/tamagoyaki/")
    Recipe.create(title: "パプリカを使った野菜たっぷりスープ", description: "業務スーパーの冷凍パプリカを使って野菜スープを作りました。我が家の恒例朝食メニューです。", url: "http://gsrecipe.com/2014/08/14/vegesoup/")

## elasticsearch-railsをインストールする

まずはelasticsearch-railsとelasticsearch-modelをGemfileに追加して```bundle install```します.

**Gemfile**
{% highlight ruby %}
gem "elasticsearch-rails"
gem "elasticsearch-model"
{% endhighlight %}

## Elasticsearch::Modelをincludeする

Elasticsearch::ModelモジュールをRecipeクラスでincludeします

**app/models/recipe.rb**
{% highlight ruby %}
require "elasticsearch/model"

class Recipe < ActiveRecord::Base
  include Elasticsearch::Model
end
{% endhighlight %}

これで最低限の機能は利用できます.

    $ bundle exec rails console
    > Rails.import
    > Recipe.search("卵").records.map(&:title)
      Recipe Load (0.2ms)  SELECT "recipes".* FROM "recipes"  WHERE "recipes"."id" IN (11, 9, 10)
    => ["ミックス赤玉で卵焼き", "ミックス赤玉で豚玉を作ってみた", "パルメザンチーズで濃厚カルボナーラ"]

## N-gramアナライザを設定する

上記の例はデフォルトのアナライザを利用した例ですが, 続いて自分でN-gramアナライザを設定してみます.

まずN-gramアナライザをセッティングに追加します.

**app/models/recipe.rb**
{% highlight ruby %}
class Recipe < ActiveRecord::Base
  include Elasticsearch::Model

  settings analysis: {
      tokenizer: {
        ngram_tokenizer: {
          type: "nGram",
          min_gram: "2",
          max_gram: "3",
          token_chars: [
            "letter",
            "digit"
          ]
        }
      },
      analyzer: {
        ngram_analyzer: {
          tokenizer: "ngram_tokenizer"
        }
      }
    }
end
{% endhighlight %}

セッティングを有効にするためにインデックスを作り直します.

    $ bundle exec rails console
    > Recipe.__elasticsearch__.create_index! force: true
    > Recipe.__elasticsearch__.refresh_index!

設定されたセッティングを確認します.

    > Recipe.__elasticsearch__.client.indices.get_settings["recipes"]
    => {"settings"=>
      {"index"=>
        {"uuid"=>"vBlZkYiaQAKBI7s3n08QOA",
         "analysis"=>
          {"analyzer"=>{"ngram_analyzer"=>{"tokenizer"=>"ngram_tokenizer"}},
           "tokenizer"=>
            {"ngram_tokenizer"=>
              {"max_gram"=>"3",
               "type"=>"nGram",
               "min_gram"=>"2",
               "token_chars"=>["letter", "digit"]}}},
         "number_of_replicas"=>"1",
         "number_of_shards"=>"5",
         "version"=>{"created"=>"1030199"}}}}

## マッピングの設定をする

次に実際にレシピデータをN-gramアナライザで解析するマッピングの設定を行います.

**app/models/concerns/recipe/searchable.rb**
{% highlight ruby %}
class Recipe < ActiveRecord::Base
  settings ...

  mappings do
    indexes :id, type: :long, index: :not_analyzed
    indexes :title, type: :string, index: :analyzed, analyzer: :ngram_analyzer
    indexes :description, type: :string, index: :analyzed, analyzer: :ngram_analyzer
    indexes :url, type: :string, index: :analyzed, analyzer: :ngram_analyzer
  end
end
{% endhighlight %}

またインデックスを作り直します.

    $ bundle exec rails console
    > Recipe.__elasticsearch__.create_index! force: true
    > Recipe.__elasticsearch__.refresh_index!

設定されたマッピングを確認します

    > Recipe.__elasticsearch__.client.indices.get_mapping["recipes"]
    => {"mappings"=>
      {"recipe"=>
        {"properties"=>
          {"created_at"=>{"type"=>"date", "format"=>"dateOptionalTime"},
           "description"=>{"type"=>"string", "analyzer"=>"ngram_analyzer"},
           "id"=>{"type"=>"long"},
           "title"=>{"type"=>"string", "analyzer"=>"ngram_analyzer"},
           "updated_at"=>{"type"=>"date", "format"=>"dateOptionalTime"},
           "url"=>{"type"=>"string", "analyzer"=>"ngram_analyzer"}}}}}

DBのレシピデータをElasticsearchにインポートします

    > Recipe.import

レシピデータを検索します

    > Recipe.search("ミックス赤玉").records.map(&:title)
  Recipe Load (0.2ms)  SELECT "recipes".* FROM "recipes"  WHERE "recipes"."id" IN (1, 3)
=> ["ミックス赤玉で豚玉を作ってみた", "ミックス赤玉で卵焼き"]

結果が全く同じなので区別がつきにくいですが, うまくできました.

次回はRecipeモデルのElasticsearch検索機能のテストをしようと思います.

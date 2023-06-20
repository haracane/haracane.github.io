---
layout: post
title:  "elasticsearch-rails0.1.4の検索機能をRSpecでテストする"
description: "前回RailsからElasticsearchを使ってみましたが, 今回はRSpecでモデルのElasticsearch機能のテストを行います."
date:   2014-08-22 20:12:24J
tags: Elasticsearch Ruby Rails RSpec
---
[Elasticsearch](/tags/elasticsearch/) / [Ruby](/tags/ruby/) / [Rails](/tags/rails/) / [RSpec](/tags/rspec/)

## セッティングをテストする

まずは正しくセッティングされていることをテストします.

最初にインデックスの再作成を行います.

**spec/models/recipe_spec.rb**
{% highlight ruby %}
require 'rails_helper'

describe Recipe do
  before :all do
    Recipe.__elasticsearch__.create_index! force: true
    Recipe.__elasticsearch__.refresh_index!
  end
end
{% endhighlight %}

続いて取得したセッティングのトークナイザとアナライザの確認を行います.

**spec/models/recipe_spec.rb**
{% highlight ruby %}
describe Recipe do
  ...

  context "with settings" do
    let(:settings) { Recipe.__elasticsearch__.client.indices.get_settings[Recipe.index_name] }
    let(:analysis) { settings["settings"]["index"]["analysis"] }

    context "with tokenizer" do
      subject { analysis["tokenizer"]}
      it do
        should eq({"ngram_tokenizer" =>
                     {"max_gram" => "3",
                      "type" => "nGram",
                      "min_gram" => "2",
                      "token_chars" => ["letter", "digit"]}})
      end
    end

    context "with analyzer" do
      subject { analysis["analyzer"]}
      it { should eq({"ngram_analyzer" => {"tokenizer" => "ngram_tokenizer"}}) }
    end
  end
end
{% endhighlight %}

ここではN-gramのトークナイザとアナライザが設定されていることを確認しています.

## マッピングをテストする

続いてマッピング設定をテストします.

**spec/models/recipe_spec.rb**
{% highlight ruby %}
describe Recipe do
  ...

  context "with mappings" do
    subject { Recipe.__elasticsearch__.client.indices.get_mapping index: Recipe.index_name }

    it do
      should eq({
        "recipes" => {
          "mappings" => {
            "recipe" => {
              "properties" => {
                "id" => {"type" => "long"},
                "title" => {"type" => "string",
                            "analyzer" => "ngram_analyzer"},
                "description" => {"type" => "string",
                                  "analyzer" => "ngram_analyzer"},
                "url" => {"type" => "string",
                          "analyzer" => "ngram_analyzer"}
              }
            }
          }
        }
      })
    end
  end
end
{% endhighlight %}

ちょっとネストが深いですが, title/description/urlフィールドにそれぞれN-gramアナライザが設定されていることを確認しています.

## 検索機能をテストする

最後に検索機能のテストをします.

まずは検索用のテストデータをインポートします.

**spec/models/recipe_spec.rb**
{% highlight ruby %}
describe Recipe do
  ...

  describe ".search" do
    before :all do
      Recipe.delete_all

      Recipe.create(title: "ミックス赤玉で豚玉を作ってみた", description: "業務スーパーで買ったのは卵(ミックス赤玉)だけですが、豚玉炒めを作りました。", url: "http://gsrecipe.com/2014/08/09/butatama/")
      Recipe.create(title: "パルメザンチーズで濃厚カルボナーラ", description: "業務スーパーのパルメザンチーズ(200g入り！)と卵でカルボナーラを作りました。", url: "http://gsrecipe.com/2014/08/10/carbonara/")
      Recipe.create(title: "ミックス赤玉で卵焼き", description: "またまた卵ですが業務スーパーのミックス赤玉で卵焼きを作りました。", url: "http://gsrecipe.com/2014/08/13/tamagoyaki/")
      Recipe.create(title: "パプリカを使った野菜たっぷりスープ", description: "業務スーパーの冷凍パプリカを使って野菜スープを作りました。我が家の恒例朝食メニューです。", url: "http://gsrecipe.com/2014/08/14/vegesoup/")

      Recipe.__elasticsearch__.import
      Recipe.__elasticsearch__.refresh_index!
    end
  end
end
{% endhighlight %}

ここではDBに作成したRecipeデータをElastisearchにインポートしています.

また, 最後の```refresh_index!```では強制的にインデックスを更新しています.

Elastisearchでのインデックス更新は非同期なので, 確実にインデックスを更新したい場合はこのように```refresh_index!```メソッドを実行する必要があります.

続いて更新したインデックスから検索できるかテストします.

**spec/models/recipe_spec.rb**
{% highlight ruby %}
describe Recipe do
  ...

  describe ".search" do
    ...

    context "when query is 'ミックス赤玉'" do
      let(:query) { "ミックス赤玉" }
      let(:records) { Recipe.search(query).records }
      subject { records }
      it { should have(2).items }

      context "with titles" do
        subject { records.map(&:title) }
        it { should match_array ["ミックス赤玉で豚玉を作ってみた", "ミックス赤玉で卵焼き"] }
      end
    end
  end
end
{% endhighlight %}

実行してみると

    $ bundle exec rspec spec/models/recipe_spec.rb -f d
    Recipe
      with settings
        with tokenizer
          should eq {"ngram_tokenizer"=>{"max_gram"=>"3", "type"=>"nGram", "min_gram"=>"2", "token_chars"=>["letter", "digit"]}}
        with analyzer
          should eq {"ngram_analyzer"=>{"tokenizer"=>"ngram_tokenizer"}}
      with mappings
        should eq {"recipes"=>{"mappings"=>{"recipe"=>{"properties"=>{"id"=>{"type"=>"long"}, "title"=>{"type"=>"string", "analyzer"=>"ngram_analyzer"}, "description"=>{"type"=>"string", "analyzer"=>"ngram_analyzer"}, "url"=>{"type"=>"string", "analyzer"=>"ngram_analyzer"}}}}}}
      .search
        when query is 'ミックス赤玉'
          should have 2 items
          with titles
            should contain exactly "ミックス赤玉で豚玉を作ってみた" and "ミックス赤玉で卵焼き"

    Finished in 2.12 seconds (files took 1.14 seconds to load)
    5 examples, 0 failures

ということで無事Elasticsearchでの検索機能をテストできました.

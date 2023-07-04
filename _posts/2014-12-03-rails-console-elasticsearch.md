---
author: haracane
layout: post
title: Rails ConsoleでActiveRecordをElasticsearchに放り込んでみる
date: 2014-12-03 07:08:56J
tags:
- Elasticsearch
- ActiveRecord
- Rails
- Ruby
keywords: Elasticsearch ActiveRecord Rails Ruby
description: ActiveRecordのデータをElasticsearchに放り込むのはとても簡単なので、Rails Consoleから実践してみます。
image: "/assets/images/posts/rails.png"
---
<!-- tag_links -->
[Elasticsearch](/tags/elasticsearch/) / [ActiveRecord](/tags/activerecord/) / [Rails](/tags/rails/) / [Ruby](/tags/ruby/)

<!-- content -->
この記事は[Elasticsearch Advent Calendar 2014](http://qiita.com/advent-calendar/2014/elasticsearch)の3日目です。

2日目は[@ariarijp](http://qiita.com/ariarijp)さんの「[入門記事：ElasticSearch1.4.0とKibana4.0.0の環境構築](http://qiita.com/ariarijp/items/d0fc7a4161f56f4cda32)」でした。おつかれさまでした。

ではさっそくはじめましょう。

## elasticsearch-rails Gemを追加する

Rails Consoleを起動する前にまずGemfileに

{% highlight ruby %}
gem 'elasticsearch-model'
gem 'elasticsearch-rails'
{% endhighlight %}

を追加します。

`bundle install`で[elasticsearch-rails](https://github.com/elasticsearch/elasticsearch-rails)をインストールしたら、Rails Consoleを起動します。

    % rails c

## Elasticsearch::Modelを組み込む

最初に扱いたいデータのActiveRecordモデルクラスで`Elasticsearch::Model`を`include`します。

{% highlight ruby %}
> class Blog::Site; include Elasticsearch::Model; end
=> Blog::Site (call 'Blog::Site.connection' to establish a connection)
{% endhighlight %}

これで`Blog::Site`モデルに一通りメソッドが追加されます。

## Elasticsearchにデータをインポートする

Elasticsearchへのインポートには`import`メソッドを使います。

{% highlight ruby %}
> Blog::Site.__elasticsearch__.import
# Blog::Site Load (1.9ms)  SELECT  `blog_sites`.* FROM `blog_sites`   ORDER BY `blog_sites`.`id` ASC LIMIT 1000
=> 0
{% endhighlight %}

続いてElasticsearchに問い合わせてインポート結果を確認します。

## マッピングを確認する

Elasticsearchに問い合わせるにはインデックス名とタイプ名が必要なので、まずはそちらを確認してみます。

{% highlight ruby %}
> Blog::Site.__elasticsearch__.index_name
"blog-sites"
> Blog::Site.__elasticsearch__.document_type
"site"
{% endhighlight %}

`blog-sites`インデックスの`site`タイプとして登録されたようです。

この名前がわかればElasticsearchのAPIにアクセスできるので、インポート結果を確認してみましょう。

マッピングを確認する方法はいくつかあるのですが、今回は`perform_request`を使います。

{% highlight ruby %}
> Blog::Site.__elasticsearch__.client.perform_request(
  :get,
  'blog-sites/site/_mapping'
).body
=> {"blog-sites"=>
  {"mappings"=>
    {"site"=>
      {"properties"=>
        {"created_at"=>{"type"=>"date", "format"=>"dateOptionalTime"},
         "description"=>{"type"=>"string"},
         "id"=>{"type"=>"long"},
         "language"=>{"type"=>"string"},
         "title"=>{"type"=>"string"},
         "updated_at"=>{"type"=>"date", "format"=>"dateOptionalTime"},
         "user_id"=>{"type"=>"long"}}}}}}
{% endhighlight %}

各プロパティが`long`, `string`, `date`型で登録されていますね。

## 件数を取得する

続いて件数も見てみましょう。

{% highlight ruby %}
> Blog::Site.__elasticsearch__.client.perform_request(
  :get,
  'blog-sites/site/_count'
).body
=> {"count"=>3, "_shards"=>{"total"=>5, "successful"=>5, "failed"=>0}}
{% endhighlight %}

## データを確認する

id=1のデータの中身も見てみます。

{% highlight ruby %}
> Blog::Site.__elasticsearch__.client.perform_request(
  :get,
  'blog-sites/site/1'
).body
=> {"_index"=>"blog-sites",
 "_type"=>"site",
 "_id"=>"1",
 "_version"=>1,
 "found"=>true,
 "_source"=>
  {"id"=>1,
   "user_id"=>11,
   "language"=>"ja",
   "title"=>"Railsブログ",
   "description"=>"Railsの技術ブログです",
   "created_at"=>"2014-11-07T09:32:46.000+09:00",
   "updated_at"=>"2014-11-07T09:32:46.000+09:00"}}
{% endhighlight %}

ちゃんとデータが取得できました。

## フィルタで検索する

続いて検索をしてみましょう。検索には`search`メソッドを利用します。

まずは[termフィルタ](http://www.elasticsearch.org/guide/en/elasticsearch/reference/current/query-dsl-term-filter.html)を利用して`language`が`ja`のデータを検索してみます。

{% highlight ruby %}
> Blog::Site.search(
  filter: {term: {language: 'ja'}}
).records.to_a
# Blog::Site Load (0.3ms)  SELECT `blog_sites`.* FROM `blog_sites`  WHERE `blog_sites`.`id` IN (2, 1)
=> [#<Blog::Site id: 2, user_id: 11, language: "ja", title: "Elasticsearchブログ", description: "Elasticsearchの技術ブログです", created_at: "2014-11-07 00:32:47", updated_at: "2014-11-07 00:32:47">,
 #<Blog::Site id: 1, user_id: 11, language: "ja", title: "Railsブログ", description: "Railsの技術ブログです", created_at: "2014-11-07 00:32:46", updated_at: "2014-11-07 00:32:46">]
{% endhighlight %}

2件のデータがヒットしました。

## クエリで検索する

続いて[matchクエリ](http://www.elasticsearch.org/guide/en/elasticsearch/reference/current/query-dsl-match-query.html)で`title`にElasticsearchを含むデータを検索してみましょう

{% highlight ruby %}
> Blog::Site.search(
  query: {match: {title: 'Elasticsearch'}}
).records.to_a
# Blog::Site Load (0.2ms)  SELECT `blog_sites`.* FROM `blog_sites`  WHERE `blog_sites`.`id` IN (2)
=> [#<Blog::Site id: 2, user_id: 11, language: "ja", title: "Elasticsearchブログ", description: "Elasticsearchの技術ブログです", created_at: "2014-11-07 00:32:47", updated_at: "2014-11-07 00:32:47">]
{% endhighlight %}

ちゃんとElasticsearchのデータが検索できました。

## アグリゲーションで集計する

次は[termsアグリゲーション](http://www.elasticsearch.org/guide/en/elasticsearch/reference/current/search-aggregations-bucket-terms-aggregation.html)で`language`毎の件数を集計してみます。

{% highlight ruby %}
> Blog::Site.__elasticsearch__.search(
  {aggs: {agg: {terms: {field: :language}}}},
  search_type: :count
).response["aggregations"]
=> {"agg"=>{"buckets"=>[{"key"=>"ja", "doc_count"=>2}]}}
{% endhighlight %}

`language`がjaのデータが2件という集計結果でした。

## インデックスを削除する

一通り動作を確認したので、最後にインデックスを削除します。

{% highlight ruby %}
> Blog::Site.__elasticsearch__.delete_index!
=> {"acknowledged"=>true}
{% endhighlight %}

削除したらこのままRails Consoleを抜けておしまいです。

## まとめ

今回はElasticsearchをRailsから手軽に扱う方法をご紹介しました。

Elasticsearchに慣れた後でも、データベースのデータをサッとElasticsearchに入れて動作確認できると結構便利なのでそういった時にも参考にしていただければ良いかと思います。

もちろんやろうと思えばもっといろんなことができるので、その際はElasticsearchやElasticsearch-railsのドキュメントを見ながら色々試してみてください。

4日目は[@tady](http://qiita.com/tady)さんです。よろしくお願いします。

## 参考文献

* [Elasticsearch Filters](http://www.elasticsearch.org/guide/en/elasticsearch/reference/current/query-dsl-filters.html)
* [Elasticsearch Queries](http://www.elasticsearch.org/guide/en/elasticsearch/reference/current/query-dsl-queries.html)
* [Elasticsearch Aggregations](http://www.elasticsearch.org/guide/en/elasticsearch/reference/current/search-aggregations.html)

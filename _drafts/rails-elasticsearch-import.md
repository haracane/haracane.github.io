---
layout: post
title: Elasticsearchにデータをインポートする
date: 2014-10-31 07:50:49J
tags: Elasticsearch Rails ActiveRecord
keywords: Elasticsearch elasticsearch-rails Rails ActiveRecord
description: Rails4.1.6でelasticsearch-rails0.1.6を使ってElasticsearchから検索をしてみます。
categories: rails-elasticsearch
---

### Elasticsearch::Modelの導入

[elasticsearch-rails](http://github.com/elasticsearch-rails/elasticsearch-rails)を使うと

{% highlight ruby %}
class Blog::Post < ActiveRecord::Base
  include Elasticsearch::Model
end
{% endhighlight %}

とするだけでElasticsearchから検索できます。

### テストデータの作成

まずはデータベースにテストデータを作成します。

{% highlight ruby %}
blog_user = FactoryGirl.create(:blog_user, name: 'haracane')
FactoryGirl.create(:blog_post, user: blog_user, content: 'ActiveRecordの使い方')
FactoryGirl.create(:blog_post, user: blog_user, content: 'Elasticsearchの使い方')
{% endhighlight %}

### Elasticsearchへのインポート

次にインポートを実行します

{% highlight ruby %}
Blog::Post.__elasticsearch__.import
{% endhighlight %}

### マッピングの確認

インポートが終わるとマッピングが自動的に作成されるので、まずそちらを確認します。

{% highlight ruby %}
> ap Blog::Post.__elasticsearch__.client.indices.get_mapping(index: Blog::Post.index_name)
{
    "blog-posts" => {
        "mappings" => {
            "post" => {
                "properties" => {
                       "content" => {
                        "type" => "string"
                    },
                    "created_at" => {
                          "type" => "date",
                        "format" => "dateOptionalTime"
                    },
                            "id" => {
                        "type" => "long"
                    },
                     "permalink" => {
                        "type" => "string"
                    },
                         "title" => {
                        "type" => "string"
                    },
                    "updated_at" => {
                          "type" => "date",
                        "format" => "dateOptionalTime"
                    },
                       "user_id" => {
                        "type" => "long"
                    }
                }
            }
        }
    }
}
{% endhighlight %}

ちゃんとblog-postsインデックスにpostタイプで各フィールドがマッピングされていることが確認できます。

### インポート結果の確認

続いてインポート結果の確認です。

{% highlight ruby %}
ap Blog::Post.__elasticsearch__.client.indices.perform_request(:get, 'blog-posts/post/_count').body
{
      "count" => 2,
    "_shards" => {
             "total" => 5,
        "successful" => 5,
            "failed" => 0
    }
}
{% endhighlight %}

ちゃんと2件登録されているようです。

データの中身も確認するなら

{% highlight ruby %}
ap Blog::Post.__elasticsearch__.client.indices.perform_request(:get, 'blog-posts/post/1').body
{
      "_index" => "blog-posts",
       "_type" => "post",
         "_id" => "1",
    "_version" => 4,
       "found" => true,
     "_source" => {
                "id" => 1,
           "user_id" => 1,
         "permalink" => "permalink_1",
             "title" => "title",
           "content" => "ActiveRecordの使い方",
        "created_at" => "2014-10-29T10:56:34.000Z",
        "updated_at" => "2014-10-29T10:56:34.000Z"
    }
}
{% endhighlight %}

と、id=1のデータが登録されていることを確認できます。

---
layout: post
title: Elasticsearchにデータを検索する
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

### インポート結果の確認

[Marvel]()から`GET blog-posts/_settings`を実行すると

{
   "blog-posts": {
      "settings": {
         "index": {
            "number_of_replicas": "1",
            "number_of_shards": "5",
            "uuid": "xHu-G6XpTzSbEf4VBABwpw",
            "version": {
               "created": "1030199"
            }
         }
      }
   }
}

### インポートの確認

[Marvel]()からElasticsearchに登録された件数を確認すると

{% highlight javascript %}
GET blog-posts/post/_count
{
   "count": 2,
   "_shards": {
      "total": 5,
      "successful": 5,
      "failed": 0
   }
}
{% endhighlight %}

とちゃんと2件登録されてます。



idが1のデータを見るのであれば

でデータベースからElasticsearchにデータをインポートして

{% highlight ruby %}
Blog::Post.search("ActiveRecord").records.to_a
# => [#<Blog::Post id: 1, user_id: 1, permalink: "permalink_1", title: "title", content: "ActiveRecordの使い方", created_at: "2014-10-29 10:56:34", updated_at: "2014-10-29 10:56:34">]
{% endhighlight %}

とすることで検索できます。（ただしデフォルトでは日本語がうまく扱えません）

Elasticsearchのクエリを組み立てるなら

{% highlight ruby %}
Blog::Post.search(query: {match: {content: "ActiveRecord"}}).records.to_a
# => [#<Blog::Post id: 1, user_id: 1, permalink: "permalink_1", title: "title", content: "ActiveRecordの使い方", created_at: "2014-10-29 10:56:34", updated_at: "2014-10-29 10:56:34">]{% endhighlight %}

という感じになります。

直接Elaticsearchに問い合わせるなら



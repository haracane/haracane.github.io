---
layout: post
title: Rails4からElasticsearchで検索する
date: 2014-10-28 07:50:49J
tags: Elasticsearch Rails ActiveRecord
keywords: Elasticsearch elasticsearch-rails Rails ActiveRecord
description: Rails4.1.6でelasticsearch-rails0.1.6を使ってElasticsearchから検索をしてみます。
---

[elasticsearch-rails](http://github.com/elasticsearch-rails/elasticsearch-rails)を使うと

{% highlight ruby %}
class Blog::Post < ActiveRecord::Base
  include Elasticsearch::Model
end
{% endhighlight %}

とするだけでElasticsearchから検索できます。

{% highlight ruby %}
blog_user = FactoryGirl.create(:blog_user, name: 'haracane')
FactoryGirl.create(:blog_post, user: blog_user, content: 'ActiveRecordの使い方')
FactoryGirl.create(:blog_post, user: blog_user, content: 'Elasticsearchの使い方')
{% endhighlight %}

というテストデータを作ってから

{% highlight ruby %}
Blog::Post.import
Blog::Post.search("ActiveRecord")
Blog::Post.search(query: {match: {content: "ct"}})
{% endhighlight %}
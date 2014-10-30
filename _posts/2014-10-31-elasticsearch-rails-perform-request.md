---
layout: post
title: elasticsearch-railsで任意のリクエストを送れるperform_requestメソッドが便利
date: 2014-10-31 07:59:39J
tags: Elasticsearch Rails Ruby
keywords: Elasticsearch Rails Ruby
description: elasticsearch-railsのソースを軽く読んでいたら、任意のリクエストを送れるperform_requestという便利メソッドがあったので紹介します。
image: rails.png
---

`Blog::Post`が`Elasticsearch::Model`を`include`しているとして

{% highlight ruby %}
Blog::Post.__elasticsearch__.client.perform_request(:get, 'blog-posts/_count').body
=> {"count"=>2, "_shards"=>{"total"=>5, "successful"=>5, "failed"=>0}}
{% endhighlight %}

という感じで任意のHTTPリクエストを送れます。

[Awesome Print](https://github.com/michaeldv/awesome_print)を使って結果を見やすく。

{% highlight ruby %}
ap Blog::Post.__elasticsearch__.client.perform_request(:get, 'blog-posts/_count').body
{
      "count" => 2,
    "_shards" => {
             "total" => 5,
        "successful" => 5,
            "failed" => 0
    }
}
{% endhighlight %}

メソッドのインタフェースは

{% highlight ruby %}
(Object) perform_request(method, path, params = {}, body = nil)
{% endhighlight %}

となっています。ドキュメントは[こちら](http://www.rubydoc.info/gems/elasticsearch-transport/Elasticsearch/Transport/Client:perform_request)。

これでいちいちcurlや[Marvel](http://www.elasticsearch.org/overview/marvel/)に切り替えなくてもサクッとElasticsearchの応答を確認できますね。



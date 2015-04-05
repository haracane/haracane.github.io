elasticsearch-railsで任意のリクエストを送れるperform_requestメソッドが便利

※ この記事は[江の島エンジニアBlog](http://blog.enogineer.com/)の「[elasticsearch-railsで任意のリクエストを送れるperform_requestメソッドが便利](http://blog.enogineer.com/2014/10/31/elasticsearch-rails-perform-request/)」の転載です。

elasticsearch-railsのソースを軽く読んでいたら、任意のリクエストを送れるperform_requestという便利メソッドがあったので紹介します。

`Blog::Post`が`Elasticsearch::Model`を`include`しているとして

```ruby
Blog::Post.__elasticsearch__.client.perform_request(:get, 'blog-posts/_count').body
=> {"count"=>2, "_shards"=>{"total"=>5, "successful"=>5, "failed"=>0}}
```

という感じで任意のHTTPリクエストを送れます。

[Awesome Print](https://github.com/michaeldv/awesome_print)を使えば結果も見やすくなります。

```ruby
ap Blog::Post.__elasticsearch__.client.perform_request(:get, 'blog-posts/_count').body
{
      "count" => 2,
    "_shards" => {
             "total" => 5,
        "successful" => 5,
            "failed" => 0
    }
}
```

メソッドのインタフェースは

```ruby
(Object) perform_request(method, path, params = {}, body = nil)
```

となっています。ドキュメントは[こちら](http://www.rubydoc.info/gems/elasticsearch-transport/Elasticsearch/Transport/Client:perform_request)。

これでいちいちcurlや[Marvel](http://www.elasticsearch.org/overview/marvel/)に切り替えなくてもサクッとElasticsearchの応答を確認できますね。



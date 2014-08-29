---
layout: post
title:  "Rubyでオブジェクトの初期化にハッシュを使う時に手を抜く"
description: "Rubyでハッシュを使ってオブジェクトの初期化をする時によくこんなことしてます"
date:   2014-08-30 01:31:58J
keywords: Ruby,手抜き
tags: Ruby
---

{{ page.description }}

{% highlight ruby %}
class User
  attr_accessor :name
  def initialize(params = {})
    params.each_pair do |key, value|
      setter_method = "#{key}="
      send(setter_method, value) if respond_to?(setter_method)
    end
  end
end
{% endhighlight %}

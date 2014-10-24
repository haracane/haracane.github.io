---
layout: post
title:  "Rubyでデータオブジェクト用クラスを手抜き作成"
description: "Rubyでとりあえずデータオブジェクト用のクラスが欲しい時によくこんなことしてます"
date:   2014-08-30 01:31:58J
keywords: Ruby,手抜き
tags: Ruby
---

コードはこんな感じです。

{% highlight ruby %}
require "json"

class Person
  def self.parse_json(json)
    new(JSON.parse(json))
  end

  attr_accessor :name

  def initialize(params)
    params.each_pair do |key, value|
      setter_method = "#{key}="
      send(setter_method, value) if respond_to?(setter_method)
    end
  end

  def to_hash
    keys = instance_variables.map { |v| v.to_s.gsub(/@/, "").to_sym }
    keys.reject! do |key|
      !respond_to?(key) ||
      send(key).tap { |v| break v.nil? || (v.respond_to?(:empty?) && v.empty?) }
    end
    Hash[keys.map { |k| [k, send(k)] }]
  end

  def to_json
    to_hash.to_json
  end
end
{% endhighlight %}

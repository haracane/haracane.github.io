Rubyでデータオブジェクト用クラスを手抜き作成

※ この記事は[江の島エンジニアBlog](http://blog.enogineer.com/)の「[Rubyでデータオブジェクト用クラスを手抜き作成](http://blog.enogineer.com/2014/08/30/initialize-with-params/)」の転載です。

Rubyでとりあえずデータオブジェクト用のクラスが欲しい時によくこんなことしてます

コードはこんな感じです。

```ruby
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
```

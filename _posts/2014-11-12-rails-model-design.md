---
layout: post
title: Rails4.1.7のActiveRecordにCallbackクラス＆Validatorクラス＆Valueオブジェクトを組み込んでみる
date: 2014-11-12 07:46:13J
tags: ActiveRecord Rails Ruby
keywords: Callback Validator Valueオブジェクト ActiveRecord Rails Ruby
description: ActiveRecordに楽をさせてくれるCallback・Validator・Valueオブジェクトを、過去文献を参考に組み込んでみました。
image: rails.png
---

ActiveRecordモデルのコードはこんな感じです。

{% highlight ruby %}
# app/models/blog/site.rb
class Blog::Site < ActiveRecord::Base
  validates :title, presence: true
  validates :description, presence: true
  validates_with Blog::SiteDescriptionSignificanceValidator

  before_save Blog::SiteLanguageEstimator.new(:language)

  def rating
    @rating ||= Blog::SiteRating.from_description(description)
  end
end
{% endhighlight %}

ここでは

* カスタムValidatorで`description`の内容をチェックする
* Callbackクラスで`language`を設定する`before_save`を設定する
* Valueオブジェクトで`rating`を扱う

ということを行っています。

以下でそれぞれについて簡単に説明します。

### カスタムValidatorクラス

カスタムValidatorでは`description`の内容が「ひらがなを含んで10文字以上」か「ひらがなを含まずに3単語以上」となっていることを確認します。

{% highlight ruby %}
# app/validators/blog/site_description_significance_validator.rb
class Blog::SiteDescriptionSignificanceValidator < ActiveModel::Validator
  def validate(record)
    description = record.description
    if description
      if /[ぁ-ゔ]/ =~ description
        return if description.length >= 10
      else
        return if description.split(/[\s,\.]+/).size >= 3
      end
    end
    record.errors.add :description, :not_significant
  end
end
{% endhighlight %}

### Callbackクラス

Callbackでは`before_save`で`language`の設定をしています。

今回の例ではひらがなを含んでいれば`language`に`:ja`を設定します。

{% highlight ruby %}
# app/callbacks/blog/site_language_estimator.rb
class Blog::SiteLanguageEstimator
  def initialize(attribute)
    @attribute = attribute
  end

  def before_save(record)
    return if record.send(@attribute)
    language = (/[ぁ-ゔ]/ =~ record.description ? :ja : '')
    record.send("#{@attribute}=", language)
  end
end
{% endhighlight %}

### Valueオブジェクト

Valueオブジェクトでは`rating`の比較を行えるようにしています。

{% highlight ruby %}
# app/values/blog/site_rating.rb
class Blog::SiteRating
  include Comparable

  def self.from_description(description)
    description.length >= 10 ? new('A') : new('B')
  end

  def initialize(letter)
    @letter = letter
  end

  def better_than?(other)
    self > other
  end

  def <=>(other)
    other.to_s <=> to_s
  end

  def hash
    @letter.hash
  end

  def eql?(other)
    to_s == other.to_s
  end

  def to_s
    @letter.to_s
  end
end
{% endhighlight %}

### 参考文献

この記事を書くにあたって、CallbackクラスとValidatorについては

* [てめえらのRailsはオブジェクト指向じゃねえ！まずはCallbackクラス、Validatorクラスを活用しろ！](http://qiita.com/joker1007/items/2a03500017766bdb0234) (2013/12/04)

を、Valueオブジェクトについては

* [肥大化したActiveRecordモデルをリファクタリングする7つの方法](http://techracho.bpsinc.jp/hachi8833/2013_11_19/14738) [[原文](http://blog.codeclimate.com/blog/2012/10/17/7-ways-to-decompose-fat-activerecord-models/) (2012/10/17)]

を参考にしました。

どちらもよくまとまっているのでオススメです。
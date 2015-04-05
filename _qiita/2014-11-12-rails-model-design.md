Rails4.1.7のActiveRecordにCallbackクラス＆Validatorクラス＆Valueオブジェクトを組み込んでみる

※ この記事は[江の島エンジニアBlog](http://blog.enogineer.com/)の「[Rails4.1.7のActiveRecordにCallbackクラス＆Validatorクラス＆Valueオブジェクトを組み込んでみる](http://blog.enogineer.com/2014/11/12/rails-model-design/)」の転載です。

ActiveRecordに楽をさせてくれるCallback・Validator・Valueオブジェクトを、過去文献を参考に組み込んでみました。

ActiveRecordモデルのコードはこんな感じです。

```ruby
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
```

ここでは

* カスタムValidatorで`description`の内容をチェックする
* Callbackクラスで`language`を設定する`before_save`を設定する
* Valueオブジェクトで`rating`を扱う

ということを行っています。

以下でそれぞれについて簡単に説明します。

## カスタムValidatorクラス

カスタムValidatorでは`description`の内容が「ひらがなを含んで10文字以上」か「ひらがなを含まずに3単語以上」となっていることを確認します。

```ruby
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
```

## Callbackクラス

Callbackでは`before_save`で`language`の設定をしています。

今回の例ではひらがなを含んでいれば`language`に`:ja`を設定します。

```ruby
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
```

## Valueオブジェクト

Valueオブジェクトでは`rating`の比較を行えるようにしています。

```ruby
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
```

## 参考文献

この記事を書くにあたって、CallbackクラスとValidatorについては

* [てめえらのRailsはオブジェクト指向じゃねえ！まずはCallbackクラス、Validatorクラスを活用しろ！](http://qiita.com/joker1007/items/2a03500017766bdb0234) (2013/12/04)

を、Valueオブジェクトについては

* [肥大化したActiveRecordモデルをリファクタリングする7つの方法](http://techracho.bpsinc.jp/hachi8833/2013_11_19/14738) [[原文](http://blog.codeclimate.com/blog/2012/10/17/7-ways-to-decompose-fat-activerecord-models/) (2012/10/17)]

を参考にしました。

どちらもよくまとまっているのでオススメです。
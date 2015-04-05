Rails4でFormオブジェクトを作る際に気をつける3つのポイント

※ この記事は[江の島エンジニアBlog](http://blog.enogineer.com/)の「[Rails4でFormオブジェクトを作る際に気をつける3つのポイント](http://blog.enogineer.com/2014/12/02/rails-form-object/)」の転載です。

Railsで実際にFormオブジェクトを作ってみたらいくつか気をつけるポイントがあったので紹介します。

この記事は[Ruby on Rails Advent Calendar 2014](http://qiita.com/advent-calendar/2014/rails)の2日目です。

1日目は[@miyukki](http://qiita.com/miyukki)さんの「[結局Ruby on RailsとPHPってどっちが優れてるの？](http://blog.applest.net/article/20141201-ruby-on-rails-vs-php/)」でした。おつかれさまでした。

## Formオブジェクトとは

Formオブジェクトはその名の通り入力フォーム用のオブジェクトです。

フォームとモデルがうまく対応しているときはActiveRecordをそのまま使えば良いのですが、
複数モデルを作りたかったりモデルとは違うValidationを行いたかったりする場合にはFormオブジェクトを使うと便利です。

Formオブジェクトのサンプルコードはこんな感じになります。

```ruby
class Blog::SiteForm
  include Virtus.model

  extend ActiveModel::Naming
  include ActiveModel::Conversion
  include ActiveModel::Validations

  attribute :title, String
  attribute :description, String

  #追加するvalidationがあればこのあたりに書く

  def site
    @site ||= Blog::Site.new(title: title, description: description)
  end

  def site=(site)
    @site = site
    self.title = site.title
    self.description = site.description
    @site
  end

  def persisted?
    site.persisted?
  end

  def save(user)
    site.user = user
    valid? && site.save
  end

  def url
    if persisted?
      Rails.application.routes.url_helpers.blog_site_path(site.id)
    else
      Rails.application.routes.url_helpers.blog_sites_path
    end
  end

  def valid?
    result = super
    unless site.valid?
      key = :title
      site.errors[key].each do |error|
        errors.add(key, error)
      end
      return false
    end
    return result
  end
end
```

この例では`Blog::Site`がActiveRecordモデルになっています。

では、以下で気をつけるポイントを紹介します。

## form_forにFormオブジェクトを渡してもURLが生成されない

`form_for`にActiveRecordオブジェクトを渡してもちゃんとURLが生成されません。

これは`form_for`が受け取ったオブジェクトのクラス名を元にURLを生成しているからです。

例えば`Blog::Site`オブジェクトを渡せば`blog_sites_path`ヘルパーを実行してくれるのですが、`Blog::SiteForm`オブジェクトを渡すと`blog_site_forms_path`ヘルパーを実行しようとして失敗してしまいます。

なので、次のようにURLを直接指定しましょう。

```slim
- form_for @site_form, url: @site_form.url do
    ...
```

### 追記(2014/12/3)

[@joker1007](http://qiita.com/joker1007)さんから「[FormオブジェクトのURLの渡し方について](http://qiita.com/joker1007/items/ba2812eedb7062dcbf1e)」という記事で突っ込みをいただきました。

今回のような場合は[polymorphic_path](http://apidock.com/rails/ActionController/PolymorphicRoutes/polymorphic_path)を使って

```slim
- form_for @site_form, url: polymorphic_path(@site_form.site) do
```

とした方が良さそうです。こうすれば`url`, `persisted?`メソッドは不要になります。

合わせて

```ruby
extend ActiveModel::Naming
include ActiveModel::Conversion
include ActiveModel::Validations
```

は`include ActiveModel::Model`に置き換えられるという指摘もいただいたのですが、手元のコードだと`create`アクション実行時にエラーが出てしまったので、こちらはひとまずこのままにしておきます。原因特定したら別途追記します。← `Virtus.model`を使う場合は単純には`ActiveModel::Model`はincludeできないようです。

## validate_uniqueness_ofが使えない

一意性制約を検証するにはデータベースのUNIQUE制約を利用する必要があります。

ただ、Formオブジェクトからはデータベース制約を直接扱えません。

なので、`validate_uniqueness_of`はActiveRecordオブジェクト（今回の例だと`Blog::Site`オブジェクト）で実行する必要があります。

具体的にはサンプルコードのようにFormオブジェクトの`valid?`メソッドでActiveRecordオブジェクトの`valid?`を呼び出せば良いかと思います。

## errorsは統合する必要がある

2つ目のポイントで紹介したようにFormオブジェクト以外のモデルでvalidationを行った場合は気をつけることがもう1つあります。

通常validationに失敗するとモデルオブジェクトの`errors`にエラー情報が格納されるのですが、その情報はFormオブジェクトの`errors`には自動的には統合されません。

なので、Formオブジェクトのエラーとして扱うには各オブジェクトの`errors`をFormオブジェクトに統合する必要があります。

サンプルコードでは`valid?`メソッドでその処理をしています。

```ruby
def valid?
  result = super
  unless site.valid?
    key = :title
    site.errors[key].each do |error|
      errors.add(key, error)
    end
    return false
  end
  return result
end
```

## まとめ

Formオブジェクトは単なるクラスなので、自分でいろいろと面倒を見る必要がありますが
うまく使うとコードがすっきりするのでチャンスがあれば是非活用してみてください。

3日目は[@awakia](http://qiita.com/awakia)さんです。よろしくお願いします。

## 参考文献

* [肥大化したActiveRecordモデルをリファクタリングする7つの方法](http://techracho.bpsinc.jp/hachi8833/2013_11_19/14738) ([原文](http://blog.codeclimate.com/blog/2012/10/17/7-ways-to-decompose-fat-activerecord-models/))

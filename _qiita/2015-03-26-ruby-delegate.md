Rubyでのメソッドの委譲方法をまとめてみた

※ この記事は[江の島エンジニアBlog](http://blog.enogineer.com/)の「[Rubyでのメソッドの委譲方法をまとめてみた](http://blog.enogineer.com/2015/03/26/ruby-delegate/)」の転載です。

Rubyでは委譲の方法がいくつかあるのでまとめてみました。インスタンスメソッドの委譲方法とクラスメソッドの委譲方法をまとめています。チームで開発している場合はあらかじめ方法を統一しておくと良いと思います。

## インスタンスメソッドを委譲する

まずはインスタンスメソッドを委譲する方法をいくつか紹介します。

### `delegate`を使う

```ruby
class User
  delegate :name, :age, to: :info
end
```

ここでは`name`と`age`メソッドを`info`に委譲しています。

### `Forwardable.def_delegators`を使う

```ruby
class User
  extend Forwardable
  def_delegators :info, :name, :age
end
```

同じ例を`Forwardable`の`def_delegators`を使って書くとこんな感じになります。

### `Forwardable.def_delegator`を使う

```ruby
class User
  extend Forwardable
  def_delegator :info, :name, :info_name
end
```

`def_delegator`を使うとメソッド名をカスタマイズすることもできます。

この例では`info_name`で`info.name`を参照できるようにしています。

`def_delegators`と引数の扱いが違うので気をつけましょう。

## クラスメソッドを委譲する

クラスメソッドを委譲する方法もいくつかあります。

### `class << self`を使う

```ruby
class User
  class << self
    delegate :log, to: :instance
  end
end
```

`class << self`と`delegate`を使って委譲します。

### `SingleForwardable`を使う

```ruby
class Logger
  extend SingleForwardable
  def_delegators :instance, :log
end
```

`Forwardable`の代わりに`SingleForwardable`を使えばクラスメソッドを委譲出来ます。

もちろん`def_delegators`を使ってもOKです。

### まとめ

ということでRubyで委譲をする方法をいくつかご紹介しました。

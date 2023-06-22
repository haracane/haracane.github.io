---
author: haracane
layout: post
title: RSpecでDatabaseCleanerを使っているのにAUTOCOMMITされたデータが残る場合の対処
date: 2015-12-03 08:05:44J
tags:
- RSpec
- Rails
- Ruby
description: RSpecでテストをする際にDatabaseCleanerを使うとテストケース毎にデータを削除してくれて非常に便利なのですが、transaction
  strategyで実行している場合にAUTOCOMMITされたデータが削除されず、その結果テストが失敗してしまう場合があります。今回はその対処方法をまとめてみました。
image: rails.png
---
<!-- tag_links -->
[RSpec](/tags/rspec/) / [Rails](/tags/rails/) / [Ruby](/tags/ruby/)

<!-- content -->
この記事は[Ruby on Rails Advent Calendar 2015](http://qiita.com/advent-calendar/2015/rails)の3日目です。

## DatabaseCleanerでテスト実行毎にデータを削除する

RSpecでテストをする際に、各テストケースの実行毎にデータベースの状態をクリアしてくれる[database_cleaner](https://github.com/DatabaseCleaner/database_cleaner)というgemがあります。

このgemはとても便利で、`rails_helper.rb`に以下のような感じで設定しておくと他のテストの影響を受けずに各テストケースを実行できます。

{% highlight ruby %}
RSpec.configure do |config|
  ...

  config.use_transactional_fixtures = false

  except_tables = %w(blog_categories)

  config.before(:suite) do
    # db/seeds.rbでblog_categoriesテーブルのデータを設定
    load Rails.root.join('db', 'seeds.rb')
    DatabaseCleaner.clean_with(:truncation, except: except_tables)
  end

  config.before(:example) do
    DatabaseCleaner.strategy = :transaction
  end

  config.before(:example, js: true) do
    DatabaseCleaner.strategy = :truncation, {except: except_tables}
  end

  config.before(:example) do
    DatabaseCleaner.start
  end

  config.after(:example) do
    DatabaseCleaner.clean
  end

  ## スマホ版のfeature specを書く場合などは以下の設定もしておく
  config.before(:example, type: :mobile) do
    Capybara.current_driver = :mobile_client
  end

  config.after(:example, type: :mobile) do
    Capybara.use_default_driver
  end
end
{% endhighlight %}

## DatabaseCleanerのAUTOCOMMIT問題

ただ、transaction strategyで実行している場合は`DatabaseCleaner.clean`実行後も`AUTOCOMMIT`されたデータが削除されません。

そのため「個別にテストを実行すると成功するのに`rake spec`では失敗する」といったことが起きてしまう場合があります。

## AUTOCOMMIT問題の対策

で、そのための対策なのですが、`rails_helper.rb`に

{% highlight ruby %}
config.before(:example, truncation: true) do
  DatabaseCleaner.strategy = :truncation, {except: except_tables}
end
{% endhighlight %}

を追加して、`AUTOCOMMIT`が行われるテストケースに

{% highlight ruby %}
it 'performs AUTOCOMMIT', truncation: true do
  ...
end
{% endhighlight %}

と`truncation: true`を設定します。

こうするとこのテストケースはtruncation strategyで実行するのでAUTOCOMMITされたデータも削除してくれます。

## AUTOCOMMITされるテストケースを見つける

ただ、どのテストケースで`AUTOCOMMIT`が行われているのかをひとつひとつ確認するのは大変です。

なので、各テストケース終了後にデータが残っていないか確認するようにしておくと便利です。

例えば

{% highlight ruby %}
config.after(:example) do
  DatabaseCleaner.clean
  [Blog::User, Blog::Tag].each do |model|
    raise "#{model} exists after example" if model.unscoped.exists?
  end
end
{% endhighlight %}

のようにしておくと、各テストケースの実行後にデータが残っている場合にちゃんとテストを失敗させることができます。

ちなみに`unscoped`は`default_scope`の影響を除外するために追加しています。

問題のあるテストケースが見つかれば、あとは`truncation: true`を設定するだけです。

### チェックするモデルの選び方

全てのモデルのチェックをテスト実行毎に行うとテスト実行時間が長くなってしまうので、必要なモデルだけチェックするようにしましょう。

例えば`Blog::Site`が`Blog::User`に依存している場合は`Blog::Site`のチェックは不要です。

依存先がないモデルは全てチェックした方が良いのですが、全モデルのチェックは問題があった時に行うだけにして、毎回チェックするモデルは絞り込みましょう。

## まとめ

テスト後にデータが残っていると`AUTOCOMMIT`されたテストケースは成功するのに、その後で別のテストが失敗したりするので原因を探すのが結構大変です。

しかもテストの実行順によって時々失敗したり、失敗するテストケースも異なったりします。

この状態で放置しているとCIが機能しなくなってしまうので、`AUTOCOMMIT`したデータはしっかり削除するようにしましょう。

最後に最終的な`rails_helper.rb`の内容も載せておきます。

{% highlight ruby %}
RSpec.configure do |config|
  ...

  config.use_transactional_fixtures = false

  except_tables = %w(blog_categories)

  config.before(:suite) do
    # db/seeds.rbでblog_categoriesテーブルのデータを設定
    load Rails.root.join('db', 'seeds.rb')
    DatabaseCleaner.clean_with(:truncation, except: except_tables)
  end

  config.before(:example) do
    DatabaseCleaner.strategy = :transaction
  end

  config.before(:example, truncation: true) do
    DatabaseCleaner.strategy = :truncation, {except: except_tables}
  end

  config.before(:example, js: true) do
    DatabaseCleaner.strategy = :truncation, {except: except_tables}
  end

  config.before(:example) do
    DatabaseCleaner.start
  end

  config.after(:example) do
    DatabaseCleaner.clean
    [Blog::User, Blog::Tag].each do |model|
      raise "#{model} exists after example" if model.unscoped.exists?
    end
  end

  ## スマホ版のfeature specを書く場合などは以下の設定もしておく
  config.before(:example, type: :mobile) do
    Capybara.current_driver = :mobile_client
  end

  config.after(:example, type: :mobile) do
    Capybara.use_default_driver
  end
end
{% endhighlight %}

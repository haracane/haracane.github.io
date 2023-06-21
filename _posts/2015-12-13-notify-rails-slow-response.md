---
author: haracane
layout: post
title: Railsのレスポンス遅延を通知する
date: 2015-12-13 09:32:21J
tags: Rails
description: Railsを運用しているとレスポンスタイムの監視は欠かせません。New Relicなどを使って監視している方が多いかと思いますが、今回はActive SupportのInstrumentation機能を使って10秒以上のレスポンスを通知するシンプルな方法をご紹介します。
image: rails.png
---
[Rails](/tags/rails/)

この記事は[Ruby on Rails Advent Calendar 2015](http://qiita.com/advent-calendar/2015/rails)の13日目です。

## Active Support Instrumentationとは

ざっくり言うと「Railsアプリケーションやフレームワーク内のアクションを計測するためのAPI」です。

この仕組みを使うと、コントローラのアクション実行やSQL実行などをフックすることができます。

今回はこのInstrumentationの仕組みを使ってレスポンス遅延の監視を行います。

## アクションを監視する

アクションを監視するには提供されているフックを`subscribe`します。

アクションのフックは`process_action.action_controller`という名前なので

{% highlight ruby %}
# config/initializers/subscribe_process_action_action_controller.rb
ActiveSupport::Notifications.subscribe "process_action.action_controller" do |*args|
end
{% endhighlight %}

という感じのファイルを用意するとアクションを監視できます。

## レスポンス遅延の場合に通知する

subscribeした時のブロック引数にレスポンス情報が入っているので、レスポンス時間が長過ぎる場合に通知をしてみます。

ブロック引数はそのまま`ActiveSupport::Notifications::Event.new`の引数になるので、まずは`ActiveSupport::Notifications::Event`オブジェクトを作成します。

{% highlight ruby %}
ActiveSupport::Notifications.subscribe "process_action.action_controller" do |*args|
  event = ActiveSupport::Notifications::Event.new(*args)
end
{% endhighlight %}

`event`オブジェクトを取得したら、`event.duration`で取得できるレスポンス時間(単位はミリ秒)が10秒以上かかっているか判定します。

{% highlight ruby %}
ActiveSupport::Notifications.subscribe "process_action.action_controller" do |*args|
  event = ActiveSupport::Notifications::Event.new(*args)
  if event.duration > 10_000
    ## ここで通知処理
  end
end
{% endhighlight %}

## メール/チャットで通知

あとは通知処理をすればOKです。

ただし、フック処理が終わるまでアクションが終了しないので、通知処理で邪魔しないように非同期で通知するようにしましょう。

例えば`Resque`を使っている場合は

{% highlight ruby %}
ActiveSupport::Notifications.subscribe "process_action.action_controller" do |*args|
  event = ActiveSupport::Notifications::Event.new(*args)
  if event.duration > 10_000
    Resque.enqueue(
      SlowResponseNotifyJob,
      time: event.time,
      duration: "#{(event.duration / 1000).round(3)}sec"}.merge(event.payload)
    )
  end
end
{% endhighlight %}

という感じにすると良いかと思います。

あとは`SlowResponseNotifyJob`クラスを実装してメールなりSlackなりHipchatなりに通知するようにしましょう。

## おまけ：スロークエリの通知

Instrumentation機能を使うとSQL実行遅延の通知もできます。

SQL実行のhook名は`sql.active_record`なので

{% highlight ruby %}
# config/initializer/subscribe_sql_active_record.rb
ActiveSupport::Notifications.subscribe "sql.active_record" do |*args|
  event = ActiveSupport::Notifications::Event.new(*args)
  if event.duration > 10_000
    Resque.enqueue(
      SlowQueryNotifyJob,
      time: event.time,
      duration: "#{(event.duration / 1000).round(3)}sec"}.merge(event.payload)
    )
  end
end
{% endhighlight %}

という感じにすればOKです。

他にも色々なフックがあるので[Active Support Intrumentationのドキュメント](http://edgeguides.rubyonrails.org/active_support_instrumentation.html)を参考に、必要な監視を設定してみてください。

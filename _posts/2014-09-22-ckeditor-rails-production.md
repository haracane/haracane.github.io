---
layout: post
title:  RailsのProduction環境でCKEditorを動かす
date: 2014-09-22 10:08:34J
tags: Ruby Rails
keywords: Ruby,Rails
description: RailsのProduction環境でCKEditorを動かす
image: rails.png
---
[Ruby](/tags/ruby/) / [Rails](/tags/rails/)

Production環境でCKEditorを動かしたら編集画面が表示されず。。

JavaScript Consoleを確認したら http://localhost/assets/ckeditor/lang/ja.js の取得に失敗していたので言語設定を追加。

*config/initializers/ckeditor.rb*
{% highlight ruby %}
Ckeditor.setup do |config|
  config.assets_languages = ['ja']
end
{% endhighlight %}

    $ rake assets:precompile RAILS_ENV=production
    $ rails s -e production

で無事表示できました。

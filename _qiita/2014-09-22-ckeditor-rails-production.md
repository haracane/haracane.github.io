RailsのProduction環境でCKEditorを動かす

※ この記事は[江の島エンジニアBlog](http://blog.enogineer.com/)の「[RailsのProduction環境でCKEditorを動かす](http://blog.enogineer.com/2014/09/22/ckeditor-rails-production/)」の転載です。

RailsのProduction環境でCKEditorを動かす

Production環境でCKEditorを動かしたら編集画面が表示されず。。

JavaScript Consoleを確認したら http://localhost/assets/ckeditor/lang/ja.js の取得に失敗していたので言語設定を追加。

*config/initializers/ckeditor.rb*
```ruby
Ckeditor.setup do |config|
  config.assets_languages = ['ja']
end
```

    $ rake assets:precompile RAILS_ENV=production
    $ rails s -e production

で無事表示できました。

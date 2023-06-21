---
author: haracane
layout: post
title: Doorkeeper2.1.4でコンソールからOAuth2.0認証API用のアクセストークンを発行してみた
date: 2015-04-25 11:28:33J
tags:
- Rails
- Ruby
- OAuth2.0
description: OAuth2認証の定番Doorkeeper gemを使ってコンソールからアクセストークンを発行してみました。自前で認証画面を作る場合など参考になるかと思います。
image: rails.png
---
[Rails](/tags/rails/) / [Ruby](/tags/ruby/) / [OAuth2.0](/tags/oauth2/)

Doorkeeperを使うとデフォルトの認証画面を使うのが定番のようですが、自前で認証画面を用意したりRakeタスクでアクセストークンを発行したいことがあったりします。

ということで、Railsコンソールからアクセストークンの発行までやってみました。

## Doorkeeper インストール

まずはRailsプロジェクトのGemfileにDoorkeeper gemを追加して`bundle install`します。

{% highlight ruby %}
# Gemfile
gem 'doorkeeper'
{% endhighlight %}

今回はdoorkeeper-2.1.4が入りました。

続いてActiveRecord用の設定＆テーブルを作成します。

{% highlight text %}
$ rails generate doorkeeper:install
$ rails generate doorkeeper:migration
$ rails db:migrate
{% endhighlight %}

こうするとデータベースに

* oauth_applications
* oauth_access_grants
* oauth_access_tokens

というテーブルが作られます。

### Doorkeeperを設定

Doorkeeperをインストールすると`config/initializers/doorkeeper.rb`に設定ファイルも作られます。

Deviseユーザーを認証する場合は

{% highlight ruby %}
# config/initializers/doorkeeper.rb
resource_owner_authenticator do
  current_user || warden.authenticate!(:scope => :user)
end
{% endhighlight %}

という感じで`resource_owner_authenticator`を設定します。

また、インストール時に`config/routes.rb`も更新されますが、今回はDoorkeeperのアプリケーションは使わないので元に戻しておきます。

### OAuth2アプリケーションの作成

続いてRails ConsoleからOAuth2アプリケーションを作成します。

ActiveRecordの場合は`Doorkeeper::Application`オブジェクトを作ればOKです。

{% highlight ruby %}
> client = Doorkeeper::Application.create(name: 'アプリケーション名', redirect_uri: '認証後のリダイレクトURL')
{% endhighlight %}

作成したアプリケーションのID（Client ID）とClient Secretを確認します。

{% highlight ruby %}
> client.uid
=> "094ce26134c0cbee97c91511b7f91137cb1963d7186066948b3126bb8e0f3ad76fce522e01634ee51e20954977c5b77f45b682c1ff4570a66598fcf19699d23b"
> client.secret
=> "49f947fceebbfd3c5e8100cbde8e410530e6a7a0d1c5a9af90705760968af4e6e719ec1776e49bf2f21673868f0ce2aa5d24fe697229e6fc6d3661614fded3cd"
{% endhighlight %}

ということで無事OAuth2認証用アプリケーションが作成できました。

### 認証コードの生成

続いて認証コードの生成です。

認証コードの生成には`Doorkeeper::OAuth::CodeRequest`クラスを使います。

{% highlight ruby %}
params =
  ActionController::Parameters.new(
    client_id: client.uid,
    redirect_uri: client.redirect_uri,
    response_type: 'code'
  )

pre_auth = Doorkeeper::OAuth::PreAuthorization.new(Doorkeeper.configuration, client, params)

request = Doorkeeper::OAuth::CodeRequest.new(pre_auth, user)

response = request.authorize # Doorkeeper::OAuth::CodeResponseオブジェクト

code = response.auth # Doorkeeper::OAuth::Authorization::Codeオブジェクト

grant = code.token # Doorkeeper::AccessGrantオブジェクト
{% endhighlight %}

こんな感じで`Doorkeeper::AccessGrant`モデルのオブジェクトを取得します。

取得した認証コードを確認してみます。

{% highlight ruby %}
> grant.token
=> "f001b3327b4f13f6aea35ffea3601f5d2eea0e18fa5393f928e25b52a314df36"
{% endhighlight %}

## アクセストークンの生成

認証コードを取得したので、続いてアクセストークンを生成します。

{% highlight ruby %}
params =
  ActionController::Parameters.new(
    client_id: client.uid,
    client_secret: client.secret,
    code: grant.token,
    grant_type: 'authorization_code',
    redirect_uri: client.redirect_uri
  )

request =
  Doorkeeper::OAuth::AuthorizationCodeRequest.new(
    Doorkeeper.configuration,
    grant,
    client,
    params
  )

response = request.authorize # Doorkeeper::OAuth::TokenResponseオブジェクト
access_token = response.token # Doorkeeper::AccessTokenオブジェクト
{% endhighlight %}

取得したアクセストークンを確認してみます。

{% highlight ruby %}
> access_token.token
=> "c8f32d02ea56979882ca8ee659a64b4088774a973655ba6cbf91ef1fcb0f739f"
{% endhighlight %}

これでOAuth2認証に必要なアクセストークンが手に入りました。

## OAuth2.0認証対応のAPIを作る

アクセストークンは作りましたが、APIがないと試せないのでGrapeを使って簡単なAPIを作ります

### Grape gemをインストール

Gemfileにgrapeとgrape-active_model_serializersを追加して`bundle install`します。

{% highlight ruby %}
# Gemfile
gem 'grape'
gem 'grape-active_model_serializers'
{% endhighlight %}

バージョンはgrape-0.11.0, grape-active_model_serializers-1.3.2が入りました。

### API用のディレクトリを設定

`app/api`を読み込むようにします。

{% highlight ruby %}
# config/application.rb
...
config.paths.add 'app/api', glob: '**/*.rb'
...
{% endhighlight %}

### サンプルAPIを作成

とりあえず簡単なAPIを作ります。

{% highlight ruby %}
# app/api/api.rb
class API < Grape::API
  prefix 'api'

  format :json
  formatter :json, Grape::Formatter::ActiveModelSerializers
  content_type :json, 'application/json; charset=UTF-8'

  mount V1::SampleAPI
end
{% endhighlight %}

{% highlight ruby %}
# app/api/v1/sample_api.rb
require 'doorkeeper/grape/helpers'

module V1
  class SampleAPI < Grape::API
    ## OAuth2認証用の設定を追加
    helpers Doorkeeper::Grape::Helpers
    before { doorkeeper_authorize! }

    version 'v1', using: :path

    resource :samples do
      get '/' do
        {foo: :bar}
      end
    end
  end
end
{% endhighlight %}

### サンプルAPIにアクセスしてみる

APIにアクセスしてみると`401 Unauthorized`になっています。

{% highlight text %}
$ curl -I http://localhost:3000/api/v1/samples/
HTTP/1.1 401 Unauthorized
...
{% endhighlight %}

## アクセストークンを使ってAPIにアクセスしてみる

アクセストークンの発行もAPIの用意もできたので、OAuth2 gemを使ってAPIを呼び出してみます。

{% highlight ruby %}
require 'oauth2'

client_id     = 'CLIENT_ID'
client_secret = 'CLIENT_SECRET'
site          = 'http://localhost:3000'

client = OAuth2::Client.new(client_id, client_secret, :site => site)

access_token = 'ACCESS_TOKEN'

token = OAuth2::AccessToken.new(client, access_token)
response = token.get('/api/v1/samples')
{% endhighlight %}

レスポンスの内容を確認してみます。

{% highlight ruby %}
> JSON.parse(response.body)
=> {"foo"=>"bar"}
{% endhighlight %}

ちゃんとOAuth2認証APIを呼び出すことができました。

### まとめ

今回はDoorkeeper + GrapeでOAuth2認証APIを作ってみました。

認証機能付きAPIだと定番かと思いますのでよろしければご参考にどうぞ。

### おまけ

今回GrapeでAPIを作りましたが、最初に試した時はGrapeのバージョンが古くて

{% highlight text %}
undefined local variable or method `settings' for #<Grape::Endpoint:0x007fb15f9fa7c8>
{% endhighlight %}

とか

{% highlight text %}
undefined method `head' for #<Grape::Endpoint:0x007f9f172bd280>
{% endhighlight %}

というエラーが出たりしました。

こういう時は`bundle update grape grape-active_model_serializers`でバージョンを上げればOKです。

また、`grape-active_model_serializers`のバージョンを上げると`active_model_serializers`のバージョンも上がります。

このとき古いDraperを使っている場合は

{% highlight text %}
uninitialized constant ActiveModel::ArraySerializerSupport
{% endhighlight %}

というエラーが出たりします。

そういう場合は`bundle update draper`でDraperのバージョンも上げましょう。

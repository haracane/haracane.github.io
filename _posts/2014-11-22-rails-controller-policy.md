---
author: haracane
layout: post
title: Rails4.1.8でアクション毎の実行権限を設定してみる
date: 2014-11-22 08:56:33J
tags:
- Rails
- Ruby
keywords: Pundit Policy Rails Ruby
description: Railsのアクションでユーザ毎の権限に応じて実行結果を変えたかったので、Pundit gemを使って設定してみました。
image: "/assets/images/posts/rails.png"
---
<!-- tag_links -->
[Rails](/tags/rails/) / [Ruby](/tags/ruby/)

<!-- content -->
サンプルコードでは

* `update`できれば`edit`を、`create`できれば`new`を実行できる
* ログインユーザ自身のレコードだけ`show`, `update`, `destroy`できる
* ログインしていれば`create`できる
* ログインユーザのレコードだけ`index`で一覧できる

という権限設定をしています。

{% highlight ruby %}
# app/controllers/application_controller.rb
class ApplicationController < ActionController::Base
  include Pundit
  protect_from_forgery with: :exception

  private

  def pundit_auth
    authorize(pundit_record)
  rescue Pundit::NotDefinedError
    authorize(:application)
  end

  def pundit_record
    controller_path.to_sym
  end
end
{% endhighlight %}

{% highlight ruby %}
class Blog::SitesController < ApplicationController
  before_action :set_site, only: [:show, :edit, :update, :destroy]
  before_action :pundit_auth
  # verify_authorizedではauthorizeをしていない場合に
  # Pundit::AuthorizationNotPerformedError例外を投げます
  before_action :verify_authorized

  respond_to :html, :xml, :json

  def index
    @sites = policy_scope(Blog::Site)
  end

  ...

  private

  def set_site
    @site = Blog::Site.find(params[:id])
  end

  def pundit_record
    # Blog::Siteオブジェクトまたは:'blog/site'を渡すことで
    # Blog::SitePolicyが適用されます
    @site || controller_path.to_sym
  end
end
{% endhighlight %}

ポリシーはこんな感じです

{% highlight ruby %}
# app/policies/application_policy.rb
# 自動生成コードそのままです
class ApplicationPolicy
  attr_reader :user, :record

  def initialize(user, record)
    # userにはコントローラのpundit_userメソッドの結果が入ります。
    # デフォルトはcurrent_user
    @user = user

    # recordにはコントローラのauthorizeメソッドの引数が入ります。
    @record = record
  end

  def index?
    true
  end

  def show?
    scope.where(id: record.id).exists?
  end

  def create?
    false
  end

  def new?
    create?
  end

  def update?
    false
  end

  def edit?
    update?
  end

  def destroy?
    false
  end

  def scope
    Pundit.policy_scope!(user, record.class)
  end

  class Scope
    attr_reader :user, :scope

    def initialize(user, scope)
      @user = user
      @scope = scope
    end

    def resolve
      scope
    end
  end
end
{% endhighlight %}

{% highlight ruby %}
# app/policies/blog/site_policy.rb
class Blog::SitePolicy < ApplicationPolicy
  def index?
    !!user
  end

  def show?
    record.user == user
  end

  def create?
    !!user
  end

  def new?
    create?
  end

  def update?
    record.user == user
  end

  def edit?
    update?
  end

  def destroy?
    record.user == user
  end

  class Scope < Scope
    def resolve
      scope.where(user_id: user.id)
    end
  end
end
{% endhighlight %}

以上、ポリシー設定のサンプルコード紹介でした。

詳しくは[Punditのドキュメント](https://github.com/elabs/pundit)や[るびまのPundit解説記事](http://magazine.rubyist.net/?0047-IntroductionToPundit)を読むと参考になると思います。

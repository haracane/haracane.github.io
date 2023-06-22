---
author: haracane
layout: post
title: Rails4でhas-one関連先のレコードをCoffeeScriptから作成＆更新する
date: 2014-12-11 07:07:43J
tags:
- CoffeeScript
- JavaScript
- Rails
- Ruby
keywords: CoffeeScript JavaScript Rails Ruby
description: Railsで画面遷移なしでレコードを作成＆更新したいことがよくあるので、CoffeeScriptを使った実装パターンをまとめてみました。
image: coffee.png
---
[CoffeeScript](/tags/coffeescript/) / [JavaScript](/tags/javascript/) / [Rails](/tags/rails/) / [Ruby](/tags/ruby/)

サンプルコードでは`Blog::Site`オブジェクトが持つ`Blog::SiteConfig`オブジェクトを作成・更新しています。

コントローラ側ではJSON APIとして`create`アクションと`update`アクションを実装します。

{% highlight ruby %}
# app/controllers/blog/site_configs_controller.rb
class Blog::SiteConfigsController < ApplicationController
  before_action :set_site_config, only: [:update]

  def create
    @site_config =
      Blog::SiteConfig.new(site_config_params)
    if @site_config.save
      render json: @site_config
    else
      render json: {message: 'Save Failure'}, status: 400
    end
  end

  def update
    if @site_config.update(site_config_params)
      render json: @site_config
    else
      render json: {message: 'Update Failure'}, status: 400
    end
  end

  private

  def set_site_config
    @site_config = Blog::SiteConfig.find(params[:id])
  end

  def site_config_params
    params.require(:site_config).permit(:site_id, :redirect_to)
  end
end
{% endhighlight %}

CoffeeScriptでは

* 「編集」ボタンを押したら入力フォームを表示する
* 「保存」ボタンを押したら`create`アクションか`update`アクションをリクエストする
* 保存できたら入力フォームを非表示にする

という動作を記述します。

{% highlight coffee %}
# app/assets/javascripts/blog/sites/index.coffee
$ ->
  $('body#blog-sites-index-page').each ->
    $('button.redirect-to-edit').click ->
      showBlogSiteConfigForm($(@).data('blog-site-id'))

    showBlogSiteConfigForm = (blogSiteId) ->
      $("tr#blog-site-#{blogSiteId} span.blog-site-config-edit").slideDown()
      $("tr#blog-site-#{blogSiteId} span.blog-site-config-show").slideUp()

    hideBlogSiteConfigForm = (blogSiteId) ->
      $("tr#blog-site-#{blogSiteId} span.blog-site-config-edit").slideUp()
      $("tr#blog-site-#{blogSiteId} span.blog-site-config-show").slideDown()

    $('button.redirect-to-save').click ->
      createOrUpdateBlogSiteConfig($(@).data('blog-site-id'))

    createOrUpdateBlogSiteConfig = (blogSiteId) ->
      id = blogSiteConfigIdOf(blogSiteId)

      if id
        url = "/blog/site_configs/#{id}/"
        method = 'PUT'
      else
        url = '/blog/site_configs/'
        method = 'POST'

      $.ajax url,
        type: method,
        data:
          site_config: blogSiteConfigParams(blogSiteId)
        dataType: 'json'
        success: (data) ->
          receiveBlogSiteConfig(blogSiteId, data)
          hideBlogSiteConfigForm(blogSiteId)

    blogSiteConfigIdOf = (blogSiteId) ->
      $("tr#blog-site-#{blogSiteId} td.blog-site-config").data('id')

    blogSiteConfigParams = (blogSiteId) ->
      site_id: blogSiteId,
      redirect_to: $("tr#blog-site-#{blogSiteId} input.redirect-to-input").val()

    receiveBlogSiteConfig = (blogSiteId, data) ->
      $("tr#blog-site-#{blogSiteId} td.blog-site-config").data('id', data['id'])
      $("tr#blog-site-#{blogSiteId} p.redirect-to-show").text(data['redirect_to'])
      $("tr#blog-site-#{blogSiteId} input.redirect-to-input").val(data['redirect_to'])
{% endhighlight %}

HTMLはこんな感じです

{% highlight slim %}
# app/views/blog/sites/index.html.slim
- @body_id = 'blog-sites-index-page'

table
  tbody
    - @sites.each do |blog_site|
      tr.blog-site id="blog-site-#{blog_site.id}" data-id=blog_site.id
        ...
        td.blog-site-config data-id=(blog_site.config.id if blog_site.config)
          - show_visible = !!blog_site.config
          span.blog-site-config-show style=('display: none;' unless show_visible)
            p.redirect-to-show data-blog-site-id=blog_site.id #{blog_site.config.try(:redirect_to)}
            button.redirect-to-edit data-blog-site-id=blog_site.id 編集
          - edit_visible = !blog_site.config
          span.blog-site-config-edit style=('display: none;' unless edit_visible)
            input.redirect-to-input value=blog_site.config.try(:redirect_to)
            button.redirect-to-save data-blog-site-id=blog_site.id 保存
{% endhighlight %}

以上、has-one関連先のレコードをCoffeeScriptから`create`&`update`するサンプルコードのご紹介でした。

---
layout: post
title:  rails-form
date: 2014-09-19 15:54:18J
tags: 
keywords: 
description: 
---

{{ page.description }}

{% highlight slim %}
= form_for @user, url: users_path do |f|
  = f.hidden_field :only_validation, value: true
  = f.text_field :name, class: "input-name", placeholder: "名前"
{% endhighlight %}

### ドキュメント
* <http://railsdoc.com/form>

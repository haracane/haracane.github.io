---
layout: post
title: rails-form
date: 2014-10-28 16:43:07J
tags: 
keywords: 
description: 
---

= form_for @post do |f|
  = f.label :title
  = f.text_field :title

  = f.label :category
  = f.select :category, [['選択してください'], ['Rails', 'rails']]

  - f.object.appendix || f.object.build_appendix
  = f.fields_for :appendix do |b|
    = f.label :content
    = f.text_area :content


validates :question_id, presence: true
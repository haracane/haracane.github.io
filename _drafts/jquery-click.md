---
layout: post
title: jquery-click
date: 2014-10-28 18:55:56J
tags: 
keywords: 
description: 
---

    $('.btn.delete-question').click (event) ->
      question_id = $(event.target).data('id')
      content = $("#question_content_#{question_id}").text()
      window.confirm("「#{content.text()}」を削除してよろしいですか？")

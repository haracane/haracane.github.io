---
layout: post
title: active-record-locale
date: 2014-10-29 09:33:40J
tags: 
keywords: 
description: 
---

{% highlight ruby %}
validates :category_id, presence: {message: :not_selected_message}
{% endhighlight %}

ja:
  activerecord:
    errors:
      models:
        research/report:
          attributes:
            research_tags:
              not_selected_message: "を選択してください"
    models:
      research/report: アンケート記事
    attributes:
      research/report:
        id: 管理ID
        title: タイトル
        content: 本文
        started_on: 調査開始日
        ended_on: 調査終了日
        subjects: 調査対象
        subjects_count: 有効回答数
        submitted_at: 投稿日時
        published_at: 公開日時
        research_category_id: カテゴリ
        secreted_at: 非公開日時
        research_report_pictures: アンケート記事画像

        created_at: 作成日時
        updated_at: 更新日時

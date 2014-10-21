---
layout: post
title:  git commitをフックしてコミットメッセージに自動的にチケット番号を追加する
date: 2014-09-06 17:39:08J
tags: Git
keywords: Git
description: いちいちコミットメッセージにチケット番号を追加するのは面倒なので、自動的にチケット番号を追加してくれるgit commitのhookを作りました。
---



こんな感じでブランチ名末尾の数字をチケット番号として付与します。

    (function-123)$ git add sample.txt
    (function-123)$ git commit -m "Add sample.txt"
    (function-123)$ git log --oneline -n 1
    3764bef #123 Add sample.txt

hookスクリプトはこんな感じ。

**.git/hooks/prepare-commit-msg**
{% highlight sh %}
#!/bin/bash

TICKET_PREFIX=${TICKET_PREFIX:-#}

message_file=$1
mode=$2

if [ "$mode" = "" ] || [ "$mode" = "message" ] ; then
  ticket_number=`git branch | grep "*" | awk '{print $2}' | perl -nE 'say $& if /[0-9]+$/'`

  if [ "$ticket_number" != "" ]; then
    mv $message_file $message_file.tmp
    echo -n "$TICKET_PREFIX$ticket_number " > $message_file
    cat $message_file.tmp >> $message_file
  fi
fi
{% endhighlight %}

ローカルリポジトリの.git/hooks/prepare-commit-msgにこのファイルを置けば使えます。

チケットのプレフィックスを変える場合は

{% highlight sh %}
export TICKET_PREFIX="TICKET-"
{% endhighlight %}

のように環境変数でTICKET_PREFIXを設定してください。

上記の例のようにTICKET_PREFIXを設定すると

    TICKET-123 Add sample.txt

という形式でチケット番号が付与されます。

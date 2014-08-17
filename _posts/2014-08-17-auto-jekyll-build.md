---
layout: post
title:  "Jekyllでブログが更新されたら自動ビルドしてもらう"
description: "masterが更新されたときに自動的にgit pull & jekyll buildをする設定です."
date:   2014-08-17 14:55:06J
tags: Jekyll Git
---

{{ page.description }}

Git hookは使わずにシンプルにシェルスクリプトで行っています.

**auto-jekyll-build.sh**
{% highlight bash %}
cwd=$(pwd)

for dir in $*; do
  echo "check $dir" >&2
  cd $cwd
  cd $dir
  git fetch
  diff_count=$(git diff origin/master | wc -l)

  if [ "$diff_count" = 0 ]; then
    echo "it's up-to-date" >&2
    continue;
  fi

  git branch -D tmp
  git checkout -b tmp
  if [ $? != 0 ]; then continue; fi
  git branch -D master
  git fetch
  if [ $? != 0 ]; then continue; fi
  git checkout master
  if [ $? != 0 ]; then continue; fi
  bundle exec jekyll build
done
{% endhighlight %}

というようにビルドスクリプトを作成して

{% highlight bash %}
* * * * * sh /path/to/auto-jekyll-build.sh /path/to/sample-blog.enogineer.com 2> /path/to/auto-jekyll-build.log
{% endhighlight %}

というようにcrontabを設定してあげればOKです.

これで1分毎に更新をチェックして更新があれば自動的に```jekyll build```を実行してくれます.

※ ただし, ファイル削除のみの更新の場合は自動更新されません.


---
author: haracane
layout: post
title: 息をするようにプルリクするための6つのGitの使い方
date: 2015-02-05 07:16:51J
tags: Git
keywords: プルリクエスト Git
description: プルリクエストを基本とした開発スタイルの場合、Gitコマンドの使い方が開発効率にかなり影響します。今回はプルリクエストをうまく使うためのGitの使い方を6個紹介します。
image: git.png
---
[Git](/tags/git/)

## 1. 最初は空コミット

`git commit --allow-empty`を実行すると空のコミットを作ることができます。

作業を始める時はまず空コミットでプルリクを作って、実装中のメモ書きをしたりしています。

なお、このプルリクにはWIP(Work in progress)ラベルをつけて作業中ということがわかるようにしています。

## 2. コミットメッセージにチケット番号を含める

`git commit -m 'TICKET-123 コミットメッセージ'`のようにコミットの先頭にチケット番号を追加するようにしています。

これでチケット番号でプルリクを検索しやすくなりますし、次のプルリクエストメッセージ作成の自動化にも役に立ちます。

なお、チケット番号の入力は[チケット番号を自動的に追加するgit hook]({% post_url 2014-09-06-git-hook-commit-ticket %})を使って自動化しています。

## 3. プルリクエストのテンプレートを使う

プルリクエストのタイトルや内容を毎回入力するのは面倒なので、テンプレートを自動作成するシェル関数を作っています。

例えば

    $ pr-url
    https://github.com/haracane/sample/compare/master...develop?title=TICKET-123&body=...

という感じにURLを出力するようにしていています。

スクリプトはざっくりこんな感じです。

{% highlight sh %}
export TICKET_PREFIX=TICKET-
export TICKET_DIR_URL=https://example.com/tickets
export REPOSITORY_URL=https://github.com/haracane/sample

alias url-encode="ruby -rcgi -e 'puts CGI.escape(STDIN.read)'"

function pr-url() {
  parent_branch=${1:-master}
  current_branch=$(git rev-parse --abbrev-ref HEAD)

  ticket_id=$(git log --oneline | cut -f2 -d' ' | grep ^$TICKET_PREFIX | head -n 1)
  title=$ticket_id
  body="# 関連チケット
* [$ticket_id]($TICKET_DIR_URL/$ticket_id)
...
"
  query_string="title=$(echo "$title" | url-encode)&body=$(echo "$body" | url-encode)"

  echo "$REPOSITORY_URL/compare/$parent_branch...$current_branch?$query_string"
}
{% endhighlight %}

## 4. レビューを受けたら`git rebase -i`で空edit

プルリクを出したら次の機能をどんどん作っていきます。

そうするとだいたいプルリク後にコミット追加した後でレビューが返ってくることになります。

レビュー内容を反映するには過去コミットを追加します。

具体的には`git rebase -i`で空editしています。

例えば`pr-branch`というブランチをプルリク中で

    $ git log --oneline
    1111111 TICKET-123 プルリク後の変更
    0000000 TICKET-123 レビュー済みの変更  ← pr-branch

というようにコミットしていた場合は

    $ git rebase -i pr-branch
    e ← 空editを追加
    pick 1111111 TICKET-123 プルリク後の変更

とします。

こうするとプルリクした後の空コミットを編集できるので、レビュー内容を反映してコミットします。

    (rebase-i) $ git commit -m 'TICKET-123 レビュー内容を反映'

コミットしたらrebaseを終了します。

    (rebase-i) $ git rebase --continue

rebaseが終わった後のコミットログは

    $ git log --oneline
    1111111 TICKET-123 プルリク後の変更
    xxxxxxx TICKET-123 レビュー内容を反映
    0000000 TICKET-123 レビュー済みの変更  ← pr-branch

のようになります。

## 5. 過去コミットをpushする

レビュー内容を反映したらプルリク中のブランチが新しいコミットを指すように変更します。

今回の例だと

    $ git log --oneline
    1111111 TICKET-123 プルリク後の変更
    xxxxxxx TICKET-123 レビュー内容を反映
    0000000 TICKET-123 レビュー済みの変更  ← pr-branch

となっていたところを

    $ git log --oneline
    1111111 TICKET-123 プルリク後の変更
    xxxxxxx TICKET-123 レビュー内容を反映  ← pr-branch
    0000000 TICKET-123 レビュー済みの変更

となるようにします。

これはブランチを削除してから再作成すればOKです。

    $ git branch -D pr-branch
    $ git checkout xxxxxxx
    $ git branch pr-branch
    $ git checkout <元のブランチ>


ブランチを変更したらpushします。

    $ git push origin pr-branch

これで新しいコミットがプルリクに反映されました。

## 6. masterと乖離して来たら遡って`git merge master`

チームで開発していると自分が変更中の箇所がmasterで変更されたりします。

そのままだとコンフリクトしてマージできなくなったりするので、`master`と乖離して来たら適宜解消します。

こういう時は遡って`git merge master`をしています。

例えば

    $ git log --oneline
    1111111 TICKET-123 プルリク後の変更
    0000000 TICKET-123 ここでプルリク

というようにコミットしていた場合は

    $ git rebase -i 000000
    x git merge master ← 遡ってmasterをマージ
    pick 1111111 TICKET-123 プルリク後の変更

とします。

こうすると

    $ git log --oneline
    1111111 TICKET-123 プルリク後の変更
    xxxxxxx Merge branch 'master' into feature/new-function
    0000000 TICKET-123 ここでプルリク

のようにmasterがマージされて、プルリク後のコミットは自由にrebaseできます。

## おまけ／よく使うコマンドをエイリアス・シェル関数化する

今回紹介したコマンドを簡単に入力できるように、なるべくエイリアスやシェル関数にしておきます。

例えば

* ブランチをpushしてプルリク用URLを表示する
* リビジョンとブランチ名を指定して過去コミットをpushする

というようなコマンドを作っておくと便利です。

## まとめ

今回はプルリク開発をスムーズに行うための工夫を紹介しました。

gitコマンドを上手に使って素早くプルリク開発を回しましょう！

---
layout: post
title: Mac OS Mavericks 10.9.5のMAMP3.0.7.2環境でWordpress4.0を動かす
date: 2014-10-29 14:03:34J
tags: MAMP Wordpress
keywords: MAMP Wordpress
description: 
---

[MAMPのダウンロードページ](http://www.mamp.info/en/downloads/)からMAMP_MAMP_PRO_3.0.7.2.pkgをダウンロードします。

pkgファイルを実行してインストールします。なお、「MAMP PRO」は不要なので途中でチェックを外します。

インストールしたMAMPを起動します。Webサーバのポート番号は80番にします。

[Wordpressのサイト](https://ja.wordpress.org/)からwordpress-4.0.zipをダウンロードします。

wordpress-4.0.zipを展開してwordpressディレクトリを作成します。

wordpressディレクトリを適当な場所に置いて適当な名前(例えば~/local-wordpress)に変更します。

[設定]->[Webサーバ]->[ドキュメントのルート]でドキュメントルートにリポジトリのルートパスを設定します。

http://localhost/phpMyAdmin/にアクセスして"wp"データベースを作成します。

http://localhostからWordpressにアクセスします。

画面に表示される通りに言語設定を日本語にしてから設定ファイルを作成します。

設定ファイルの作成ではデータベースに"wp"を設定して、root:rootで設定ファイルを作成します。


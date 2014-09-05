---
layout: post
title:  "NTTコミュニケーションズの内製エンジニアは実はわりとアジャイラー"
description: "@hamaknがDevSumiで『OSSで作る！クラウドサービス開発戦記』というNTTコミュニケーションズのアジャイル開発事例をしてくれたので、私も同僚としてアジャイル開発現場の紹介をしてみたくなりました。"
tags: Redmine Scrum アジャイル Jenkins YARD Sphinx Chef Git Subversion
keywords: Redmine,Scrum,アジャイル,Jenkins
date:   2013-02-16 21:00:00J
---

[https://twitter.com/hamakn:title=@hamakn]がDevSumiで『[https://speakerdeck.com/hamakn/ossdezuo-ru-kuraudosabisukai-fa-zhan-ji:title=OSSで作る！クラウドサービス開発戦記]』というNTTコミュニケーションズのアジャイル開発事例をしてくれたので、私も同僚としてアジャイル開発現場の紹介をしてみたくなりました。

同じ会社の中でもチームが違うと全然何やってるかわからなかったりするので。

ちなみに今回の記事は
-「DevSumiでも発表してたし、NTTコミュニケーションズのエンジニアって結構アジャイラーなんだ」と思ってもらうこと
- 社内、NTTグループ内のアジャイラーにBuzzFinderでのアジャイル開発の様子を知ってもらうこと
を目標にしています^^

* BuzzFinderインキュ開発チームと準スクラム開発

まずはチーム紹介から。

うちのチームでは[http://www.nttcoms.com/service/buzzfinder.html/:title=BuzzFinder]というTwitter全量リアルタイム分析サービスのための機能追加などをメインにやってます。

チームの人数は割と変動的でフェーズによって3人～6人くらいの範囲で増減します。
というのもNTTコミュニケーションズ先端IPアーキテクチャセンタ(R&D部門です)では掛け持ちでプロジェクトを持っている人が多いので、そちらのプロジェクトの状況によっては一時的にオブサーバーになったりチームを抜けたりしてしまうのです。

そのような状況だと完全にスクラム開発体制を作るのは難しいので、コアメンバーのスクラムに助っ人が入るような感じの準スクラム開発的なプロジェクト管理をしています。

と、チーム紹介とプロジェクト管理の概要はこのあたりにしてあとは具体的なツールの話です。

* Redmine VMの準備

まずプロジェクト管理ツールには[http://redmine.jp/:title=Redmine]を使っています。
ただ、新しくプロジェクトを立てるたびに構築し直すのは面倒なのでCentOS6に[http://alminium.github.com/alminium/:title=ALMinium]を入れたVMを用意しておいて、プロジェクト開始時にこのVMをコピーしてRedmine VMを作っています。

このVMにはRedmine以外にも以下のようなツールもインストールしています。

** Redmine Backlogs Pluginでスクラム開発

[http://www.redminebacklogs.net/en/introduction.html:title=Redmine Backlogs Plugin]は[http://www.atmarkit.co.jp/fjava/index/index_scrum.html:title=@ITのありがたい記事]でも説明されている便利プラグインです。ALMiniumを入れると自動的にこのプラグインもインストールされるのでそういう意味でも便利です^^

このプラグインで提供される
- バックログ
- かんばん
- バーンダウンチャート
などの使い方を知るのがチーム参加時の第一歩となっています。
※いずれも上記の記事でわかりやすく説明されています

** GitとSubversionで各種ファイルをバージョン管理

説明不要のバージョン管理ツールですが、[http://ja.wikipedia.org/wiki/Git:title=Git]と[http://ja.wikipedia.org/wiki/Apache_Subversion:title=Subversion]はALMiniumをインストールすると一緒についてきます。

コードの管理はGit、Officeファイルの管理はSubversionという使い分けをすることが多いような気がします。

チームメンバーにはまず最初にGit/Subversionの使い方を覚えてもらっていますが、
企画担当などコードを書かないメンバーにはSubversionの使い方だけ覚えてもらっています。


** YARDでRubyコードをドキュメンテーション

BuzzFinderがRubyベースなのでRubyコードのドキュメンテーションには[http://yardoc.org/:title=YARD]を使っています。

なのでメンバーにはYARDでのドキュメントの書き方も覚えてもらっています。

とはいえ最初に覚えるというよりは書きながら覚えるという感じです。

ちなみにYARDでドキュメントを作ると[http://rubydoc.info/gems/lapidary/0.2.3/frames:title=こんな感じ]になります。

** Sphinxでその他の内容をドキュメンテーション

RubyコードのドキュメンテーションにはYARDを使っているのですが、それ以外のインストール手順やシェルスクリプト等のドキュメンテーションには[http://sphinx-users.jp/:title=Sphinx]を使っています。

Sphinxでドキュメントを作るとHTMLだけでなくPDF版も生成できるので運用チームにドキュメントを渡す時にも助かっています。

YARDと同じで、メンバーにはSphinxでのドキュメントの書き方も覚えてもらっています。

** Jenkinsでドキュメントビルド

このVMはテストマシンではないのですが[https://wiki.jenkins-ci.org/display/JA/Jenkins:title=Jenkins]もインストールしています。

というのもYARDやSphinxでドキュメントを書いていると、RedmineサーバでHTML&PDF版のドキュメントが自動更新されると何かと便利なのでJenkinsではその自動化をしています。

ちなみにJenkinsについても[http://www.atmarkit.co.jp/fjava/rensai4/devtool21/devtool21_1.html:title=@ITの記事]がありがたそうな気がします。

** Chef-Soloで構成管理

上記のような構成を[http://wiki.opscode.com/display/chef/Chef+Solo:title=Chef-Solo]で構築しています。

他チームに渡すときなどは基本的にはコピーVMを渡すので良いのですが、その後マスターVMにソフトウェアを追加した際にもコピー先VMをアップデートしやすいように上記のツールは全てChef-Soloで管理しています。

ちなみにこのChef設定は[https://github.com/haracane/chef:title=Githubで公開]しているので、VMはいいからChefだけ使いたいという場合はこちらをご利用ください。

ALMiniumをインストール済みのCentOS6なら

>||
git clone https://github.com/haracane/chef.git
sudo chef/bin/chef-solo-role agile
||<

で上記の構成を構築できる、かもしれません。。

* Redmine VMまとめ

BuzzFinderチームでは上記のような構成でプロジェクト管理サーバを運用していますが、「こうするともっと良いよ」みたいなフィードバックをもらえたりすると嬉しいです。

今回は主にツールの紹介でしたが、実際のプロジェクト管理のやり方についてはまた別の日に書こうと思います。
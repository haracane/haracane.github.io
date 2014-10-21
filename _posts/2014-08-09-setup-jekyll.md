---
layout: post
title:  "Ruby2.1.2+Jekyll2.2.0+Nginx+独自ドメインでブログを作ってみた"
description: "前から興味があったJekyllでブログを作ってみました. "
date:   2014-08-09 11:00:00
tags: Jekyll Nginx
---



なお, リポジトリ管理にはGithubを使っていますが, ホスティングにはGithub Pagesは使わずにNginxを使いました.

### Jekyll2.2.0インストール

まずはJekyllをインストールします.

    $ gem install jeykyll -v 2.2.0

### Jekyllプロジェクト作成

初期プロジェクトがあった方が楽なので```jekyll new```で作成します.

    $ jekyll new sample-blog.enogineer.com
    $ cd sample-blog.enogineer.com

jekyll serverでhttp://localhost:4000から動作確認できます. 終了するにはCtrl-C.

    $ jekyll server
    ^C

### Githubにpush

Githubでリポジトリ管理をするのでharacane/sample-blog.enogineer.comリポジトリを作ってから

    $ git init
    $ git add .
    $ git ci -m "jekyll new blog.enonineer.com"
    $ git remote add origin git@github.com:haracane/sample-blog.enogineer.com
    $ git push -u origin master

でGithubにpushします.

### Gemfileを追加

一応Gemfileも追加しておきます.

**Gemfile**
{% highlight ruby %}
source 'https://rubygems.org'
gem 'jekyll', '2.2.0'
{% endhighlight %}

```bundle install```も実行します.

    $ bundle install
    $ git add .
    $ git ci -m "Add Gemfile"
    $ git push -u origin master

### メールアドレスを表示しない

デフォルトのテンプレートではメールアドレスを表示するようになっているので, 表示しないようにデザイン&設定を変更します.

**_includes/footer.html**
{% raw %}
<pre>
{% if site.email %}&lt;li&gt;&lt;a href="mailto:{{ site.email }}"&gt;{{ site.email }}&lt;/a&gt;&lt;/li&gt;{% endif %}
</pre>
{% endraw %}

**_config.yml**(下記を削除)

    email: your-email@domain.com

### コード表示時にスクロールバーを強制しない

デフォルトではコード表示時に常にスクロールバーが表示されるようになっているのでautoに変更します.

**css/main.css**

    .post pre,
    .post code {
      ...
      overflow: auto;
    }

### 設定をカスタマイズする

自分のブログ用にサイト設定をカスタマイズします.

**_config.yml**

    title: "江の島エンジニアBlog"
    description: "湘南在住、渋谷で働くエンジニアのブログです"
    baseurl: ""
    url: "http://sample-blog.enogineer.com"
    twitter_username: haracane
    github_username:  haracane
    ...

### NginxでVirtual Host設定をする

ブログ用のVirtual Host設定を追加します.

今回はsample-blog.enogineer.comドメインを利用した場合の例になります.

**/etc/nginx/conf.d/sample-blog.enogineer.com.conf**

    server {
      listen       80;
      server_name  sample-blog.enogineer.com;
      root /path/to/sample-blog.enogineer.com/_site;
      index index.html;
    }

### ブログをビルドする

```jekyll build```でブログをビルドします.

    $ bundle exec jekyll build

ビルドに成功したら[http://sample-blog.enogineer.com](http://sample-blog.enogineer.com)にブログが作られています.

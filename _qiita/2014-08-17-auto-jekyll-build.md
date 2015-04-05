JekyllでGitリポジトリのmasterブランチが更新されたら自動ビルドする

※ この記事は[江の島エンジニアBlog](http://blog.enogineer.com/)の「[JekyllでGitリポジトリのmasterブランチが更新されたら自動ビルドする](http://blog.enogineer.com/2014/08/17/auto-jekyll-build/)」の転載です。

masterが更新されたときに自動的にリポジトリ更新 & jekyll buildをする設定です.



Git hookは使わずにシンプルにシェルスクリプトで行っています.

まず

    $ git clone https://github.com/haracane/sample-blog.enogineer.com

でリポジトリをcloneしてから

**auto-jekyll-build.sh**
```bash
cd $1

echo "check $dir" >&2
git fetch
diff_count=$(git diff origin/master | wc -l)

if [ "$diff_count" = 0 ]; then
  echo "it's up-to-date" >&2
  exit 1
fi

git reset --hard
git clean -fd
git branch -D tmp
git checkout -b tmp
if [ $? != 0 ]; then exit 1; fi
git branch -D master
git fetch
if [ $? != 0 ]; then exit 1; fi
git checkout master
if [ $? != 0 ]; then exit 1; fi
bundle exec jekyll build
```

という内容でビルドスクリプトを作成して

```bash
* * * * * sh /path/to/auto-jekyll-build.sh /path/to/sample-blog.enogineer.com 2> /path/to/auto-jekyll-build.log
```

とcrontabを設定してあげればOKです.

これで1分毎に更新をチェックして更新があれば自動的に```jekyll build```を実行します.

※ ただし, ファイル削除のみの更新の場合は自動更新されません.

もし実行ログ(auto-jekyll-build.log)に

    Permission denied (publickey).
    fatal: The remote end hung up unexpectedly

のようなエラーメッセージが出るようならリモートリポジトリのURLを確認して,
HTTPSのURLになっていなかったら

    $ git remote rm origin
    $ git remote add origin https://github.com/haracane/sample-blog.enogineer.com

とリモートリポジトリのURLを変更してください.
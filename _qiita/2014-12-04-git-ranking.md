よく使うGitコマンドのエイリアス＆シェル関数トップ10+α

※ この記事は[江の島エンジニアBlog](http://blog.enogineer.com/)の「[よく使うGitコマンドのエイリアス＆シェル関数トップ10+α](http://blog.enogineer.com/2014/12/04/git-ranking/)」の転載です。

Gitコマンドはターミナルで最もよく使うコマンドなのでエイリアスやシェル関数にして実行しているのですが、実際に何をよく使っているか調べてみました。

この記事は[Git Advent Calendar 2014](http://qiita.com/advent-calendar/2014/git)の4日目です。

3日目は[@sue738](http://qiita.com/sue738)さんの「[Githubのブラウザのみでブランチ切ってプルリクするまで](http://qiita.com/sue738/items/7b979c554a03441901c6)」でした。おつかれさまでした。

今回はよく使うGitコマンドのランキングです。ちなみに、同じサブコマンドはまとめて集計しました。

ではさっそく結果発表です。

## 1位：とりあえず`gs`

これは`git status`のエイリアスです。

```sh
alias gs='git status'
```

「何の作業してたっけな」という時にまず打ってみるコマンドなので、やっぱり利用頻度が高いですね。

ちなみに2位の3倍のダントツ1位でした。

## 2位：`ga`, `gap`でインデックス追加

それぞれ`git add`と`git add -p`のエイリアスです。

```sh
alias ga='git add'
alias gap='git add -p'
```

`gap`の方はたまにしか使いませんが、結構便利です。

## 3位: `gl`, `gln`でコミットログ確認

これは`git log`系のエイリアスです。

```sh
alias gl='git log --oneline'
alias gln='git log --name-only'
for n in $(seq 50); do
  alias gl$n="git log --oneline -n $n | tee"
done
```

普段はシンプルに見るので`gl`は`git log --oneline`に割り当てています。

行数指定の方は`gl1`や`gl10`あたりを時々使ってますね。

## 4位: `gps`, `gpsf`でpush&プルリク

4位は`git push`系のシェル関数でした。

`gps`と打つと現在のブランチをoriginにpushして、プルリクエスト用のURLを表示するようにしています。

実行するとこんな感じになります。

    [feature/add_function] % gps
    Total 0 (delta 0), reused 0 (delta 0)
    To git@github.com:haracane/blog.enogineer.com
     * [new branch]      feature/add_function -> feature/add_function
    https://github.com/haracane/blog.enogineer.com
    https://github.com/haracane/blog.enogineer.com/tree/feature/add_function
    https://github.com/haracane/blog.enogineer.com/compare/master...feature/add_function

ちょっと長いですが、シェル関数はこんな感じにしています。

```sh
function github-push() {
  local repository=origin
  while true; do
    if [ "$1" = -f ]; then
      local f_option=$1; shift
    elif [ "$1" = --repo ]; then
      repository=$2; shift 2
    else break; fi
  done

  local branch=${1:-$(git rev-parse --abbrev-ref HEAD)}
  local parent_branch=${2:-master}

  git push $f_option $repository $branch \
  && github-urls $branch $parent_branch
}

function github-urls() {
  local src_branch=${1:-$(git rev-parse --abbrev-ref HEAD)}
  local dst_branch=${2:-master}
  local url=$(github-push-url)

  echo "$url "
  echo "$url/tree/$src_branch "
  if [ $src_branch != $dst_branch ]; then
    echo "$url/compare/${dst_branch}...${src_branch} "
  fi
}

function github-push-url() {
  git remote -v | grep '(push)' | awk '{print $2}' | sed -e "s/^[a-z]*@\([a-z0-9\.]*\):/https:\/\/\1\//g" | sed 's/\.git$//g'
}

alias gps='github-push'
alias gpsf='github-push -f'
```

## 5位: `gd`, `gdn`で差分確認

5位は`git diff`系です。

```sh
alias gd='git diff'
alias gdn='git diff --name-only'
for n in $(seq 50); do
  alias gd$n="git diff HEAD~$n"
  alias gdn$n="git diff --name-only HEAD~$n"
done
```

普段は`gd`を、変更ファイルを確認したい時に`gdn`を、直前のコミットの差分を見たい時に`gd1`を使ったりしてます。

## 6位: `gci`, `gcm`, `gca`でコミット作成・変更

6位は`git commit`系でした。

```sh
alias gci='git commit'
alias gcm='git commit -m'
alias gca='git commit --amend'
```

ちなみに[git commitをフックしてコミットメッセージに自動的にチケット番号を追加する]({% post_url 2014-09-06-git-hook-commit-ticket %})ようにしています。

## 7位: `gco`, `gcof`でブランチ切り替え

続いては`git checkout`です。

```sh
alias gco='git checkout'
alias gcot='git checkout --theirs'
```

`gco`は普通にブランチ切り替えに使ってます。

あとは`gcot .`で変更内容を元に戻したりもよくしてますね。

## 8位: `gcof`でブランチ作成

次も`git checkout`系なのですが、ブランチ作成の用途がメインなのでランキングを分けました。

```sh
function git-checkout-force() {
  local branch=$1
  if [ $branch = $(git rev-parse --abbrev-ref HEAD) ]; then
    echo "Already on '$branch'" >&2
    return 0
  fi
  git branch -D $branch > /dev/null 2>&1
  git checkout -b $branch
}
```

簡単に解説すると

1. 作りたいブランチが既にあれば削除
2. `git checkout -b`でブランチを作成

ということを行って強制的にブランチを作っています。

いちいち作成済みだったかどうか気にせずにブランチを作れるので結構重宝しています。

## 9位: `gpl`, `gplf`でブランチ最新化

こちらは`git pull`系のシェル関数です。

現在のブランチをoriginからpullします。

```sh
function git-pull() {
  local repository=${1:-origin}
  local branch=${2:-$(git rev-parse --abbrev-ref HEAD)}
  git pull origin $branch
}
alias gps=git-pull
```

`gplf`の場合は完全にoriginのブランチに置き換えるようにしています。

```sh
function git-pull-force() {
  local branch=$(git rev-parse --abbrev-ref HEAD)
  git-checkout-force tmp 2> /dev/null
  if [ $? != 0 ]; then return 1; fi
  git branch -D $branch > /dev/null 2>&1
  if [ $? != 0 ]; then return 1; fi
  git fetch
  if [ $? != 0 ]; then return 1; fi
  git checkout $branch
}
alias gplf=git-pull-force
```

見ての通り実は`git pull`コマンドは実行してなかったりします。

## 10位: `grbi`, `grba`, `grbc`でコミット書き換え

10位はコミットの整理に欠かせない`git rebase`系のコマンドです。

```sh
alias grbi='git rebase -i'
alias grba='git rebase --abort'
alias grbc='git rebase --continue'
for n in $(seq 50); do
  alias grb$n="git rebase -i HEAD~$n"
done
```

`grb2`とか`grb3`とか割とカジュアルにrebaseできて重宝してます。

## その他: `grs`, `grsh`, `glcp`とか

他には`git reset`系ではこんな感じのエイリアスを作ってます。

```sh
alias grs='git reset'
alias grsh='git reset --hard'
for n in $(seq 50); do
  alias grs$n="git reset HEAD~$n"
done
```

あとは直近コミット取り込み用の`git cherry-pick`コマンドを生成するシェル関数もよく使っています。

```sh
function git-log-cherry-pick() {
  local count=${1:-10}
  git log --oneline | head -n $count | tac | sed 's/ / #/' | sed 's/^/git cherry-pick /g'
}
alias glcp=git-log-cherry-pick
for n in $(seq 50); do
  alias glcp$n="git-log-cherry-pick $n"
done
```

## まとめ

以上、よく使っているgitエイリアス＆シェル関数のまとめでした。

基本的に自分で使うだけなので適当なところが多いですが、参考になる物があれば幸いです。

5日目は[@ayato](http://qiita.com/ayato)さんです。よろしくお願いします。
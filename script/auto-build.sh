cd $(dirname $0)/..

diff_count=$(git diff origin/master | wc -l)

if [ "$diff_count" = 0 ]; then exit 0; fi

git pull origin master
rvm use 2.1.2
bundle exec jekyll build

jekyller draft \
  --title "git commitをフックして自動的にチケット番号をコミットメッセージ追加する" \
  --tags "Git" \
  --description "いちいちコミットメッセージにチケット番号を追加するのは面倒なので、自動的にチケット番号を追加してくれるgit commitのhookを作りました。" \
  git-hook-commit-ticket

jekyller publish -f git-hook-commit-ticket

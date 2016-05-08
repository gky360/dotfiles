#!/bin/sh

# ruby, rails
alias be='bundle exec'
alias rsb='rails s -b 0.0.0.0'

# vagrant
alias vain='vagrant up; vagrant ssh'
alias vash='vagrant ssh'
alias vahl='vagrant halt'

# local IP address 確認
alias localip="ifconfig | grep -Eo 'inet (addr:)?([0-9]*\.){3}[0-9]*'"

# redis
alias rds='redis-server'
alias rdc='redis-cli'

# git
if command_exists git ; then
  # カラフルにする
  git config --global color.ui true
  # ステータス
  git config --global alias.st status
  # チェックアウト
  git config --global alias.ch checkout
  # git mab -> git merge --abort
  git config --global alias.mab 'merge --abort'
  # ログをツリー状に表示
  git config --global alias.gr 'log --graph --oneline --decorate -10'
  # リポジトリ内を検索
  git config --global alias.gn 'grep -n'
  # マージできるか調べる
  git config --global alias.mts 'merge --no-commit --no-ff'
  # git add した後に差分を確認する
  git config --global alias.dfca 'diff --cached'
  # 不要な空白やタブ、改行が含まれていないか add 前にチェック
  git config --global alias.dfch 'diff --check'
fi

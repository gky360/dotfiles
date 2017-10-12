#!/bin/sh

if command_exists git ; then
  # ghq config
  git config --global ghq.root ~/ghq
  # エディターを vim にする
  git config --global core.editor 'vim -c "set fenc=utf-8"'
  # enable gitignore_global
  git config --global core.excludesfile ~/.gitignore_global
  # カラフルにする
  git config --global color.ui true
  git config --global color.diff auto
  git config --global color.status auto
  git config --global color.branch auto
  # ステータス
  git config --global alias.st status
  # ブランチ
  git config --global alias.br branch
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
  # side-by-side diff --cached
  git config --global alias.dfca 'diff --cached'
  # 不要な空白やタブ、改行が含まれていないか add 前にチェック
  git config --global alias.dfch 'diff --check'
  # 今の日時にしてcommitし直す
  git config --global alias.cmad '!git commit --amend --date'
  # push -u
  git config --global alias.pushu 'push -u'
fi


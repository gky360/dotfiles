#!/bin/sh

# git config
if command_exists git ; then
  # redirect old repo
  if [ "`git remote -v | grep scarletrunner7000`" ]; then
    if [ "`git remote -v | grep https`" ]; then
      # https
      new_origin='https://github.com/gky360/dotfiles.git'
    else
      # ssh
      new_origin='git@github.com:gky360/dotfiles.git'
    fi
    set -x
    git remote set-url origin $new_origin
    { set +x; } 2>/dev/null
  fi

  # user and email
  git config --global user.name ${GIT_GLOBAL_USER_NAME:-gky360}
  git config --global user.email ${GIT_GLOBAL_USER_EMAIL:-gky360@gmail.com}

  # editor
  git config --global core.editor vim
  # ghq config
  git config --global ghq.root ~/dev/src
  # enable gitignore_global
  git config --global core.excludesfile ~/.gitignore_global
  # colorful
  git config --global color.ui true
  git config --global color.diff auto
  git config --global color.status auto
  git config --global color.branch auto

  # unset alias
  git config --global --remove-section alias || :

  git config --global alias.st status
  git config --global alias.br branch
  git config --global alias.co checkout
  git config --global alias.ci commit
  git config --global alias.cia 'commit --amend'
  git config --global alias.cim 'commit -m'
  git config --global alias.ciam 'commit --amend -m'
  git config --global alias.mab 'merge --abort'
  git config --global alias.gr 'log --graph --oneline --decorate -10'
  git config --global alias.gn 'grep -A 1 -B 1 -n'

  # make sure the current branch has no conflict
  git config --global alias.mts 'merge --no-commit --no-ff'
  # side-by-side diff --cached
  git config --global alias.dfca 'diff --cached'
  # make sure there are no unnecessary spaces nor tabs
  git config --global alias.dfch 'diff --check'
  # show diff per words
  git config --global alias.dfw 'diff --word-diff'
  git config --global alias.dfwca 'diff --word-diff --cached'
  git config --global alias.shw 'show --word-diff'
  # edit commit's timestamp
  git config --global alias.cmad '!git commit --amend --date'
  # set upstream
  git config --global alias.pu 'push -u'

  # Temporary disable git-secrets until say command is removed from git-secrets.
  # See: https://github.com/awslabs/git-secrets/pull/221

  # if command_exists 'git-secrets' ; then
  #   git secrets --register-aws --global
  #   bash -c 'alias say="echo" && git secrets --install -f ~/.git-templates/git-secrets'
  #   git config --global init.templatedir '~/.git-templates/git-secrets'
  # fi

  # git-delta
  if command_exists delta ; then
    git config --global core.pager delta
    git config --global interactive.diffFilter 'delta --color-only'
    git config --global merge.conflictstyle diff3
    git config --global diff.colorMoved default
    git config --global delta.navigate true
    git config --global delta.dark true
    git config --global delta.side-by-side true
    git config --global delta.line-numbers true
    git config --global delta.syntax-theme 'Dracula'
    git config --global delta.minus-emph-style 'syntax bold "#b80000"'
    git config --global delta.minus-style 'syntax "#5d001e"'
    git config --global delta.plus-emph-style 'syntax bold "#007800"'
    git config --global delta.plus-style 'syntax "#004433"'
  fi
fi

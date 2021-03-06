#!/bin/sh

PATH=$PATH:/sbin:$HOME/bin

export PATH

# dotfiles
export DOTPATH="$HOME/dotfiles"

# brew
export PATH=/usr/local/bin:/usr/local/sbin:/usr/sbin:$PATH

# zsh-completions
if [ -e /usr/local/share/zsh-completions ]; then
  fpath=(/usr/local/share/zsh-completions $fpath)
fi

# ruby, rails
export PATH="$HOME/.rbenv/bin:$PATH"
if command_exists 'rbenv' ; then
  eval "$(rbenv init - --no-rehash)"
fi

# python
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PATH:$PYENV_ROOT/bin"
if command_exists 'pyenv' ; then
  eval "$(pyenv init - --no-rehash)"
  eval "$(pyenv virtualenv-init - --no-rehash)"
fi
if [ -e /c/tools/Anaconda3 ]; then
  export PATH=/c/tools/Anaconda3:$PATH
fi

# poetry
if [ -e $HOME/.poetry/env ]; then
  . $HOME/.poetry/env
fi

# postgreSQL
if command_exists 'postgres' ; then
  export PGDATA=/usr/local/var/postgres
fi

# latex
TEXLIVE_BIN=/usr/local/texlive/2020/bin/x86_64-darwin
if [ -e $TEXLIVE_BIN ]; then
  export PATH=$PATH:$TEXLIVE_BIN
fi

# go
if [ -e $HOME/.goenv ]; then
  export GOENV_ROOT="$HOME/.goenv"
  export PATH="$GOENV_ROOT/bin:$PATH"
  eval "$(goenv init -)"
  export PATH="$GOROOT/bin:$PATH"
  export PATH="$PATH:$GOPATH/bin"
fi

# atcli
export ATCLI_ROOT=${GOPATH}/src/github.com/gky360/contests/atcoder
export ATCLI_CPP_TEMPLATE_PATH=$ATCLI_ROOT/../templates/Main.cpp.tmpl

# nvm
# 参考: [NVM の nvm.sh を遅延ロードしてシェルの起動を高速化する - Qiita](http://qiita.com/uasi/items/80865646607b966aedc8)
if [ -s $HOME/.nvm ]; then
  export NVM_DIR="$HOME/.nvm"
  NVM_DEFAULT_VERSION=`cat $NVM_DIR/alias/default`
  NVM_DEFAULT_DIR=$NVM_DIR/versions/node/$NVM_DEFAULT_VERSION
  PATH=$NVM_DEFAULT_DIR/bin:$PATH
  MANPATH=$NVM_DEFAULT_DIR/share/man:$MANPATH
  export NODE_PATH=$NVM_DEFAULT_DIR/lib/node_modules
  NODE_PATH=${NODE_PATH:A}
  nvm() {
    unset -f nvm
    . "$NVM_DIR/nvm.sh"
    . "$NVM_DIR/bash_completion"
    nvm "$@"
  }
fi

# OPAM configuration
if [ -s $HOME/.opam ]; then
  . ~/.opam/opam-init/init.zsh > /dev/null 2> /dev/null || true
fi

# rust
if [ -e ~/.cargo ]; then
  export PATH="$HOME/.cargo/bin:$PATH"
  if command_exists 'rustc' ; then
    export RUST_SRC_PATH="$(rustc --print sysroot)/lib/rustlib/src/rust/src"
  fi
fi
export RUST_BACKTRACE=1

# docker
export DOCKER_BUILDKIT=1
export COMPOSE_DOCKER_CLI_BUILD=1

# local bin
export PATH=$HOME/.local/bin:$PATH
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$HOME/.local/lib

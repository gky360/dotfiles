#!/bin/sh

export PATH=$PATH:/sbin:$HOME/bin

# dotfiles
export DOTPATH="$HOME/dotfiles"

# docker
export DOCKER_BUILDKIT=1

# brew
export PATH="/opt/homebrew/bin:$PATH"
if [ -e /opt/homebrew ]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"

  ## for numpy build
  # export OPENBLAS="$(brew --prefix openblas)"
  ## for cryptography
  # export LDFLAGS="-L$(brew --prefix openssl@1.1)/lib" CFLAGS="-I$(brew --prefix openssl@1.1)/include"
fi

# zsh-completions
if [ -e /usr/local/share/zsh-completions ]; then
  fpath=(/usr/local/share/zsh-completions $fpath)
fi

# python
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
if command_exists 'pyenv' ; then
  eval "$(pyenv init --path)"
  if [ -e $(pyenv root)/plugins/pyenv-virtualenv ]; then
    eval "$(pyenv virtualenv-init -)"
  fi
fi
if [ -e /c/tools/Anaconda3 ]; then
  export PATH=/c/tools/Anaconda3:$PATH
fi

# poetry
if [ -e $HOME/.poetry/env ]; then
  . $HOME/.poetry/env
  export PATH="$HOME/.poetry/bin:$PATH"
fi

# atcli
export ATCLI_ROOT=${GOPATH}/src/github.com/gky360/contests/atcoder
export ATCLI_CPP_TEMPLATE_PATH=$ATCLI_ROOT/../templates/Main.cpp.tmpl

# nodenv
if [ -s $HOME/.nodenv ]; then
  eval "$(nodenv init -)"
fi

# rust
if [ -e ~/.cargo ]; then
  export PATH="$HOME/.cargo/bin:$PATH"
  if command_exists 'rustc' ; then
    # racer
    export RUST_SRC_PATH="$(rustc --print sysroot)/lib/rustlib/src/rust/src"
  fi
fi
export RUST_BACKTRACE=1

# golang
if command_exists 'goenv' ; then
  export GOENV_ROOT="$HOME/.goenv"
  export PATH="$GOENV_ROOT/bin:$PATH"
  eval "$(goenv init -)"
  export PATH="$GOROOT/bin:$PATH"
  export PATH="$PATH:$GOPATH/bin"
fi

# local bin
export PATH=$HOME/.local/bin:$PATH
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$HOME/.local/lib

#!/bin/sh

export PATH=$PATH:/sbin:$HOME/bin

# local bin
export PATH=$HOME/.local/bin:$PATH
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$HOME/.local/lib

# dotfiles
export DOTPATH="$HOME/dotfiles"

# docker
export DOCKER_BUILDKIT=1

# rancher desktop
export PATH=$PATH:$HOME/.rd/bin

# brew
export PATH="/opt/homebrew/bin:$PATH"
if [ -e /opt/homebrew ]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"

  ## for numpy build
  # export OPENBLAS="$(brew --prefix openblas)"
  ## for cryptography
  # export LDFLAGS="-L$(brew --prefix openssl@1.1)/lib" CFLAGS="-I$(brew --prefix openssl@1.1)/include"
  ## for pygraphviz
  # export LDFLAGS="-L$(brew --prefix graphviz)/lib" CFLAGS="-I$(brew --prefix graphviz)/include"
fi

# zsh-completions
if [ -e /usr/local/share/zsh-completions ]; then
  fpath=(/usr/local/share/zsh-completions $fpath)
fi

# mise
if command_exists 'mise'; then
  eval "$(mise activate zsh)"
fi

# poetry
if [ -e $HOME/.poetry/env ]; then
  . $HOME/.poetry/env
  export PATH="$HOME/.poetry/bin:$PATH"
fi

# atcli
export ATCLI_ROOT=${GOPATH}/src/github.com/gky360/contests/atcoder
export ATCLI_CPP_TEMPLATE_PATH=$ATCLI_ROOT/../templates/Main.cpp.tmpl

# rust
if [ -e ~/.cargo ]; then
  export PATH="$HOME/.cargo/bin:$PATH"
  if command_exists 'rustc' ; then
    # racer
    export RUST_SRC_PATH="$(rustc --print sysroot)/lib/rustlib/src/rust/src"
  fi
fi
export RUST_BACKTRACE=1

# For git diff
export LESSCHARSET=utf-8

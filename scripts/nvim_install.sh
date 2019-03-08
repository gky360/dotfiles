#!/bin/bash

set -eux

WORKING_DIR=$HOME/tmp
TARGET_DIR=$HOME/.local
PYTHON_VERSION=3.7.2


# Support Python3 provider

$DOTPATH/scripts/pyenv_install.sh

pyenv install $PYTHON_VERSION || true
if ! [ -e $(pyenv root)/versions/3.7.2/envs/nvim3 ]; then
  pyenv virtualenv $PYTHON_VERSION nvim3
fi
set +u
eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"
pyenv activate nvim3
pyenv which python
pip install pynvim


if ! [ -x "$(command -v nvim)" ]; then
  cd $WORKING_DIR
  if ! [ -e neovim ]; then
    git clone https://github.com/neovim/neovim
  fi
  cd neovim
  git pull
  export PATH=/usr/bin:$PATH
  export CMAKE_BUILD_TYPE=Release
  export CMAKE_EXTRA_FLAGS="-DCMAKE_INSTALL_PREFIX=$TARGET_DIR"
  make
  make install
fi

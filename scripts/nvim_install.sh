#!/bin/bash

set -eux

WORKING_DIR=$HOME/tmp
TARGET_DIR=$HOME/.local

if [ -x "$(command -v nvim)" ]; then
  cd $WORKING_DIR
  git clone https://github.com/neovim/neovim
  make CMAKE_BUILD_TYPE=Release CMAKE_EXTRA_FLAGS="-DCMAKE_INSTALL_PREFIX=$TARGET_DIR"
  make install
fi


# Support Python3 provider

PYTHON_VERSION=3.7.2

pyenv install $PYTHON_VERSION || true
pyenv virtualenv $PYTHON_VERSION nvim3
. ~/.bashrc
pyenv activate nvim3
set +u
pip install pynvim

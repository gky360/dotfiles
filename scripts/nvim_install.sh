#!/bin/bash

set -eux

WORKING_DIR=$HOME/tmp
TARGET_DIR=$HOME/.local
# PYTHON_VERSION=3.11.3


# Support Python3 provider

# $DOTPATH/scripts/pyenv_install.sh
#
# pyenv install $PYTHON_VERSION || true
# if ! [ -e $(pyenv root)/versions/$PYTHON_VERSION/envs/nvim3 ]; then
#   pyenv virtualenv $PYTHON_VERSION nvim3
# fi
# set +u
# eval "$(pyenv init -)"
# eval "$(pyenv virtualenv-init -)"
# pyenv activate nvim3
# pyenv which python
# pip install pynvim

# Install dependencies
if [ -f /etc/lsb-release ]; then
  # Debian/Ubuntu
  sudo apt-get update
  sudo apt-get -y install ninja-build gettext libtool libtool-bin autoconf automake cmake g++ pkg-config unzip
elif [ -f /etc/redhat-release ]; then
  # CentOS
  sudo yum -y install ninja-build libtool autoconf automake cmake gcc gcc-c++ make pkgconfig unzip
fi

if ! [ -x "$(command -v nvim)" ]; then
  mkdir -p $WORKING_DIR
  cd $WORKING_DIR
  if ! [ -e neovim ]; then
    git clone --depth 1 https://github.com/neovim/neovim
  fi
  cd neovim
  git pull
  export PATH=/usr/bin:$PATH
  export CMAKE_BUILD_TYPE=Release
  export CMAKE_EXTRA_FLAGS="-DCMAKE_INSTALL_PREFIX=$TARGET_DIR"
  make
  make install
fi

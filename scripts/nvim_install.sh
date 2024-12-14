#!/bin/bash

set -eux

WORKING_DIR=$HOME/tmp
TARGET_DIR=$HOME/.local


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

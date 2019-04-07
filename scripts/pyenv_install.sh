#!/bin/bash

set -eux

# Install dependencies
if [ -f /etc/lsb-release ]; then
  # Debian/Ubuntu
  sudo apt-get update
  sudo apt-get install -y make build-essential libssl-dev zlib1g-dev libbz2-dev libreadline-dev libsqlite3-dev wget curl llvm libncurses5-dev xz-utils tk-dev libxml2-dev libxmlsec1-dev libffi-dev liblzma-dev
elif [ -f /etc/redhat-release ]; then
  # CentOS
  sudo yum install -y gcc zlib-devel bzip2 bzip2-devel readline-devel sqlite sqlite-devel openssl-devel tk-devel libffi-devel
fi

if ! [ -x "$(command -v pyenv)" ]; then
  git clone https://github.com/pyenv/pyenv.git ~/.pyenv
fi
cd $(pyenv root)
git pull

if ! [ -e $(pyenv root)/plugins/pyenv-virtualenv ]; then
  git clone https://github.com/pyenv/pyenv-virtualenv.git $(pyenv root)/plugins/pyenv-virtualenv
fi
cd $(pyenv root)/plugins/pyenv-virtualenv
git pull

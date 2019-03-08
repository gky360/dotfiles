#!/bin/bash

set -eux

if ! [ -x "$(command -v pyenv)" ]; then
  git clone https://github.com/pyenv/pyenv.git ~/.pyenv
fi

if ! [ -e $(pyenv root)/plugins/pyenv-virtualenv ]; then
  git clone https://github.com/pyenv/pyenv-virtualenv.git $(pyenv root)/plugins/pyenv-virtualenv
fi

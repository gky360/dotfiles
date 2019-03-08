#!/bin/bash

set -ex

PYTHON_VERSION=3.7.2

pyenv install $PYTHON_VERSION || true
pyenv virtualenv $PYTHON_VERSION nvim3
. ~/.bashrc
pyenv activate nvim3
pip install pynvim

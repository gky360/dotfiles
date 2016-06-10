#!/bin/sh

set -e

DOTPATH="$HOME/dotfiles"
export DOTPATH

cd $DOTPATH

git pull
./deploy.sh


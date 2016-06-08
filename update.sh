#!/bin/sh

DOTPATH="$HOME/dotfiles"
export DOTPATH

cd $DOTPATH

git pull
./deploy.sh


#!/bin/bash

set -e

DOTPATH="$HOME/dotfiles"
export DOTPATH

cd $DOTPATH
cd ansible

brew bundle dump --describe --force
mv Brewfile Brewfile.tmp
cat <<EOF | cat - Brewfile.tmp > Brewfile
# -*- mode: ruby -*-
# vi: set ft=ruby :

EOF
rm -f Brewfile.tmp

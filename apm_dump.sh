#!/bin/bash

set -e

DOTPATH="$HOME/dotfiles"
export DOTPATH

cd $DOTPATH

apm list --installed --bare | awk '{ print tolower($0) }' | tee ${DOTPATH}/_atom/packages-list.txt

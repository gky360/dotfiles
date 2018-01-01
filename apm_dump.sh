#!/bin/bash

set -e

DOTPATH="$HOME/dotfiles"
export DOTPATH

cd $DOTPATH

apm list --installed --bare | awk '{ print tolower($0) }' | sed '/^\s*$/d' | sort | tee ${DOTPATH}/_atom/packages-list.txt

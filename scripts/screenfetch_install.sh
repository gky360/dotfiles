#!/bin/bash

set -e

working_dir=$HOME/tmp
target_dir=$HOME/.local

mkdir -p ${working_dir}
mkdir -p ${target_dir}/bin

cd $working_dir
git clone https://github.com/KittyKatt/screenFetch.git
cd screenFetch
chmod +x screenfetch-dev
cp screenfetch-dev ${target_dir}/bin/screenfetch

echo 'Add "export PATH=$HOME/.local/bin:$PATH" to your .bashrc or .zshrc .'


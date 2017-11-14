#!/bin/bash

set -e

GO_VERSION=1.9

working_dir=$HOME
target_dir=$HOME/.local
mkdir -p $working_dir
mkdir -p $target_dir/bin


function install_go() {
  cd $working_dir
  if ! [ -d go${1} ]; then
    git clone https://go.googlesource.com/go go${1}
  fi
  cd go${1}/src
  git checkout release-branch.go${1}
  ./make.bash
}

install_go 1.4
install_go $GO_VERSION

ln -sf ${working_dir}/go${GO_VERSION}/bin/* $target_dir/bin

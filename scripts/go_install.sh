#!/bin/bash

set -e

GO_VERSION=1.11

working_dir=$HOME
target_dir=$HOME/.local
mkdir -p $working_dir
mkdir -p $target_dir

cd $working_dir
wget https://dl.google.com/go/go$GO_VERSION.linux-amd64.tar.gz
tar -C $target_dir -xzf go$GO_VERSION.linux-amd64.tar.gz

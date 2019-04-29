#!/bin/bash

set -eux

working_dir=$HOME/tmp

cd $working_dir

# install ghq
go get github.com/motemen/ghq

# install glide
curl https://glide.sh/get | sh

ghq get peco/peco
cd $(ghq root)/$(ghq list --exact peco/peco)
make build
cp releases/$(ls releases)/peco $(ghq root)/../bin

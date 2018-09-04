#!/bin/bash

set -eux

working_dir=$HOME/tmp

cd $working_dir

# install ghq
go get github.com/motemen/ghq

# install glide
curl https://glide.sh/get | sh

ghq get peco/peco
ghq look peco/peco
glide install
go build cmd/peco/peco.go
cp peco $(ghq root)/../bin

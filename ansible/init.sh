#!/bin/sh

set -e

xcode-select --install

if [[ $(uname -p) == 'arm' ]]; then
  # has M1 chip
  softwareupdate --install-rosetta
fi

/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

brew doctor
brew update

brew install ansible
brew install git

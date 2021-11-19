#!/bin/sh

set -e

xcode-select --install || true

if [[ $(uname -p) == 'arm' ]]; then
  # has M1 chip
  softwareupdate --install-rosetta
fi

/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

brew doctor
brew update

brew install ansible
brew install git

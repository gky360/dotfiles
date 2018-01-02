#!/bin/sh

sudo xcodebuild -license
xcode-select --install
sudo xcode-select -s /Applications/Xcode.app/Contents/Developer

/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

brew doctor
brew update

brew install python
brew install ansible
brew install git

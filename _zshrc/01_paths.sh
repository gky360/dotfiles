#!/bin/sh

PATH=$PATH:$HOME/bin

export PATH

# ruby, rails
export PATH="$HOME/.rbenv/bin:$PATH"
eval "$(rbenv init --no-rehash -)"

# go 言語
# [Macでgo言語開発環境を作る]
# (http://qiita.com/puttyo_bubu/items/4e60e42ff041f2474428)
if command_exists go ; then
  if [ -x "`which go`" ]; then
    export GOROOT=`go env GOROOT`
    export GOPATH=$HOME/go
    export PATH=$PATH:$GOROOT/bin:$GOPATH/bin
  fi
fi

# Android
if command_exists android ; then
  export ANDROID_HOME=/usr/local/opt/android-sdk
fi

# cordova
if command_exists cordova ; then
  export PATH=$PATH:/usr/local/Cellar/android-sdk/24.4/tools
  export PATH=$PATH:/usr/local/Cellar/android-sdk/24.4/platform-tools
fi

# postgreSQL
if command_exists postgres ; then
  export PGDATA=/usr/local/var/postgres
fi

# node
# export NVM_DIR="/Users/inagaki/.nvm"
# [ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"  # This loads nvm


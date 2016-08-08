#!/bin/sh

PATH=$PATH:$HOME/bin

export PATH

# ruby, rails
export PATH="$HOME/.rbenv/bin:$PATH"
if command_exists 'rbenv' ; then
  eval "$(rbenv init --no-rehash -)"
fi

# python
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
if command_exists 'pyenv' ; then
  eval "$(pyenv init -)"
fi

# go 言語
# [Macでgo言語開発環境を作る]
# (http://qiita.com/puttyo_bubu/items/4e60e42ff041f2474428)
if command_exists 'go' ; then
  if [ -x "`which go`" ]; then
    export GOROOT=`go env GOROOT`
    export GOPATH=$HOME/go
    export PATH=$PATH:$GOROOT/bin:$GOPATH/bin
  fi
fi

# Android
if command_exists 'android' ; then
  export ANDROID_HOME=/usr/local/opt/android-sdk
fi

# cordova
if command_exists 'cordova' ; then
  export PATH=$PATH:/usr/local/Cellar/android-sdk/24.4/tools
  export PATH=$PATH:/usr/local/Cellar/android-sdk/24.4/platform-tools
fi

# postgreSQL
if command_exists 'postgres' ; then
  export PGDATA=/usr/local/var/postgres
fi

# nvm
# [NVM の nvm.sh を遅延ロードしてシェルの起動を高速化する - Qiita](http://qiita.com/uasi/items/80865646607b966aedc8)
PATH=${NVM_DIR:-$HOME/.nvm}/default/bin:$PATH
MANPATH=${NVM_DIR:-$HOME/.nvm}/default/share/man:$MANPATH
export NODE_PATH=${NVM_DIR:-$HOME/.nvm}/default/lib/node_modules
NODE_PATH=${NODE_PATH:A}
nvm() {
  unset -f nvm
  source "${NVM_DIR:-$HOME/.nvm}/nvm.sh"
  nvm "$@"
}


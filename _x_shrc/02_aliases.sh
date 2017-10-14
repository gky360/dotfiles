#!/bin/sh

# basic
alias la='ls -la'
alias ll='ls -l'
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'
# sudo の後のコマンドでエイリアスを有効にする
alias sudo='sudo '

# dotfiles
alias dotfiles="cd $DOTPATH"
alias srcrc="if [ -e ~/.${SHELL##*/}rc ]; then source ~/.${SHELL##*/}rc; fi"

# emacs
alias emacs='emacs -nw'

# gcc
alias g++14='g++ -std=c++14 -Wall'

# ruby, rails
alias be='bundle exec'
alias rsb='bundle exec rails s -b 0.0.0.0'
alias rtcc='bundle exec rake tmp:cache:clear'
alias Prc='bundle exec rails c -e production'
alias Prap='RAILS_ENV=production bundle exec rake assets:precompile assets:clean'
alias Prsb='bundle exec rails s -b 0.0.0.0 -e production'

# git
## status
alias gst="git status"
## log graph
alias ggr="git gr"
## clear unused branches
alias gbrcl="git branch --merged | grep -v '*' | xargs git branch -d"
## reset modes of the files
alias gprst="git diff --numstat | awk '{if ((\$1 == \"0\" && \$2 == \"0\") || (\$1 == \"-\" && \$2 == \"-\")) print \$3}' | xargs git checkout HEAD"
## ghq list
alias gl='cd $(ghq root)/$(ghq list | peco)'
## hub browse
alias gb='hub browse $(ghq list | peco | cut -d "/" -f 2,3)'

# vagrant
alias vain='vagrant up && vagrant ssh'
alias vash='vagrant ssh'
alias vahl='vagrant halt'
alias vasus='vagrant suspend'
alias varein='vagrant reload && vagrant ssh'

# docker
alias dcm='docker-compose'

# linux
alias osstats='cat /etc/redhat-release /proc/version /proc/cpuinfo /proc/meminfo && df -h'

# local IP address 確認
alias localips="ifconfig | grep -Eo 'inet (addr:)?([0-9]*\.){3}[0-9]*'"

# redis
alias rds='redis-server'
alias rdc='redis-cli'

# npm
alias nrbw='npm run build:watch'
alias wpbw='webpack --progress --colors --watch'

# tmux
alias txa='tmux a || tmux'

# tail
alias tlf='tail -F'

# heroku
alias hlt='heroku logs -t'

# nkf
alias nuo='nkf -Luw --overwrite'


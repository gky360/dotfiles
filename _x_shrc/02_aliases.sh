#!/bin/sh

# dotfiles
alias dotfiles="cd $DOTPATH"
alias srcrc="if [ -e ~/.${SHELL##*/}rc ]; then; source ~/.${SHELL##*/}rc; fi"

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
alias gbrcl="git branch --merged | grep -v '*' | xargs git branch -d"

# vagrant
alias vain='vagrant up && vagrant ssh'
alias vash='vagrant ssh'
alias vahl='vagrant halt'
alias vasus='vagrant suspend'
alias varein='vagrant reload && vagrant ssh'

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
alias tlf='tail -f'

# heroku
alias hlt='heroku logs -t'


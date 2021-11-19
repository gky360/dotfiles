#!/bin/sh

# basic
alias la='ls -la'
alias ll='ls -l'
alias lh='ls -lah'
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'
# sudo の後のコマンドでエイリアスを有効にする
alias sudo='sudo '

# dotfiles
alias dotfiles="cd $DOTPATH"
alias srcrc="if [ -e ~/.${SHELL##*/}rc ]; then . ~/.${SHELL##*/}rc; fi"

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
## log
alias gl="git log"
## log graph
alias ggr="git gr"
## status and log graph
alias gsr="gst && echo && ggr"
## clear unused branches
alias gbrcl="git branch --merged | grep -v '*' | xargs git branch -d"
## reset modes of the files
alias gprst="git diff --numstat | awk '{if ((\$1 == \"0\" && \$2 == \"0\") || (\$1 == \"-\" && \$2 == \"-\")) print \$3}' | xargs git checkout HEAD"
## word-by-word diff
alias gdfw="git dfw"
alias gdfwca="git dfwca"
alias gshw="git shw"
## push
alias gpo="git push -u origin"
## ghq list
alias glp='cd $(ghq root)/$(ghq list | peco)'
## hub browse
alias gb='hub browse $(ghq list | peco | cut -d "/" -f 2,3)'

# grep
alias grep='grep --color=auto'

# vagrant
alias vain='vagrant up && vagrant ssh'
alias vash='vagrant ssh'
alias vahl='vagrant halt'
alias vasus='vagrant suspend'
alias varein='vagrant reload && vagrant ssh'
alias vast='vagrant status'

# docker
alias dcm='docker-compose'
alias dcmr='docker-compose run --rm'

# dstat
alias dstata='dstat -tlcmgdr --socket --tcp -n'

# linux
alias osstats='cat /etc/redhat-release /proc/version /proc/cpuinfo /proc/meminfo && echo "\n=====\n" && lscpu && echo "\n=====\n" && df -h'

# network
alias localips="ip addr | grep -Eo 'inet (addr:)?([0-9]*\.){3}[0-9]*'"
alias globalip="curl inet-ip.info"

# redis
alias rds='redis-server'
alias rdc='redis-cli'

# npm
alias nrbw='npm run build:watch --fix'
alias wpbw='$(npm bin)/webpack --progress --colors --watch'

# tail
alias tlf='tail -F'

# ssh
alias scpf='scp -F ~/.ssh/config'

# heroku
alias hlt='heroku logs -t'

# python
alias jnb='jupyter notebook'
alias pyex='PYTHONPATH=. python'
alias pri='poetry run invoke'

# terraform
alias tf="terraform"
alias tfp="terraform plan"
alias tfv="terraform validate"
alias tff="terraform fmt -recursive"

# kubernetes
alias kgponame="kgpo -o go-template --template '{{(index .items 0).metadata.name}}'"
alias kgponamel="kgpo -o go-template --template '{{(index .items 0).metadata.name}}' -l"

# completion
alias watch='watch '

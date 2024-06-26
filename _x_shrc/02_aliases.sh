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

# ruby, rails
alias be='bundle exec'

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
alias gdf="git diff"
alias gdfca="git dfca"
alias gdfw="git dfw"
alias gdfwca="git dfwca"
alias gsh="git show"
alias gshw="git shw"
## push
alias gpo="git push -u origin"
## copy current branch
alias cpgbr="git rev-parse --abbrev-ref HEAD | tr -d '\n' | pbcopy"
## ghq list
alias glp='cd $(ghq root)/$(ghq list | peco)'

# grep
alias grep='grep --color=auto'

# docker
alias dcm='docker compose'
alias dcmr='docker compose run --rm'

# dstat
alias dstata='dstat -tlcmgdr --socket --tcp -n'

# linux
alias osstats='cat /etc/redhat-release /proc/version /proc/cpuinfo /proc/meminfo && echo "\n=====\n" && lscpu && echo "\n=====\n" && df -h'

# network
alias localips="ip addr | grep -Eo 'inet (addr:)?([0-9]*\.){3}[0-9]*'"
alias globalip="curl inet-ip.info"

# tail
alias tlf='tail -F'

# python
alias jnb='jupyter notebook'
alias pyex='PYTHONPATH=. python'
alias pri='poetry run invoke'
alias prp='poetry run poe'

# terraform
alias tf="terraform"
alias tfi="terraform init"
alias tfp="terraform plan"
alias tfv="terraform validate"
alias tff="terraform fmt -recursive"
alias tg="terragrunt"
alias tgi="terragrunt init"
alias tgp="terragrunt plan"

# kubernetes
alias kgponame="kgpo -o go-template --template '{{(index .items 0).metadata.name}}'"
alias kgponamel="kgpo -o go-template --template '{{(index .items 0).metadata.name}}' -l"

# completion
alias watch='watch '

# aws
alias awsme='aws sts get-caller-identity'

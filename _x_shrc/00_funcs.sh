#!/bin/sh

function command_exists () {
  command -v "$1" >/dev/null 2>&1 ;
}

## tmux attach
function txa() {
  session_name=${1:-$(basename "$PWD" | cut -d. -f1)}
  tmux -u new-session -A -s $session_name
}

## hash base64 encode
function md5base64() {
  echo -n $1 | openssl dgst -md5 -binary | openssl enc -base64
}

function sha256base64() {
  echo -n $1 | openssl dgst -sha256 -binary | openssl enc -base64
}

## random string
function gen_random() {
  openssl rand -base64 24 | tr -d '\n'
}

# kubectl completion<
if command_exists 'autoload' ; then
  autoload -U +X bashcompinit && bashcompinit
  autoload -U +X compinit && compinit -u
fi
# if [ $commands[kubectl] ]; then source <(kubectl completion zsh 2>/dev/null); fi
# complete -F __start_kubectl k

# Incremental search for git branches
gcop() {
  git branch -a --sort=-authordate |
    grep -v -e '->' -e '*' |
    perl -pe 's/^\h+//g' |
    perl -pe 's#^remotes/origin/##' |
    perl -nle 'print if !$c{$_}++' |
    peco |
    xargs git checkout
}

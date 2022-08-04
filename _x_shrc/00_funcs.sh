#!/bin/sh

function command_exists () {
  command -v "$1" >/dev/null 2>&1 ;
}


# git

## side-by-side diff
function gdf() {
  if [[ -x `which ydiff 2>/dev/null` ]]; then
    git diff $@ | ydiff -s -w 0
  else
    git diff $@
  fi
}

## side-by-side diff --cached
function gdfca() {
  if [[ -x `which ydiff 2>/dev/null` ]]; then
    git diff --cached $@ | ydiff -s -w 0
  else
    git diff --cached $@
  fi
}

## side-by-side show
function gsh() {
  if [[ -x `which ydiff 2>/dev/null` ]]; then
    git show $@ | ydiff -s
  else
    git show $@
  fi
}

## tmux attach
function txa() {
  session_name=${1:-${${PWD##*/}%.*}}
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

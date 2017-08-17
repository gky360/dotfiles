#!/bin/sh

function command_exists () {
  command -v "$1" >/dev/null 2>&1 ;
}


# c++

## g++ -Wall -std=c++!4 -o
function gpwo() {
  set -x
  g++ -Wall -std=c++14 -o ${1%.cpp}.out ${@:2} ${1%.cpp}.cpp
}


# git

## side-by-side diff
# alias gdf='if [[ -x `which cdiff 2>/dev/null` ]]; then; git diff $@ | cdiff -s; else; git diff $@; fi'
function gdf() {
  if [[ -x `which cdiff 2>/dev/null` ]]; then
    git diff $@ | cdiff -s
  else
    git diff $@
  fi
}

## side-by-side diff --cached
function gdfca() {
  if [[ -x `which cdiff 2>/dev/null` ]]; then
    git diff --cached $@ | cdiff -s
  else
    git diff --cached $@
  fi
}

## side-by-side show
function gsh() {
  if [[ -x `which cdiff 2>/dev/null` ]]; then
    git show $@ | cdiff -s
  else
    git show $@
  fi
}




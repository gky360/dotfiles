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
    git diff $@ | cdiff -s -w 0
  else
    git diff $@
  fi
}

## side-by-side diff --cached
function gdfca() {
  if [[ -x `which cdiff 2>/dev/null` ]]; then
    git diff --cached $@ | cdiff -s -w 0
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

## tmux attach
function txa() {
  session_name=${1:-${${PWD##*/}%.*}}
  tmux new-session -A -s $session_name
}

## convert md to pdf using pandoc
function md2pdf() {
  if ! [ -e ~/.pandoc/templates/eisvogel.latex ]; then
    mkdir -p ~/.pandoc/templates/
    curl -o ~/.pandoc/templates/eisvogel.latex\
      https://raw.githubusercontent.com/Wandmalfarbe/pandoc-latex-template/master/eisvogel.tex
  fi
  basename=${1//.md}
  pandoc -f markdown_github ${basename}.md -o ${basename}.pdf\
    --from markdown --template eisvogel --listings --latex-engine=xelatex\
    -V CJKmainfont=Hiragino\ Kaku\ Gothic\ Pro -V lang=en-US\
    --metadata date="`date +%Y-%m-%d`"
}


#!/bin/sh

function command_exists () {
  command -v "$1" >/dev/null 2>&1 ;
}

function gpwo() {
  set -x
  g++ -Wall -std=c++14 -o ${1%.cpp}.out ${@:2} ${1%.cpp}.cpp
}



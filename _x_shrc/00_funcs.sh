#!/bin/sh

function command_exists () {
    command -v "$1" >/dev/null 2>&1 ;
}

function gpwo() {
    g++ -Wall $1 -o ${1%.*}
}



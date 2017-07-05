#!/bin/sh

function command_exists () {
    command -v "$1" >/dev/null 2>&1 ;
}

function gpwo() {
    g++ -Wall -std=c++14 ${1%.cpp}.cpp -o ${1%.cpp}.out
}



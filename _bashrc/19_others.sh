#!/bin/sh

declare -A prompt_colors=(
  ["black"]="30"
  ["red"]="31"
  ["green"]="32"
  ["yellow"]="33"
  ["blue"]="34"
  ["magenta"]="35"
  ["cyan"]="36"
  ["white"]="37"
)

PS1="\[\033[01;${prompt_colors[$prompt_color]}m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ "

#!/bin/sh

PROMPT_COMMAND=__prompt_command

__prompt_command() {
  local EXIT="$?"

  declare -A colors=(
    ["black"]="\[\e[01;30m\]"
    ["red"]="\[\e[01;31m\]"
    ["green"]="\[\e[01;32m\]"
    ["yellow"]="\[\e[01;33m\]"
    ["blue"]="\[\e[01;34m\]"
    ["magenta"]="\[\e[01;35m\]"
    ["cyan"]="\[\e[01;36m\]"
    ["white"]="\[\e[01;37m\]"
  )
  reset_color="\[\e[m\]"

  PS1="${colors[$prompt_color]}\u@\h${reset_color}:${colors['blue']}\w${reset_color}\n"

  if [ $EXIT != 0 ]; then
    PS1+="${colors['red']}\$${reset_color} "
  else
    PS1+="\$ "
  fi
}

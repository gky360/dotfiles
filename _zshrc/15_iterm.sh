#!/bin/bash

if [[ $OSTYPE != darwin* ]]; then
  # exit if not in macOS
  return
fi

# iTerm2 window/tab color commands
#   Requires iTerm2 >= Build 1.0.0.20110804
#   http://code.google.com/p/iterm2/wiki/ProprietaryEscapeCodes
tab-color-rgb() {
echo -ne "\033]6;1;bg;red;brightness;$1\a"
echo -ne "\033]6;1;bg;green;brightness;$2\a"
echo -ne "\033]6;1;bg;blue;brightness;$3\a"
}
tab-color-reset() {
echo -ne "\033]6;1;bg;*;default\a"
}
tab-color() {
case $1 in
  black)
    tab-color-rgb 0 0 0
    ;;
  red)
    tab-color-rgb 170 51 51
    ;;
  green)
    tab-color-rgb 51 170 51
    ;;
  yellow)
    tab-color-rgb 170 170 51
    ;;
  blue)
    tab-color-rgb 51 51 170
    ;;
  magenta)
    tab-color-rgb 170 51 170
    ;;
  cyan)
    tab-color-rgb 51 170 170
    ;;
  white)
    tab-color-reset
    ;;
  *)
    echo invalid color name >&2
    ;;
  esac

}

# Change the color of the tab when using SSH
# reset the color after the connection closes
color-ssh() {
if [[ -n "$ITERM_SESSION_ID" ]]; then
  trap "tab-color-reset" INT EXIT
  tab-color ${zshrc_prompt_color:-'white'}
fi
ssh $*
}
compdef _ssh color-ssh=ssh

alias ssh='color-ssh '

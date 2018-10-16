#!/bin/bash

if [[ $OSTYPE != darwin* ]]; then
  # exit if not in macOS
  return
fi

# iTerm2 window/tab color commands
#   Requires iTerm2 >= Build 1.0.0.20110804
#   http://code.google.com/p/iterm2/wiki/ProprietaryEscapeCodes
tab_color_rgb() {
  echo -ne "\033]6;1;bg;red;brightness;$1\a"
  echo -ne "\033]6;1;bg;green;brightness;$2\a"
  echo -ne "\033]6;1;bg;blue;brightness;$3\a"
}
tab_color_reset() {
  echo -ne "\033]6;1;bg;*;default\a"
}
tab_color() {
  case $1 in
    black)
      tab_color_rgb 0 0 0
      ;;
    red)
      tab_color_rgb 170 51 51
      ;;
    green)
      tab_color_rgb 51 170 51
      ;;
    yellow)
      tab_color_rgb 170 170 51
      ;;
    blue)
      tab_color_rgb 51 51 170
      ;;
    magenta)
      tab_color_rgb 170 51 170
      ;;
    cyan)
      tab_color_rgb 51 170 170
      ;;
    white)
      tab_color_reset
      ;;
    *)
      echo invalid color name >&2
      ;;
  esac
}

tab_title() {
  echo -ne "\033]0;$1\007"
}
tab_title ""

# Change the color of the tab when using SSH
# reset the color after the connection closes
finish_ssh() {
  tab_color_reset
  tab_title ""
}
color_ssh() {
  if [[ -n "$ITERM_SESSION_ID" ]]; then
    trap "finish_ssh" INT EXIT
    tab_color ${theme_color:-'white'}
  fi
  \ssh $*
}
compdef _ssh color_ssh=ssh

alias ssh='color_ssh '

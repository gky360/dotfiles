#!/bin/bash

set -e

DOTPATH="$HOME/dotfiles"
export DOTPATH

cd $DOTPATH


select_theme_color () {
  if [ ! $theme_color ] ; then
    export theme_color='green'
  fi
  echo "Select theme color from below. Default is '$theme_color'."
  echo "  [black, red, green, yellow, blue, magenta, cyan, white]"
  /bin/echo -n "theme color > "
  read tmp_theme_color
  if [ $tmp_theme_color ] ; then
    export theme_color=$tmp_theme_color
  fi
  echo "theme_color = $theme_color"
}


echo
for before_deploy_sh in $DOTPATH/before_deploy/*.sh; do
  echo "loading $before_deploy_sh ..."
  . $before_deploy_sh
done


echo
for dotfile in .??*; do
  [ "$dotfile" = ".git" ] && continue
  [ "$dotfile" = ".gitignore" ] && continue
  [ "$dotfile" = ".gitattributes" ] && continue
  [ "$dotfile" = ".DS_Store" ] && continue
  [ ${dotfile##*.} = "swp" ] && continue

  echo
  if [ -e "$HOME"/"$dotfile" ]; then
    read -p "overwrite ~/$dotfile ? (Yn) > " yn
    case $yn in
      [Nn]* )
        echo "skipping ..."
        continue
        ;;
    esac
    if [ -d "$DOTPATH"/"$dotfile" ]; then
      rm -rf "$HOME"/"$dotfile"
    fi
  fi

  echo "loading $dotfile ..."
  ln -snfv "$DOTPATH"/"$dotfile" "$HOME"

done

select_theme_color

echo
echo "loading .bashrc ..."
./_bashrc/deploy.sh

echo
echo "loading .zshrc ..."
./_zshrc/deploy.sh


echo
for after_deploy_sh in $DOTPATH/after_deploy/*.sh; do
  echo "loading $after_deploy_sh ..."
  . $after_deploy_sh
done


echo
echo "finished."


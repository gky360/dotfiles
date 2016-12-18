#!/bin/sh

set -e

DOTPATH="$HOME/dotfiles"
export DOTPATH

cd $DOTPATH

echo
for before_deploy_sh in $DOTPATH/before_deploy/*.sh; do
  echo "loading $before_deploy_sh ..."
  source $before_deploy_sh
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
  fi

  echo "loading $dotfile ..."
  ln -snfv "$DOTPATH"/"$dotfile" "$HOME"/"$dotfile"
done

echo
echo "loading .bashrc ..."
./_bashrc/deploy.sh

echo
echo "loading .zshrc ..."
./_zshrc/deploy.sh

echo
echo "finished."


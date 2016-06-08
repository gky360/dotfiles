#!/bin/sh

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
  echo "loading $dotfile ..."
  if [ -e "$HOME"/"$dotfile" ]; then
    /bin/echo -n "overwrite ~/$dotfile ? (yn) > "
    read yn
  else
    yn="y"
  fi
  if [ ${yn:-"no"} = "y" ]; then
    ln -snfv "$DOTPATH"/"$dotfile" "$HOME"/"$dotfile"
  fi
done

echo
echo "loading .zshrc ..."
./_zshrc/deploy.sh

echo
echo "finished."

echo
/bin/echo -n "restart $SHELL ? (yn) > "
read yn
if [ ${yn:-"no"} = "y" ]; then
  exec $SHELL -l
fi


#!/bin/sh

set -e

echo "deploying .bashrc ..."

cd $DOTPATH

if sed --version 2>/dev/null |grep -q GNU;then
  alias sedi='sed -i"" '
else
  alias sedi='sed -i "" '
fi

if ! [ -e "$HOME"/.bashrc ]; then
  touch "$HOME"/.bashrc
fi

sedi "/##### begin dotfiles #####/,/##### end dotfiles #####/c\\" "$HOME"/.bashrc


echo "##### begin dotfiles #####" >> "$HOME"/.bashrc

echo "export theme_color=$theme_color" >> "$HOME"/.bashrc
echo "export prompt_color=$theme_color" >> "$HOME"/.bashrc

_x_sh_shs=`ls $DOTPATH/_x_shrc/[0-9][0-9]_*.sh`
bash_shs=`ls $DOTPATH/_bashrc/[0-9][0-9]_*.sh`
shs="$_x_sh_shs $bash_shs"
for sh in $shs
do
  echo "loading $sh ..."
  echo ". $sh" >> "$HOME"/.bashrc
done

echo "##### end dotfiles #####" >> "$HOME"/.bashrc

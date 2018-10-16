#!/bin/sh

set -e

echo "deploying .zshrc ..."

cd $DOTPATH

if sed --version 2>/dev/null |grep -q GNU;then
  alias sedi='sed -i"" '
else
  alias sedi='sed -i "" '
fi

if ! [ -e "$HOME"/.zshrc ]; then
  touch "$HOME"/.zshrc
fi

sedi "/##### begin dotfiles #####/,/##### end dotfiles #####/c\\" "$HOME"/.zshrc


echo "##### begin dotfiles #####" >> "$HOME"/.zshrc

echo "export theme_color=$theme_color" >> "$HOME"/.zshrc
echo "export zshrc_prompt_color=$theme_color" >> "$HOME"/.zshrc

_x_sh_shs=`ls $DOTPATH/_x_shrc/[0-9][0-9]_*.sh`
zsh_shs=`ls $DOTPATH/_zshrc/[0-9][0-9]_*.sh`
shs="$_x_sh_shs $zsh_shs"
for sh in $shs
do
  echo "loading $sh ..."
  echo ". $sh" >> "$HOME"/.zshrc
done

echo "##### end dotfiles #####" >> "$HOME"/.zshrc

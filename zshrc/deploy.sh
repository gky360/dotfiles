#!/bin/sh

echo $DOTPATH

cd $DOTPATH

select_prompt_color () {
  echo "select prompt color from below."
  echo "  [black, red, green, yellow, blue, magenta, cyan, white]"
  /bin/echo -n "prompt color > "
  read zshrc_prompt_color
  if [ ! $zshrc_prompt_color ] ; then
    zshrc_prompt_color='green'
  fi
  echo "zshrc_prompt_color = $zshrc_prompt_color"
}

if sed --version 2>/dev/null |grep -q GNU;then
  alias sedi='sed -i"" '
else
  alias sedi='sed -i "" '
fi

sedi "/##### begin dotfiles #####/,/##### end dotfiles #####/c\\" "$HOME"/.zshrc


echo "##### begin dotfiles #####" >> "$HOME"/.zshrc

select_prompt_color
echo "zshrc_prompt_color=$zshrc_prompt_color" >> "$HOME"/.zshrc
echo "export zshrc_prompt_color" >> "$HOME"/.zshrc

shs=`ls $DOTPATH/zshrc/[0-9][0-9]_*.sh`
for sh in $shs
do
  echo "loading ${sh} ..."
  echo "source $sh" >> "$HOME"/.zshrc
done

echo "##### end dotfiles #####" >> "$HOME"/.zshrc

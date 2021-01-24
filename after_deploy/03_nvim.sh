#!/bin/sh

# link ~/.config/nvim/after -> ~/.vim/after
if [ -e ~/.config/nvim ]; then
  cd ~/.config/nvim
  ln -sf ~/.vim/after .
fi

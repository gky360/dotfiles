#!/bin/sh

# link ~/.config/nvim/after -> ~/.vim/after
cd ~/.config/nvim
ln -sf ~/.vim/after .

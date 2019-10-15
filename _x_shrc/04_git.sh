# set commit message editor
if command_exists "nvim"; then
  git config --global core.editor 'nvim'
elif command_exists "vim"; then
  git config --global core.editor 'vim'
fi

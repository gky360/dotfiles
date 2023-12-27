if command_exists "nvim"; then
  alias vim="nvim"
  git config --global core.editor nvim
  export EDITOR=nvim
fi

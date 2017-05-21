"
" Note: Skip initialization for vim-tiny or vim-small.
"
let g:dotpath = $DOTPATH
if 1
  execute 'source' g:dotpath.'/.vim/init.vim'
endif

if !exists('g:env')
  finish
endif

augroup filetypes
  autocmd!
  autocmd BufRead,BufNewFile .vimrc set filetype=vim
  autocmd BufRead,BufNewFile *.vim set filetype=vim
  autocmd BufRead,BufNewFile *.nas set filetype=nask
augroup END

filetype plugin indent on


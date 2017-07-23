if !exists('g:env')
  finish
endif

augroup filetypes
  autocmd!
  autocmd BufRead,BufNewFile .vimrc set filetype=vim
  autocmd BufRead,BufNewFile *.nas set filetype=nask
  autocmd BufRead,BufNewFile *.vim set filetype=vim
augroup END

filetype plugin indent on

let g:tex_flavor = 'tex'


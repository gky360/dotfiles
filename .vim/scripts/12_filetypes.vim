if !exists('g:env')
  finish
endif

augroup filetypes
  autocmd!
  autocmd BufRead,BufNewFile .vimrc set filetype=vim
  autocmd BufRead,BufNewFile *.nas set filetype=nask
  autocmd BufRead,BufNewFile *.vim set filetype=vim
  autocmd BufRead,BufNewFile *.jsx set filetype=javascript.jsx
  autocmd BufRead,BufNewFile *.tsx set filetype=typescript.jsx
augroup END

filetype plugin indent on

let g:tex_flavor = 'tex'


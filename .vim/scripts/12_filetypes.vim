if !exists('g:env')
  finish
endif

augroup filetypes
  autocmd!
  autocmd BufRead,BufNewFile .vimrc set filetype=vim
  autocmd BufRead,BufNewFile *.html.erb set filetype=eruby.html
  autocmd BufRead,BufNewFile *.jsx set filetype=javascript.jsx
  autocmd BufRead,BufNewFile *.nas set filetype=nask
  autocmd BufRead,BufNewFile *.tsx set filetype=typescript.jsx
  autocmd BufRead,BufNewFile *.vim set filetype=vim
augroup END

filetype plugin indent on

let g:tex_flavor = 'tex'


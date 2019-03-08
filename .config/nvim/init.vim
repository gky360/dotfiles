" Tiny vim
if 0 | endif

" Use plain vim
" when vim was invoked by 'sudo' command
" or, invoked as 'git difftool'
if exists('$SUDO_USER')
  finish
endif

if &compatible
  set nocompatible
endif

let g:false = 0
let g:true = 1

augroup MyAutoCmd
  autocmd!
augroup END

" Base functions "{{{1
function! Glob(from, pattern)
  return split(globpath(a:from, a:pattern), "[\r\n]")
endfunction
"}}}

let g:dotvim = '~/.vim'
for script in Glob(g:dotvim."/scripts", "*[0-9]*_*.vim")
  execute 'source' escape(script, ' ')
endfor

" Must be written at the last.  see :help 'secure'.
set secure

" __END__ {{{1
" vim:fdm=marker expandtab fdc=3:

if !exists('g:env')
  finish
endif

function! s:root() "{{{1
  let me = expand('%:p:h')
  let gitd = finddir('.git', me.';')
  if empty(gitd)
    echo "Not in git repo"
  else
    let gitp = fnamemodify(gitd, ':h')
    echo "Change directory to: ".gitp
    execute 'lcd' gitp
  endif
endfunction
command! Root call <SID>root()

" Restore cursor position {{{1
if g:env.vimrc.restore_cursor_position == g:true
  function! s:restore_cursor_postion()
    if line("'\"") > 0 && line("'\"") <= line("$")
      normal! g`"
      return 1
    endif
  endfunction
  augroup restore-cursor-position
    autocmd!
    autocmd BufWinEnter * call <SID>restore_cursor_postion()
  augroup END
endif

" __END__ {{{1
" vim:fdm=marker expandtab fdc=3:


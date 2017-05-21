if !exists('g:env')
    finish
endif


" Load dein. "{{{1

let s:base_path = expand('~/.cache/dein.vim')
let s:dein_path = s:base_path . '/repos/github.com/Shougo/dein.vim'

if !isdirectory(s:dein_path)
      execute '!git clone https://github.com/Shougo/dein.vim' s:dein_path
      endif
      execute 'set runtimepath^=' . substitute(fnamemodify(s:dein_path, ':p') , '/$', '', '')


" dein configurations. "{{{1

let g:dein#install_progress_type = 'title'
let g:dein#install_message_type = 'none'
let g:dein#enable_notification = 1
let g:dein#notification_icon = g:dotpath.'/.vim/signs/warn.png'

if !dein#load_state(s:base_path)
    finish
endif

let s:tomls = Glob(g:dotvim."/scripts/dein", "*[0-9]*_*.toml")
call dein#begin(s:base_path, [expand('<sfile>')] + s:tomls)
let s:lazy = 0
for toml in s:tomls
    call dein#load_toml(toml, {'lazy' : s:lazy})
    let s:lazy += 1
endfor

call dein#end()
call dein#save_state()

if dein#check_install()
    " Installation check.
    call dein#install()
endif

" __END__ {{{1
" vim:fdm=marker expandtab fdc=3:


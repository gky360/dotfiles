if !exists('g:env')
    finish
endif


" load dein. "{{{1

let g:dein_base_path = expand('~/.cache/dein.vim')
let g:plugins_path = g:dein_base_path . '/repos/github.com'
let s:dein_path = g:plugins_path . '/shougo/dein.vim'

if !isdirectory(s:dein_path)
      execute '!git clone https://github.com/shougo/dein.vim' s:dein_path
      endif
      execute 'set runtimepath^=' . substitute(fnamemodify(s:dein_path, ':p') , '/$', '', '')


" dein configurations. "{{{1

let g:dein#install_progress_type = 'title'
let g:dein#install_message_type = 'none'
let g:dein#enable_notification = 1
let g:dein#notification_icon = '~/.vim/signs/warn.png'

if !dein#load_state(g:dein_base_path)
    finish
endif

let s:toml_path = '~/.vim/scripts/dein/dein.toml'
let s:toml_lazy_path = '~/.vim/scripts/dein/dein_lazy.toml'

call dein#begin(g:dein_base_path, [expand('<sfile>'), s:toml_path, s:toml_lazy_path])

call dein#load_toml(s:toml_path, {'lazy': 0})
call dein#load_toml(s:toml_lazy_path, {'lazy': 1})

call dein#end()
call dein#save_state()

if dein#check_install()
    " Installation check.
    call dein#install()
endif

" __END__ {{{1
" vim:fdm=marker expandtab fdc=3:


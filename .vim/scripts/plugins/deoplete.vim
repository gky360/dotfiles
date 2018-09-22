" let g:deoplete#enable_at_startup = 1
let g:deoplete#enable_at_startup = 0
augroup load_us_ycm
  autocmd!
  autocmd InsertEnter * call deoplete#enable()
augroup END
let g:deoplete#auto_complete_start_length = 1

" from https://github.com/zchee/.nvim
let s:deoplete_custom_option = {
      \ 'ignore_case': g:true,
      \ 'ignore_sources': {
      \   '_': ['around', 'dictionary', 'omni', 'tag'],
      \   'cpp': ['around', 'dictionary', 'omni', 'tag', 'member'],
      \   'python': ['around', 'dictionary', 'omni', 'tag', 'member'],
      \ },
      \ 'num_processes': 6,
      \ }
call deoplete#custom#option(s:deoplete_custom_option)

set completeopt-=preview
set completeopt+=noinsert

" Disable conflicting keymaps
let g:lexima_no_default_rules = 1
call lexima#set_default_rules()
call lexima#insmode#map_hook('before', '<CR>', '')

" Recommended key-mappings.
" <CR>: close popup and save indent.
inoremap <silent> <CR> <C-r>=<SID>my_cr_function()<CR>
function! s:my_cr_function()
  " return (pumvisible() ? "\<C-y>" : "" ) . "\<CR>"
  " For no inserting <CR> key.
  "return pumvisible() ? "\<C-y>" : "\<CR>"
  return pumvisible() ? "\<C-e>\<CR>" : lexima#expand('<CR>', 'i')
endfunction
" <TAB>: completion.
inoremap <expr><TAB>  pumvisible() ? "\<C-y>" : "\<TAB>"

" <C-h>, <BS>: close popup and delete backword char.
inoremap <expr><C-h> deoplete#smart_close_popup()."\<C-h>"
" inoremap <expr><BS> deoplete#smart_close_popup()."\<C-h>"

inoremap <expr><C-g> deoplete#refresh()
" inoremap <expr><C-e> deoplete#cancel_popup()
inoremap <silent><expr><C-l> deoplete#complete_common_string()

" Enable omni completion
if !exists('g:deoplete#omni_patterns')
  let g:deoplete#omni_patterns = {}
endif

if !exists('g:deoplete#omni#input_patterns')
  let g:deoplete#omni#input_patterns = {}
endif

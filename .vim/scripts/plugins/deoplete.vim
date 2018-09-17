" Enable omni completion
if !exists('g:deoplete#omni_patterns')
  let g:deoplete#omni_patterns = {}
endif

if !exists('g:deoplete#omni#input_patterns')
  let g:deoplete#omni#input_patterns = {}
endif


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

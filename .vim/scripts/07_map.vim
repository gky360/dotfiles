if !exists('g:env')
  finish
endif

" Common {{{1

" Use backslash
if IsMac()
  noremap ¥ \
  noremap \ ¥
endif

" Define mapleader
let g:mapleader = "\<Space>"
let g:maplocalleader = "\<Space>"

" Smart space mapping
" Notice: when starting other <Space> mappings in noremap, disappeared [Space]
nmap  <Space>   [Space]
xmap  <Space>   [Space]
nnoremap  [Space]   <Nop>
xnoremap  [Space]   <Nop>
" key map ^,$ to <Space>h,l. Because ^ and $ is difficult to type and damage little finger!!!
noremap [Space]h ^
noremap [Space]l $

inoremap <C-h> <Backspace>
inoremap <C-d> <Delete>
cnoremap <C-k> <UP>
cnoremap <C-j> <DOWN>
cnoremap <C-l> <RIGHT>
cnoremap <C-h> <LEFT>
cnoremap <C-d> <DELETE>
cnoremap <C-p> <UP>
cnoremap <C-n> <DOWN>
cnoremap <C-f> <RIGHT>
cnoremap <C-b> <LEFT>
cnoremap <C-a> <HOME>
cnoremap <C-e> <END>
cnoremap <C-a> <Home>
cnoremap <C-e> <End>
cnoremap <C-b> <Left>
cnoremap <C-f> <Right>
cnoremap <C-d> <Del>
cnoremap <C-h> <BS>

inoremap <C-a> <Home>
inoremap <C-e> <End>
inoremap <C-h> <BS>
inoremap <C-d> <Del>
inoremap <C-f> <Right>
inoremap <C-b> <Left>
inoremap <C-p> <Up>
inoremap <C-n> <Down>
inoremap <C-m> <CR>

" Tabpages {{{1
" The prefix key.
nnoremap [Tag] <Nop>
nmap <leader>t [Tag]

" Jump to n-th tab
for n in range(1, 9)
  execute 'nnoremap <silent> [Tag]'.n ':<C-u>tabnext'.n.'<CR>'
endfor
" Create new tab at right
map <silent> [Tag]c :tablast <bar> Texplore<CR>
" Close tab
map <silent> [Tag]x :tabclose<CR>
" Move to next tab
map <silent> [Tag]l :tabnext<CR>
" Move to previous tab
map <silent> [Tag]h :tabprevious<CR>
" Move tab to right
map <silent> [Tag]ml :tabm +1<CR>
" Move tab to left
map <silent> [Tag]mh :tabm -1<CR>

let g:ale_fixers = {
      \  'cpp': ['clang-format'],
      \  'javascript': ['eslint'],
      \  'python': ['autopep8'],
      \}

" Set this setting in vimrc if you want to fix files automatically on save.
" This is off by default.
let g:ale_fix_on_save = 1

" Enable completion where available.
let g:ale_completion_enabled = 1

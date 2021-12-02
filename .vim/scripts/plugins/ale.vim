let g:ale_linters = {
      \  'cpp': ['cppcheck'],
      \  'go': ['golangci-lint'],
      \  'javascript': ['eslint', 'flow', 'flow-language-server', 'jscs', 'jshint', 'standard', 'xo'],
      \  'json': [],
      \}

let g:ale_fixers = {
      \  'c': ['clang-format'],
      \  'cpp': ['clang-format'],
      \  'css': ['stylelint'],
      \  'go': ['gofmt', 'goimports'],
      \  'javascript': ['prettier'],
      \  'json': ['prettier'],
      \  'scss': ['stylelint'],
      \  'typescript': ['eslint'],
      \  'php': ['phpcbf'],
      \  'python': ['autopep8'],
      \  'rust': ['rustfmt'],
      \}

" Set this setting in vimrc if you want to fix files automatically on save.
" This is off by default.
let g:ale_fix_on_save = 1

" Enable completion where available.
" let g:ale_completion_enabled = 1

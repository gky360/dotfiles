let g:user_emmet_install_global = 0

let g:user_emmet_settings = {
\  'javascript.jsx' : {
\      'extends' : 'jsx',
\  },
\  'typescript.jsx' : {
\      'extends' : 'jsx',
\  },
\}

let g:user_emmet_leader_key='<C-Z>'
autocmd FileType html,css,jsx,javascript.jsx,javascript,tsx,typescript.jsx,typescript,eruby,xhtml,php,twig EmmetInstall

if !exists('g:env')
  finish
endif

let g:vimtex_compiler_latexmk = {'callback' : 0}
let g:vimtex_compiler_latexmk['options'] = ["-cd",
      \ "-e", '''$latex = "platex -synctex=1 -src-specials -interaction=nonstopmode"''',
      \ "-e", '''$biber = "biber %O --bblencoding=utf8 -u -U --output_safechars %B"''',
      \ "-e", '''$bibtex = "pbibtex %O %B"''',
      \ "-e", '''$makeindex = "makeindex %O -o %D %S"''',
      \ "-e", '''$dvipdf = "dvipdfmx %O -o %D %S"''',
      \ "-e", '''$pdf_mode = "3"''',
      \ "-e", '''$pdf_update_method = "0"''',
      \ "-f", "-norc", "-gg", "-pdfdvi"]
      " \ "-e", "$pdf_previewer = 'open -a preview.app'",


let g:vimtex_latexmk_continuous = 1
let g:vimtex_latexmk_background = 1
" let g:vimtex_latexmk_options = '-pdf'
let g:vimtex_latexmk_options = '-pdfdvi'
" let g:vimtex_latexmk_options = '-pdfps'
" let g:vimtex_view_general_viewer = 'open'

" viewer
if IsMac()
  let g:vimtex_view_general_viewer = '/Applications/Skim.app/Contents/SharedSupport/displayline'
  let g:vimtex_view_general_options = '-r @line @pdf @tex'
  let g:vimtex_view_general_options_latexmk = '-r 1'
endif


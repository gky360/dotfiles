$latex = 'platex %O -synctex=1 %S';
$pdflatex = 'pdflatex -kanji=utf8 %O -synctex=1 %S';
$lualatex = 'lualatex -kanji=utf8 %O -synctex=1 %S';
$biber = 'biber %O --bblencoding=utf8 -u -U --output_safechars %B';
$bibtex = 'pbibtex %O %B';
$makeindex = 'upmendex %O -o %D %S';
$dvipdf = 'dvipdfmx %O -o %D %S';
$dvips = 'dvips %O -z -f %S | convbkmk -u > %D';
$ps2pdf = 'ps2pdf %O %S %D';
$pdf_mode = 3;
$pvc_view_file_via_temporary = 0;
$pdf_previewer = 'open -ga /Applications/Skim.app';

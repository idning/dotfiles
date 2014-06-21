
"Section
syn match   rstSections "^\%(\([=`:.'"~^_*+#-]\)\1\+\n\)\=.\+\n\([=`:.'"~^_*+#-]\)\2\+$"
hi def link rstSections                     Type

"Literal
syn region  rstLiteralBlock         matchgroup=rstDelimiter
      \ start='::\_s*\n\ze\z(\s\+\)' skip='^$' end='^\z1\@!'
      \ contains=@NoSpell

syn region  rstQuotedLiteralBlock   matchgroup=rstDelimiter
      \ start="::\_s*\n\ze\z([!\"#$%&'()*+,-./:;<=>?@[\]^_`{|}~]\)"
      \ end='^\z1\@!' contains=@NoSpell

hi def link rstLiteralBlock                 String
hi def link rstQuotedLiteralBlock           String

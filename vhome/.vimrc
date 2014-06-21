function! SetupDummy()  " {{{
endfunction "}}}
call SetupDummy()

function! SetupVundle()  " {{{
    set nocompatible              " be iMproved for vundle
    filetype off                  " required for vundle!

    source ~/.vim/vundle.vim

    filetype plugin indent on     " required for vundle!
    syntax on
endfunction "}}}
call SetupVundle()

function! SetupBasic()  " {{{
    " 1. search 
    set hlsearch
    set incsearch
    " set ignorecase
    set smartcase

    " 2. tab stop
    set tabstop=4
    set softtabstop=4
    set shiftwidth=4
    set expandtab

    " 3. encoding
    set encoding=utf8
    set fileencodings=utf8

    " 4. fold
    set foldlevelstart=20
    set foldmethod=syntax
    autocmd FileType python set foldmethod=indent
    autocmd FileType xml set foldmethod=indent
    autocmd FileType dia set foldmethod=indent
    autocmd FileType vim set foldmethod=marker
    autocmd FileType python set foldnestmax=3 "foldnestmax is useful "set foldlevel=1 is not correct
    autocmd BufRead,BufNewFile *.rl   set filetype=c

    let g:php_folding=2

    " 5. status line
    set laststatus=2      " 总是显示状态栏
    set statusline=%f%m%r%w\ %y\ \ \ \ 
    "set statusline=%<%f\ %h%m%r%{fugitive#statusline()}%=%-14.(%l,%c%V%)\ %P

    set statusline+=%=
    set statusline+=[line:%l/%L][col:%c][%3p%%]             "[line:499/677][col:74][ 73%]

endfunction "}}}
call SetupBasic()

function! SetupMisc()  " {{{
    let g:mapleader=','

    " Use the same symbols as TextMate for tabstops and EOLs
    " 可以用set list 看到.
    set listchars=tab:▸\ ,eol:¬

    "text wrap的时候, 显示这个标记
    set showbreak=◀

    " Title of the window
    set title
    set titlestring=%F\ %m

    "Set 5 lines to the cursor
    set scrolloff=2

    " Display a list of matches when using command-line completion
    set wildmenu
    set wildmode=full
    set wildignore=*.o,*.obj,*.pyc,*.pyo,*.swp,.sconsign.dblite
    set wildignore+=*/.git/*,*/.hg/*,*/.svn/*
    "better completion in cmd mode
    set wildmode=list:longest,full


    "au BufWinLeave * mkview 
    "au BufWinEnter * silent loadview
    " bellow code if form : http://vim.wikia.com/wiki/Make_views_automatic
    " which works find for me !!!
    "autocmd BufWinLeave * if expand("%") != "" | mkview | endif
    "autocmd BufWinEnter * if expand("%") != "" | loadview | endif
    autocmd FileType vim set keywordprg=:help

    " no backup
    set nobackup
    set backupdir=/tmp
    set noswapfile

    " use :set verbose=15,  you will see the log
    set verbosefile=~/vim.log 

    " allow backspacing over everything in insert mode
    set backspace=indent,eol,start

    set history=50		" keep 50 lines of command line history
    set ruler		" show the cursor position all the time 
    set showcmd		" display incomplete commands

    set lazyredraw

    "bn时不要求buffer 一定要写入
    set hidden

    "let g:winManagerWindowLayout = 'FileExplorer,TagsExplorer|BufExplorer'
    "nnoremap <silent> <F7> :WMToggle<cr>

    "
    "highlight current line
    :hi CursorLine   cterm=NONE ctermbg=darkred ctermfg=white guibg=darkred guifg=white
    set cursorline
    autocmd WinEnter * setlocal cursorline
    "autocmd WinLeave * setlocal nocursorline


    " 记住上次关闭的位置.
    " Only do this part when compiled with support for autocommands.
    if has("autocmd")
      " Enable file type detection.
      filetype plugin indent on

      " Put these in an autocmd group, so that we can delete them easily.
      augroup vimrcEx
      au!

      " For all text files set 'textwidth' to 78 characters.
      autocmd FileType text setlocal textwidth=78

      " When editing a file, always jump to the last known cursor position.
      autocmd BufReadPost *
        \ if line("'\"") > 1 && line("'\"") <= line("$") |
        \   exe "normal! g`\"" |
        \ endif

      augroup END

    else
      set autoindent		" always set autoindenting on
    endif " has("autocmd")

endfunction "}}}
call SetupMisc()

function! SetupCscope()  " {{{
    if has("cscope")
        "使用 quickfix 窗口来显示 cscope 结果:
        set cscopequickfix=s-,g-,c-,d-,i-,t-,e-
        set csto=0  "The value of 'csto' determines the order in which |:cstag| performs a search
        "set cst     " replaced all instances of the :tag command with :cstag.  includes :tag, Ctrl-], and "vim -t".
        set nocsverb "If 'cscopeverbose' is not set (the default), messages will not be printed indicating success or failure when adding a cscope database

        "尝试从多个地方加载cscope.out
        cs add ./cscope.out 
        cs add ../cscope.out  
        cs add ../../cscope.out  
        set csverb

        " 找到引用.
        map gs :cs find 0 <C-R>=expand("<cword>")<CR><CR>       
        " 找到定义, gd 为本文间内跳到定义. 'Goto local Declaration.'
        map gd :cs find 1 <C-R>=expand("<cword>")<CR><CR>       
    endif

endfunction "}}}
call SetupCscope()

function! SetupMisc2()  " {{{
    "voom conf
    let g:voom_tree_placement = 'left'
    "tagbar config
    let g:tagbar_left=1
    let g:tagbar_autofocus=1
    let g:tagbar_sort = 0

    " miniBufExpl
    "let g:miniBufExplMapCTabSwitchBufs = 1
    "let g:miniBufExplMapWindowNavVim = 1
    "let g:miniBufExplMapWindowNavArrows = 1
    let loaded_minibufexplorer = 1 "不再load. (关掉.)


    " Convenient command to see the difference between the current buffer and the
    " file it was loaded from, thus the changes you made.
    " Only define it when not defined already.
    if !exists(":DiffOrig")
      command DiffOrig vert new | set bt=nofile | r # | 0d_ | diffthis
              \ | wincmd p | diffthis
    endif

    nmap <leader>a= :Tabularize /=<CR>
    vmap <leader>a= :Tabularize /=<CR>
    nmap <leader>a: :Tabularize /:\zs<CR>
    vmap <leader>a: :Tabularize /:\zs<CR>


    " Always keep 20 lines above and below the cursor if possible
    " set scrolloff=20

    "winmanager:
    "let g:winManagerWindowLayout='FileExplorer|TagList'
    "
    let g:NERDTree_title='[NERD Tree]'
    let g:winManagerWindowLayout='NERDTree|TagList'
    let g:NERDTreeMapJumpNextSibling=''
    let g:NERDTreeMapJumpPrevSibling=''
    "let g:NERDTreeMapActivateNode='<space>'
    let g:NERDTreeMapCloseDir='<left>'
    autocmd Filetype nerdtree nmap <space> <Enter>

    let g:SuperTabRetainCompletionType=2
    "let g:SuperTabDefaultCompletionType="<C-X><C-O>"
    "let g:SuperTabDefaultCompletionType="<C-X><C-F>"
    let g:SuperTabDefaultCompletionType="<C-N>"

    let tlist_c_settings = 'c;f:Functions'
    let tlist_cpp_settings = 'c;f:Functions'
    let Tlist_Exit_OnlyWindow = 1
    let Tlist_Show_One_File = 1

    "show marks
    "现在已经不需要这个插件了.
    let g:showmarks_enable=0 
    "showmarks plugin to put a sign in the left margin for each mark; works poorly and interferes with other commands in Vim 7
    "   问题是, 在同一行下两个mark, 左边列不能更新. 代码比下一个好
    "script#2142 is another showmarks plugin which works without problems in Vim 7
    "   同有上面问题.
    "
    "<leader> ma for clear all marks
    "<leader> mt for close and open mark colume
    "
    let g:showmarks_hlline_lower = "1"
    let showmarks_include = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"
    let g:showmarks_textlower=">"

    let g:snips_author = 'ning'

    let g:vimwiki_CJK_length=2
    let g:multiedit_nomappings=1

    "riv config disable rstFileLink hightlight
    let g:riv_file_link_style=0
    let g:riv_file_ext_link_hl=0

endfunction "}}}
call SetupMisc2()

function! SetupVimrcPrj()  " {{{
    if filereadable("../../.vimrc.prj")                                         
        source ../../.vimrc.prj
    endif
    if filereadable("../.vimrc.prj")                                         
        source ../.vimrc.prj
    endif
    if filereadable("./.vimrc.prj")                                         
        source ./.vimrc.prj
    endif
    "if filereadable("./.vimrc")                                         
    "    source ./.vimrc
    "endif
endfunction "}}}
call SetupVimrcPrj()

function! SetupMaps()  " {{{
    " quickfix always has linke number
    autocmd QuickFixCmdPost * :set nu

    "js-beautify
    "
    command! JSbeautify :%!js-beautify -
    nmap <leader>ff :%!js-beautify -j -<CR>

    ":map <C-o> :vertical wincmd f<CR>
    nmap gf :e! <cfile><CR>

    " move faster.
    map <C-K> 5k
    map <C-J> 5j

    " Ctrl-a selects everything
    " map <C-a> ggVG

    " Select the stuff I just pasted
    nmap gV `[v`]
    nnoremap / /\v

    nnoremap <C-d> :qa<CR>
    "
    "自己映射ctrl+Left, 移动窗口光标
    noremap <C-Down>  <C-W>j
    noremap <C-Up>    <C-W>k
    noremap <C-Left>  <C-W>h
    noremap <C-Right> <C-W>l

    " this has no effect in terminal
    imap <C-BS> <C-w>   
    imap <A-BS> <C-w>   
    imap <C-Del> <C-w>

    "better shift
    vmap <tab> >gv
    vmap <s-tab> <gv

    " 方便移动行, 这个与自己C-Up在窗口间移动冲突了, 所以不用, 只用vmap
    "nmap <C-Up> ddkP
    "nmap <C-Down> ddp
    " 方便移动块(有用  在文件尾的时候有问题)
    vmap <C-Up> xkP`[V`]
    vmap <C-Down> xp`[V`]

    nnoremap <Space> za

    " tab switch 
    nnoremap <S-tab>   :tabnext<CR>
    " only in gvim 
    nnoremap <C-S-tab> :tabprevious<CR>
    nnoremap <C-tab>   :tabnext<CR>
    inoremap <C-S-tab> <Esc>:tabprevious<CR>i
    inoremap <C-tab>   <Esc>:tabnext<CR>i

    " switch tabs
    " this will not work in console, and gvim...
    map <S-1> 1gt
    map <C-2> 2gt
    map <C-3> 3gt
    map <C-4> 4gt
    map <C-5> 5gt
    map <C-6> 6gt
    map <C-7> 7gt
    map <C-8> 8gt
    map <C-9> 9gt
    map <C-0> :tablast<CR>

    " NERD Commenter. 
    nmap <silent>cc ,c<space> 

    " Open vimgrep and put the cursor in the right position
    " I have ack, this is not very useful
    map <leader>g :vimgrep // **/*.<left><left><left><left><left><left><left>

    let g:manpageview_K_http='curl'

    " in CommandLine expand the directory of the current file by pressing %%. A top tip from Max Cantor!
    cnoremap %% <C-R>=fnameescape(expand('%:h')).'/'<cr>

    "需要用root 身份保存时 W!即可.
    command! -bang W :w !sudo tee %
    "Make :Q! have the same functionality as :q! in vim
    command! -bang Q quit<bang>

    " easy adjust window size
    :map - 5<C-W><
    :map + 5<C-W>>
    "map Alt  is difficult
    ":map <M-+> <C-W>+
    ":map <M--> <C-W>-

    " ctrl+n for quickfix next item
    nmap <C-n> :cn<CR>

    " Don't use Ex mode, use Q for formatting, 这到底是什么?
    map Q gq
    " CTRL-U in insert mode deletes a lot.  Use CTRL-G u to first break undo,
    " so that you can undo CTRL-U after inserting a line break.
    " 不懂..
    inoremap <C-U> <C-G>u<C-U>

    " for rst, fast Bold
    " 结果决定用下面这个, C-B 加一次星号，再按一次在加重.
    " 用' **' 和 '** ' 包围, 应该智能的有空格就不再加空格了. 用surround搞不定,
    " 所以用了个插件
    "autocmd FileType rst vmap <silent> <C-b> s*gvs*gvs g
    "autocmd FileType rst vmap <silent> <C-c> s`gvs`gvs g
    "autocmd FileType rst vmap <silent> <C-n> s`gv

    autocmd FileType rst vnoremap <silent> <C-b> :call RstBold('**')<CR>
    autocmd FileType rst vnoremap <silent> <C-c> :call RstBold('``')<CR>

    command! -nargs=1 Ack2 Ack --type-add rst=.rst --type-add md=.md --type=rst --type=md <args>
    command! -nargs=0 Rrc source ~/.vimrc

endfunction "}}}
call SetupMaps()

function! SetupFX()  " {{{

    " F2 for copy/paster 去掉行号，mark等
    map <F2> :set nonu<cr>:ShowMarksOff<cr>:set paste<cr>o
    map `<F2> :set nu<cr>:ShowMarksOn<cr>:set nopaste<cr>
    if has("gui_running")
        map `<F2> :set nu<cr>:ShowMarksOn<cr>:set nopaste<cr>:IndentGuidesToggle<cr>
    endif

    " F3 for Ack current word in current dir
    nnoremap <silent> <F3> :Ack <cword> <CR>

    " F5 for reload 
    map <F5> :e!<CR>
    autocmd FileType c map <F5> :!cscope -Rbq<CR>:cs reset<CR><CR>:!ctags -R<CR><CR>
    " F5 for insert time in insert mode
    inoremap <F5> <C-R>=strftime("%F %T")<CR>

    " F6
    map <F6> "+y<cr>
    vnoremap <C-c> "+y

    " F7 for NCRETree ,好像和minBufExpl冲突
    nnoremap <silent> <F7> :NERDTreeToggle<cr>

    " F8 for outline
    nmap <F8> :TagbarToggle<CR>
    autocmd FileType python map <buffer> <F8> :Voom python<CR>
    autocmd FileType mkd    map <buffer> <F8> :Voom markdown<CR>
    autocmd FileType org    map <buffer> <F8> :Voom org<CR>
    autocmd FileType rst    map <buffer> <F8> :Voom rest<CR>
    autocmd FileType wiki   map <buffer> <F8> :Voom wiki<CR>
    "autocmd FileType c map <F8> :TlistToggle<CR>
    
    " F9 for make
    nnoremap <silent> <F9> :make<CR><CR>:ccl<CR>:cw<CR>:set nu<CR>:/error: <CR>
    autocmd FileType rst map <F9> :make<CR><CR><CR>

    " F10 for debug vim syntax
    nmap <F10> :echo "hi<" . synIDattr(synID(line("."),col("."),1),"name") . '> trans<'
                \ . synIDattr(synID(line("."),col("."),0),"name") . "> lo<"
                \ . synIDattr(synIDtrans(synID(line("."),col("."),1)),"name") . ">"<CR>

endfunction "}}}
call SetupFX()

function! SetupStartStop()  " {{{
    " Visual mode pressing * or # searches for the current selection
    " Super useful! From an idea by Michael Naumann
    "vnoremap <silent> * :call UtilVisualSelection('f')<CR>
    "vnoremap <silent> # :call UtilVisualSelection('b')<CR>

    " Delete trailing white space on save, useful for Python and CoffeeScript ;)

   autocmd BufWrite *.rst,*.py,*.cpp,*.h,*.c :call TrimSpaces()

    autocmd VimEnter *.rst :call Voom_Init('rest')
    autocmd VimEnter * wincmd p 
    "关闭主窗口的同时, 关闭Voom
    "
    if version >= 703
        autocmd QuitPre *.rst call OnQuitPre()                                                                          
    endif

endfunction "}}}
call SetupStartStop()

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""" utils

function! UtilVisualSelection(direction) range " {{{
    let l:saved_reg = @"
    execute "normal! vgvy"

    let l:pattern = escape(@", '\\/.*$^~[]')
    let l:pattern = substitute(l:pattern, "\n$", "", "")

    if a:direction == 'b'
        execute "normal ?" . l:pattern . "^M"
    elseif a:direction == 'gv'
        call CmdLine("vimgrep " . '/'. l:pattern . '/' . ' **/*.')
    elseif a:direction == 'replace'
        call CmdLine("%s" . '/'. l:pattern . '/')
    elseif a:direction == 'f'
        execute "normal /" . l:pattern . "^M"
    endif

    let @/ = l:pattern
    let @" = l:saved_reg
endfunction " }}}
" From http://got-ravings.blogspot.com/2008/07/vim-pr0n-visual-search-mappings.html

"UtilVisualSelection 可以用下面函数替代, 更简单, 效果更好::
"From: http://vimcasts.org/episodes/search-for-the-selected-text/

" makes * and # work on visual mode too.
function! s:VSetSearch(cmdtype)
  let temp = @s
  norm! gv"sy
  let @/ = '\V' . substitute(escape(@s, a:cmdtype.'\'), '\n', '\\n', 'g')
  let @s = temp
endfunction

xnoremap * :<C-u>call <SID>VSetSearch('/')<CR>/<C-R>=@/<CR><CR>
xnoremap # :<C-u>call <SID>VSetSearch('?')<CR>?<C-R>=@/<CR><CR>

" recursively vimgrep for word under cursor or selection if you hit leader-star
nnoremap <leader>* :execute 'noautocmd vimgrep /\V' . substitute(escape(expand("<cword>"), '\'), '\n', '\\n', 'g') . '/ **'<CR>
vnoremap <leader>* :<C-u>call <SID>VSetSearch('/')<CR>:execute 'noautocmd vimgrep /' . @/ . '/ **'<CR>

function! TrimSpaces() "{{{
  let save_cursor = getpos(".")
  silent! %s/\s\+$//e
  call setpos('.', save_cursor)
endfunction "}}}

function! OnQuitPre() " {{{ 
    exe "lclose"
    exe "cclose"

    if exists(":Voomquit")
        exe "Voomquit"
    endif
endfunction "}}}

function! Hint()  " {{{
    " hints
    ":bufdo %s/pattern/replace/ge | update
    ":windo %s/pattern/replace/ge | update

    "fold keys hint:
    "zr
    "zm 
    "
    " Treat long lines as break lines (useful when moving around in them)
    " 不需要, 不过知道这个技巧不错
    " map j gj
    " map k gk

    " TO Practice:
    " Tabularize
    " gv, gV
    " riv, 用=格式化list, 自动编号.
    " jump to last modify position: ``g;``
    " g+, g-
endfunction "}}}

"256 color 把中文输入框的颜色弄得很难看.
"set t_Co=256



command! -nargs=0 -bar Qargs execute 'args' QuickfixFilenames()
function! QuickfixFilenames()
  " Building a hash ensures we get each buffer only once
  let buffer_numbers = {}
  for quickfix_item in getqflist()
    let buffer_numbers[quickfix_item['bufnr']] = bufname(quickfix_item['bufnr'])
  endfor
  return join(map(values(buffer_numbers), 'fnameescape(v:val)'))

endfunction

"存在溢出的问题.
nnoremap Q 0yt=A<C-r>=<C-r>"<CR><Esc>
vnoremap Q yA<C-r>=<C-r>"<CR><Esc>

"**有用**, 但是会破坏我的ctrl+c, ctrl+b, 我修改了rst_bold_it, 换了一个寄存器,
set clipboard=unnamed,unnamedplus
"set clipboard=
"还有一个问题是: x删一个字符, 也会修改系统剪切板, 这就不好了, 试试下面这样,
"只把x作为特殊的不隐射:
"
""NOT GOOD 
"nnoremap y "+y
"vnoremap y "+y
"nnoremap d "+d
"vnoremap d "+d
""nnoremap x "+x         "这样问题是, 用xp交换两个字符就不能用了..
"vnoremap x "+x
"nnoremap p "+p
"vnoremap p "+p
"nnoremap P "+P
"vnoremap P "+P


"nnoremap C "+C

"for tmux
if &term =~ '^screen'
    " tmux will send xterm-style keys when xterm-keys is on
    execute "set <xUp>=\e[1;*A"
    execute "set <xDown>=\e[1;*B"
    execute "set <xRight>=\e[1;*C"
    execute "set <xLeft>=\e[1;*D"
endif


"for scala-taglist
"let tlist_scala_settings='scala;c:Classes;t:Traits;o:Objects;m:Methods;C:Constants;l:Local variables;T:Types'
let tlist_scala_settings='scala;c:Classes;t:Traits;o:Objects;m:Methods;T:Types'
autocmd FileType scala map <buffer> <F8> :Tlist<CR>

"Change Fugitive's Gstatus window height
setlocal previewheight=30


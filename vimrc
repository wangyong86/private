" ========================== BEGIN settingn for Vundle
set nocompatible

" backspace delete char
set backspace=indent,eol,start

" disable auto indent and filetype related plugin
filetype off

if has('python3')
endif

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
" alternatively, pass a path where Vundle should install plugins
"call vundle#begin('~/some/path/here')

" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'

" eye pleasant color scheme: 
Plugin 'morhetz/gruvbox'

" detailed intro: https://www.jianshu.com/p/27d7fbd6cdc6
Plugin 'Valloric/YouCompleteMe'

" The following are examples of different formats supported.
" Keep Plugin commands between vundle#begin/end.
" plugin on GitHub repo
Plugin 'tpope/vim-fugitive'

" plugin from http://vim-scripts.org/vim/scripts.html
" Plugin 'L9'
" Git plugin not hosted on GitHub
Plugin 'git://git.wincent.com/command-t.git'

" git repos on your local machine (i.e. when working on your own plugin)
" Plugin 'file:///home/gmarik/path/to/plugin'
" The sparkup vim script is in a subdirectory of this repo called vim.
" Pass the path to set the runtimepath properly.

Plugin 'rstacruz/sparkup', {'rtp': 'vim/'}
" Install L9 and avoid a Naming conflict if you've already installed a
" different version somewhere else.
" Plugin 'ascenator/L9', {'name': 'newL9'}

Plugin 'masukomi/vim-markdown-folding', { 'for': 'markdown' }

Plugin 'godlygeek/tabular'
Plugin 'preservim/vim-markdown'

" All of your Plugins must be added before the following line
call vundle#end()            " required

filetype plugin indent on    " required
" To ignore plugin indent changes, instead use:
"filetype plugin on
"
" Brief help
" :PluginList       - lists configured plugins
" :PluginInstall    - installs plugins; append `!` to update or just :PluginUpdate
" :PluginSearch foo - searches for foo; append `!` to refresh local cache
" :PluginClean      - confirms removal of unused plugins; append `!` to auto-approve removal
"
" see :h vundle for more details or wiki for FAQ
" Put your non-Plugin stuff after this line
" ========================== END settingn for Vundle

" detailed:https://github.com/morhetz/gruvbox/wiki/
autocmd vimenter * ++nested colorscheme gruvbox

set number

" shift width, tab stop width
set ts=4 sw=4
set et

"set noet

" auto indent using 4 spaces
set autoindent
set cindent

" line width and no wrap
set cc=80
"set nowrap

" align at (
set cino=(0

" auto detect filetype, for taglsit etc.
filetype on

" highlight synatx
syntax on

" highlight current line
set cursorline

" don't add style automatically
set paste "unpaste

" !make, copen: open make result
" so $vimrcfile: reload specific vimrc; :so %; current editing vimrc

" dispaly row, col
set ruler

" bell
set noeb
set vb

" avoid blue comment hard to recognation during night
set t_Co=256 "
"colorscheme desert

" display invisible char
" :set invlist

" set foldmethod=indent and disable it by default
" set foldmethod=indent
set foldlevelstart=99

" search highlight
set hlsearch

" enable mouse
set mouse=a

" open/close taglsit using f1/esc"
let Tlist_Use_SingleClick=1 " enable mouse single click
let Tlist_Show_One_File=1   " only display current file
let Tlist_Ctags_Cmd="/usr/bin/ctags"
let Tlist_GainFocus_On_ToggleOpen=1  " focus on tlist win
let Tlist_File_Fold_Auto_Close=1 " fold tags of other files
let Tlist_Use_Right_Window=1   " location
let Tlist_Exit_OnlyWindow=1 " exit if last
let Tlist_WinWidth=40

map <C-p> <Esc>:TlistToggle<Cr>

"cctree and default hotkey, Ref: https://sites.google.com/site/vimcctree/faq
autocmd vimenter * if filereadable('/home/wy/matrixdb/cscope.out') | CCTreeLoadDB /home/wy/matrixdb/cscope.out | endif
"   g:CCTreeKeyTraceForwardTree = '<C-\>>'
"   g:CCTreeKeyTraceReverseTree = '<C-\><'
"   g:CCTreeKeyHilightTree = '<C-l>'
"   g:CCTreeKeySaveWindow = '<C-\>y'
"   g:CCTreeKeyToggleWindow = '<C-\>w
"   g:CCTreeKeyCompressTree = 'zs'
"   g:CCTreeKeyDepthPlus = '<C-\>='
"   g:CCTreeKeyDepthMinus = '<C-\>-'

"cscope
if has("cscope")
	set csto=1   " search tags first
	"set cst 	" use :cs find g, not :tag which is defalut
	set nocscopeverbose " not show cscope db add info
	if filereadable("./cscope.out")
		cs add ./cscope.out
    else
        if filereadable("/home/wy/matrixdb/cscope.out")
            cs add /home/wy/matrixdb/cscope.out
        endif
	endif
endif

" bind cscope key
"s: symbol; g: definition; c: caller; d: callee; t: pattern; d: callee;
"e: egrep; f: file; i: included
nmap <C-\>d :cs find d <C-R>=expand("<cword>")<CR><CR>
nmap <C-\>g :cs find g <C-R>=expand("<cword>")<CR><CR>
nmap <C-\>c :cs find c <C-R>=expand("<cword>")<CR><CR>
nmap <C-\>t :cs find t <C-R>=expand("<cword>")<CR><CR>
nmap <C-\>e :cs find e <C-R>=expand("<cword>")<CR><CR>
nmap <C-\>f :cs find f <C-R>=expand("<cword>")<CR><CR>
nmap <C-\>i :cs find i <C-R>=expand("<cword>")<CR><CR>
nmap <C-\>s :cs find s <C-R>=expand("<cword>")<CR><CR>

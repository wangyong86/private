" ========================== BEGIN settingn for Vundle
set nocompatible
filetype off

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
" alternatively, pass a path where Vundle should install plugins
"call vundle#begin('~/some/path/here')

" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'

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

set number

" shift width, tab stop width
set ts=4 sw=4

set noet

" auto indent using 4 spaces
set autoindent

" line width and no wrap
set cc=80
"set nowrap

" align at (
set cino=(0

" auto detect filetype, for taglsit etc.
filetype on

" highlight synatx
syntax on

" don't add style automatically
set paste

" dispaly row, col 
set ruler

" avoid blue comment hard to recognation during night
set t_Co=256 "
colorscheme darkblue

" set foldmethod=indent and disable it by default
set foldmethod=indent
set foldlevelstart=99

" search highlight
set hlsearch

if has("cscope")
	set csto=1   " search tags first
	"set cst 	" use :cs find g, not :tag which is defalut
	set nocscopeverbose " not show cscope db add info
	if filereadable("/home/wy/matrixdb/cscope.out")
    	cs add /home/wy/matrixdb/cscope.out
	endif
endif

" open/close taglsit using f1/esc"
map <C-p> <Esc>:TlistToggle<Cr>

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

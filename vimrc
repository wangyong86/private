" ========================== BEGIN settingn for Vundle
set nocompatible

" backspace delete char
set backspace=indent,eol,start

" disable auto indent and filetype related plugin
filetype off

if has('python3')
endif

" set the runtime path to include Vundle and initialize
" Vundle install: git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim

set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
" alternatively, pass a path where Vundle should install plugins
"call vundle#begin('~/some/path/here')

" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'

" recently opened file
Plugin 'jlanzarotta/bufexplorer'
" \<Leader\>be normal open: <leader> is \ defaultly
" \<Leader\>bt toggle open / close
" \<Leader\>bs force horizontal split open
" \<Leader\>bv force vertical split open

" eye pleasant color scheme:
Plugin 'morhetz/gruvbox'

" detailed intro: https://www.jianshu.com/p/27d7fbd6cdc6
" YCM installation is complex on older platform, disable for now
" Plugin 'Valloric/YouCompleteMe'

" The following are examples of different formats supported.
" Keep Plugin commands between vundle#begin/end.
" plugin on GitHub repo
Plugin 'tpope/vim-fugitive'

" plugin from http://vim-scripts.org/vim/scripts.html
" Plugin 'L9'
" Git plugin not hosted on GitHub
" Plugin 'git://git.wincent.com/command-t.git'

" git repos on your local machine (i.e. when working on your own plugin)
" Plugin 'file:///home/gmarik/path/to/plugin'
" The sparkup vim script is in a subdirectory of this repo called vim.
" Pass the path to set the runtimepath properly.

Plugin 'rstacruz/sparkup', {'rtp': 'vim/'}
" Install L9 and avoid a Naming conflict if you've already installed a
" different version somewhere else.
" Plugin 'ascenator/L9', {'name': 'newL9'}

Plugin 'masukomi/vim-markdown-folding', { 'for': 'markdown' }

Plugin 'vim-scripts/ShowTrailingWhitespace.git'

Plugin 'airblade/vim-gitgutter'

" Syntax highlight of markdown
Plugin 'godlygeek/tabular'
Plugin 'preservim/vim-markdown'

Plugin 'kien/ctrlp.vim'

" toggle :NERDTree
" :help NERDTree
Plugin 'preservim/nerdtree'

" realtime mardown, use together with browser, disable it
" Plugin 'kannokanno/previm'
" Plugin 'tyru/open-browser.vim'

" All of your Plugins must be added before the following line
call vundle#end()            " required

" download plug 
" curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
"    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
call plug#begin()

" Use release branch (recommended)
Plug 'neoclide/coc.nvim', {'branch': 'release'}

Plug 'gyim/vim-boxdraw'

" List your plugins here
Plug 'tpope/vim-sensible'

call plug#end()

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
" autocmd vimenter * ++nested colorscheme gruvbox
" We should use the upper cmdline, but for lower version of vim, just use:
colorscheme gruvbox

" Inside tmux, vim maybe set as bg=light, set as dark explicitly
set bg=dark

set number

" shift width, tab stop width
set ts=4 sw=4
" set et

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

" Install taglist
" 1) w3m https://www.vim.org/scripts/download_script.php?src_id=19574 #may changed
" 2) decompress in ~/.vim/

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

" ======================== ctrlp =====================
let g:ctrlp_map = '<C-l>'
let g:ctrlp_cmd = 'CtrlP'
map <leader>f :CtrlPMRU<CR>
let g:ctrlp_custom_ignore = {
    \ 'dir':  '\v[\/]\.(git|hg|svn|rvm)$',
    \ 'file': '\v\.(exe|so|dll|zip|tar|tar.gz|pyc)$',
    \ }
let g:ctrlp_working_path_mode=0
let g:ctrlp_match_window_bottom=1
let g:ctrlp_max_height=15
let g:ctrlp_match_window_reversed=0
let g:ctrlp_mruf_max=500
let g:ctrlp_follow_symlinks=1

" Press <F5> to purge the cache for the current directory to get new files, remove deleted files and apply new ignore options.
" Press <c-f> and <c-b> to cycle between modes.
" Press <c-d> to switch to filename only search instead of full path.
" Press <c-r> to switch to regexp mode.
" Use <c-j>, <c-k> or the arrow keys to navigate the result list.
" Use <c-t> or <c-v>, <c-x> to open the selected entry in a new tab or in a new split.
" Use <c-n>, <c-p> to select the next/previous string in the prompt's history.
" Use <c-y> to create a new file and its parent directories.
" Use <c-z> to mark/unmark multiple files and <c-o> to open them.
" ======================== ctrlp =====================

"cctree and default hotkey, Ref: https://sites.google.com/site/vimcctree/faq
"autocmd vimenter * if filereadable('/home/wy/matrixdb/cscope.out') | CCTreeLoadDB /home/wy/matrixdb/cscope.out | endif
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
    elseif filereadable("/home/wy/matrixdb/cscope.out")
		cs add /home/wy/matrixdb/cscope.out
    else
		if filereadable("/workspace/matrixdb/cscope.out")
			cs add /workspace/matrixdb/cscope.out
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

" Other useful index
" markdown syntax: https://markdown.com.cn/basic-syntax/emphasis.html

set nocompatible

filetype off

"--------------------------------------
" Languages plugins
"--------------------------------------

let SYNTASTIC_PLUGIN = 0
let PYTHON_PLUGINS = 0
let PERL_PLUGINS = 0

"--------------------------------------
" Install NeoBundle if it is not exists
"--------------------------------------

let firstRun = 0
let neobundle_file = expand($HOME.'/.vim/bundle/neobundle.vim/README.md')
if !filereadable(neobundle_file)
    echo "Installing NeoBundle.."
    echo ""
    silent !mkdir -p $HOME/.vim/bundle
    silent !git clone https://github.com/Shougo/neobundle.vim $HOME/.vim/bundle/neobundle.vim
    let firstRun = 1
endif

"--------------------------------------
" NeoBundle configuration
"--------------------------------------
if has('vim_starting')
    set runtimepath+=$HOME/.vim/bundle/neobundle.vim/
endif

call neobundle#begin(expand($HOME.'/.vim/bundle'))

NeoBundleFetch 'Shougo/neobundle.vim'

"list plugins

if SYNTASTIC_PLUGIN == 1
    NeoBundle 'scrooloose/syntastic'
endif

if PERL_PLUGINS == 1
    NeoBundle 'vim-perl/vim-perl'
endif

if PYTHON_PLUGINS == 1
    NeoBundle 'davidhalter/jedi-vim'
    NeoBundle 'hynek/vim-python-pep8-indent'
    NeoBundle 'mitechie/pyflakes-pathogen'
endif

call neobundle#end()

if firstRun == 1
    echo "Installing Neobundle plugins"
    echo ""
    :NeoBundleInstall
endif

NeoBundleCheck

"
"--------------------------------------
" General vim configuration
"--------------------------------------

filetype plugin indent on

syntax on

"Buffer options
set autoread  "auto reload changed files
set hidden    "don't unload buffer

"Display options
set guioptions-=T
set mousehide
set title           "show file name in window title
set novisualbell    "mute error bell
set list           
set listchars=tab:➝\ ,extends:#,nbsp:.
set linebreak "wrap long lines at a character in 'breakat'
set scrolljump=7 "Minimal number of lines to scroll when the cursor gets off the screen
set scrolloff=7 "Minimal number of screen lines to keep above and below the cursor
set sidescroll=4 "The minimal number of columns to scroll horizontally
set sidescrolloff=10 "The minimal number of screen columns to keep to the left and to the right of the cursor
set showcmd  "show unfinished commands in status bar
set completeopt=menu,preview "list of options for Insert mode completion
set infercase 
set ruler "show cursor
set statusline=%<%f%h%m%r\ %l,%c\ %P
set laststatus=2 "show always
set cmdheight=1
set ttyfast
set shortmess=filnxtToOI 
set nostartofline
set number

set nowrap

"Tab options
set autoindent
set smartindent
set expandtab
set smarttab
set shiftwidth=4
set softtabstop=4
set tabstop=4
set shiftround
set formatoptions+=cr

" Search options
set hlsearch           " highlight search text
set incsearch          " increment search
set ignorecase         " Ignore case in search patterns
set smartcase          " Override the 'ignorecase' option if the search pattern contains upper case characters
" stop highlighting on enter
nnoremap <silent> <cr> :nohlsearch<cr><cr>  

" Matching characters
set showmatch
set matchpairs+=<:>

" Localization
set langmenu=none
set keymap=russian-jcukenwin " Alternative keymap
set iminsert=0
set imsearch=-1
set spelllang=en,ru
set encoding=utf-8           " Default encoding
set fileencodings=utf-8,cp1251,koi8-r,cp866
set termencoding=utf-8
set fileformat=unix

" Wild menu
set wildmenu
set wildcharm=<TAB>
set wildignore+=*.pyc

" Folding
if has('folding')
    set foldmethod=indent
    set foldlevel=99
endif

" Edit
set backspace=indent,eol,start
set nobackup
set nowritebackup
set noswapfile
set noeol

" Session
set sessionoptions=curdir,buffers,tabpages

" Colors
color desert

"--------------------------------------
" Plugins
"--------------------------------------

if PYTHON_PLUGINS == 1
    " jedi-vim {{{
    autocmd FileType python setlocal completeopt-=preview

    let g:jedi#auto_vim_configuration = 0
    let g:jedi#popup_on_dot = 0
    let g:jedi#auto_close_doc = 1
    let g:jedi#show_call_signatures = 1
    let g:jedi#use_splits_not_buffers = "" " right
    let g:jedi#force_py_version = 2
    let g:jedi#completions_command = "<C-n>"
    " }}}
endif

if SYNTASTIC_PLUGIN == 1
    " syntastic {{{
    let g:syntastic_auto_loc_list=1
    let g:syntastic_aggregate_errors = 1

    if PERL_PLUGINS == 1
        let g:syntastic_enable_perl_checker = 1
        let g:syntastic_perl_checkers = ['perl']
    endif

    if PYTHON_PLUGINS == 1
        if filereadable(expand($HOME.'/.pylintrc'))
            let g:syntastic_python_pylint_args = "--rcfile=~/.pylintrc" 
        endif
    endif
    "let g:syntastic_python_checkers = ['pylint']
    " }}}
endif

"--------------------------------------
" Hot keys
"--------------------------------------

" replace under cursor
nmap ; :s/\<<c-r>=expand("<cword>")<cr>\>/

" selection move
vmap < <gv
vmap > >gv

" open Ex in a new tab
nmap <F3> :tabnew<CR>:Ex<cr>
imap <F3> <Esc>:tabnew<CR>:Ex<cr>

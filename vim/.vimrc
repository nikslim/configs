set nocompatible

filetype off

"--------------------------------------
" Plugin groups
"--------------------------------------

let PYTHON_PLUGINS = 0
let PERL_PLUGINS = 0
let CPP_PLUGINS = 0
let GO_PLUGINS = 0

"--------------------------------------
" Install vim-plug if it is not exists
"--------------------------------------

if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin('~/.vim/plugged')

Plug 'tpope/vim-fugitive'
Plug 'scrooloose/nerdtree'
Plug 'Xuyuanp/nerdtree-git-plugin'
Plug 'dense-analysis/ale'

if CPP_PLUGINS == 1
    Plug 'octol/vim-cpp-enhanced-highlight'
    Plug 'Valloric/YouCompleteMe', { 'do': './install.py --clang-completer' }
    Plug 'rdnetto/YCM-Generator'
    Plug 'rhysd/vim-clang-format'
endif

if PERL_PLUGINS == 1
    Plug 'vim-perl/vim-perl'
endif

if PYTHON_PLUGINS == 1
    Plug 'davidhalter/jedi-vim'
    Plug 'hynek/vim-python-pep8-indent'
    Plug 'mitechie/pyflakes-pathogen'
endif

if GO_PLUGINS == 1
    Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }
endif

call plug#end()

" Ensure plugins are installed and up to date
augroup plug_auto_update
    autocmd!
    autocmd VimEnter * if len(filter(values(g:plugs), {_, v -> !isdirectory(v.dir)})) |
                \ PlugInstall --sync |
                \ PlugUpdate |
                \ PlugUpgrade |
            \ endif
augroup END

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
set completeopt=menuone,noinsert,noselect "list of options for Insert mode completion
set infercase
set ruler "show cursor
set statusline=%<%f%h%m%r\ %l,%c\ %P
set laststatus=2 "show always
set cmdheight=1
set ttyfast
set shortmess=filnxtToOI
set shortmess+=c
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
set termguicolors

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

" show line for 80 symbols
set colorcolumn=80

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
    let g:jedi#use_splits_not_buffers = "right" " right
    let g:jedi#force_py_version = 3
    let g:jedi#completions_command = "<C-n>"
    " }}}
endif

if GO_PLUGINS == 1
    let g:go_fmt_command = "goimports"
endif

if CPP_PLUGINS == 1
    let g:cpp_class_scope_highlight = 1
    "let g:cpp_experimental_template_highlight = 1

    let g:ycm_confirm_extra_conf = 0
    let g:ycm_autoclose_preview_window_after_insertion = 1
    let g:clang_format#code_style = "google"
    let g:clang_format#detect_style_file = 0
endif


" ALE configuration
let g:ale_linters = {}
if PERL_PLUGINS == 1
    let g:ale_linters['perl'] = ['perl']
endif

if PYTHON_PLUGINS == 1
    let g:ale_linters['python'] = ['pylint']
    if filereadable(expand($HOME.'/.pylintrc'))
        let g:ale_python_pylint_options = '--rcfile=' . expand('~/.pylintrc')
    endif
endif

if GO_PLUGINS == 1
    let g:ale_linters['go'] = ['gofmt', 'golint']
endif

"--------------------------------------
" Auto commands
"--------------------------------------

" Remove blank symbols at the end of lines
augroup misc
    autocmd!
    au BufWritePre * :%s/\s\+$//e
augroup end

"--------------------------------------
" FileType settings
"--------------------------------------

" Enable autopep8 on `gq`
if executable('autopep8')
    au FileType python setlocal formatprg=autopep8\ -
endif

autocmd FileType cpp,c setlocal shiftwidth=2 tabstop=2 softtabstop=2

autocmd FileType go setlocal noexpandtab tabstop=4 shiftwidth=4 softtabstop=4

"--------------------------------------
" Hot keys
"--------------------------------------

" replace under cursor
nmap ; :s/\<<c-r>=expand("<cword>")<cr>\>/

nnoremap ]d :YcmCompleter GoToDefinition<CR>

" selection move
vmap < <gv
vmap > >gv

" open Ex in a new tab
nmap <F3> :tabnew<CR>:Ex<cr>
imap <F3> <Esc>:tabnew<CR>:Ex<cr>

" copy to os clipboard Ctrl-C
if has("unix")
  let s:uname = system("uname")
  if s:uname == "Darwin\n"
    vmap <C-c> :w !pbcopy<CR><CR>
  endif
endif

let mapleader=","
set nocompatible              " be iMproved, required
filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
" alternatively, pass a path where Vundle should install plugins
"call vundle#begin('~/some/path/here')

" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'

Plugin 'nvie/vim-flake8'
Plugin 'sjl/gundo.vim'
Plugin 'ambv/black'
Plugin 'leafgarland/typescript-vim'
Plugin 'quramy/tsuquyomi'
Plugin 'fatih/vim-go'
Plugin 'udalov/kotlin-vim'
Plugin 'mitermayer/vim-prettier'


" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required



syntax on
set backspace=2				  " For macOS apparently we need to set that.
set number                    " Display line numbers
set numberwidth=1             " using only 1 column (and 1 space) while possible
set background=dark           " We are using dark background in vim
set title                     " show title in console title bar
set wildmenu                  " Menu completion in command mode on <Tab>
set wildmode=full             " <Tab> cycles between all matching choices.
" Ignore these files when completing
set wildignore+=*.o,*.obj,.git,*.pyc
" show existing tab with 4 spaces width
set tabstop=4
" when indenting with '>', use 4 spaces width
set shiftwidth=4
" On pressing tab, insert 4 spaces
set expandtab

let g:flake8_show_in_file=1
let g:flake8_show_quickfix=0

autocmd BufWritePre *.py execute ':Black'
autocmd BufWritePost *.py call Flake8()
autocmd FileType yaml setlocal ts=2 sts=2 sw=2 expandtab


if exists("&colorcolumn")
    set colorcolumn=79
endif


let mapleader=","
set nocompatible              " be iMproved, required
filetype off                  " required

call plug#begin()

Plug 'nvie/vim-flake8'
Plug 'sjl/gundo.vim'
Plug 'valloric/youcompleteme'
Plug 'psf/black'
Plug 'leafgarland/typescript-vim'
Plug 'quramy/tsuquyomi'
Plug 'fatih/vim-go'
Plug 'udalov/kotlin-vim'
Plug 'mitermayer/vim-prettier'
Plug 'keith/swift.vim'
Plug 'rust-lang/rust.vim'
Plug 'wagnerf42/vim-clippy'
Plug 'zxqfl/tabnine-vim'

" All of your Plugins must be added before the following line
call plug#end()            " required
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

let g:prettier#autoformat = 0
autocmd BufWritePre *.js,*.jsx,*.mjs,*.ts,*.tsx,*.css,*.less,*.scss,*.json,*.graphql,*.vue,*.yaml,*.html Prettier


let g:rustfmt_autosave = 1
let g:ycm_language_server =
\ [
\   {
\     'name': 'rust',
\     'cmdline': ['rust-analyzer'],
\     'filetypes': ['rust'],
\     'project_root_files': ['Cargo.toml']
\   }
\ ]
let g:syntastic_rust_checkers = ['rustc', 'clippy']


augroup typescriptreact
  au!
  autocmd BufNewFile,BufRead *.tsx   set filetype=typescript
  autocmd BufNewFile,BufRead *.tsx   set filetype=javascript
augroup END



if exists("&colorcolumn")
    set colorcolumn=79
endif


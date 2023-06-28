let mapleader=","
set nocompatible              " be iMproved, required
filetype off                  " required

call plug#begin()

Plug 'nvie/vim-flake8'
Plug 'dense-analysis/ale'
Plug 'mitermayer/vim-prettier'
Plug 'rust-lang/rust.vim'
Plug 'wagnerf42/vim-clippy'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'evanleck/vim-svelte', {'branch': 'main'}

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

let g:ale_fix_on_save = 1
let g:ale_fixers = {
    \    'python': ['black']
    \}
autocmd BufWritePost *.py call Flake8()
autocmd FileType yaml setlocal ts=2 sts=2 sw=2 expandtab

let g:prettier#autoformat = 0
autocmd BufWritePre *.js,*.jsx,*.mjs,*.ts,*.tsx,*.css,*.less,*.scss,*.json,*.graphql,*.vue,*.yaml,*.html Prettier


let g:rustfmt_autosave = 1


augroup typescriptreact
  au!
  autocmd BufNewFile,BufRead *.tsx   set filetype=typescript
  autocmd BufNewFile,BufRead *.tsx   set filetype=javascript
augroup END

" Use K for show documentation in preview window
nnoremap <silent> K :call <SID>show_documentation()<CR>
function! s:show_documentation()
  if &filetype == 'vim'
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction
" Remap keys for gotos
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)
" Remap for do codeAction of current line
nmap <leader>ac  <Plug>(coc-codeaction)

" Follow option for ripgrep
let g:fzf_layout = { 'down': '~30%' }
command! -bang -nargs=* Rg
  \ call fzf#grep(
  \   'rg --follow --column --line-number --no-heading --color=always '.shellescape(<q-args>), 1,
  \   <bang>0 ? fzf#with_preview('up:60%')
  \           : fzf#with_preview('right:50%:hidden', '?'),
  \   <bang>0)

let g:svelte_preprocessors = ['typescript']

if exists("&colorcolumn")
    set colorcolumn=79
endif


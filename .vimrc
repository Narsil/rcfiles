set shiftwidth=4
set expandtab
au BufRead,BufNewFile Makefile* set noexpandtab

" Use the below highlight group when displaying bad whitespace is desired.
highlight BadWhitespace ctermbg=red guibg=red

" Display tabs at the beginning of a line in Python mode as bad.
au BufRead,BufNewFile *.py,*.pyw match BadWhitespace /^\t\+/
" Make trailing whitespace be flagged as bad.
au BufRead,BufNewFile *.py,*.pyw,*.c,*.h match BadWhitespace /\s\+$/

" Wrap text after a certain number of characters
" Python: 79 
" C: 79
au BufRead,BufNewFile *.py,*.pyw,*.c,*.h set textwidth=79

filetype plugin indent on
filetype indent on

set runtimepath+=/home/nicolas/src/vim-addons/vim-addon-manager/
call scriptmanager#Activate([ 'vim-latex', 'Efficient_python_folding', 'matchit.zip', 'pyflakes2441', 'snipMate'])
au BufRead,BufNewFile *.ccss set filetype=css
au BufRead,BufNewFile *.scss set filetype=css
source /home/nicolas/src/vim-addons/rope.vim

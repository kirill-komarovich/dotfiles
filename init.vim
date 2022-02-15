set mouse=a
set encoding=utf-8
set number
set noswapfile

set tabstop=2
set expandtab
set autoindent
set fileformat=unix
set shiftwidth=2

" Plugins

call plug#begin('~/.vim/plugged')
  Plug 'preservim/nerdtree'
  Plug 'vim-airline/vim-airline'
call plug#end()

" Rulers
set colorcolumn=81,121
highlight ColorColumn ctermbg=0 guibg=lightgrey

nnoremap <C-b> :NERDTreeToggle<CR>
let NERDTreeShowHidden=1
let NERDTreeIgnore=['\.git$']


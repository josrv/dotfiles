syntax on
filetype plugin indent on 

if !has('gui_running')
  set t_Co=256
endif

let mapleader = "<alt>"
set tabstop=2
set shiftwidth=2
set hidden
set expandtab
set laststatus=2
" set textwidth=120
set undodir=~/.local/share/vimundo

set undofile

" show numbers in the sidebar
set relativenumber
set number
" show current command
set showcmd
" disable mode label
set noshowmode

" Use system clipboard
set clipboard+=unnamedplus

" Custom bindings
map <C-N> :noh<cr>


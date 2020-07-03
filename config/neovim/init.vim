syntax on
filetype plugin indent on 

if !has('gui_running')
  set t_Co=256
endif

let mapleader = "<alt>"
set tabstop=4
set shiftwidth=4
set hidden
set expandtab
set laststatus=2
set textwidth=120
set undodir=~/.local/share/vimundo

set undofile

" show numbers in the sidebar
set relativenumber
set number
" show current command
set showcmd
" disable mode label
set noshowmode

" highlight column
" set colorcolumn=+1
" :highlight ColorColumn ctermbg=DarkBlue guibg=DarkBlue

" Plugin configs
let g:lightline = {
      \ 'active': {
      \   'left': [ ['mode'] ]
      \ },
      \ 'colorscheme': 'wombat',
      \ }

" Custom bindings
map ; A;<Esc>

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
set showtabline=0
set undodir=~/.vimundo

set undofile

" show numbers in the sidebar
set relativenumber
set number
" show current command
set showcmd
" disable mode label
set noshowmode

" Plugin configs
let g:lightline = {
      \ 'active': {
      \   'left': [ ['mode', 'buffers'] ]
      \ },
      \ 'component_expand': {
      \   'buffers': 'lightline#bufferline#buffers',
      \ },
      \ 'component_type': {
      \   'buffers': 'tabsel',
      \ },
      \ 'colorscheme': 'wombat',
      \ }

let g:lightline#bufferline#show_number  = 1
let g:lightline#bufferline#unnamed      = '[Unnamed]'

" Custom bindings
map ; A;<Esc>

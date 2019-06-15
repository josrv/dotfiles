syntax on
filetype plugin indent on 

let mapleader = "<alt>"
set tabstop=4
set shiftwidth=4
set hidden
set expandtab
set laststatus=2
set undodir=~/.vimundo
set undofile

" show numbers in the sidebar
set relativenumber
set number
" show current command
set showcmd
" disable mode label
set noshowmode

" Plugins
call plug#begin('~/.vim/plugged')

Plug 'itchyny/lightline.vim'
Plug 'mengelbrecht/lightline-bufferline'

call plug#end()

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

" Disable arrow keys for navigation
"nnoremap <up> <nop>
"nnoremap <down> <nop>
"inoremap <up> <nop>
"inoremap <down> <nop>
"inoremap <left> <nop>
"inoremap <right> <nop>

"nnoremap <left> :bp<CR>
"nnoremap <right> :bn<CR>

" Custom bindings
"
"mmap ml :call Wikt()<cr>
map ; A;<Esc>

"au FileType rust nmap gd <Plug>(rust-def)
"au FileType rust nmap gs <Plug>(rust-def-split)
"au FileType rust nmap gx <Plug>(rust-def-vertical)
au FileType rust nmap gd <Plug>(rust-doc)

" Colemak mappings
" Up/down/left/right {{{
"    nnoremap h h|xnoremap h h|onoremap h h|
"    nnoremap n j|xnoremap n j|onoremap n j|
"    nnoremap e k|xnoremap e k|onoremap e k|
"    nnoremap i l|xnoremap i l|onoremap i l|
" }}}
" Words forward/backward {{{
"    cnoremap <C-L> <C-Left>
"    cnoremap <C-Y> <C-Right>
" }}}
" inSert/Replace/append (T) {{{
"    nnoremap s i|
"    nnoremap S I|
" }}}
" Visual mode {{{
"    nnoremap ga gv
    " Make insert/add work also in visual line mode like in visual block mode
"    xnoremap <silent> <expr> s (mode() =~# "[V]" ? "\<C-V>0o$I" : "I")
"    xnoremap <silent> <expr> S (mode() =~# "[V]" ? "\<C-V>0o$I" : "I")
"    xnoremap <silent> <expr> t (mode() =~# "[V]" ? "\<C-V>0o$A" : "A")
"    xnoremap <silent> <expr> T (mode() =~# "[V]" ? "\<C-V>0o$A" : "A")
" }}}
" Search {{{
"    nnoremap k n|xnoremap k n|onoremap k n|
"    nnoremap K N|xnoremap K N|onoremap K N|
" }}}
" inneR text objects {{{
    " E.g. dip (delete inner paragraph) is now drp
"    nnoremap r i|xnoremap r i|onoremap r i|
" }}}
" Folds, etc. {{{
"    nnoremap j z|xnoremap j z|
"    nnoremap jn zj|xnoremap jn zj|
"    nnoremap je zk|xnoremap je zk|
" }}}
" Overridden keys must be prefixed with g {{{
"    nnoremap gX X|xnoremap gX X|
"    nnoremap gK K|xnoremap gK K|
"    nnoremap gL L|xnoremap gL L|
" }}}
" Window handling {{{
"    nnoremap <C-W>h <C-W>h|xnoremap <C-W>h <C-W>h|
"    nnoremap <C-W>n <C-W>j|xnoremap <C-W>n <C-W>j|
"    nnoremap <C-W>e <C-W>k|xnoremap <C-W>e <C-W>k|
"    nnoremap <C-W>i <C-W>l|xnoremap <C-W>i <C-W>l|
" }}}

" Custom functions

" Call wikt on a current word
function! Wikt()
   let word = expand("<cword>")
   call system("wikt " . word)
   mark w
   call system("sh -c 'mkdir -p $HOME/.local/share/llr'")
   call system("sh -c 'echo " . word . " >> $HOME/.local/share/llr/words'")
endfunction

" Save-on-type mode
command Sot autocmd TextChanged,TextChangedI <buffer> silent write

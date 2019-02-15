" Description {{{
"   Original by Shai Coleman, 2008-04-21.  http://colemak.com/
"
"   Load colemak.vim after all other Vim scripts.
"
"   Refer to ../README.markdown for keymap explanations.
" }}}
" Require Vim >=7.0 {{{
    if v:version < 700 | echohl WarningMsg | echo "colemak.vim: You need Vim version 7.0 or later." | echohl None | finish | endif
" }}}
" Up/down/left/right {{{
    nnoremap h h|xnoremap h h|onoremap h h|
    nnoremap n j|xnoremap n j|onoremap n j|
    nnoremap e k|xnoremap e k|onoremap e k|
    nnoremap i l|xnoremap i l|onoremap i l|
" }}}
" Words forward/backward {{{
    cnoremap <C-L> <C-Left>
    cnoremap <C-Y> <C-Right>
" }}}
" inSert/Replace/append (T) {{{
    nnoremap s i|
    nnoremap S I|
" }}}
" Visual mode {{{
    nnoremap ga gv
    " Make insert/add work also in visual line mode like in visual block mode
    xnoremap <silent> <expr> s (mode() =~# "[V]" ? "\<C-V>0o$I" : "I")
    xnoremap <silent> <expr> S (mode() =~# "[V]" ? "\<C-V>0o$I" : "I")
    xnoremap <silent> <expr> t (mode() =~# "[V]" ? "\<C-V>0o$A" : "A")
    xnoremap <silent> <expr> T (mode() =~# "[V]" ? "\<C-V>0o$A" : "A")
" }}}
" Search {{{
    nnoremap k n|xnoremap k n|onoremap k n|
    nnoremap K N|xnoremap K N|onoremap K N|
" }}}
" inneR text objects {{{
    " E.g. dip (delete inner paragraph) is now drp
    nnoremap r i|xnoremap r i|onoremap r i|
" }}}
" Folds, etc. {{{
    nnoremap j z|xnoremap j z|
    nnoremap jn zj|xnoremap jn zj|
    nnoremap je zk|xnoremap je zk|
" }}}
" Overridden keys must be prefixed with g {{{
    nnoremap gX X|xnoremap gX X|
    nnoremap gK K|xnoremap gK K|
    nnoremap gL L|xnoremap gL L|
" }}}
" Window handling {{{
    nnoremap <C-W>h <C-W>h|xnoremap <C-W>h <C-W>h|
    nnoremap <C-W>n <C-W>j|xnoremap <C-W>n <C-W>j|
    nnoremap <C-W>e <C-W>k|xnoremap <C-W>e <C-W>k|
    nnoremap <C-W>i <C-W>l|xnoremap <C-W>i <C-W>l|
" }}}


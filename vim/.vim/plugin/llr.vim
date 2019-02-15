" Jump to a last searched word (llr mode)
call feedkeys("'w")

" Call wikt on a current word
function! Wikt()
   let word = expand("<cword>")
   call system("wikt " . word)
   mark w
   call system("sh -c 'mkdir -p $HOME/.local/share/llr'")
   call system("sh -c 'echo " . word . " >> $HOME/.local/share/llr/words'")
endfunction



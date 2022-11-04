" Filter lines in current buffer and print them in new buffer.
" Usage: FilterBuf /foobar/
command! -nargs=1 -range=% FilterBuf call local#mod#filterbuf#do(<q-mods>, <line1>, <line2>, <f-args>)

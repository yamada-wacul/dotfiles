" TODOコメントを探し出す
function! local#mod#todo#grep()
  silent! grep! -i 'TODO\|UNDONE\|HACK\|FIXME' | copen
endfunction

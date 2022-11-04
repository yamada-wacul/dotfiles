" Drop a file with lnum at cursor
function! local#mod#droplnum#visual() abort
  let [prev_reg, prev_regtype] = [getreg('z', 1), getregtype('z')]
  try
    normal! gv"zy
    let [cfile, clnum] = s:parse_file_and_lnum(@z)
    call local#mod#droplnum#normal(cfile, clnum)
  finally
    call setreg('z', prev_reg, prev_regtype)
  endtry
endfunction

function! s:parse_file_and_lnum(str) abort
  let r = split(a:str, ':')
  let file = get(r, 0, '')
  let lnum = get(r, 1, '')
  return [file, lnum]
endfunction

function! local#mod#droplnum#normal(...) abort
  let cfile = a:0 >=# 1 ? a:1 : expand('<cfile>')
  if cfile ==# ''
    return
  endif
  let clnum = a:0 >=# 2 ? a:2 : matchstr(getline('.'), '\V' . cfile . '\v:\zs\d+')
  execute 'drop' cfile
  if clnum !=# ''
    execute clnum
  endif
endfunction

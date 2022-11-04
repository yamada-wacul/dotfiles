" / と :s///g をトグルする
cnoremap <expr> <C-\><C-O> ToggleSubstituteSearch(getcmdtype(), getcmdline())

function! ToggleSubstituteSearch(type, line)
  if a:type == '/' || a:type == '?'
    let l:range = GetOnetime('s:range', '%')
    return "\<End>\<C-U>\<BS>" . substitute(a:line, '^\(.*\)', ':' . l:range . 's/\1', '')
  elseif a:type == ':'
    let g:line = a:line
    let [s:range, expr] = matchlist(a:line, '^\(.*\)s\%[ubstitute]\/\(.*\)$')[1:2]
    if s:range == "'<,'>"
      call setpos('.', getpos("'<"))
    endif
    return "\<End>\<C-U>\<BS>" . '/' . expr
  endif
endfunction

function! GetOnetime(varname, defaultValue)
  if exists(a:varname)
    let varValue = eval(a:varname)
    execute 'unlet ' . a:varname
    return varValue
  else
    return a:defaultValue
  endif
endfunction

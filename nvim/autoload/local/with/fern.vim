function! local#with#fern#open_dir()
  if &buftype !=# ''
    echom 'is not file buffer'
    return '-'
  endif

  let l:dirname = expand('%:p:h')
  if !isdirectory(l:dirname)
    echom 'is not dir'
    return '-'
  endif
  return eval('":\<C-u>edit "') .. l:dirname .. eval('"\<CR>"')
endfunction

function! local#with#fern#init()
  nmap <nowait> <buffer> !       <plug>(fern-action-hidden:toggle)
  nmap <nowait> <buffer> <c-r>   <plug>(fern-action-reload:cursor)
  nmap <nowait> <buffer> <c-s-r> <plug>(fern-action-reload:all)
  nmap <nowait> <buffer> >       <plug>(fern-action-expand:in)
  nmap <nowait> <buffer> <       <plug>(fern-action-collapse)
  nmap <nowait> <buffer> -       <plug>(fern-action-leave)
  nmap <nowait> <buffer> +       <plug>(fern-action-enter)
  nmap <nowait> <buffer> <c-x>   <plug>(fern-action-open:above)
  nmap <nowait> <buffer> <c-v>   <plug>(fern-action-open:left)
  nmap <nowait> <buffer> <cr>    <plug>(fern-action-open-or-expand)
  nmap <nowait> <buffer> <c-l>   <plug>(fern-action-redraw)
  nmap <nowait> <buffer> y       <plug>(fern-action-yank:bufname)
  nmap <nowait> <buffer> <c-g>   <plug>(fern-action-cd)             " hint: 'g'oto dir
  nmap <nowait> <buffer> <c-/>   <plug>(fern-action-include)

  nnoremap <nowait> <buffer> <c-x>      <cmd>call <sid>fern_mode_toggle()<cr>
endfunction

function! s:fern_mode_operate()
  if &ft != 'fern'
    return
  endif
  let b:my_fern_mode = 'operate'

  nmap <nowait> <buffer> <space>     <plug>(fern-action-mark:toggle)
  nmap <nowait> <buffer> <c-s-space> <plug>(fern-action-mark:clear)
  nmap <nowait> <buffer> <esc>       <plug>(fern-action-cancel)<plug>(fern-action-mark:clear)<cmd>call <sid>fern_mode_view(v:false)<cr>
  nmap <nowait> <buffer> N           <plug>(fern-action-new-path)
  nmap <nowait> <buffer> C           <plug>(fern-action-copy)
  nmap <nowait> <buffer> M           <plug>(fern-action-move)
  nmap <nowait> <buffer> D           <plug>(fern-action-remove)

  highlight link FernRootSymbol   WarningMsg
  highlight link FernRootText     WarningMsg
  highlight link FernLeafSymbol   WarningMsg
  highlight link FernBranchSymbol WarningMsg
  highlight link FernBranchText   WarningMsg

  doautocmd User MyFernModeChanged
endfunction

function! s:fern_mode_view(init)
  if &ft != 'fern'
    return
  endif
  let b:my_fern_mode = 'view'

  if !a:init
    call fern#action#call('mark:clear')
  endif

  nmap <nowait> <buffer> <space>     <nop>
  nmap <nowait> <buffer> <c-s-space> <nop>
  nmap <nowait> <buffer> <esc>       <plug>(fern-action-cancel)
  nmap <nowait> <buffer> N           <nop>
  nmap <nowait> <buffer> C           <nop>
  nmap <nowait> <buffer> M           <nop>
  nmap <nowait> <buffer> D           <nop>

  highlight link FernRootSymbol   Directory
  highlight link FernRootText     Directory
  highlight link FernLeafSymbol   Directory
  highlight link FernBranchSymbol Directory
  highlight link FernBranchText   Directory

  doautocmd User MyFernModeChanged
endfunction

function! s:fern_mode_toggle()
  if &ft != 'fern'
    return
  endif
  if get(b:, 'my_fern_mode', '') !=# 'operate'
    call s:fern_mode_operate()
  else
    call s:fern_mode_view(v:false)
  endif
endfunction

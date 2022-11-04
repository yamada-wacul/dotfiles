function! local#mod#filterbuf#do(mods, line1, line2, filter)
    let l:number = &number
    let l:list = &list
    set nonumber nolist
    redir @b | silent execute a:line1 .. "," .. a:line2 .. "global" .. a:filter .. "print" | redir END
    let &number = l:number
    let &list = l:list
    silent execute a:mods .. " new"
    silent 0put! b
endfunction

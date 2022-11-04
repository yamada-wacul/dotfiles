function! s:get_opeland(motion_wiseness)
    " Why is this not a built-in Vim script function?!
    let [l:lnum1, l:col1] = getpos("'[")[1:2]
    let [l:lnum2, l:col2] = getpos("']")[1:2]
    let l:lines = getline(l:lnum1, l:lnum2)
    if l:lnum1 == 0 && l:lnum2 == 0 && l:col1 == 0 && l:col2 == 0
        return []
    endif
    if l:lnum1 != l:lnum2
        echoerr 'invalid opeland: create-github-issue accepts only 1 line'
        return []
    endif
    let [l:prefix, l:text, l:suffix] = ['', l:lines[0], '']
    if a:motion_wiseness ==# 'char'
        let l:tail = col2 - (&selection == 'inclusive' ? 1 : 2)
        let l:head = l:col1 - 1

        let l:suffix = l:text[l:tail+1:]
        if l:head > 0
            let l:prefix = l:text[:l:head-1]
        endif

        let l:text = l:text[:l:tail]
        let l:text = l:text[l:head:]
    endif
    return [l:lnum1, l:prefix, l:text, l:suffix]
endfunction

let s:shell = {'chunks': ['']}
function s:shell.on_exit(_job_id, exit_code, _)
    for l:line in reverse(self.chunks)
        let l:match = matchlist(l:line, 'https://github.com/[^/]\+/[^/]\+/issues/\([0-9]\+\)')
        if !empty(l:match)
            call setbufline(self.bufnr, self.lnum, self.prefix .. '[' .. self.title .. ' (#' .. l:match[1] .. ')](' .. l:match[0] ..')' .. self.suffix)
            break
        endif
    endfor
endfunction

function s:shell.on_stdout(_job_id, data, _event)
    let self.chunks[-1] .= a:data[0]
    call extend(self.chunks, a:data[1:])
endfunction

function s:shell.init()
    let self.chunks = ['']
endfunction

function! local#mod#issue#create(motion_wiseness)
    let l:bufnr = bufnr()
    let [l:lnum, l:prefix, l:title, l:suffix] = s:get_opeland(a:motion_wiseness)

    if empty(trim(l:title))
        echoerr 'invalid opeland: empty string'
        return
    endif

    let l:shell = extend(copy(s:shell), {
                \ 'title': l:title,
                \ 'bufnr': l:bufnr,
                \ 'lnum': l:lnum,
                \ 'prefix': l:prefix,
                \ 'suffix': l:suffix,
                \ })
    call l:shell.init()
    new
    let l:shell.id = termopen(['gh', 'issue', 'create', '--title', l:title], l:shell)
    startinsert
endfunction

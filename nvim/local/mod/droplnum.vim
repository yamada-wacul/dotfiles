" Drop a file with lnum at cursor
nmap     <c-w>f     <c-w><c-f>
vmap     <c-w>f     <c-w><c-f>
nnoremap <c-w><c-f> :<c-u>call local#mod#droplnum#normal()<cr>
vnoremap <c-w><c-f> :<c-u>call local#mod#droplnum#visual()<cr>

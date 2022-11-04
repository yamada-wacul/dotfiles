highlight link FernMarkedLine PmenuSel

nnoremap <silent> <C-_> <cmd>Fern . -reveal=%<cr>
nmap <silent> <expr> - local#with#fern#open_dir()

let g:fern#default_hidden = v:true

augroup local-with-fern-mode
  autocmd!
  autocmd FileType fern call local#with#fern#init()
augroup end

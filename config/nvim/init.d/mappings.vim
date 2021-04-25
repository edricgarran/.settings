" clear whitespace before saving
au BufWritePre * :%s/\s\+$//e
" clear search highlights
nnoremap <silent> <esc> :nohl<cr><esc>
" go to last mark
nmap <silent> <leader>b <C-O>
" save from insert mode
inoremap :w <esc>:w
" correct regexp escaping
nnoremap / /\v

nnoremap <silent><M-j> :m+1<cr>
nnoremap <silent><M-k> :m-2<cr>
nnoremap <silent><M-h> <<
nnoremap <silent><M-l> >>

vnoremap <silent><M-j> :m'>+1<cr>gv
vnoremap <silent><M-k> :m'<-2<cr>gv
vnoremap <silent><M-h> <gv
vnoremap <silent><M-l> >gv

" switch to last buffer
nnoremap <BS> <C-^>

" foot IME escape codes
autocmd InsertEnter * call chansend(v:stderr, "\e[?737769h")
autocmd InsertLeave * call chansend(v:stderr, "\e[?737769l")

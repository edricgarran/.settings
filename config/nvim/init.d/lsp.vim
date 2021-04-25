" Highlight the symbol and its references when holding the cursor.
autocmd CursorHold * silent call CocActionAsync('highlight')

" Autocomplete with C-Space
inoremap <silent><expr> <C-Space> coc#refresh()

" Override default documentation
nnoremap <silent>K :call <SID>show_documentation()<CR>
function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction

" Jump to errors
nmap <silent><C-k> <Plug>(coc-diagnostic-prev-error)
nmap <silent><C-j> <Plug>(coc-diagnostic-next-error)
nmap <silent><C-h> <Plug>(coc-diagnostic-prev)
nmap <silent><C-l> <Plug>(coc-diagnostic-next)

" Usual LSP shortcuts
nmap <silent><leader>d <Plug>(coc-definition)
nmap <silent><leader>t <Plug>(coc-type-definition)
nmap <silent><leader>i <Plug>(coc-implementation)
nmap <silent><leader>r <Plug>(coc-references)
nmap <silent><leader>R <Plug>(coc-rename)
nmap <silent><leader>a <Plug>(coc-codeaction)
nmap <silent><leader>f <Plug>(coc-fix-current)

" Map function/class text-objects
xmap if <Plug>(coc-funcobj-i)
omap if <Plug>(coc-funcobj-i)
xmap af <Plug>(coc-funcobj-a)
omap af <Plug>(coc-funcobj-a)
xmap ic <Plug>(coc-classobj-i)
omap ic <Plug>(coc-classobj-i)
xmap ac <Plug>(coc-classobj-a)
omap ac <Plug>(coc-classobj-a)

" Use CTRL-S for selections ranges.
" Requires 'textDocument/selectionRange' support of LS, ex coc-tsserver
nmap <silent> <C-s> <Plug>(coc-range-select)
xmap <silent> <C-s> <Plug>(coc-range-select)

" Add `:Format` command to format current buffer.
command! -nargs=0 Format :call CocAction('format')
" Add `:Fold` command to fold current buffer.
command! -nargs=? Fold :call CocAction('fold', <f-args>)
" Add `:OR` command for organize imports of the current buffer.
command! -nargs=0 OR :call CocAction('runCommand', 'editor.action.organizeImport')

" Autoformat
nnoremap <silent><C-f> :Format<CR>

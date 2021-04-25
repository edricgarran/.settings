" Add diagnostic info for https://github.com/itchyny/lightline.vim
let g:lightline = {
    \   'active': {
    \     'left': [ [ 'mode', 'paste' ],
    \               [ 'cocstatus', 'filename',  'readonly', 'gitbranch' ] ],
    \   },
    \   'component_function': {
    \     'cocstatus': 'coc#status',
    \     'gitbranch': 'fugitive#head',
    \   },
    \ }

set showtabline=1  " Show tabline
set guioptions-=e  " Don't use GUI tabline

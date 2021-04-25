" [Quality of Life]
"
" turn off visual bell
set novisualbell
" make (in|de)crement ignore octal syntax
set nrformats-=octal
" hide autocomplete docwindow
set completeopt-=preview
" center cursor vertically
set scrolloff=999
" horizontal scrolling
set nowrap
" show the last line when it doesn't fit the screen
set display+=lastline
" indent on line breaks
set autoindent
" make backspace make sense
set backspace=indent,eol,start
" tabs are spaces
set expandtab
" make automatic indentation width 4 spaces
set shiftwidth=4
" make the tab key indent 4 spaces
set softtabstop=4
" wrap lines at column 72, more readable than 80
set textwidth=72
" recursive find
set path+=**
" switch to last file
nnoremap <bs> :e#<cr>
" jump to matches when entering regexp
set showmatch
" highlight search
set hlsearch
" incremental search feedback
set incsearch
set inccommand=nosplit
" ignore case when searching
set ignorecase
" no ignorecase if uppercase char present
set smartcase
" no swap file
set noswapfile
" improve update delay
set updatetime=500
" if hidden is not set, TextEdit might fail
set hidden
" Don't pass messages to ins-completion-menu
set shortmess+=c

" [interface]
" adds mouse support
set mouse=a
" enable airline
set laststatus=2
" fix airline lag
set ttimeoutlen=0
" highlight current line
set cursorline
" show the current row and column
set ruler
" show line numbers
set number
" display incomplete commands
set showcmd
" do not keep a backup file
set nobackup
set nowritebackup
" make system clipboard work
set clipboard=unnamedplus
" Hide annoying sign column
set signcolumn=no

" spaaaaaaaace
map <space> <leader>

syntax on
filetype off
source ~/.config/nvim/plugins.vim
filetype plugin indent on

" disable automatic wrapping as you type (must be after filetype on)
set formatoptions=cqj

" load matching rules that come with vim, why isn't this default?
runtime! macros/matchit.vim

" [folding]
augroup folding
    au FileType * setlocal foldmethod=syntax
    au FileType python setlocal foldmethod=indent nosmartindent
augroup end
set nofoldenable

" [color tweaks]
colorscheme default
hi normal guibg=NONE ctermbg=NONE
hi CursorLine cterm=NONE ctermbg=BLACK
hi NormalFloat cterm=NONE ctermbg=BLACK
hi CocUnderline cterm=NONE
hi CocErrorHighlight ctermbg=RED
hi CocWarningHighlight ctermbg=BLACK
hi CocInfoHighlight ctermbg=BLACK
hi CocHintHighlight ctermbg=BLACK
hi CocRustTypeHint cterm=NONE ctermfg=BLACK
hi CocRustChainingHint cterm=NONE ctermfg=DARKGRAY

for file in split(glob('~/.config/nvim/init.d/*.vim'), '\n')
    exe 'source' file
endfor

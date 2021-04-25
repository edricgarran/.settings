call plug#begin('~/.config/nvim/bundle')

" QoL
Plug 'tpope/vim-rsi'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-endwise'
Plug 'terryma/vim-multiple-cursors'
Plug 'nelstrom/vim-visual-star-search'
Plug 'michaeljsmith/vim-indent-object'
Plug 'jiangmiao/auto-pairs'
Plug 'alvan/vim-closetag'

" LSP
Plug 'neoclide/coc.nvim', {'branch': 'release'}

" Auto-complete plugin
Plug 'junegunn/fzf'
Plug 'lifepillar/vim-mucomplete'

" Status line
Plug 'itchyny/lightline.vim'

" SQL
Plug 'vim-scripts/dbext.vim'

" Python
Plug 'lepture/vim-jinja'
Plug 'hdima/python-syntax'

" Javascript/HTML
Plug 'othree/html5.vim'
Plug 'pangloss/vim-javascript'
Plug 'mxw/vim-jsx'

" TypeScript
Plug 'leafgarland/typescript-vim'
Plug 'peitalin/vim-jsx-typescript'

" Terraform
Plug 'hashivim/vim-terraform'

" Rust
Plug 'rust-lang/rust.vim'
Plug 'ron-rs/ron.vim'

" Flutter
Plug 'dart-lang/dart-vim-plugin'
Plug 'thosakwe/vim-flutter'

" Godot
Plug 'calviken/vim-gdscript3'

" C/C++
Plug 'jackguo380/vim-lsp-cxx-highlight'

call plug#end()

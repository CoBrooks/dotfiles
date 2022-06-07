call plug#begin()

Plug 'sainnhe/gruvbox-material'
Plug 'itchyny/lightline.vim'
Plug 'rust-lang/rust'
Plug 'w0rp/ale'
Plug 'maximbaz/lightline-ale'
Plug 'mkitt/tabline.vim'
Plug 'airblade/vim-rooter'
Plug 'ervandew/supertab'

call plug#end()

" Theming
set background=dark
colorscheme gruvbox-material

" LightLine
set laststatus=2
set noshowmode
let g:lightline = {}
let g:lightline.colorscheme = 'gruvbox_material'
let g:lightline.component_expand = {
            \ 'linter_checking': 'lightline#ale#checking',
            \ 'linter_infos': 'lightline#ale#infos',
            \ 'linter_warnings': 'lightline#ale#warnings',
            \ 'linter_errors': 'lightline#ale#errors',
            \ 'linter_ok': 'lightline#ale#ok',
            \ }
let g:lightline.component_type = {
            \ 'linter_checking': 'right',
            \ 'linter_infos': 'right',
            \ 'linter_warnings': 'warning',
            \ 'linter_errors': 'error',
            \ 'linter_ok': 'right',
            \ }
let g:lightline.active = {
            \ 'right': [
            \   [ 'linter_checking', 'linter_errors', 'linter_warnings', 'linter_infos', 'linter_ok' ],
            \   [ 'lineinfo' ],
            \   [ 'fileformat', 'fileencoding', 'filetype' ]
            \ ]
            \ }

" Tabline
set showtabline=2

" Vim-Root
let g:rooter_patterns = [ '.git', 'Makefile', 'target', 'src' ]

" Rust
syntax enable
filetype plugin indent on
let g:rustfmt_autosave = 1

" LSP
let g:ale_linters = { 'rust': ['analyzer'] }
let g:ale_completion_enabled = 1
let g:ale_sign_column_always = 1
let g:ale_sign_error = '->'
let g:ale_sign_warning = '->'
let g:ale_lint_on_text_changed = 'never'
let g:ale_floating_preview = 1
let g:ale_set_balloons = 1
let g:ale_set_loclist = 0
let g:ale_set_quicklist = 0

" Explorer
let g:netrw_liststyle = 3

" General Options
set tabstop=4
set shiftwidth=4
set expandtab
set relativenumber
set splitright
set showcmd

" Cursor shape
let &t_SI = "\<Esc>[6 q"
let &t_SR = "\<Esc>[4 q"
let &t_EI = "\<Esc>[2 q"

" Tab completion
let g:SuperTabDefaultCompletionType = "<c-n>"

" Leader key
nnoremap <SPACE> <Nop>
let mapleader = " "

" Keybinds
nmap <silent> K :ALEHover<CR>
nnoremap <silent> <Tab> :tabnext<CR>
nnoremap <leader>r :source ~/.vimrc<CR>
nnoremap <silent> <leader>fn :tabnew<CR>
nnoremap <silent> <leader>n :Texplore getcwd()<CR>

" chillipeper
" version: 0.1
"
" --> Vimrc automatic initialization
" ============================================================================

" Vim-plug package manager automatic installation
let vim_plug_just_installed = 0
if empty(glob('~/.vim/autoload/plug.vim'))
    silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    autocmd VimEnter * PlugInstall | source $MYVIMRC
    let vim_plug_just_installed = 1
endif

" Manually load vim-plug the first time
if vim_plug_just_installed
    :execute 'source '.fnameescape(vim_plug_path)
endif


" --> Begin vim-plug package manager
" ============================================================================
" Begin vim-plug
call plug#begin('~/.vim/plugged')

" Python Mode
Plug 'python-mode/python-mode'

" Nodejs Mode
" Plug 'moll/vim-node'

" Git Integration
Plug 'tpope/vim-fugitive'
Plug 'airblade/vim-gitgutter'

" Nerd Tree -- Load on demmand
Plug 'scrooloose/nerdtree', { 'on':  'NERDTreeToggle' }

" Airline
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

" Colorschemes
Plug 'altercation/vim-colors-solarized'
Plug 'vim-scripts/peaksea'

" Control P finder
Plug 'ctrlpvim/ctrlp.vim'

" Javascript
Plug 'pangloss/vim-javascript'

" Vim Ansible
Plug 'pearofducks/ansible-vim'

" End vim-plug
call plug#end()

" -->  Install plugins the first time vim runs
" ============================================================================

if vim_plug_just_installed
    echo "Installing Bundles, please ignore key map error messages"
    :PlugInstall
endif

" --> General
" ============================================================================
" No vi-compatible
set nocompatible

" Allow plugins by file type
filetype plugin on
filetype indent on

" Set map leader
let mapleader=","

" --> Files, backups and undo
" ============================================================================
" Turn backup off, since most stuff is in SVN, git et.c anyway...
set nobackup
set nowb
set noswapfile

" --> Colors and Fonts
" ============================================================================
" Set utf8 as standard encoding and en_US as the standard language
set encoding=utf8


" Enable Solarized colorcheme
syntax enable
set background=dark
colorscheme solarized

" --> Tabs, windows and buffers navigation
" ============================================================================
" Open splits to the right or below
set splitbelow
set splitright

" Smart way to move between windows
noremap <C-j> <C-W>j
noremap <C-k> <C-W>k
noremap <C-h> <C-W>h
noremap <C-l> <C-W>l

inoremap <C-j> <esc><C-W>j
inoremap <C-k> <esc><C-W>k
inoremap <C-h> <esc><C-W>h
inoremap <C-l> <esc><C-W>l

" Smart way to move between tabs
noremap <C-S-Left> :tabprevious<CR>
noremap <C-S-Right> :tabnext<CR>

inoremap <C-S-Left> <esc>:tabprevious<CR>
inoremap <C-S-Right> <esc>:tabnext<CR>

" Open .vimrc on a split
nnoremap <leader>ev :edit $MYVIMRC<cr>

" Source .vimrc from vim
nnoremap <leader>sv :source $MYVIMRC<cr>

" --> Key mappings
" ============================================================================
" Delete current line and paste it below the current one
nnoremap <leader>- ddp

" Delete current line and paste it above the current one
nnoremap <leader>+ dd2kp

" Convert current word to lowercase in insert mode
inoremap <leader>u <esc>viwui

" Convert current word to lowercase in normal mode
nnoremap <leader>u <esc>viwu

"" Convert current word to uppercase in insert mode
inoremap <leader>U <esc>viwUi

" Convert current word to uppercase in normal mode
nnoremap <leader>U <esc>viwU

" Fast saving
nnoremap <leader>w :w!<cr>
inoremap <leader>w <esc>:w!<cr>

" Solarized colorscheme toggle
call togglebg#map("<F6>")

" --> Python Mode
" ============================================================================
" Default code checkers
let g:pymode_lint_checkers = ['pylint', 'pyflakes', 'pep8', 'mccabe']

" Do not do folding
let g:pymode_folding = 0

" Do not open window error
let g:pymode_lint_cwindow = 0

" --> Airline
" ============================================================================
" Checking if dictionary is defined and if not create it
if !exists('g:airline_symbols')
    let g:airline_symbols = {}
endif

" unicode symbols
let g:airline_left_sep = '▶'
let g:airline_right_sep = '◀'
let g:airline_symbols.crypt = '🔒'
let g:airline_symbols.linenr = '␤'
let g:airline_symbols.maxlinenr = '☰'
let g:airline_symbols.branch = '⎇'
let g:airline_symbols.paste = 'Þ'
let g:airline_symbols.spell = 'Ꞩ'
let g:airline_symbols.notexists = '∄'
let g:airline_symbols.whitespace = 'Ξ'

" --> NERDTree
" ============================================================================
" noremap <F5> :NERDTreeToggle<CR>:vsplit<CR>:q!<CR>
noremap <F5> :NERDTreeToggle<CR>

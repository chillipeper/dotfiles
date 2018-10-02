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

" pymode
Plug 'python-mode/python-mode'

" You Complete Me
Plug 'Valloric/YouCompleteMe'

" Ale
Plug 'w0rp/ale'

" Git Integration
Plug 'tpope/vim-fugitive'
Plug 'airblade/vim-gitgutter'

" FZF finder
Plug '/usr/local/opt/fzf'
Plug 'junegunn/fzf.vim'

" Nerd Tree -- Load on demmand
Plug 'scrooloose/nerdtree', { 'on':  'NERDTreeToggle' }

" Airline
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

" Colorschemes
Plug 'altercation/vim-colors-solarized'
Plug 'vim-scripts/peaksea'

" Javascript
Plug 'pangloss/vim-javascript'

" Vim Bash Support
Plug 'vim-scripts/bash-support.vim'

" Markdown Mode
Plug 'godlygeek/tabular'
Plug 'plasticboy/vim-markdown'

" Vim Ansible
Plug 'pearofducks/ansible-vim'

" Markdown Preview
Plug 'iamcco/markdown-preview.vim'

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

" Highlit searches
set hlsearch

" Turn off hlsearch and map reset terminal
nnoremap <silent> <F2> :<C-u>nohlsearch<CR><C-l>

" Enable Solarized colorcheme
syntax enable
set background=dark
colorscheme solarized

" --> Tabs, windows and buffers navigation
" ============================================================================
" Open splits to the right or below
set splitbelow
set splitright

" Line numbers, folding
set number
set foldcolumn=1

" Smart way to move between windows
nnoremap <C-k> <C-W>k
nnoremap <C-j> <C-W>j
nnoremap <C-h> <C-W>h
nnoremap <C-l> <C-W>l

inoremap <C-j> <esc><C-W>j
inoremap <C-k> <esc><C-W>k
inoremap <C-h> <esc><C-W>h
inoremap <C-l> <esc><C-W>l

" Create a new tab
nnoremap <leader>tt :tabnew<CR>
inoremap <leader>tt <esc>:tabnew<CR>

" --> Key mappings
" ============================================================================
" Open .vimrc on a split
nnoremap <leader>ev :edit $MYVIMRC<cr>

" Source .vimrc from vim
nnoremap <leader>sv :source $MYVIMRC<cr>

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

" -->  Fugitive
" ============================================================================
" Add the current working file to git
nnoremap <leader>ga :Git add %<cr>
inoremap <leader>ga <esc>:Git add %<cr>

" Git status
nnoremap <leader>gs :Gstatus<cr>
inoremap <leader>gs <esc>:Gstatus<cr>

" Git diff current file
nnoremap <leader>gf :Gdiff<cr>
inoremap <leader>gf <esc>:Gdiff<cr>

" Git push
nnoremap <leader>gp :Gpush<cr>
inoremap <leader>gp <esc>:Gpush<cr>

" --> Ale
" ============================================================================
" Disable completition
let g:ale_completion_enabled = 0

" Python fixers
let g:ale_fixers = {
\  	'*': ['remove_trailing_lines', 'trim_whitespace'], 
\	'python': ['autopep8', 'isort', 'add_blank_lines_for_python_control_statements', 'black', 'yapf']
\}

let g:ale_linters = {
\	'python': ['flake8', 'mypy', 'prospector', 'pycodestyle', 'pyflakes', 'pylint', 'pyls', 'pyre', 'vulture']
\}

" Enable python interpreter if VIRTUAL_ENV exists
if $VIRTUAL_ENV
	let g:ale_virtualenv_dir_names = [$VIRTUAL_ENV]
endif

" --> YCM
" ============================================================================
" Enable python interpreter if VIRTUAL_ENV exists
if $VIRTUAL_ENV
	let g:ycm_python_interpreter_path = $VIRTUAL_ENV . "/bin/python"
endif

" GoTo Definition
nnoremap <leader>gt :YcmCompleter GoTo<cr>
inoremap <leader>gt <esc>:YcmCompleter GoTo<cr>

" GoTo Reference
nnoremap <leader>gr :YcmCompleter GoToReferences<cr>
inoremap <leader>gr <esc>:YcmCompleter GoToReferences<cr>

" --> Python Mode
" ============================================================================
" Disable pymode-lint
let g:pymode_lint = 0

" Enable pymode-virtualenv
let g:pymode_virtualenv = 1

" Disable pymode-completetion
let g:pymode_rope_completion = 0

" Do not open window error
let g:pymode_lint_cwindow = 0

" Enable folding
let g:pymode_folding = 1

" --> FZF Finder
" ============================================================================
" Map search like ctrlp search
nnoremap <C-p> :FZF<cr>
inoremap <C-p> <esc>:FZF<cr>

let g:fzf_layout = { 'down': '~20%' }

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

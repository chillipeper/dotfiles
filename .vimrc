" chillipeper
" version: 0.1
"
" ============================================================================
" Vimrc automatic initialization {{{
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

" }}}

" --> Begin vim-plug package manager
" ============================================================================
" Begin vim-plug
call plug#begin('~/.vim/plugged')

" Ale
Plug 'w0rp/ale'

" Deoplete VIM
if has('nvim')
  Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
else
  Plug 'Shougo/deoplete.nvim'
  Plug 'roxma/nvim-yarp'
  Plug 'roxma/vim-hug-neovim-rpc'
endif

" vim-jedi
Plug 'davidhalter/jedi-vim'
" Deoplete Jedi
Plug 'deoplete-plugins/deoplete-jedi'

" Golang
Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }


"Prettier 
Plug 'prettier/vim-prettier', {
  \ 'do': 'yarn install',
  \ 'branch': 'release/1.x',
  \ 'for': ['css', 'json', 'yaml', 'html'] }

" Git Integration
Plug 'tpope/vim-fugitive'
Plug 'airblade/vim-gitgutter'

" FZF finder
" Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf', { 'do': './install --all' } 
Plug 'junegunn/fzf.vim'

" Airline
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

" Colorschemes
Plug 'altercation/vim-colors-solarized'
Plug 'vim-scripts/peaksea'
 
" Vim Bash Support
Plug 'vim-scripts/bash-support.vim'

" Markdown Mode
Plug 'godlygeek/tabular'
Plug 'plasticboy/vim-markdown'

" Vim Ansible
Plug 'pearofducks/ansible-vim'

" Markdown Preview
Plug 'iamcco/markdown-preview.nvim', { 'do': 'cd app & yarn install'  }

" Obsession --> use vim save sessions to restore tmux sessions
Plug 'tpope/vim-obsession'

" Vim Ruby
Plug 'vim-ruby/vim-ruby'

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

" yank to and paste the selection without prepending "* to commands
" in other words copy to the clipboard
set clipboard=unnamed

" Allow plugins by file type
filetype plugin on
filetype indent on

" Set map leader
let mapleader=","

" Turn backup off, since most stuff is in git etc
set nobackup
set nowb
set noswapfile

" Set utf8 as standard encoding and en_US as the standard language
set encoding=utf8

" Highlit searches
set hlsearch

" Enable Solarized colorscheme
syntax enable
" let g:solarized_termtrans = 1
set background=dark
colorscheme solarized

" Open splits to the right or below
set splitbelow
set splitright

" Line numbers, folding
set number
set foldcolumn=1

" Try out ident folding
set foldmethod=indent
nnoremap <space> za
vnoremap <space> zf

" 
set autowrite

" --> Autocommands
" ============================================================================
" go-vim 

" run :GoBuild or :GoTestCompile based on the go file
function! s:build_go_files()
	let l:file = expand('%')
	if l:file =~# '^\f\+_test\.go$'
        	call go#test#Test(0, 1)
        elseif l:file =~# '^\f\+\.go$'
                call go#cmd#Build(0)
        endif
endfunction

autocmd FileType go nmap <leader>b :<C-u>call <SID>build_go_files()<CR>
autocmd FileType go nmap <Leader>c <Plug>(go-coverage-toggle)
autocmd FileType go nmap <leader>r  <Plug>(go-run)
autocmd FileType go nmap <leader>t  <Plug>(go-test)

" set ruler for python files
autocmd FileType python set colorcolumn=81

" Groovy syntax
" Checking if dictionary is defined and if not create it
autocmd BufNewFile,BufRead Jenkinsfile setf groovy

" I don't want the docstring window to popup during completion
" autocmd FileType python setlocal completeopt-=preview
autocmd FileType go setlocal completeopt=menu,noselect,preview

" --> Key mappings
" ============================================================================
" Turn off hlsearch and map reset terminal
nnoremap <silent> <F2> :<C-u>nohlsearch<CR><C-l>

" Smart way to move between windows
" nnoremap <C-k> <C-W>k
" nnoremap <C-j> <C-W>j
" nnoremap <C-h> <C-W>h
" nnoremap <C-l> <C-W>l
" 
" inoremap <C-j> <esc><C-W>j
" inoremap <C-k> <esc><C-W>k
" inoremap <C-h> <esc><C-W>h
" inoremap <C-l> <esc><C-W>l

" Display errors more friendly way
map <C-m> :cprevious<CR>
map <C-n> :cnext<CR>

" FZF as like ctrlp search
nnoremap <C-p> :FZF<cr>
inoremap <C-p> <esc>:FZF<cr>

" Open .vimrc on a split
nnoremap <leader>ev :edit $MYVIMRC<cr>

" Source .vimrc from vim
nnoremap <leader>sv :source $MYVIMRC<cr>

" Delete current line and paste it below the current one
nnoremap <leader>- ddp

" Delete current line and paste it above the current one
nnoremap <leader>+ dd2kp

" Close error window
nnoremap <leader>a :cclose<CR>

" ALEFix
nnoremap <leader>af :ALEFix<cr>
inoremap <leader>af <esc>:ALEFix<cr>

" " ALEDefinition
" nnoremap <leader>ag :ALEGoToDefinitionInSplit<cr>
" inoremap <leader>ag <esc>:ALEGoToDefinitionInSplit<cr>

" ALEinfo
nnoremap <leader>ai :ALEInfo<cr>
inoremap <leader>ai <esc>:ALEInfo<cr>

" Git Add
nnoremap <leader>ga :Git add %<cr>
inoremap <leader>ga <esc>:Git add %<cr>

" Git commit -m 
nnoremap <leader>gc :Gcommit -m "
inoremap <leader>gc <esc>:Gcommit -m "

" Git diff current file
nnoremap <leader>gf :Gdiff<cr>
inoremap <leader>gf <esc>:Gdiff<cr>

" Git push
nnoremap <leader>gp :Gpush<cr>
inoremap <leader>gp <esc>:Gpush<cr>

" Git status
nnoremap <leader>gs :Gstatus<cr>
inoremap <leader>gs <esc>:Gstatus<cr>

" Convert current word to lowercase in insert mode
inoremap <leader>u <esc>viwui

" Convert current word to lowercase in normal mode
nnoremap <leader>u <esc>viwu

"" Convert current word to uppercase in insert mode
inoremap <leader>U <esc>viwUi

" Convert current word to uppercase in normal mode
nnoremap <leader>U <esc>viwU

" Remove words that are under quotes and insert
nnoremap <leader>r" <esc>T"vt"s

" Remove words that are under quotes and insert
nnoremap <leader>r' <esc>T'vt's

" Create a new tab
nnoremap <leader>tt :tabnew<CR>

" Fast saving
nnoremap <leader>w :w!<cr>
inoremap <leader>w <esc>:w!<cr>

" Solarized colorscheme toggle
call togglebg#map("<F6>")

" --> Deoplete nvim
" ============================================================================
let g:deoplete#enable_at_startup = 1
let g:deoplete#sources#jedi#show_docstring = 1
call deoplete#custom#option('omni_patterns', { 'go': '[^. *\t]\.\w*' })

" --> Jedi VIM
" ============================================================================
" Disable jedi completition if deoplete is enabled
let g:jedi#completions_enabled = 0


" --> Ale
" ============================================================================

" :help ale-completion-completeopt-bug
" set completeopt=menu,menuone,noselect,noinsert
" 
" Enable completition
" let g:ale_completion_enabled = 1

" Python fixers
let g:ale_fixers = {
\  	'*': ['remove_trailing_lines', 'trim_whitespace'], 
\	'python': ['isort', 'add_blank_lines_for_python_control_statements', "black"],
\       'yaml': ['prettier'],
\       'json': ['prettier']
\}

let g:ale_linters = {
\	'python': ['pylint', 'flake8']
\}

let g:ale_yaml_yamllint_options = '-d "{extends: relaxed, rules: {line-length: {max: 120}}}"'

" let g:ale_python_pyls_auto_pipenv = 1
" 
" " Disabling pylint, because pyls can't pick up yet pylintrc config
" " https://github.com/palantir/python-language-server/pull/538
" let g:ale_python_pyls_config = {
" \   	'pyls': { 
" \		'configurationSources': ['flake8'],
" \		'plugins': {
" \			'pylint': {
" \				'enabled': v:false
" \			}
" \		}
" \	}
" \}
"
" --> Vim Gutter
" ============================================================================
" Enable python YCMinterpreter if VIRTUAL_ENV exists
"let g:gitgutter_max_signs = 5000

" --> FZF Finder
" ============================================================================
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
"

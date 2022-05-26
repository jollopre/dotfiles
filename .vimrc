" General
set nobackup " no backup made
set nowritebackup " no backup while writing 
set noswapfile " disables creating swap files

set number	" Show line numbers
set linebreak	" Break lines at word (requires Wrap lines)
set showbreak=+++	" Wrap-broken line prefix
set textwidth=100	" Line wrap (number of cols)
set showmatch	" Highlight matching brace
set spell	" Enable spell-checking
set visualbell	" Use visual bell (no beeping)

set hlsearch	" Highlight all search results
"set smartcase	" Enable smart-case search
set incsearch	" Searches for strings incrementally

set autoindent	" Auto-indent new lines
set expandtab	" Use spaces instead of tabs
set shiftwidth=2	" Number of auto-indent spaces
set smartindent	" Enable smart-indent
set smarttab	" Enable smart-tabs
set softtabstop=2	" Number of spaces per Tab
set encoding=utf-8
set foldmethod=syntax " permits folding a block by its syntax inferred
set nofoldenable " folding is disabled implicitly
syntax on " Enable syntax highlighting

" Advanced
set ruler	" Show row and column ruler information
set undolevels=1000	" Number of undo levels
set backspace=indent,eol,start	" Backspace behaviour
set laststatus=2  " Used for lightline.vim
filetype plugin indent on    " filetype plugin for detection and indentation

" runtimepath additions
set rtp+=~/.vim/bundle/Vundle.vim
set rtp+=~/.fzf

call vundle#begin()
Plugin 'VundleVim/Vundle.vim'
Plugin 'junegunn/fzf'
Plugin 'junegunn/fzf.vim'
Plugin 'scrooloose/nerdtree'
Plugin 'dracula/vim', { 'name': 'dracula' }
Plugin 'w0rp/ale'
Plugin 'itchyny/lightline.vim'
Plugin 'tpope/vim-commentary'
call vundle#end()

" Ale linter configuration. Requires eslint and ruby packages installed
let g:ale_linters = { 'javascript': ['eslint'], 'ruby': ['ruby'] }

" Ag
if executable('ag')
  let g:ackprg = 'ag --vimgrep'
endif

" Dracula theme
try
  colorscheme dracula
catch /^Vim\%((\a\+)\)\=:E185/
endtry

" mappings
nnoremap <c-p> :FZF<CR>
nnoremap <c-f> :Ag<CR>
nnoremap <c-b> :!git blame %:p<CR>
nnoremap <c-l> :let @*=expand("%")<CR>
nnoremap <c-n> :let @*=fnamemodify(expand("%"), ":~:.") . ":" . line(".")<CR>

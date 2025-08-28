" ============================================================================
" Solid .vimrc Configuration
" ============================================================================

" Basic Settings
" ============================================================================
set nocompatible                " Use Vim settings, not Vi
set encoding=utf-8              " Use UTF-8 encoding
set fileencoding=utf-8          " File encoding
set backspace=indent,eol,start  " Allow backspace over everything
set history=1000                " Keep 1000 lines of command history
set undolevels=1000             " More undo levels

" Display & UI
" ============================================================================
set number                      " Show line numbers
set relativenumber              " Show relative line numbers
set ruler                       " Show cursor position
set showcmd                     " Show incomplete commands
set showmatch                   " Show matching brackets
set laststatus=2                " Always show status line
set wildmenu                    " Enhanced command completion
set wildmode=longest:full,full  " Command completion behavior
set title                       " Set terminal title
set cursorline                  " Highlight current line
syntax enable                   " Enable syntax highlighting
set background=dark             " Dark background
colorscheme desert              " Color scheme (built-in)

" Search Settings
" ============================================================================
set hlsearch                    " Highlight search results
set incsearch                   " Incremental search
set ignorecase                  " Case insensitive search
set smartcase                   " Case sensitive when uppercase present
set wrapscan                    " Wrap search around file

" Indentation & Formatting
" ============================================================================
set autoindent                  " Auto indent new lines
set smartindent                 " Smart auto indenting
set expandtab                   " Use spaces instead of tabs
set tabstop=4                   " Tab width
set shiftwidth=4                " Indent width
set softtabstop=4               " Soft tab width
set wrap                        " Wrap long lines
set linebreak                   " Break lines at word boundaries
set textwidth=80                " Auto wrap at 80 characters
set formatoptions+=t            " Auto-wrap text using textwidth

" File Handling
" ============================================================================
set autoread                    " Auto reload files changed outside Vim
set hidden                      " Allow hidden buffers
set backup                      " Enable backups
set backupdir=~/.vim/backup     " Backup directory
set directory=~/.vim/swap       " Swap file directory
set undofile                    " Enable persistent undo
set undodir=~/.vim/undo         " Undo directory

" Create directories if they don't exist
if !isdirectory($HOME."/.vim/backup")
    call mkdir($HOME."/.vim/backup", "p", 0700)
endif
if !isdirectory($HOME."/.vim/swap")
    call mkdir($HOME."/.vim/swap", "p", 0700)
endif
if !isdirectory($HOME."/.vim/undo")
    call mkdir($HOME."/.vim/undo", "p", 0700)
endif

" Performance & Behavior
" ============================================================================
set lazyredraw                  " Don't redraw during macros
set ttyfast                     " Fast terminal connection
set timeoutlen=500              " Timeout for key sequences
set ttimeoutlen=10              " Timeout for key codes
set updatetime=250              " Faster completion
set scrolloff=5                 " Keep 5 lines visible when scrolling
set sidescrolloff=5             " Keep 5 columns visible when scrolling

" Key Mappings
" ============================================================================
" Set leader key
let mapleader = ","

" Quick save and quit
nnoremap <leader>w :w<CR>
nnoremap <leader>q :q<CR>
nnoremap <leader>x :wq<CR>

" Clear search highlighting
nnoremap <leader><space> :nohlsearch<CR>

" Buffer navigation
nnoremap <leader>n :bnext<CR>
nnoremap <leader>p :bprevious<CR>
nnoremap <leader>d :bdelete<CR>

" Window navigation
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

" Resize windows
nnoremap <leader>= <C-w>=
nnoremap <leader>+ :resize +5<CR>
nnoremap <leader>- :resize -5<CR>
nnoremap <leader>> :vertical resize +5<CR>
nnoremap <leader>< :vertical resize -5<CR>

" Quick edit .vimrc
nnoremap <leader>ev :edit ~/.vimrc<CR>
nnoremap <leader>sv :source ~/.vimrc<CR>

" Move lines up/down
nnoremap <C-Up> :m-2<CR>==
nnoremap <C-Down> :m+1<CR>==
inoremap <C-Up> <Esc>:m-2<CR>==gi
inoremap <C-Down> <Esc>:m+1<CR>==gi
vnoremap <C-Up> :m-2<CR>gv=gv
vnoremap <C-Down> :m'>+1<CR>gv=gv

" Visual mode improvements
vnoremap < <gv
vnoremap > >gv

" Insert mode improvements
inoremap jj <Esc>               " Quick escape
inoremap <C-a> <Home>           " Go to beginning of line
inoremap <C-e> <End>            " Go to end of line

" File Operations
" ============================================================================
" File explorer settings
let g:netrw_banner = 0          " Remove banner
let g:netrw_liststyle = 3       " Tree view
let g:netrw_winsize = 25        " Window size

" Quick file explorer
nnoremap <leader>e :Explore<CR>
nnoremap <leader>v :Vexplore<CR>

" Programming Features
" ============================================================================
set showmatch                   " Show matching parentheses
set matchtime=2                 " How long to show matching paren
filetype plugin indent on      " Enable file type detection

" Auto-completion settings
set completeopt=menuone,longest " Completion options
set omnifunc=syntaxcomplete#Complete

" Folding
set foldmethod=indent           " Fold based on indentation
set foldlevelstart=99           " Start with all folds open
nnoremap <space> za             " Toggle fold with spacebar

" Status Line
" ============================================================================
set statusline=%f               " File name
set statusline+=\ %m            " Modified flag
set statusline+=\ %r            " Read-only flag
set statusline+=\ %h            " Help flag
set statusline+=%=              " Right align
set statusline+=\ %y            " File type
set statusline+=\ [%{&encoding}] " Encoding
set statusline+=\ [%{&ff}]      " File format
set statusline+=\ %p%%          " Percentage through file
set statusline+=\ %l:%c         " Line and column
set statusline+=\ [%L]          " Total lines

" Auto Commands
" ============================================================================
if has("autocmd")
    " Remove trailing whitespace on save
    autocmd BufWritePre * :%s/\s\+$//e
    
    " Return to last edit position
    autocmd BufReadPost *
        \ if line("'\""}) > 0 && line("'\""}) <= line("$") |
        \   exe "normal! g`\""} |
        \ endif
    
    " File type specific settings
    autocmd FileType python setlocal tabstop=4 shiftwidth=4 expandtab
    autocmd FileType javascript setlocal tabstop=2 shiftwidth=2 expandtab
    autocmd FileType html setlocal tabstop=2 shiftwidth=2 expandtab
    autocmd FileType css setlocal tabstop=2 shiftwidth=2 expandtab
    autocmd FileType yaml setlocal tabstop=2 shiftwidth=2 expandtab
    autocmd FileType json setlocal tabstop=2 shiftwidth=2 expandtab
endif

" Miscellaneous
" ============================================================================
set mouse=a                     " Enable mouse support
set clipboard=unnamed           " Use system clipboard
set spelllang=en_us             " Spell check language
set noerrorbells                " No error bells
set visualbell                  " Visual bell instead of beeping

" Toggle spell check
nnoremap <leader>s :set spell!<CR>

" Toggle line numbers
nnoremap <leader>l :set number! relativenumber!<CR>

" Toggle paste mode
nnoremap <leader>pp :set paste!<CR>

" ============================================================================
" End of .vimrc
" ============================================================================

call plug#begin('~/.vim/plugged')
" Generic language plugins,
Plug 'w0rp/ale' " For linting
Plug 'sheerun/vim-polyglot' " For random language support
Plug 'autozimu/LanguageClient-neovim', { 'branch': 'next', 'do': 'bash install.sh' }
" Plug 'prabirshrestha/async.vim'
" Plug 'prabirshrestha/vim-lsp'
Plug 'roxma/nvim-yarp' " For ncm
Plug 'ncm2/ncm2' " For Autocomplete
" Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }

" Autocomplete extensions
Plug 'ncm2/ncm2-bufword'
Plug 'ncm2/ncm2-path'
Plug 'ncm2/ncm2-syntax' | Plug 'Shougo/neco-syntax'

Plug 'xuhdev/vim-latex-live-preview'
Plug 'rhysd/vim-grammarous'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'


"Ui changes
" Plug 'airblade/vim-gitgutter'
" Plug 'vim-airline/vim-airline'
" Plug 'vim-airline/vim-airline-themes'
Plug 'junegunn/rainbow_parentheses.vim'
Plug 'tpope/vim-sleuth'
Plug 'drewtempelmeyer/palenight.vim'
Plug 'itchyny/lightline.vim'

"Movement plugins
Plug 'easymotion/vim-easymotion'
" Plug 'vim-scripts/a.vim'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-surround'

call plug#end()

"Autocomplete
autocmd BufEnter * call ncm2#enable_for_buffer()
" let g:deoplete#enable_at_startup = 1
" :help Ncm2PopupOpen for more information
set completeopt=noinsert,menuone,noselect
inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
" let g:ale_completion_enabled = 1
let g:LanguageClient_serverCommands = {
    \ 'rust': ['rustup', 'run', 'nightly', 'rls'],
    \ 'javascript': ['/opt/javascript-typescript-langserver/lib/language-server-stdio.js'],
    \ 'haskell': ['hie-wrapper', '--lsp', '-d', '-l', 'hie.log'],
    \ 'cpp': ['clangd'],
    \ }

let g:LanguageClient_hoverPreview = "Never"

nnoremap <silent> K :call LanguageClient_textDocument_hover()<CR>
let g:LanguageClient_autoStart = 1
let g:LanguageClient_diagnosticsEnable = 0
let g:cm_refresh_length = 1
let g:EclimCompletionMethod = 'omnifunc'

let g:ale_linters = {
    \   'haskell': ['stack-ghc', 'ghc-mod', 'hlint', 'hdevtools', 'hfmt'],
    \   'cpp': ['clangd'],
    \}

"Qol changes
set background=dark
filetype plugin indent on
set relativenumber 
set number  
set hidden " don't close when switching buffers
let mapleader=" "
set tabstop=2     " a tab is two spaces
set copyindent    " copy the previous indentation on autoindenting
set shiftwidth=2  " number of spaces to use for autoindenting
set expandtab " On pressing tab, insert 2 spaces
set shiftround    " use multiple of shiftwidth when indenting with '<' and '>'
set ignorecase    " ignore case when searching
set smartcase     " ignore case if search pattern is all lowercase,
                    "    case-sensitive otherwise
nnoremap j gj
nnoremap k gk
set pastetoggle=<F2>
nnoremap ; :
nmap <silent> ,, :nohlsearch<CR>
set scrolloff=5

"Carefully crafted rainbow configuration
autocmd FileType * RainbowParentheses
let g:rainbow#max_level = 16
let g:rainbow#pairs = [['(', ')'], ['[', ']']]
let g:rainbow#blacklist = ['#ECEFF4', '#D8DEE9']

"General ui stuff
set termguicolors
colorscheme palenight
let g:palenight_terminal_italics=1


"Airlines

" let g:airline_powerline_fonts = 1
" let g:airline_theme='nord'
set laststatus=2
" let g:lightline.colorscheme = 'palenight'
let g:lightline = {
      \ 'colorscheme': 'palenight',
      \ }
set noshowmode

"Easy motion

" <Leader>f{char} to move to {char}
" map  <Leader>c <Plug>(easymotion-bd-f)
nmap <Leader>ec <Plug>(easymotion-overwin-f)
" s{char}{char} to move to {char}{char}
nmap <Leader>es <Plug>(easymotion-overwin-f2)
" " Move to line
" map <Leader>l <Plug>(easymotion-bd-jk)
nmap <Leader>el <Plug>(easymotion-overwin-line)
" " Move to word
" map  <Leader>w <Plug>(easymotion-bd-w)
nmap <Leader>ew <Plug>(easymotion-overwin-w)


" FZF - Fuzzy finder
nnoremap <Leader>f :Files<CR>
nnoremap <Leader>p :GFiles<CR>
nnoremap <Leader>b :Buffers<CR>
nnoremap <Leader>l :Lines<CR>
nnoremap <Leader>c :Commands<CR>
autocmd! FileType fzf
autocmd  FileType fzf set laststatus=0 noshowmode noruler
  \| autocmd BufLeave <buffer> set laststatus=2 showmode ruler

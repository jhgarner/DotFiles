call plug#begin('~/.vim/plugged')

"Language plugins

Plug 'neomake/neomake'
Plug 'sheerun/vim-polyglot'
Plug 'autozimu/LanguageClient-neovim', { 'do': ':UpdateRemotePlugins' }
Plug 'roxma/nvim-completion-manager'
Plug 'eagletmt/neco-ghc', {'for' : 'haskell'}
Plug 'roxma/ncm-clang'
Plug 'racer-rust/vim-racer', {'for' : 'rust'}
Plug 'roxma/nvim-cm-racer', {'for' : 'rust'}
Plug 'xuhdev/vim-latex-live-preview'
Plug 'dansomething/vim-eclim'

"Ui changes

Plug 'airblade/vim-gitgutter'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'iCyMind/NeoSolarized'
Plug 'luochen1990/rainbow'
Plug 'tpope/vim-sleuth'

"Movement plugins

Plug 'easymotion/vim-easymotion'
Plug 'vim-scripts/a.vim'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-surround'

call plug#end()

"Autocomplete

inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
let g:LanguageClient_serverCommands = {
    \ 'rust': ['rustup', 'run', 'nightly', 'rls'],
    \ 'javascript': ['/opt/javascript-typescript-langserver/lib/language-server-stdio.js'],
    \ }

nnoremap <silent> K :call LanguageClient_textDocument_hover()<CR>
"let g:LanguageClient_autoStart = 1
let g:cm_refresh_length = 1
let g:EclimCompletionMethod = 'omnifunc'
au User CmSetup call cm#register_source({'name' : 'cm-css',
        \ 'priority': 9, 
        \ 'scoping': 1,
        \ 'scopes': ['scala'],
        \ 'abbreviation': 'scala',
        \ 'word_pattern': '[\w\-]+',
        \ 'cm_refresh_patterns':['[\w\-]+\s*:\s+'],
        \ 'cm_refresh': {'omnifunc': 'eclim#scala#complete#CodeComplete'},
        \ })
au User CmSetup call cm#register_source({'name' : 'haskell-css',
        \ 'priority': 9, 
        \ 'scoping': 1,
        \ 'scopes': ['haskell'],
        \ 'abbreviation': 'haskell',
        \ 'word_pattern': '[\w\-]+',
        \ 'cm_refresh_patterns':['[\w\-]+\s*:\s+'],
        \ 'cm_refresh': {'omnifunc': 'necoghc#omnifunc'},
        \ })

let g:necoghc_use_stack = 1

"Neomake

autocmd! BufWritePost * Neomake

"Qol changes
set background=dark
set relativenumber 
set number  
set hidden " don't close when switching buffers
let mapleader=","
set tabstop=4     " a tab is four spaces
set copyindent    " copy the previous indentation on autoindenting
set shiftwidth=4  " number of spaces to use for autoindenting
set expandtab " On pressing tab, insert 4 spaces
set shiftround    " use multiple of shiftwidth when indenting with '<' and '>'
set ignorecase    " ignore case when searching
set smartcase     " ignore case if search pattern is all lowercase,
                    "    case-sensitive otherwise
nnoremap j gj
nnoremap k gk
set pastetoggle=<F2>
nnoremap ; :
nmap <silent> ,/ :nohlsearch<CR>
set scrolloff=5

"Carefully crafted rainbow configuration

let g:rainbow_conf = {
	\	'guifgs': [ 'darkorange3', 'yellowgreen', 'darkorchid', 'deepskyblue'],
	\	'ctermfgs': ['lightblue', 'lightyellow', 'lightcyan', 'lightmagenta'],
	\	'operators': '_,_',
	\	'parentheses': ['start=/(/ end=/)/ fold', 'start=/\[/ end=/\]/ fold', 'start=/{/ end=/}/ fold'],
	\	'separately': {
	\		'*': {},
	\		'tex': {
	\			'parentheses': ['start=/(/ end=/)/', 'start=/\[/ end=/\]/'],
	\		},
	\		'lisp': {
	\			'guifgs': ['royalblue3', 'darkorange3', 'seagreen3', 'firebrick', 'darkorchid3'],
	\		},
	\		'vim': {
	\			'parentheses': ['start=/(/ end=/)/', 'start=/\[/ end=/\]/', 'start=/{/ end=/}/ fold', 'start=/(/ end=/)/ containedin=vimFuncBody', 'start=/\[/ end=/\]/ containedin=vimFuncBody', 'start=/{/ end=/}/ fold containedin=vimFuncBody'],
	\		},
	\		'html': {
	\			'parentheses': ['start=/\v\<((area|base|br|col|embed|hr|img|input|keygen|link|menuitem|meta|param|source|track|wbr)[ >])@!\z([-_:a-zA-Z0-9]+)(\s+[-_:a-zA-Z0-9]+(\=("[^"]*"|'."'".'[^'."'".']*'."'".'|[^ '."'".'"><=`]*))?)*\>/ end=#</\z1># fold'],
	\		},
	\		'css': 0,
	\	}
	\}
let g:rainbow_active = 1 "0 if you want to enable it later via :RainbowToggle
let g:gitgutter_override_sign_column_highlight = 0

"General ui stuff

set termguicolors
colorscheme NeoSolarized

"NerdTree
map <C-n> :NERDTreeToggle<CR>

"Airlines

let g:airline_powerline_fonts = 1
let g:airline_theme='solarized'
set laststatus=2

"Easy motion

" <Leader>f{char} to move to {char}
map  <Leader>f <Plug>(easymotion-bd-f)
nmap <Leader>f <Plug>(easymotion-overwin-f)
" s{char}{char} to move to {char}{char}
nmap s <Plug>(easymotion-overwin-f2)
" " Move to line
map <Leader>L <Plug>(easymotion-bd-jk)
nmap <Leader>L <Plug>(easymotion-overwin-line)
" " Move to word
map  <Leader>w <Plug>(easymotion-bd-w)
nmap <Leader>w <Plug>(easymotion-overwin-w)

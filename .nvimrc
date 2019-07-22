call plug#begin('~/.vim/plugged')
" Generic language plugins,
" Plug 'w0rp/ale' " For linting
Plug 'sheerun/vim-polyglot' " For random language support
" Plug 'autozimu/LanguageClient-neovim', { 'branch': 'next', 'do': 'bash install.sh' }
" Plug 'prabirshrestha/async.vim'
" Plug 'prabirshrestha/vim-lsp'
" Plug 'roxma/nvim-yarp' " For ncm
" Plug 'ncm2/ncm2' " For Autocomplete
" Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
Plug 'calviken/vim-gdscript3'

" Autocomplete extensions
" Plug 'ncm2/ncm2-bufword'
" Plug 'ncm2/ncm2-path'
" Plug 'ncm2/ncm2-syntax' | Plug 'Shougo/neco-syntax'
Plug 'neoclide/coc.nvim', {'do': { -> coc#util#install()}}
Plug 'derekwyatt/vim-scala'

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
Plug 'liuchengxu/vim-which-key', { 'on': ['WhichKey', 'WhichKey!'] }

"Movement plugins
Plug 'easymotion/vim-easymotion'
" Plug 'vim-scripts/a.vim'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-surround'

call plug#end()

let mapleader=" "
nnoremap <silent> <Leader> :WhichKey '<Space>'<CR>

"LSP
set updatetime=300
set shortmess+=c
set signcolumn=yes
set cmdheight=2

autocmd CursorHold * silent call CocActionAsync('highlight')

inoremap <silent><expr> <c-space> coc#refresh()
inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"

nmap <silent> <Leader>ep <Plug>(coc-diagnostic-prev)
nmap <silent> <Leader>en <Plug>(coc-diagnostic-next)

nmap <silent> <Leader>jd <Plug>(coc-definition)
nmap <silent> <Leader>jt <Plug>(coc-type-definition)
nmap <silent> <Leader>ji <Plug>(coc-implementation)
nmap <silent> <Leader>jr <Plug>(coc-references)

nmap <Leader>da <Plug>(coc-codeaction)

nnoremap <silent> <Leader>df :call CocAction('format')<CR>

function! s:show_documentation()
  if &filetype == 'vim'
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction
nnoremap <silent> <Leader>jh :call <SID>show_documentation()<CR>

nmap <Leader>r <Plug>(coc-rename)

nnoremap <silent> <Leader>ee  :<C-u>CocList diagnostics<cr>
nnoremap <silent> <Leader>fd  :<C-u>CocList outline<cr>
nnoremap <silent> <Leader>fw  :<C-u>CocList -I symbols<cr>
nnoremap <silent> <Leader>ean  :<C-u>CocNext<CR>
nnoremap <silent> <Leader>epn  :<C-u>CocPrev<CR>
nnoremap <silent> <Leader>or  :<C-u>CocListResume<CR>

"Autocomplete
set completeopt=noinsert,menuone,noselect
inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
" let g:ale_completion_enabled = 1
let g:LanguageClient_serverCommands = {
    \ 'rust': ['rustup', 'run', 'nightly', 'rls'],
    \ 'javascript': ['/opt/javascript-typescript-langserver/lib/language-server-stdio.js'],
    \ 'haskell': ['hie-wrapper', '--vomit', '--lsp', '-l', 'hie.log'],
    \ 'cpp': ['clangd'],
    \ 'tex': ['java', '-jar', '/home/jack/.local/bin/texlab.jar'],
    \ 'python': ['pyls'],
    \ }

"Qol changes
set background=dark
filetype plugin indent on
set relativenumber 
set number  
set hidden " don't close when switching buffers
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
let g:livepreview_previewer = 'zathura'

"General ui stuff
set termguicolors
colorscheme palenight
let g:palenight_terminal_italics=1
set timeoutlen=500


"Airlines

set laststatus=2
let g:lightline = {
      \ 'colorscheme': 'palenight',
      \ }
set noshowmode


"Easy motion

" <Leader>f{char} to move to {char}
" map  <Leader>c <Plug>(easymotion-bd-f)
nmap <Leader>jc <Plug>(easymotion-overwin-f)
" s{char}{char} to move to {char}{char}
nmap <Leader>j2c <Plug>(easymotion-overwin-f2)
" " Move to line
nmap <Leader>jl <Plug>(easymotion-overwin-line)
" " Move to word
nmap <Leader>jw <Plug>(easymotion-overwin-w)


" FZF - Fuzzy finder
nnoremap <Leader>of :Files<CR>
nnoremap <Leader>op :GFiles<CR>
nnoremap <Leader>ob :Buffers<CR>
nnoremap <Leader>ol :Lines<CR>
nnoremap <Leader>oc :Commands<CR>
autocmd! FileType fzf
autocmd  FileType fzf set laststatus=0 noshowmode noruler
  \| autocmd BufLeave <buffer> set laststatus=2 showmode ruler

" FILETYPE SPECIFIC CONFIGURATIONS ===========================================
" Automatically break lines at 80 characters on TeX/LaTeX, Markdown, and text
" files
" Enable spell check on TeX/LaTeX, Markdown, and text files
autocmd BufNewFile,BufRead *.tex,*.md,*.txt,*.rst setlocal tw=80
autocmd BufNewFile,BufRead *.tex,*.md,*.txt,*.rst setlocal linebreak breakindent
autocmd BufNewFile,BufRead *.tex,*.md,*.txt,*.rst setlocal spell spelllang=en_us
autocmd BufNewFile,BufRead *.tex,*.md,*.txt,*.rst highlight Over100Length none
au BufRead,BufNewFile *.sbt set filetype=scala

call plug#begin('~/.vim/plugged')
" Generic language plugins,
Plug 'sheerun/vim-polyglot' " For random language support
Plug 'calviken/vim-gdscript3' " Sometimes I open Godot files

" Autocomplete extensions
Plug 'neoclide/coc.nvim', {'do': { -> coc#util#install()}}
Plug 'derekwyatt/vim-scala'

Plug 'xuhdev/vim-latex-live-preview'
Plug 'rhysd/vim-grammarous'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'


"Ui changes
Plug 'airblade/vim-gitgutter' " Show git info
Plug 'junegunn/rainbow_parentheses.vim' " Make parentheses cooler
Plug 'tpope/vim-sleuth' " Pick the right tab/spacing automatically
Plug 'drewtempelmeyer/palenight.vim' " My color scheme
Plug 'itchyny/lightline.vim' " The status bar
Plug 'liuchengxu/vim-which-key', { 'on': ['WhichKey', 'WhichKey!'] } " I like spacemacs

"Movement plugins
Plug 'easymotion/vim-easymotion' " Replace ALL the keybindings
Plug 'tpope/vim-commentary' " gcc to comment a line
Plug 'tpope/vim-surround' " Some surround commands I should use more often

call plug#end()

" I like spacemacs
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

" Error searching
nmap <silent> <Leader>pe <Plug>(coc-diagnostic-prev)
nmap <silent> <Leader>ne <Plug>(coc-diagnostic-next)

nmap <silent> <Leader>gd <Plug>(coc-definition)
nmap <silent> <Leader>gt <Plug>(coc-type-definition)
nmap <silent> <Leader>gi <Plug>(coc-implementation)
nmap <silent> <Leader>gr <Plug>(coc-references)

nmap <Leader>a <Plug>(coc-codeaction)

nnoremap <silent> <Leader>f :call CocAction('format')<CR>

function! s:show_documentation()
  if &filetype == 'vim'
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction
nnoremap <silent> <Leader>gh :call <SID>show_documentation()<CR>

nmap <Leader>lr <Plug>(coc-rename)

nnoremap <silent> <Leader>se  :<C-u>CocList diagnostics<cr>
nnoremap <silent> <Leader>so  :<C-u>CocList outline<cr>
nnoremap <silent> <Leader>ss  :<C-u>CocList -I symbols<cr>
nnoremap <silent> <Leader>nc  :<C-u>CocNext<CR>
nnoremap <silent> <Leader>pc  :<C-u>CocPrev<CR>
nnoremap <silent> <Leader>sr  :<C-u>CocListResume<CR>

"Autocomplete
set completeopt=noinsert,menuone,noselect
inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"

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
set inccommand=split
set smartcase     " ignore case if search pattern is all lowercase,
                    "    case-sensitive otherwise
set pastetoggle=<F2>
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
let g:EasyMotion_keys = 'abcdefghijklmnopqrst'

" <Leader>f{char} to move to {char}
" Let's replace some of the default bindings
let g:EasyMotion_startofline = 0
map f <Plug>(easymotion-f)
map F <Plug>(easymotion-F)
map t <Plug>(easymotion-t)
map T <Plug>(easymotion-t)
" Let's replace EVEN MORE bindings
map J gj
map K gk
noremap W w
noremap B b
map j <Plug>(easymotion-j)
map k <Plug>(easymotion-k)
map w <Plug>(easymotion-w)
map b <Plug>(easymotion-b)
nmap s <Plug>(easymotion-bd-f)

" Generic mappings
nmap <Leader>w :w<CR>
nmap <Leader>q :q<CR>


" FZF - Fuzzy finder
nnoremap <Leader>of :Files<CR>
nnoremap <Leader>op :GFiles<CR>
nnoremap <Leader>ob :Buffers<CR>
nnoremap <Leader>ol :Lines<CR>
nnoremap <Leader>oc :Commands<CR>
autocmd! FileType fzf
autocmd  FileType fzf set laststatus=0 noshowmode noruler
  \| autocmd BufLeave <buffer> set laststatus=2 showmode ruler


" pdflatex configuration
let g:livepreview_engine = 'pdflatex' . ' -shell-escape'

" FILETYPE SPECIFIC CONFIGURATIONS ===========================================
" Automatically break lines at 80 characters on TeX/LaTeX, Markdown, and text
" files
" Enable spell check on TeX/LaTeX, Markdown, and text files
autocmd BufNewFile,BufRead *.tex,*.md,*.txt,*.rst setlocal tw=80
autocmd BufNewFile,BufRead *.tex,*.md,*.txt,*.rst setlocal linebreak breakindent
autocmd BufNewFile,BufRead *.tex,*.md,*.txt,*.rst setlocal spell spelllang=en_us
autocmd BufNewFile,BufRead *.tex,*.md,*.txt,*.rst highlight Over100Length none
au BufRead,BufNewFile *.sbt set filetype=scala

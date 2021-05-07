""""""
""""""
"""""
""""""
""""""
""""""


 let mapleader=" "
 if !exists('g:vscode')
  call plug#begin('~/.vim/plugged')
  " Generic language plugins,
  " Plug 'sheerun/vim-polyglot' " For random language support
  Plug 'jhgarner/ui-experiments', {'dir': '~/code/unknown/AuraUI'}
  Plug 'sheerun/vim-polyglot' " For random language support
  " Plug 'calviken/vim-gdscript3' " Sometimes I open Godot files
  Plug 'bivab/prob.vim'
  Plug 'LnL7/vim-nix'
  Plug 'plasticboy/vim-markdown'

  " Autocomplete extensions
  Plug 'neoclide/coc.nvim', {'branch': 'release'}
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
  Plug 'NLKNguyen/papercolor-theme'
  Plug 'ayu-theme/ayu-vim'
  Plug 'ghifarit53/tokyonight-vim'
  Plug 'sainnhe/sonokai'


  " Plug 'rakr/vim-one'
  Plug 'joshdick/onedark.vim'
  " Plug 'rakr/vim-one'
  " Plug 'yarisgutierrez/ayu-lightline'


  "Movement plugins
  " Plug 'phaazon/hop.nvim' " , {'dir': '~/sources/vim-easymotion/'} Replace ALL the keybindings
  " Plug 'phaazon/hop.nvim', {'dir': '~/code/lua/hop.nvim'} " , {'dir': '~/sources/vim-easymotion/'} Replace ALL the keybindings
  Plug 'jhgarner/hop.nvim', {'branch': 'feature/additional-motions', 'dir': '~/code/lua/hop.nvim'}
  " Plug 'jhgarner/hop.nvim', {'branch': 'feature/additional-motions'}
  " Plug 'easymotion/vim-easymotion' " , {'dir': '~/sources/vim-easymotion/'} Replace ALL the keybindings
  Plug 'tpope/vim-commentary' " gcc to comment a line
  Plug 'tpope/vim-surround' " Some surround commands I should use more often
  Plug 'tweekmonster/helpful.vim'

  call plug#end()


  " I like spacemacs
  let mapleader=" "
  nnoremap <silent> <Leader> :WhichKey '<Space>'<CR>

  "LSP
  set updatetime=300
  set shortmess+=c
  set signcolumn=yes
  set cmdheight=2

  " autocmd CursorHold * silent call CocActionAsync('highlight')

  " inoremap <silent><expr> <c-space> coc#refresh()
  " inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"

  " " Error searching
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
  let g:rainbow#pairs = [['(', ')'], ['[', ']'], ['{', '}']]
  let g:rainbow#blacklist = ['#3E4452']
  let g:livepreview_previewer = 'zathura'

  "General ui stuff
  set termguicolors
  let ayucolor="light"
  let g:onedark_terminal_italics = 2

  colorscheme onedark
  " colorscheme ayu
  let g:tokyonight_style = 'night' " available: night, storm
let g:tokyonight_enable_italic = 1

" colorscheme tokyonight
let g:sonokai_style = 'andromeda'
        let g:sonokai_enable_italic = 1
        let g:sonokai_disable_italic_comment = 1
        " colorscheme sonokai
  " set t_Co=256
  " set background=light
  " colorscheme PaperColor
  " let g:palenight_terminal_italics=1
  set timeoutlen=500


  "Airlines

  set laststatus=2
  let g:lightline = {
        \ 'colorscheme': 'onedark',
        \ }
  set noshowmode

  " hi Normal guibg=NONE ctermbg=NONE


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

  " au BufRead,BufNewFile *.gd set filetype=godot

  nnoremap <Leader>ot :CocCommand explorer<CR>
  nnoremap <Leader>a :CocCommand actions.open<CR>
else
  call plug#begin('~/.vim/plugged')
  "Movement plugins
  Plug 'asvetliakov/vim-easymotion', { 'as': 'easyFork' } " Replace ALL the keybindings
  " Plug 'tpope/vim-commentary' " gcc to comment a line
  Plug 'tpope/vim-surround' " Some surround commands I should use more often
  call plug#end()


  nmap <Leader>w :Write<CR>
  nmap <Leader>q :Quit<CR>
  " Generic mappings
  nmap <Leader>of :call VSCodeNotify("workbench.action.quickOpen")<CR>
  nmap <Leader>or :call VSCodeNotify("workbench.action.quickOpenRecent")<CR>
  nmap <Leader>op :call VSCodeNotify("workbench.action.files.openFolder")<CR>
  " nmap <Space><Space> :call VSCodeNotify("workbench.action.showCommands")<CR>
  nmap <Leader>c :call VSCodeNotify("workbench.action.showCommands")<CR>
  nmap <Leader>je :call VSCodeNotify("editor.action.marker.nextInFiles")<CR>
  nmap <Leader>Je :call VSCodeNotify("editor.action.marker.prevInFiles")<CR>
  nmap <Leader>nw :call VSCodeNotify("workbench.action.newWindow")<CR>
  nmap <Leader>dw :call VSCodeNotify("workbench.action.closeWindow")<CR>
  nmap <Leader>t :call VSCodeNotify("workbench.action.terminal.toggleTerminal")<CR>


  set background=dark
  filetype plugin indent on
  set hidden " don't close when switching buffers
  set tabstop=2     " a tab is two spaces
  " set copyindent    " copy the previous indentation on autoindenting
  set shiftwidth=2  " number of spaces to use for autoindenting
  set expandtab " On pressing tab, insert 2 spaces
  set shiftround    " use multiple of shiftwidth when indenting with '<' and '>'
  set smartcase     " ignore case if search pattern is all lowercase,
                      "    case-sensitive otherwise
  nmap <silent> ,, :nohlsearch<CR>

  autocmd BufNewFile,BufRead *.tex,*.md,*.txt,*.rst setlocal tw=80
  autocmd BufNewFile,BufRead *.tex,*.md,*.txt,*.rst setlocal linebreak breakindent
  " autocmd BufNewFile,BufRead *.tex,*.md,*.txt,*.rst setlocal spell spelllang=en_us
  autocmd BufNewFile,BufRead *.tex,*.md,*.txt,*.rst highlight Over100Length none


  xmap gc  <Plug>VSCodeCommentary
  nmap gc  <Plug>VSCodeCommentary
  omap gc  <Plug>VSCodeCommentary
  nmap gcc <Plug>VSCodeCommentaryLine

endif

" nnoremap <silent> <Leader> :WhichKey '<Space>'<CR>

"Easy motion
lua require'hop'.setup { keys = 'abcdefghijklmnopqrst', term_seq_bias = 0.5 }


" <Leader>f{char} to move to {char}
" Let's replace some of the default bindings
map f <cmd>HopFind<CR>
map F <cmd>HopFindBefore<CR>
map t <cmd>HopFindTo<CR>
map T <cmd>HopFindToBefore<CR>
" nmap <Space> c :Commands<CR>
" Let's replace EVEN MORE bindings
noremap C J
map K :<CR>
map k :<CR>

map j <cmd>HopLineDown<CR>
map J <cmd>HopLineUp<CR>
map w <cmd>HopWordAfter<CR>
map W <cmd>HopWordBefore<CR>

map e <cmd>HopWordEndAfter<CR>
map E <cmd>HopWordEndBefore<CR>
map s <cmd>HopChar1<CR>
au BufRead,BufNewFile *.myui setfiletype myui
set foldcolumn=2

set foldmethod=syntax
set foldnestmax=2

let g:vim_markdown_conceal = 0

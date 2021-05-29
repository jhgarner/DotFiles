call plug#begin('~/.vim/plugged')

" Lua dependencies
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-lua/popup.nvim'

" Generic language plugins,
Plug 'sheerun/vim-polyglot' " For random language support
Plug 'jhgarner/ui-experiments', {'dir': '~/code/unknown/AuraUI'}
Plug 'LnL7/vim-nix'
Plug 'plasticboy/vim-markdown'

" Autocomplete/LSP extensions
Plug 'neovim/nvim-lspconfig'
Plug 'glepnir/lspsaga.nvim', {'branch': 'main'}
Plug 'nvim-lua/lsp-status.nvim'
Plug 'hrsh7th/nvim-compe'

Plug 'derekwyatt/vim-scala'
Plug 'xuhdev/vim-latex-live-preview'
Plug 'rhysd/vim-grammarous'


"Ui changes
Plug 'nvim-telescope/telescope.nvim'
Plug 'lewis6991/gitsigns.nvim'
Plug 'junegunn/rainbow_parentheses.vim' " Make parentheses cooler
Plug 'tpope/vim-sleuth' " Pick the right tab/spacing automatically
Plug 'folke/which-key.nvim', {'branch': 'main'}
Plug 'monsonjeremy/onedark.nvim'
Plug 'datwaft/bubbly.nvim'

"Movement plugins
" Plug 'phaazon/hop.nvim', {'dir': '~/code/lua/hop.nvim'} " , {'dir': '~/sources/vim-easymotion/'} Replace ALL the keybindings
" Until phaazon updates, use my own branch
Plug 'jhgarner/hop.nvim', {'branch': 'mergedall'}
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-surround'

call plug#end()

let mapleader=" "

" ======= LSP stuff =======
lua require'lspconfig'.hls.setup{}
lua require'lspconfig'.pyright.setup{}

lua require 'lspsaga'.init_lsp_saga()

set updatetime=300
set shortmess+=c
set signcolumn=yes
set cmdheight=1
set completeopt=menuone,noselect

nnoremap <silent><leader>gh <cmd>lua require'lspsaga.provider'.lsp_finder()<CR>
nnoremap <silent> k <cmd>lua require('lspsaga.codeaction').code_action()<CR>
vnoremap <silent> k :<C-U>lua require('lspsaga.codeaction').range_code_action()<CR>
nnoremap <silent> K <cmd>lua require('lspsaga.hover').render_hover_doc()<CR>
nnoremap <silent> <leader>j <cmd>lua require('lspsaga.action').smart_scroll_with_saga(1)<CR>
nnoremap <silent> <leader>J <cmd>lua require('lspsaga.action').smart_scroll_with_saga(-1)<CR>
nnoremap <silent><leader>s <cmd>lua require('lspsaga.signaturehelp').signature_help()<CR>
nnoremap <silent><leader>r <cmd>lua require('lspsaga.rename').rename()<CR>
nnoremap <silent> <leader>gd <cmd>lua require'lspsaga.provider'.preview_definition()<CR>
nnoremap <silent><leader>d <cmd>lua require'lspsaga.diagnostic'.show_line_diagnostics()<CR>
nnoremap <silent> <leader>ne <cmd>lua require'lspsaga.diagnostic'.lsp_jump_diagnostic_prev()<CR>
nnoremap <silent> <leader>pe <cmd>lua require'lspsaga.diagnostic'.lsp_jump_diagnostic_next()<CR>

" nvim-compe has a lot of config options (all copy and pasted from github)
let g:compe = {}
let g:compe.enabled = v:true
let g:compe.autocomplete = v:true
let g:compe.debug = v:false
let g:compe.min_length = 1
let g:compe.preselect = 'enable'
let g:compe.throttle_time = 80
let g:compe.source_timeout = 200
let g:compe.incomplete_delay = 400
let g:compe.max_abbr_width = 100
let g:compe.max_kind_width = 100
let g:compe.max_menu_width = 100
let g:compe.documentation = v:true

let g:compe.source = {}
let g:compe.source.path = v:true
let g:compe.source.buffer = v:true
let g:compe.source.calc = v:true
let g:compe.source.nvim_lsp = v:true
let g:compe.source.nvim_lua = v:true
let g:compe.source.vsnip = v:true
let g:compe.source.ultisnips = v:true

inoremap <silent><expr> <C-Space> compe#complete()
inoremap <silent><expr> <CR>      compe#confirm('<CR>')
inoremap <silent><expr> <C-e>     compe#close('<C-e>')
inoremap <silent><expr> <C-f>     compe#scroll({ 'delta': +4 })
inoremap <silent><expr> <C-d>     compe#scroll({ 'delta': -4 })

highlight link CompeDocumentation NormalFloat

lua << EOF
local t = function(str)
  return vim.api.nvim_replace_termcodes(str, true, true, true)
end

local check_back_space = function()
    local col = vim.fn.col('.') - 1
    if col == 0 or vim.fn.getline('.'):sub(col, col):match('%s') then
        return true
    else
        return false
    end
end

-- Use (s-)tab to:
--- move to prev/next item in completion menuone
--- jump to prev/next snippet's placeholder
_G.tab_complete = function()
  if vim.fn.pumvisible() == 1 then
    return t "<C-n>"
  elseif vim.fn.call("vsnip#available", {1}) == 1 then
    return t "<Plug>(vsnip-expand-or-jump)"
  elseif check_back_space() then
    return t "<Tab>"
  else
    return vim.fn['compe#complete']()
  end
end
_G.s_tab_complete = function()
  if vim.fn.pumvisible() == 1 then
    return t "<C-p>"
  elseif vim.fn.call("vsnip#jumpable", {-1}) == 1 then
    return t "<Plug>(vsnip-jump-prev)"
  else
    -- If <S-Tab> is not working in your terminal, change it to <C-h>
    return t "<S-Tab>"
  end
end

vim.api.nvim_set_keymap("i", "<Tab>", "v:lua.tab_complete()", {expr = true})
vim.api.nvim_set_keymap("s", "<Tab>", "v:lua.tab_complete()", {expr = true})
vim.api.nvim_set_keymap("i", "<S-Tab>", "v:lua.s_tab_complete()", {expr = true})
vim.api.nvim_set_keymap("s", "<S-Tab>", "v:lua.s_tab_complete()", {expr = true})
EOF


" ======= Other UI plugins that depend on LUA =======

lua << EOF
require("which-key").setup {}
vim.g.bubbly_palette = {
background = "#282c34",
foreground = "#c5cdd9",
black = "#3e4249",
red = "#ec7279",
green = "#a0c980",
yellow = "#deb974",
blue = "#6cb6eb",
purple = "#d38aea",
cyan = "#5dbbc1",
white = "#c5cdd9",
lightgrey = "#57595e",
darkgrey = "#404247",
}
vim.g.bubbly_statusline = {
'mode',

'truncate',

'path',
'branch',
'signify',
-- 'builtinlsp.diagnostic_count',
'builtinlsp.current_function',
'lsp_status.diagnostics',
'lsp_status.messages',

'divisor',

'filetype',
'progress',
}
EOF



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

"rainbow configuration
autocmd FileType * RainbowParentheses
let g:rainbow#max_level = 16
let g:rainbow#pairs = [['(', ')'], ['[', ']'], ['{', '}']]
let g:rainbow#blacklist = ['#3E4452']
let g:livepreview_previewer = 'zathura'

"General ui stuff
set termguicolors
colorscheme onedark
set timeoutlen=500
set noshowmode


" Generic mappings
nmap <Leader>w <cmd>w<CR>
nmap <Leader>q <cmd>q<CR>


" Telescope ~ FZF
nnoremap <Leader>of <cmd>lua require'telescope.builtin'.find_files{}<CR>
nnoremap <Leader>og <cmd>lua require'telescope.builtin'.live_grep{}<CR>
nnoremap <Leader>/ <cmd>lua require'telescope.builtin'.live_grep{grep_open_files = true}<CR>
nnoremap <Leader>nf <cmd>lua require'telescope.builtin'.file_browser{}<CR>
nnoremap <Leader>ob <cmd>lua require'telescope.builtin'.buffers{}<CR>
nnoremap <Leader>oc <cmd>lua require'telescope.builtin'.commands{}<CR>
nnoremap <Leader>oht <cmd>lua require'telescope.builtin'.help_tags{}<CR>
nnoremap <Leader>ohm <cmd>lua require'telescope.builtin'.man_pages{}<CR>
nnoremap <Leader>om <cmd>lua require'telescope.builtin'.marks{}<CR>
nnoremap <Leader>s <cmd>lua require'telescope.builtin'.spell_suggest{}<CR>


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


"Easy motion
lua require'hop'.setup { keys = 'abcdefghijklmnopqrst' }
lua require'gitsigns'.setup {}


" Let's replace some of the default bindings
map f <cmd>HopFind<CR>
map F <cmd>HopFindBefore<CR>
map t <cmd>HopFindTo<CR>
map T <cmd>HopFindToBefore<CR>

" Let's replace EVEN MORE bindings
noremap C J

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

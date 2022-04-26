call plug#begin('~/.vim/plugged')

" Lua dependencies
Plug 'nvim-lua/plenary.nvim'

" " Generic language plugins,
Plug 'sheerun/vim-polyglot' " For random language support
Plug 'jhgarner/ui-experiments', {'dir': '~/code/unknown/AuraUI'}
Plug 'LnL7/vim-nix'
" Plug 'plasticboy/vim-markdown'

" Autocomplete/LSP extensions
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'h-youhei/vim-cabal-indent'
" Plug 'neovim/nvim-lspconfig'
" Plug 'glepnir/lspsaga.nvim', {'branch': 'main'}
" Plug 'nvim-lua/lsp-status.nvim'
" Plug 'hrsh7th/nvim-cmp'
" Plug 'hrsh7th/vim-vsnip'
" Plug 'hrsh7th/vim-vsnip-integ'
" Plug 'hrsh7th/cmp-nvim-lsp'
" Plug 'hrsh7th/cmp-buffer'
" Plug 'hrsh7th/cmp-path'

" Plug 'jhgarner/nvim-lspinstall', {'branch': 'main'}
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}  " We recommend updating the parsers on update
Plug 'Olical/conjure', {'tag': 'v4.22.1'}
Plug 'nvim-lualine/lualine.nvim'
Plug 'Olical/aniseed', { 'tag': 'v3.20.0' }
" Plug 'tami5/compe-conjure'
Plug 'habamax/vim-godot'
" Plug 'sainnhe/sonokai'
Plug 'sainnhe/everforest'
" Plug 'simrat39/rust-tools.nvim'
Plug 'qnighy/lalrpop.vim'
Plug 'dart-lang/dart-vim-plugin'



Plug 'derekwyatt/vim-scala'
" Plug 'xuhdev/vim-latex-live-preview'
Plug 'rhysd/vim-grammarous'


"Ui changes
Plug 'nvim-telescope/telescope.nvim'
Plug 'lewis6991/gitsigns.nvim'
Plug 'junegunn/rainbow_parentheses.vim' " Make parentheses cooler
Plug 'tpope/vim-sleuth' " Pick the right tab/spacing automatically
Plug 'folke/which-key.nvim', {'branch': 'main'}
Plug 'monsonjeremy/onedark.nvim'
" Plug 'datwaft/bubbly.nvim'
" Plug 'windwp/windline.nvim'
Plug 'hrsh7th/vim-vsnip'

"Movement plugins
" Plug 'phaazon/hop.nvim', {'dir': '~/code/lua/hop.nvim'} " , {'dir': '~/sources/vim-easymotion/'} Replace ALL the keybindings
" Until phaazon updates, use my own branch
Plug 'jhgarner/hop.nvim', {'branch': 'mergedall'}
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-surround'

call plug#end()

let mapleader=" "
let maplocalleader=" "

"General ui stuff
" set termguicolors
" colorscheme onedark
set termguicolors
" colorscheme sonokai
" set bg=light
let g:everforest_background = 'hard'
colorscheme everforest

" ======= LSP stuff =======
" lua require'lspconfig'.hls.setup{}
" lua require'lspconfig'.pyright.setup{}
" lua require'lspconfig'.dartls.setup{}
" lua require'lspconfig'.gdscript.setup{}
" lua require('rust-tools').setup({})
" lua require'lspconfig'.rnix.setup{}

" lua require 'lspsaga'.init_lsp_saga()

" lua <<EOF
" require'nvim-treesitter.configs'.setup {
"   highlight = {
"     enable = true,
"     custom_captures = {
"       -- Highlight the @foo.bar capture group with the "Identifier" highlight group.
"       -- ["foo.bar"] = "Identifier",
"     },
"   },
"   indent = {
"     enable = true
"   }
" }
" EOF

set updatetime=300
set shortmess+=c
" set signcolumn=yes
" set signcolumn=number
set cmdheight=2
set completeopt=menuone,noselect

inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <c-space> to trigger completion.
if has('nvim')
  inoremap <silent><expr> <c-space> coc#refresh()
else
  inoremap <silent><expr> <c-@> coc#refresh()
endif

" Make <CR> auto-select the first completion item and notify coc.nvim to
" format on enter, <cr> could be remapped by other vim plugin
inoremap <silent><expr> <cr> pumvisible() ? coc#_select_confirm()
                              \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

" Use `[g` and `]g` to navigate diagnostics
" Use `:CocDiagnostics` to get all diagnostics of current buffer in location list.
nmap <silent> <leader>ep <Plug>(coc-diagnostic-prev)
nmap <silent> <leader>en <Plug>(coc-diagnostic-next)

" GoTo code navigation.
nmap <silent> <leader>gd <Plug>(coc-definition)
nmap <silent> <leader>gt <Plug>(coc-type-definition)
nmap <silent> <leader>gi <Plug>(coc-implementation)
nmap <silent> <leader>gr <Plug>(coc-references)

" Use K to show documentation in preview window.
nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  elseif (coc#rpc#ready())
    call CocActionAsync('doHover')
  else
    execute '!' . &keywordprg . " " . expand('<cword>')
  endif
endfunction

" Highlight the symbol and its references when holding the cursor.
autocmd CursorHold * silent call CocActionAsync('highlight')

" Symbol renaming.
nmap <leader>rn <Plug>(coc-rename)

" Formatting selected code.
xmap <leader>f  <Plug>(coc-format-selected)
" nmap <leader>f  <Plug>(coc-format-selected)
nmap <leader>f  <plug>(coc-format)

augroup mygroup
  autocmd!
  " Setup formatexpr specified filetype(s).
  autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
  " Update signature help on jump placeholder.
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end

" Applying codeAction to the selected region.
" Example: `<leader>aap` for current paragraph
xmap <leader>a  <Plug>(coc-codeaction-selected)

" Remap keys for applying codeAction to the current buffer.
nmap <leader>ac  <Plug>(coc-codeaction)
" Apply AutoFix to problem on the current line.
nmap <leader>af  <Plug>(coc-fix-current)

nnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
nnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
inoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(1)\<cr>" : "\<Right>"
inoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(0)\<cr>" : "\<Left>"
vnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
vnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"

" nnoremap <silent><leader>gh <cmd>lua require'lspsaga.provider'.lsp_finder()<CR>
" nnoremap <silent> k <cmd>lua require('lspsaga.codeaction').code_action()<CR>
" vnoremap <silent> k :<C-U>lua require('lspsaga.codeaction').range_code_action()<CR>
" nnoremap <silent> K <cmd>lua require('lspsaga.hover').render_hover_doc()<CR>
" nnoremap <silent> <leader>j <cmd>lua require('lspsaga.action').smart_scroll_with_saga(1)<CR>
" nnoremap <silent> <leader>J <cmd>lua require('lspsaga.action').smart_scroll_with_saga(-1)<CR>
" nnoremap <silent><leader>s <cmd>lua require('lspsaga.signaturehelp').signature_help()<CR>
" nnoremap <silent><leader>r <cmd>lua require('lspsaga.rename').rename()<CR>
" nnoremap <silent> <leader>gd <cmd>lua require'lspsaga.provider'.preview_definition()<CR>
" nnoremap <silent><leader>d <cmd>lua require'lspsaga.diagnostic'.show_line_diagnostics()<CR>
" nnoremap <silent> <leader>ne <cmd>lua require'lspsaga.diagnostic'.lsp_jump_diagnostic_prev()<CR>
" nnoremap <silent> <leader>pe <cmd>lua require'lspsaga.diagnostic'.lsp_jump_diagnostic_next()<CR>
" nnoremap <silent> <leader>f <cmd>lua vim.lsp.buf.formatting()<CR>


" lua << EOF
" require'lspinstall'.setup()

" local servers = require'lspinstall'.installed_servers()
" for _, server in pairs(servers) do
"   require'lspconfig'[server].setup{}
" end

" local has_words_before = function()
"   local line, col = unpack(vim.api.nvim_win_get_cursor(0))
"   return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match('%s') == nil
" end

" local cmp = require'cmp'
"   cmp.setup({
"     snippet = {
"       expand = function(args)
"         vim.fn["vsnip#anonymous"](args.body)
"       end,
"     },
"     mapping = {
"       ['<C-j>'] = cmp.mapping.scroll_docs(-4),
"       ['<C-J>'] = cmp.mapping.scroll_docs(4),
"       ['<C-Space>'] = cmp.mapping.complete(),
"       ['<C-e>'] = cmp.mapping.close(),
"       ['<CR>'] = cmp.mapping.confirm({
"         behavior = cmp.ConfirmBehavior.Replace,
"         select = true,
"       }),
"     ['<Tab>'] = cmp.mapping(function(fallback)
"       if vim.fn.pumvisible() == 1 then
"         vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<C-n>', true, true, true), 'n', true)
"       elseif has_words_before() and vim.fn['vsnip#available']() == 1 then
"         vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<Plug>(vsnip-expand-or-jump)', true, true, true), '', true)
"       else
"         fallback() -- The fallback function sends a already mapped key. In this case, it's probably `<Tab>`.
"       end
"     end, { 'i', 's' }),

"     ['<S-Tab>'] = cmp.mapping(function()
"       if vim.fn.pumvisible() == 1 then
"         vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<C-p>', true, true, true), 'n', true)
"       elseif vim.fn['vsnip#jumpable'](-1) == 1 then
"         vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<Plug>(vsnip-jump-prev)', true, true, true), '', true)
"       end
"     end, { 'i', 's' })
"     },
"     sources = {
"       { name = 'buffer' },
"       { name = 'path' },
"       { name = 'nvim_lsp' }
"     }
"   })
" EOF

" nvim-compe has a lot of config options (all copy and pasted from github)


" let g:compe = {}
" let g:compe.enabled = v:true
" let g:compe.autocomplete = v:true
" let g:compe.debug = v:false
" let g:compe.min_length = 1
" let g:compe.preselect = 'enable'
" let g:compe.throttle_time = 80
" let g:compe.source_timeout = 200
" let g:compe.incomplete_delay = 400
" let g:compe.max_abbr_width = 100
" let g:compe.max_kind_width = 100
" let g:compe.max_menu_width = 100
" let g:compe.documentation = v:true

" let g:compe.source = {}
" let g:compe.source.conjure = v:true
" let g:compe.source.path = v:true
" let g:compe.source.buffer = v:true
" let g:compe.source.calc = v:true
" let g:compe.source.nvim_lsp = v:true
" let g:compe.source.nvim_lua = v:true
" let g:compe.source.vsnip = v:true
" let g:compe.source.ultisnips = v:true

" inoremap <silent><expr> <C-Space> compe#complete()
" inoremap <silent><expr> <CR>      compe#confirm('<CR>')
" inoremap <silent><expr> <C-e>     compe#close('<C-e>')
" inoremap <silent><expr> <C-f>     compe#scroll({ 'delta': +4 })
" inoremap <silent><expr> <C-d>     compe#scroll({ 'delta': -4 })

" highlight link CompeDocumentation NormalFloat

" lua << EOF
" local t = function(str)
"   return vim.api.nvim_replace_termcodes(str, true, true, true)
" end

" local check_back_space = function()
"     local col = vim.fn.col('.') - 1
"     if col == 0 or vim.fn.getline('.'):sub(col, col):match('%s') then
"         return true
"     else
"         return false
"     end
" end

" -- Use (s-)tab to:
" --- move to prev/next item in completion menuone
" --- jump to prev/next snippet's placeholder
" -- _G.tab_complete = function()
"   -- if vim.fn.pumvisible() == 1 then
"     -- return t "<C-n>"
"   -- elseif vim.fn.call("vsnip#available", {1}) == 1 then
"     -- return t "<Plug>(vsnip-expand-or-jump)"
"   -- elseif check_back_space() then
"     -- return t "<Tab>"
"   -- else
"     -- return vim.fn['compe#complete']()
"   -- end
" -- end
" -- _G.s_tab_complete = function()
"   -- if vim.fn.pumvisible() == 1 then
"     -- return t "<C-p>"
"   -- elseif vim.fn.call("vsnip#jumpable", {-1}) == 1 then
"     -- return t "<Plug>(vsnip-jump-prev)"
"   -- else
"     -- -- If <S-Tab> is not working in your terminal, change it to <C-h>
"     -- return t "<S-Tab>"
"   -- end
" -- end

" -- vim.api.nvim_set_keymap("i", "<Tab>", "v:lua.tab_complete()", {expr = true})
" -- vim.api.nvim_set_keymap("s", "<Tab>", "v:lua.tab_complete()", {expr = true})
" -- vim.api.nvim_set_keymap("i", "<S-Tab>", "v:lua.s_tab_complete()", {expr = true})
" -- vim.api.nvim_set_keymap("s", "<S-Tab>", "v:lua.s_tab_complete()", {expr = true})
" EOF


" ======= Other UI plugins that depend on LUA =======

lua << EOF
require("which-key").setup {}
local lualine = require('lualine')

-- Color table for highlights
-- stylua: ignore
local colors = {
  bg       = '#323c41',
  fg       = '#d3c6aa',
  yellow   = '#dbbc7f',
  cyan     = '#83c092',
  darkblue = '#7fbbb3',
  green    = '#a7c080',
  orange   = '#e69875',
  violet   = '#d699b6',
  magenta  = '#c678dd',
  blue     = '#7fbbb3',
  red      = '#e67e80',
}
local conditions = {
  buffer_not_empty = function()
    return vim.fn.empty(vim.fn.expand('%:t')) ~= 1
  end,
  hide_in_width = function()
    return vim.fn.winwidth(0) > 80
  end,
  check_git_workspace = function()
    local filepath = vim.fn.expand('%:p:h')
    local gitdir = vim.fn.finddir('.git', filepath .. ';')
    return gitdir and #gitdir > 0 and #gitdir < #filepath
  end,
}

-- Config
local config = {
  options = {
    -- Disable sections and component separators
    component_separators = '',
    theme = 'everforest',
    section_separators = '',
    theme = {
      -- We are going to use lualine_c an lualine_x as left and
      -- right section. Both are highlighted by c theme .  So we
      -- are just setting default looks o statusline
      normal = { c = { fg = colors.fg, bg = colors.bg } },
      inactive = { c = { fg = colors.fg, bg = colors.bg } },
    },
  },
  sections = {
    -- these are to remove the defaults
    lualine_a = {},
    lualine_b = {},
    lualine_y = {},
    lualine_z = {},
    -- These will be filled later
    lualine_c = {},
    lualine_x = {},
  },
  inactive_sections = {
    -- these are to remove the defaults
    lualine_a = {},
    lualine_b = {},
    lualine_y = {},
    lualine_z = {},
    lualine_c = {},
    lualine_x = {},
  },
}

-- Inserts a component in lualine_c at left section
local function ins_left(component)
  table.insert(config.sections.lualine_c, component)
end

-- Inserts a component in lualine_x ot right section
local function ins_right(component)
  table.insert(config.sections.lualine_x, component)
end

ins_left {
  function()
    return '▊'
  end,
  color = { fg = colors.blue }, -- Sets highlighting of component
  padding = { left = 0, right = 1 }, -- We don't need space before this
}

ins_left {
  -- mode component
  function()
    return ''
  end,
  color = function()
    -- auto change color according to neovims mode
    local mode_color = {
      n = colors.red,
      i = colors.green,
      v = colors.blue,
      [''] = colors.blue,
      V = colors.blue,
      c = colors.magenta,
      no = colors.red,
      s = colors.orange,
      S = colors.orange,
      [''] = colors.orange,
      ic = colors.yellow,
      R = colors.violet,
      Rv = colors.violet,
      cv = colors.red,
      ce = colors.red,
      r = colors.cyan,
      rm = colors.cyan,
      ['r?'] = colors.cyan,
      ['!'] = colors.red,
      t = colors.red,
    }
    return { fg = mode_color[vim.fn.mode()] }
  end,
  padding = { right = 1 },
}

ins_left {
  -- filesize component
  'filesize',
  cond = conditions.buffer_not_empty,
}

ins_left {
  'filename',
  cond = conditions.buffer_not_empty,
  color = { fg = colors.magenta, gui = 'bold' },
}

ins_left { 'location' }

ins_left { 'progress', color = { fg = colors.fg, gui = 'bold' } }

ins_left {
  'diagnostics',
  sources = { 'nvim_diagnostic' },
  symbols = { error = ' ', warn = ' ', info = ' ' },
  diagnostics_color = {
    color_error = { fg = colors.red },
    color_warn = { fg = colors.yellow },
    color_info = { fg = colors.cyan },
  },
}

-- Insert mid section. You can make any number of sections in neovim :)
-- for lualine it's any number greater then 2
ins_left {
  function()
    return '%='
  end,
}

ins_left {
  -- Lsp server name .
  'g:coc_status',
  icon = ' LSP:',
  color = { fg = '#ffffff', gui = 'bold' },
}

-- Add components to right sections
ins_right {
  'o:encoding', -- option component same as &encoding in viml
  fmt = string.upper, -- I'm not sure why it's upper case either ;)
  cond = conditions.hide_in_width,
  color = { fg = colors.green, gui = 'bold' },
}

ins_right {
  'fileformat',
  fmt = string.upper,
  icons_enabled = false, -- I think icons are cool but Eviline doesn't have them. sigh
  color = { fg = colors.green, gui = 'bold' },
}

ins_right {
  'branch',
  icon = '',
  color = { fg = colors.violet, gui = 'bold' },
}

ins_right {
  'diff',
  -- Is it me or the symbol for modified us really weird
  symbols = { added = ' ', modified = '柳 ', removed = ' ' },
  diff_color = {
    added = { fg = colors.green },
    modified = { fg = colors.orange },
    removed = { fg = colors.red },
  },
  cond = conditions.hide_in_width,
}

ins_right {
  function()
    return '▊'
  end,
  color = { fg = colors.blue },
  padding = { left = 1 },
}

-- Now don't forget to initialize lualine
lualine.setup(config)
EOF



"Qol changes
filetype plugin indent on
" set relativenumber 
set number  
set hidden " don't close when switching buffers
set nobackup
set nowritebackup
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

set timeoutlen=500
set noshowmode


" Generic mappings
nmap <Leader>w <cmd>w<CR>
nmap <Leader>q <cmd>q<CR>


" Telescope ~ FZF
nnoremap <Leader>of <cmd>lua require'telescope.builtin'.git_files{}<CR>
nnoremap <Leader>og <cmd>lua require'telescope.builtin'.live_grep{}<CR>
nnoremap <Leader>/ <cmd>lua require'telescope.builtin'.live_grep{grep_open_files = true}<CR>
nnoremap <Leader>nf <cmd>lua require'telescope.builtin'.file_browser{}<CR>
nnoremap <Leader>ob <cmd>lua require'telescope.builtin'.buffers{sort_lastused = true, theme = require'telescope.themes'.get_dropdown, previewer = false, ignore_current_buffer = true}<CR>
nnoremap <Leader>oc <cmd>lua require'telescope.builtin'.commands{}<CR>
nnoremap <Leader>oht <cmd>lua require'telescope.builtin'.help_tags{}<CR>
nnoremap <Leader>ohm <cmd>lua require'telescope.builtin'.man_pages{}<CR>
nnoremap <Leader>om <cmd>lua require'telescope.builtin'.marks{}<CR>
nnoremap <Leader>s <cmd>lua require'telescope.builtin'.spell_suggest{}<CR>

lua << EOF
require("telescope").setup {
  defaults = {
    -- file_sorter = require("telescope.sorters").get_fzy_sorter,
    mappings = {
      i = {
        ["<Esc>"] = require("telescope.actions").close
      }
    }
  },
  pickers = {
    buffers = {
      sort_lastused = true,
      theme = "dropdown",
      -- previewer = false
    }
  }
}
EOF


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
au BufRead,BufNewFile *.gd set filetype=gdscript


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

let g:vim_markdown_conceal = 0
" highlight HopNextKey guifg=red gui=bold
" highlight HopNextKey1 guifg=green gui=bold
" highlight HopNextKey2 guifg=green gui=bold

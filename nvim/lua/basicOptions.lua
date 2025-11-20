local vim = vim -- suppress lsp warnings
local o = vim.opt
local g = vim.g
o.tabstop = 2
o.shiftwidth = 2
o.softtabstop = 2
o.expandtab = true
g.mapleader = ' '
-- General
o.undofile    = true  -- Enable persistent undo (see also `:h undodir`)
o.backup      = false -- Don't store backup while overwriting the file
o.writebackup = false -- Don't store backup while overwriting the file
o.mouse       = 'a'   -- Enable mouse for all available modes
vim.cmd('filetype plugin indent on') -- Enable all filetype plugins

-- Appearance
o.breakindent   = true    -- Indent wrapped lines to match line start
o.cursorline    = true    -- Highlight current line
o.number        = true    -- Show line numbers
o.splitbelow    = true    -- Horizontal splits will be below
o.splitright    = true    -- Vertical splits will be to the right

o.ruler         = false   -- Don't show cursor position in command line
o.showmode      = false   -- Don't show mode in command line
o.wrap          = false   -- Display long lines as just one line

o.signcolumn    = 'yes'   -- Always show sign column (otherwise it will shift text)
o.fillchars     = 'eob: ' -- Don't show `~` outside of buffer

-- Editing
o.ignorecase  = true -- Ignore case when searching (use `\C` to force not doing that)
o.incsearch   = true -- Show search results while typing
o.infercase   = true -- Infer letter cases for a richer built-in keyword completion
o.smartcase   = true -- Don't ignore case when searching if pattern has upper case
o.smartindent = true -- Make indenting smart

o.completeopt   = 'menuone,noselect' -- Customize completions
o.virtualedit   = 'block'            -- Allow going past the end of line in visual block mode
o.formatoptions = 'qjl1'             -- Don't autoformat comments

-- Neovim version dependent
o.shortmess:append('WcC') -- Reduce command line messages
o.splitkeep = 'screen'      -- Reduce scroll during window split
-- o.cmdheight = 0
vim.opt.spell = true
vim.opt.spelllang = 'en_us'

vim.keymap.set('n', '<Esc>', '<Cmd>nohl<CR>')

vim.api.nvim_create_autocmd('TextYankPost', { pattern = '*', callback = function() vim.hl.on_yank() end })

vim.diagnostic.config({
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = '',
      [vim.diagnostic.severity.WARN] = '',
      [vim.diagnostic.severity.INFO] = '󰋇',
      [vim.diagnostic.severity.HINT] = '󰌵',
    },
  },
})

vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  pattern = "*.md",
  callback = function()
    vim.opt_local.textwidth = 80
  end,
})

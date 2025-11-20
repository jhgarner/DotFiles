require 'basicOptions'
require 'treesitter'
require 'picker'
require 'statusline'

vim.pack.add({
  'https://github.com/folke/tokyonight.nvim',
  "https://github.com/mrcjkb/haskell-tools.nvim",
  "https://github.com/mrcjkb/rustaceanvim",
  "https://github.com/saecki/crates.nvim",
  'https://github.com/windwp/nvim-autopairs',
  "https://github.com/okuuva/auto-save.nvim",
  "https://github.com/stevearc/conform.nvim",
  "https://github.com/lewis6991/gitsigns.nvim",
  "https://github.com/jhgarner/nvim-just-selector",
  "https://github.com/MeanderingProgrammer/render-markdown.nvim",
  {
    src = "https://github.com/jhgarner/hop.nvim",
    version = "newer-merged-all"
  },
  "https://github.com/nvim-mini/mini.icons",
  {
    src = 'https://github.com/nvim-neo-tree/neo-tree.nvim',
    version = vim.version.range('3')
  },
  "https://github.com/nvim-lua/plenary.nvim",
  "https://github.com/MunifTanjim/nui.nvim",
  "https://github.com/nvim-tree/nvim-web-devicons",
  {
    src = "https://github.com/saghen/blink.cmp",
    version = vim.version.range('1')
  },
  "https://github.com/j-hui/fidget.nvim",
})

vim.cmd[[colorscheme tokyonight]]
require 'nvim-autopairs'.setup {
  -- skip autopair when next character is one of these
  ignored_next_char = [=[[_%w%%%"%'%[%"%.%`%$%&]]=],
  -- skip autopair when the cursor is inside these treesitter nodes
  check_ts = true,
  map_bs = false,
}

require("auto-save").setup {
  debounce_delay = 5000,
  trigger_events = { -- See :h events
    immediate_save = { "BufLeave", "FocusLost" }, -- vim events that trigger an immediate save
    defer_save = { "InsertLeave" }, -- vim events that trigger a deferred save (saves after `debounce_delay`)
    cancel_deferred_save = { "InsertEnter" }, -- vim events that cancel a pending deferred save
  }
}

vim.keymap.set('n', '<leader>j', function() return require("just-selector").just() end)

local leaderMap = function(mapping, action)
  vim.keymap.set('n', '<leader>'..mapping, action, {nowait = true})
end

require('neo-tree').setup {
  event_handlers = {
    {
      event = "file_opened",
      handler = function()
        require("neo-tree.command").execute({ action = "close" })
      end,
    },
  },
}

leaderMap("e", "<cmd>Neotree reveal toggle<CR>")

require 'hop'.setup {
  keys = "abcdefghijklmnopqrst",
  exclude_cursor = true,
  forced_motion = "v",
}

vim.keymap.set( { "n", "v", "o" }, "f",
  function()
    local hop = require("hop")
    local directions = require("hop.hint").HintDirection
    hop.hint_char1({ direction = directions.AFTER_CURSOR, current_line_only = true })
  end
)
vim.keymap.set(
  { "n", "v", "o" },
  "F",
  function()
    local hop = require("hop")
    local directions = require("hop.hint").HintDirection
    hop.hint_char1({ direction = directions.BEFORE_CURSOR, current_line_only = true })
  end
)
vim.keymap.set(
  { "n", "v", "o" },
  "t",
  function()
    local hop = require("hop")
    local directions = require("hop.hint").HintDirection
    hop.hint_char1({ direction = directions.AFTER_CURSOR, current_line_only = true, hint_offset = -1 })
  end
)
vim.keymap.set(
  { "n", "v", "o" },
  "T",
  function()
    local hop = require("hop")
    local directions = require("hop.hint").HintDirection
    hop.hint_char1({ direction = directions.BEFORE_CURSOR, current_line_only = true, hint_offset = 1 })
  end
)
vim.keymap.set(
  { "n", "v", "o" },
  "j",
  function()
    local hint = require("hop.hint")
    require("hop").hint_vertical({
      direction = hint.HintDirection.AFTER_CURSOR,
      forced_motion = "V",
      distance_method = hint.readwise_distance,
    })
  end
)
vim.keymap.set(
  { "n", "v", "o" },
  "J",
  function()
    local hint = require("hop.hint")
    require("hop").hint_vertical({
      direction = hint.HintDirection.BEFORE_CURSOR,
      forced_motion = "V",
      distance_method = hint.readwise_distance,
    })
  end
)
vim.keymap.set(
  { "n", "v", "o" },
  "w",
  function()
    local hop = require("hop")
    local directions = require("hop.hint").HintDirection
    hop.hint_ws({ direction = directions.AFTER_CURSOR, current_line_only = true })
  end
)
vim.keymap.set(
  { "n", "v", "o" },
  "W",
  function()
    local hop = require("hop")
    local directions = require("hop.hint").HintDirection
    hop.hint_ws({ direction = directions.BEFORE_CURSOR, current_line_only = true })
  end
)
vim.keymap.set(
  { "n", "v", "o" },
  "e",
  function()
    local hint = require("hop.hint")
    require("hop").hint_ws({
      direction = hint.HintDirection.AFTER_CURSOR,
      current_line_only = true,
      hint_position = hint.HintPosition.END,
    })
  end
)
vim.keymap.set(
  { "n", "v", "o" },
  "E",
  function()
    local hint = require("hop.hint")
    require("hop").hint_ws({
      direction = hint.HintDirection.BEFORE_CURSOR,
      current_line_only = true,
      hint_position = hint.HintPosition.END,
    })
  end
)
vim.keymap.set( { "n", "v", "o" }, "C", "J")
vim.keymap.set( { "n", "v", "o" }, "s", "<cmd>HopChar1<CR>")

require 'blink.cmp'.setup {
  enabled = function()
    return vim.bo.buftype ~= "prompt" and vim.b.completion ~= false
  end,
  sources = {
    default = function()
      local success, node = pcall(vim.treesitter.get_node)
      if success and node and vim.tbl_contains({ "comment", "line_comment", "block_comment" }, node:type()) then
        return { "buffer" }
      else
        return { "lsp", "path", "snippets", "buffer" }
      end
    end,
  },
  completion = {
    documentation = { auto_show = true, auto_show_delay_ms = 500 },
    menu = { draw = { treesitter = {} } },
  },
  signature = { enabled = true },
  keymap = {
    preset = "super-tab",
    ["<Tab>"] = {
      function(cmp)
        if cmp.snippet_active() then
          return cmp.accept()
        else
          return cmp.select_and_accept()
        end
      end,
      "snippet_forward",
      "fallback",
    },
  },
}

vim.o.winborder = 'rounded'

leaderMap("cd", vim.diagnostic.open_float)

require 'gitsigns'.setup {
  debug_mode = true,
}
require "fidget".setup {}
vim.notify = require("fidget.notification").notify

local methods = vim.lsp.protocol.Methods
local function desc(description)
  return { noremap = true, silent = true, buffer = bufnr, desc = description }
end

vim.api.nvim_create_autocmd('LspAttach', {
  callback = function(ev)
    local bufnr = ev.buf
    local client = vim.lsp.get_client_by_id(ev.data.client_id)
    if not client then
      return
    end
    if vim.bo[bufnr].filetype ~= "cabal" and client:supports_method(methods.textDocument_inlayHint) then
      vim.lsp.inlay_hint.enable(true, {bufnr = bufnr})
      vim.keymap.set('n', '<leader>h', function()
        local current_setting = vim.lsp.inlay_hint.is_enabled { bufnr = bufnr }
        vim.lsp.inlay_hint.enable(not current_setting, { bufnr = bufnr })
      end, desc('lsp: toggle inlay [h]ints'))
    else 
      vim.lsp.inlay_hint.enable(false, {bufnr = bufnr})
    end
  end
})

require 'render-markdown'.setup {}

require 'crates'.setup()

require "conform".setup {
  formatters_by_ft = {
    -- lua = { "stylua" },
    -- Conform will run multiple formatters sequentially
    -- python = { "isort", "black" },
    -- You can customize some of the format options for the filetype (:help conform.format)
    rust = { "rustfmt", lsp_format = "fallback" },
    -- Conform will run the first available formatter
    -- javascript = { "prettierd", "prettier", stop_after_first = true },
  },
  format_on_save = {
    -- These options will be passed to conform.format()
    timeout_ms = 500,
    lsp_format = "fallback",
  },
}

vim.keymap.set('n', '<leader>ca',
  function() vim.lsp.buf.code_action() end,
  { noremap = true, silent = true, desc = 'LSP Code Action' }
)

vim.keymap.set('n', 'gd',
  function() vim.lsp.buf.type_definition() end,
  { noremap = true, silent = true, desc = 'Go to definition' }
)

vim.keymap.set('n', 'gi',
  function() vim.lsp.buf.implementation() end,
  { noremap = true, silent = true, desc = 'Go to implementation' }
)

vim.keymap.set('n', 'gr',
  function() MiniExtra.pickers.lsp({ scope = 'references' }) end,
  { noremap = true, silent = true, desc = 'Go to references' }
)

vim.keymap.set('n', '<leader>r',
  function() vim.lsp.buf.rename() end,
  { noremap = true, silent = true, desc = 'rename' }
)

vim.api.nvim_create_autocmd('CursorHold', {
  callback = vim.lsp.buf.document_highlight
})

vim.api.nvim_create_autocmd('CursorMoved', {
  callback = vim.lsp.buf.clear_references
})

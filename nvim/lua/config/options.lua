-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

vim.opt.formatexpr = ""
vim.opt.clipboard = "unnamed"
vim.opt.relativenumber = false
vim.o.guifont = "Cascadia Code:h14"
vim.g.neovide_scroll_animation_length = 0.3
vim.g.neovide_refresh_rate = 144
vim.g.neovide_cursor_trail_size = 0.3
vim.g.neovide_remember_window_size = true
vim.opt.autochdir = true
vim.opt.textwidth = 80
vim.opt.wrap = false
vim.g.maplocalleader = " a"
vim.g.haskell_tools = {
  hls = {
    settings = {
      haskell = {
        formattingProvider = "fourmolu",
        plugin = {
          fourmolu = {
            config = {
              external = true,
            },
          },
        },
      },
    },
  },
}

-- hack: query caching not working normally for some reason
local query_parse = vim.treesitter.query.parse
local cache = {}
vim.treesitter.query.parse = function(lang, query)
  local hash = lang .. "-" .. vim.fn.sha256(query)
  if cache[hash] then
    return cache[hash]
  end
  local result = query_parse(lang, query)
  cache[hash] = result
  return result
end

-- vim.filetype.add({ extension = { dnd = "md" } })
local lspconfig = require 'lspconfig'
local configs = require 'lspconfig.configs'

if not configs.dnd_lsp then
  configs.dnd_lsp = {
    default_config = {
      cmd = { '/home/jack/.local/bin/dndLanguageServer-exe' },
      root_dir = lspconfig.util.root_pattern('.git'),
      filetypes = { 'markdown' },
    },
  }
end
lspconfig.dnd_lsp.setup {}
-- vim.lsp.config['dnd'] = {
--   -- Command and arguments to start the server.
--   cmd = { '/home/jack/code/haskell/dndLanguageServer/dist-newstyle/build/x86_64-linux/ghc-9.10.1/dndLanguageServer-0.1.0.0/x/dndLanguageServer/build/dndLanguageServer/dndLanguageServer' },
--   -- Filetypes to automatically attach to.
--   filetypes = { 'dnd' },
--   -- Sets the "root directory" to the parent directory of the file in the
--   -- current buffer that contains either a ".luarc.json" or a
--   -- ".luarc.jsonc" file. Files that share a root directory will reuse
--   -- the connection to the same LSP server.
--   root_markers = { '.git' },
--   -- Specific settings to send to the server. The schema for this is
--   -- defined by the server. For example the schema for lua-language-server
--   -- can be found here https://raw.githubusercontent.com/LuaLS/vscode-lua/master/setting/schema.json
--   settings = {},
-- }
-- vim.lsp.enable('dnd')

vim.lsp.handlers['textDocument/hover'] = function(_, result, ctx, config)
  config = config or {}
  config.focus_id = ctx.method
  if not (result and result.contents) then
    return
  end
  local markdown_lines = vim.lsp.util.convert_input_to_markdown_lines(result.contents)
  markdown_lines = vim.lsp.util.trim_empty_lines(markdown_lines)
  if vim.tbl_isempty(markdown_lines) then
    return
  end
  config.max_width = 100
  config.border = "rounded"
  return vim.lsp.util.open_floating_preview(markdown_lines, 'markdown', config)
end

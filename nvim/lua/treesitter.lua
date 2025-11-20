vim.pack.add({
  {
    src = 'https://github.com/nvim-treesitter/nvim-treesitter',
    version = 'main',
  },
})

local ts = require 'nvim-treesitter'
ts.install { 'rust', 'bash', 'haskell', 'glsl', 'markdown', 'markdown_inline', 'nix', 'just' }
local installed = ts.get_installed()

local all_filetypes = {}
for index, lang in ipairs(installed) do
  local filetypes = vim.treesitter.language.get_filetypes(lang)
  for index, filetype in ipairs(filetypes) do
    table.insert(all_filetypes, filetype)
  end
end

vim.api.nvim_create_autocmd('FileType', {
  pattern = all_filetypes,
  callback = function()
    vim.treesitter.start()
    vim.wo.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
    -- Treesitter indent doesn't really work that well
    -- vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
  end,
})

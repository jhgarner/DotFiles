vim.pack.add({
  "https://github.com/nvim-mini/mini.pick",
  "https://github.com/nvim-mini/mini.extra",
})

sortingBuffers = function()
  local buffers = vim.fn.getbufinfo({buflisted = 1})
  local cur_buf_id = vim.api.nvim_get_current_buf()
  buffers = vim.tbl_filter(function(buf)
    if buf.bufnr == cur_buf_id then return false end
    local buftype = vim.bo[buf.bufnr].buftype

    if buftype == 'quickfix' or buftype == 'prompt' then
      return false
    end

    if buftype == '' then
      if buf.name == '' then
        return true
      end
      return vim.fn.filereadable(buf.name) == 1
    else
      return true
    end
  end, buffers)

  table.sort(buffers, function(a, b)
    return a.lastused > b.lastused
  end)
  local items = vim.tbl_map(function(buf)
    local buftype = vim.bo[buf.bufnr].buftype
    local is_file = buftype == ''
    local name = is_file and vim.fn.fnamemodify(buf.name, ':.') or buf.name
    return { text = name, bufnr = buf.bufnr }
  end, buffers)

  local show = function(buf_id, items, query) MiniPick.default_show(buf_id, items, query, { show_icons = true }) end
  return MiniPick.start({ source = { name = 'Buffers', show = show, items = items } })
end

require('mini.pick').setup {
  window = {
    config = function()
      local height = vim.o.lines
      local width = vim.o.columns
      return {
        relative = "editor", anchor = 'SE',
        row = vim.o.lines - 1,
        col = vim.o.columns,
      }
    end
  }
}
require('mini.extra').setup({})

local leaderMap = function(mapping, action)
  vim.keymap.set('n', '<leader>'..mapping, action)
end

leaderMap("ob", sortingBuffers)
leaderMap("of", MiniPick.builtin.files)
leaderMap("<Space>", MiniPick.builtin.files)
leaderMap("/", MiniPick.builtin.grep_live)
leaderMap("or", MiniExtra.pickers.oldfiles)
leaderMap("os", MiniExtra.pickers.spellsuggest)
leaderMap("oc", "<cmd>e $MYVIMRC <CR>")

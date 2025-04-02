return {
  {
    "windwp/nvim-autopairs",
    opts = {
      ignored_next_char = [=[[_%w%%%"%'%[%"%.%`%$%&]]=],
      map_bs = false,
    },
  },
  {
    "LazyVim/LazyVim",
    opts = {
      -- colorscheme = "catppuccin-macchiato",
    },
  },
  {
    "okuuva/auto-save.nvim",
    cmd = "ASToggle",          -- optional for lazy loading on command
    event = { "InsertLeave" }, -- optional for lazy loading on trigger events
    opts = {
      debounce_delay = 5000,
      trigger_events = {                              -- See :h events
        immediate_save = { "BufLeave", "FocusLost" }, -- vim events that trigger an immediate save
        defer_save = { "InsertLeave" },               -- vim events that trigger a deferred save (saves after `debounce_delay`)
        cancel_deferred_save = { "InsertEnter" },     -- vim events that cancel a pending deferred save
      },
    },
  },
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, {
        "haskell",
        "nix",
        "just",
      })
    end,
  },
  {
    "folke/tokyonight.nvim",
    opts = {
      cache = false,
      plugins = {
        -- enable all plugins when not using lazy.nvim
        -- set to false to manually enable/disable plugins
        all = package.loaded.lazy == nil,
        -- uses your plugin manager to automatically enable needed plugins
        -- currently only lazy.nvim is supported
        auto = true,
        -- add any plugins here that you want to enable
        -- for all possible plugins, see:
        --   * https://github.com/folke/tokyonight.nvim/tree/main/lua/tokyonight/groups
        ["render-markdown"] = true,
      },
    },
  },
  {
    "folke/snacks.nvim",
    opts = {
      scroll = { enabled = false },
    },
  },
  {
    "jhgarner/nvim-just-selector",
    lazy = false,
    keys = {
      {
        "<leader>j",
        function()
          return require("just-selector").just()
        end,
        desc = "Run Just File",
      },
    },
  },
  {
    "ibhagwan/fzf-lua",
    opts = {
      defaults = {
        cwd_prompt = false,
        formatter  = "path.filename_first",
      },
    },
    keys = {
      { "<leader>ob", require("fzf-lua").buffers },
      { "<leader>of", require("fzf-lua").files },
      { "<leader>os", require("fzf-lua").spell_suggest },
      { "<leader>or", require("fzf-lua").oldfiles },
      { "<leader>oc", "<cmd>e $MYVIMRC <CR>" },
    },
  },
  {
    "folke/flash.nvim",
    enabled = false,
  },
  {
    "nvim-neo-tree/neo-tree.nvim",
    opts = {
      event_handlers = {
        {
          event = "file_opened",
          handler = function()
            -- auto close
            -- vimc.cmd("Neotree close")
            -- OR
            require("neo-tree.command").execute({ action = "close" })
          end,
        },
      },
    },
  },
  {
    "willothy/flatten.nvim",
    config = true,
    -- or pass configuration with
    -- opts = {  }
    -- Ensure that it runs first to minimize delay when opening file from terminal
    lazy = false,
    priority = 1001,
  },
  {
    -- "jhgarner/hop.nvim",
    -- branch = "newer-merged-all",
    dir = "~/code/lua/hop.nvim/",
    vscode = true,
    opts = {
      keys = "abcdefghijklmnopqrst",
      exclude_cursor = true,
      forced_motion = "v",
    },
    keys = {
      {
        "f",
        function()
          local hop = require("hop")
          local directions = require("hop.hint").HintDirection
          hop.hint_char1({ direction = directions.AFTER_CURSOR, current_line_only = true })
        end,
        mode = { "n", "v", "o" },
      },
      {
        "F",
        function()
          local hop = require("hop")
          local directions = require("hop.hint").HintDirection
          hop.hint_char1({ direction = directions.BEFORE_CURSOR, current_line_only = true })
        end,
        mode = { "n", "v", "o" },
      },
      {
        "t",
        function()
          local hop = require("hop")
          local directions = require("hop.hint").HintDirection
          hop.hint_char1({ direction = directions.AFTER_CURSOR, current_line_only = true, hint_offset = -1 })
        end,
        mode = { "n", "v", "o" },
      },
      {
        "T",
        function()
          local hop = require("hop")
          local directions = require("hop.hint").HintDirection
          hop.hint_char1({ direction = directions.BEFORE_CURSOR, current_line_only = true, hint_offset = 1 })
        end,
        mode = { "n", "v", "o" },
      },
      {
        "j",
        function()
          local hint = require("hop.hint")
          require("hop").hint_vertical({
            direction = hint.HintDirection.AFTER_CURSOR,
            forced_motion = "V",
            distance_method = hint.readwise_distance,
          })
        end,
        mode = { "n", "v", "o" },
      },
      {
        "J",
        function()
          local hint = require("hop.hint")
          require("hop").hint_vertical({
            direction = hint.HintDirection.BEFORE_CURSOR,
            forced_motion = "V",
            distance_method = hint.readwise_distance,
          })
        end,
        mode = { "n", "v", "o" },
      },
      {
        "w",
        function()
          local hop = require("hop")
          local directions = require("hop.hint").HintDirection
          hop.hint_ws({ direction = directions.AFTER_CURSOR, current_line_only = true })
        end,
        mode = { "n", "v", "o" },
      },
      {
        "W",
        function()
          local hop = require("hop")
          local directions = require("hop.hint").HintDirection
          hop.hint_ws({ direction = directions.BEFORE_CURSOR, current_line_only = true })
        end,
        mode = { "n", "v", "o" },
      },
      {
        "e",
        function()
          local hint = require("hop.hint")
          require("hop").hint_ws({
            direction = hint.HintDirection.AFTER_CURSOR,
            current_line_only = true,
            hint_position = hint.HintPosition.END,
          })
        end,
        mode = { "n", "v", "o" },
      },
      {
        "E",
        function()
          local hint = require("hop.hint")
          require("hop").hint_ws({
            direction = hint.HintDirection.BEFORE_CURSOR,
            current_line_only = true,
            hint_position = hint.HintPosition.END,
          })
        end,
        mode = { "n", "v", "o" },
      },
      { ",,", "<cmd>nohlsearch<CR>" },
      { "C",  "J",                  mode = { "n", "v", "o" } },
      { "s",  "<cmd>HopChar1<CR>",  mode = { "n", "v", "o" } },
    },
  },
  {
    "saghen/blink.cmp",
    opts = {
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
      keymap = { preset = "super-tab" },
    },
  },
  {
    "tpope/vim-sleuth",
  },
  {
    "direnv/direnv.vim",
  },
  { "stevearc/profile.nvim" },
  {
    "folke/noice.nvim",
    opts = {
      lsp = {
        hover = {
          silent = true,
          enabled = false,
          -- overrides = {
          --   ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
          --   ["vim.lsp.util.stylize_markdown"] = true,
          -- },
          opts = {
            buf_options = {
              -- filetype = "markdown",
            },
          },
        },
      },
    },
  },
}

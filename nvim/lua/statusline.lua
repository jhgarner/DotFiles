vim.pack.add({
  "https://github.com/folke/tokyonight.nvim",
  "https://github.com/nvim-tree/nvim-web-devicons",
  "https://github.com/rebelot/heirline.nvim"
})

local conditions = require("heirline.conditions")
local utils = require("heirline.utils")
local colors = require("tokyonight.colors").setup()

local Align = { provider = "%=" }
local Space = { provider = " " }

local ViMode = {
    -- get vim current mode, this information will be required by the provider
    -- and the highlight functions, so we compute it only once per component
    -- evaluation and store it as a component attribute
    init = function(self)
        self.mode = vim.fn.mode(1) -- :h mode()
    end,
    -- Now we define some dictionaries to map the output of mode() to the
    -- corresponding string and color. We can put these into `static` to compute
    -- them at initialisation time.
    static = {
        mode_names = { -- change the strings if you like it vvvvverbose!
            n = "N",
            no = "N",
            nov = "N",
            noV = "N",
            ["no\22"] = "N",
            niI = "N",
            niR = "N",
            niV = "N",
            nt = "N",
            v = "v",
            vs = "v",
            V = "V",
            Vs = "V",
            ["\22"] = "V",
            ["\22s"] = "V",
            s = "S",
            S = "S",
            ["\19"] = "S",
            i = "I",
            ic = "I",
            ix = "I",
            R = "R",
            Rc = "R",
            Rx = "R",
            Rv = "R",
            Rvc = "R",
            Rvx = "R",
            c = "C",
            cv = "E",
            r = ".",
            rm = "M",
            ["r?"] = "?",
            ["!"] = "!",
            t = "T",
        },
        mode_colors = {
            n = "red" ,
            i = "green",
            v = "cyan",
            V =  "cyan",
            ["\22"] =  "cyan",
            c =  "orange",
            s =  "purple",
            S =  "purple",
            ["\19"] =  "purple",
            R =  "orange",
            r =  "orange",
            ["!"] =  "red",
            t =  "red",
        }
    },
    -- We can now access the value of mode() that, by now, would have been
    -- computed by `init()` and use it to index our strings dictionary.
    -- note how `static` fields become just regular attributes once the
    -- component is instantiated.
    -- To be extra meticulous, we can also add some vim statusline syntax to
    -- control the padding and make sure our string is always at least 2
    -- characters long. Plus a nice Icon.
    provider = function(self)
        return " %("..self.mode_names[self.mode].."%)"
    end,
    -- Same goes for the highlight. Now the foreground will change according to the current mode.
    hl = function(self)
        local mode = self.mode:sub(1, 1) -- get only the first mode character
        return { fg = self.mode_colors[mode], bold = true, }
    end,
    -- Re-evaluate the component only on ModeChanged event!
    -- Also allows the statusline to be re-evaluated when entering operator-pending mode
    update = {
        "ModeChanged",
        pattern = "*:*",
        callback = vim.schedule_wrap(function()
            vim.cmd("redrawstatus")
        end),
    },
}

local FileNameBlock = {
    -- let's first set up some attributes needed by this component and its children
    init = function(self)
        self.filename = vim.api.nvim_buf_get_name(0)
    end,
}
-- We can now define some children separately and add them later

local FileIcon = {
    init = function(self)
        local filename = self.filename
        local extension = vim.fn.fnamemodify(filename, ":e")
        self.icon, self.icon_color = require("nvim-web-devicons").get_icon_color(filename, extension, { default = true })
    end,
    provider = function(self)
        return self.icon and (self.icon .. " ") or ""
    end,
    hl = function(self)
        return { fg = self.icon_color }
    end
}

local FileName = {
    provider = function(self)
        -- first, trim the pattern relative to the current directory. For other
        -- options, see :h filename-modifers
        local filename = vim.fn.fnamemodify(self.filename, ":.")
        if filename == "" then return "[No Name]" end
        -- now, if the filename would occupy more than 1/4th of the available
        -- space, we trim the file path to its initials
        -- See Flexible Components section below for dynamic truncation
        if not conditions.width_percent_below(#filename, 0.25) then
            filename = vim.fn.pathshorten(filename)
        end
        return filename
    end,
    hl = { fg = utils.get_highlight("Directory").fg },
}

local FileFlags = {
    {
        condition = function()
            return vim.bo.modified
        end,
        provider = "",
        hl = { fg = "green" },
    },
    {
        condition = function()
            return not vim.bo.modifiable or vim.bo.readonly
        end,
        provider = "",
        hl = { fg = "orange" },
    },
}

-- Now, let's say that we want the filename color to change if the buffer is
-- modified. Of course, we could do that directly using the FileName.hl field,
-- but we'll see how easy it is to alter existing components using a "modifier"
-- component

local FileNameModifer = {
    hl = function()
        if vim.bo.modified then
            -- use `force` because we need to override the child's hl foreground
            return { fg = "cyan", bold = true, force=true }
        end
    end,
}

-- let's add the children to our FileNameBlock component
FileNameBlock = utils.insert(FileNameBlock,
    FileIcon,
    utils.insert(FileNameModifer, FileName), -- a new table where FileName is a child of FileNameModifier
    Space, FileFlags,
    { provider = '%<'} -- this means that the statusline is cut here when there's not enough space
)

local Diagnostics = {
  condition = conditions.has_diagnostics,
  -- If you defined custom LSP diagnostics with vim.fn.sign_define(), use this instead
  -- Note defining custom LSP diagnostic this way its deprecated, though
  --static = {
  --    error_icon = vim.fn.sign_getdefined("DiagnosticSignError")[1].text,
  --    warn_icon = vim.fn.sign_getdefined("DiagnosticSignWarn")[1].text,
  --    info_icon = vim.fn.sign_getdefined("DiagnosticSignInfo")[1].text,
  --    hint_icon = vim.fn.sign_getdefined("DiagnosticSignHint")[1].text,
  --},

  init = function(self)
    self.errors = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.ERROR })
    self.warnings = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.WARN })
    self.hints = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.HINT })
    self.info = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.INFO })
    self.error_icon = vim.diagnostic.config()['signs']['text'][vim.diagnostic.severity.ERROR]
    self.warn_icon = vim.diagnostic.config()['signs']['text'][vim.diagnostic.severity.WARN]
    self.info_icon = vim.diagnostic.config()['signs']['text'][vim.diagnostic.severity.INFO]
    self.hint_icon = vim.diagnostic.config()['signs']['text'][vim.diagnostic.severity.HINT]
  end,

  update = { "DiagnosticChanged", "BufEnter" },

  {
    provider = function(self)
      -- 0 is just another output, we can decide to print it or not!
      return (self.error_icon .. self.errors .. " ")
    end,
    hl = { fg = "red" },
  },
  {
    provider = function(self)
      return (self.warn_icon .. self.warnings .. " ")
    end,
    hl = { fg = "yellow" },
  },
  {
    provider = function(self)
      return (self.info_icon .. self.info .. " ")
    end,
    hl = { fg = "green" },
  },
  {
    provider = function(self)
      return (self.hint_icon .. self.hints)
    end,
    hl = { fg = "blue" },
  },
}

local Ruler = {
  -- %l = current line number
  -- %L = number of lines in the buffer
  -- %c = column number
  -- %P = percentage through file of displayed window
  provider = "Column: %-2c Line: %-10(%l of %L%)",
}

local ScrollBar ={
  static = {
    sbar = { '🭶', '🭷', '🭸', '🭹', '🭺', '🭻' }
  },
  provider = function(self)
    local curr_line = vim.api.nvim_win_get_cursor(0)[1]
    local lines = vim.api.nvim_buf_line_count(0)
    if lines == 0 then return " " end
    local i = math.floor((curr_line - 1) / lines * #self.sbar) + 1
    return string.rep(self.sbar[i], 2)
  end,
  hl = { fg = "blue"},
}

local StatusLine = {
  utils.surround({"", ""}, "bg_highlight", ViMode), Space, FileNameBlock, Space, Align, Diagnostics, Space, Ruler, Space, ScrollBar,
}

-- local WinBar = {{...}, {{...}, {...}}}
--
-- local TabLine = {{...}, {...}, {...}}

-- the winbar parameter is optional!
require("heirline").setup({
  statusline = StatusLine,
  -- winbar = WinBar,
  -- tabline = TabLine,
  -- statuscolumn = StatusColumn
  opts = {
    colors = colors
  } -- other config parameters, see below
})

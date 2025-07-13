-- ~/.config/nvim/lua/configs/snacks/dashboard.lua

local M = {}
local devicons = nil               -- Declare devicons as nil initially
local devicons_initialized = false -- New flag to track if setup() has run

-- This function will determine the file/directory icon.
function M.icon(filename, filetype)
  -- Lazy-load and initialize nvim-web-devicons if not already done
  if not devicons and not devicons_initialized then -- Only try to load/init if not already done
    local ok, d = pcall(require, "nvim-web-devicons")
    if ok and d then
      devicons = d
      -- **Crucial:** Call setup() explicitly if not already done.
      -- This assumes you don't have a separate nvim-web-devicons setup function
      -- being called in your main plugins file that ensures it's always initialized.
      if type(devicons.setup) == 'function' and not devicons._loaded then -- _loaded is an internal flag
        devicons.setup()                                                  -- Call setup with default options if needed
        devicons_initialized = true
      end
    else
      devicons = false            -- Indicate that loading failed
      devicons_initialized = true -- Mark as attempted
    end
  end

  if devicons and type(devicons.get_icon_from_filetype) == 'function' then -- Ensure devicons is a table AND the function exists
    if filetype == "directory" then
      return { devicons.get_icon_from_name("folder", "directory"), hl = "FolderIcon" }
    else
      local file_extension = filename:match(".+%.(.+)$")
      local icon, hl = devicons.get_icon_from_filetype(file_extension or "", { default = true })
      if icon then
        return { icon, hl = hl }
      else
        return { "", hl = "FileIcon" } -- Default file icon if no specific one
      end
    end
  else
    -- Fallback if nvim-web-devicons is not loaded or the function isn't available
    if filetype == "directory" then
      return { "", hl = "FolderIcon" } -- Generic folder
    else
      return { "", hl = "FileIcon" } -- Generic file
    end
  end
end

---@class snacks.dashboard.Config
---@field enabled? boolean
---@field sections snacks.dashboard.Section
---@field formats table<string, snacks.dashboard.Text|fun(item:snacks.dashboard.Item, ctx:snacks.dashboard.Format.ctx):snacks.dashboard.Text>
return {
  width = 60,
  row = nil,                                                                   -- dashboard position. nil for center
  col = nil,                                                                   -- dashboard position. nil for center
  pane_gap = 4,                                                                -- empty columns between vertical panes
  autokeys = "1234567890abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ", -- autokey sequence
  -- These settings are used by some built-in sections
  preset = {
    -- Defaults to a picker that supports `fzf-lua`, `telescope.nvim` and `mini.pick`
    ---@type fun(cmd:string, opts:table)|nil
    pick = nil,
    -- Used by the `keys` section to show keymaps.
    -- Set your custom keymaps here.
    -- When using a function, the `items` argument are the default keymaps.
    ---@type snacks.dashboard.Item[]
    keys = {
      { icon = " ", key = "f", desc = "Find File", action = ":lua Snacks.dashboard.pick('files')" },
      { icon = " ", key = "n", desc = "New File", action = ":ene | startinsert" },
      { icon = " ", key = "g", desc = "Find Text", action = ":lua Snacks.dashboard.pick('live_grep')" },
      { icon = " ", key = "r", desc = "Recent Files", action = ":lua Snacks.dashboard.pick('oldfiles')" },
      { icon = " ", key = "c", desc = "Config", action = ":lua Snacks.dashboard.pick('files', {cwd = vim.fn.stdpath('config')})" },
      { icon = " ", key = "s", desc = "Restore Session", section = "session" },
      { icon = "󰒲 ", key = "L", desc = "Lazy", action = ":Lazy", enabled = package.loaded.lazy ~= nil },
      { icon = " ", key = "q", desc = "Quit", action = ":qa" },
    },
    header = [[


 /   |   \|__| ______   ______________  __ ____________/  |_
/    ~    \  | \____ \_/ __ \_  __ \  \/ // __ \_  __ \   __\
\    Y    /  | |  |_> >  ___/|  | \/\   /\  ___/|  | \/|  |
 \___|_  /|__| |   __/ \___  >__|    \_/  \___  >__|   |__|
       \/      |__|        \/                 \/


 ]],
  },
  -- item field formatters
  formats = {
    icon = function(item)
      if item.file and item.icon == "file" or item.icon == "directory" then
        return M.icon(item.file, item.icon)
      end
      return { item.icon, width = 2, hl = "icon" }
    end,
    footer = { "%s", align = "center" },
    header = { "%s", align = "center" },
    file = function(item, ctx)
      local fname = vim.fn.fnamemodify(item.file, ":~")
      fname = ctx.width and #fname > ctx.width and vim.fn.pathshorten(fname) or fname
      if #fname > ctx.width then
        local dir = vim.fn.fnamemodify(fname, ":h")
        local file = vim.fn.fnamemodify(fname, ":t")
        if dir and file then
          file = file:sub(-(ctx.width - #dir - 2))
          fname = dir .. "/…" .. file
        end
      end
      local dir, file = fname:match("^(.*)/(.+)$")
      return dir and { { dir .. "/", hl = "dir" }, { file, hl = "file" } } or { { fname, hl = "file" } }
    end,
  },
  sections = {
    { section = "header", },
    { section = "keys",   gap = 1, padding = 0 }, -- Keep your keys from preset
    {
      pane = 2,
      section = "terminal",
      cmd =
      "colorscript -e square",
      height = 5,
      padding = 1,
    },
    { pane = 2, icon = " ", title = "Recent Files", section = "recent_files", indent = 2, padding = 1 },
    { pane = 2, icon = " ", title = "Projects", section = "projects", indent = 2, padding = 1 },
    {
      pane = 2,
      icon = " ",
      title = "Git Status",
      section = "terminal",
      enabled = function()
        -- Ensure Snacks.git exists and has get_root.
        -- This might require snacks.nvim to load its 'git' module.
        local snacks_module = require("snacks")
        return snacks_module and snacks_module.git and snacks_module.git.get_root and snacks_module.git.get_root() ~= nil
      end,
      cmd = "git status --short --branch --renames",
      height = 5,
      padding = 1,
      ttl = 5 * 60,
      indent = 3,
    },
    { section = "startup" },
  },
}

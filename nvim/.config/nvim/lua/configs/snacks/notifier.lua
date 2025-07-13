return {
  {
    timeout = 3000, -- default timeout in ms
    width = { min = 40, max = 0.4 },
    height = { min = 1, max = 0.6 },
    -- editor margin to keep free. tabline and statusline are taken into account automatically
    margin = { top = 0, right = 1, bottom = 0 },
    padding = true,              -- add 1 cell of left/right padding to the notification window
    sort = { "level", "added" }, -- sort by level and time
    -- minimum log level to display. TRACE is the lowest
    -- all notifications are stored in history
    level = vim.log.levels.TRACE,
    icons = {
      error = " ",
      warn = " ",
      info = " ",
      debug = " ",
      trace = " ",
    },
    ---@diagnostic disable-next-line: unused-local
    keep = function(notif)
      return vim.fn.getcmdpos() > 0
    end,
    ---@type snacks.notifier.style
    style = "compact",
    top_down = true,    -- place notifications from top to bottom
    date_format = "%R", -- time format for notifications
    -- format for footer when more lines are available
    -- `%d` is replaced with the number of lines.
    -- only works for styles with a border
    ---@type string|boolean
    more_format = " ↓ %d lines ",
    refresh = 50, -- refresh at most every 50ms
  },
  {
    border = "rounded",
    zindex = 100,
    ft = "markdown",
    wo = {
      winblend = 5,
      wrap = false,
      conceallevel = 2,
      colorcolumn = "",
    },
    bo = { filetype = "snacks_notif" },
  },
  {
    border = "rounded",
    zindex = 100,
    width = 0.6,
    height = 0.6,
    minimal = false,
    title = " Notification History ",
    title_pos = "center",
    ft = "markdown",
    bo = { filetype = "snacks_notif_history", modifiable = false },
    wo = { winhighlight = "Normal:SnacksNotifierHistory" },
    keys = { q = "close" },
  }
}

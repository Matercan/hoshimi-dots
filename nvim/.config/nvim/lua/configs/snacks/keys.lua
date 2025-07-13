return {
  { "<leader>un", function() Snacks.notifier.hide() end,           desc = "Dismiss All Notifications" },
  { "<c-/>",      function() Snacks.terminal() end,                desc = "Toggle Terminal" },
  { "<c-_>",      function() Snacks.terminal() end,                desc = "which_key_ignore" },
  { ">>",         function() Snacks.words.jump(vim.v.count1) end,  desc = "Next Reference",           mode = { "n", "t" } },
  { "<<",         function() Snacks.words.jump(-vim.v.count1) end, desc = "Prev Reference",           mode = { "n", "t" } },
}

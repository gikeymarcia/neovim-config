return {
  -- https://github.com/folke/zen-mode.nvim
  "folke/zen-mode.nvim",
  -- https://github.com/folke/zen-mode.nvim#%EF%B8%8F-configuration
  -- configuration details
  opts = {
    window = {
      width = .85
    },
  -- TODO; not sure why this isn't working
  keys = {
      { "F12", "<cmd>ZenMode<CR>", desc = "Toggle ZenMode for focused editing"},
    }
  },
}

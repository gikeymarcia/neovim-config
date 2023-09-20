vim.keymap.set('n', '<F12>', '<cmd>ZenMode<CR>', { desc = "Toggle ZenMode"})
return {
  -- https://github.com/folke/zen-mode.nvim
  "folke/zen-mode.nvim",
  -- https://github.com/folke/zen-mode.nvim#%EF%B8%8F-configuration
  -- configuration details
  opts = {
    window = {
      width = 120,
      options = {
        number = false,
        relativenumber = false
      },
    },
  },
}

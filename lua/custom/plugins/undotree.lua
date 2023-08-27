vim.g.undotree_WindowLayout = 2
vim.g.undotree_ShortIndicators = 1
vim.g.undotree_SplitWidth = 30
vim.g.undotree_SetFocusWhenToggle = 1
return {
  -- https://github.com/mbbill/undotree
  "mbbill/undotree",
  keys = {
    { "<F5>", "<cmd>UndotreeToggle<CR>", desc = "Toggle undotree" },
  },
}

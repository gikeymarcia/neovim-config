-- https://github.com/shaunsingh/nord.nvim
return {
  {
    "shaunsingh/nord.nvim",
    lazy = false,
    priority = 1000,
    config = function ()
      vim.g.nord_borders = true
      vim.g.bold = true
      vim.g.italic = true
      vim.g.nord_contrast = true
    end
  }
}

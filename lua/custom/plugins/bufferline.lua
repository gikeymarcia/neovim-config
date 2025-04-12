-- https://github.com/akinsho/bufferline.nvim
-- :h bufferline-configuration
return {
  'akinsho/bufferline.nvim',
  version = "*",
  dependencies = {
    'nvim-tree/nvim-web-devicons',
    'shaunsingh/nord.nvim',
  },
  config = function ()
    -- nord theme interaction
    local highlights = require("nord").bufferline.highlights({
      italic = true,
      bold = true,
    })
    require("bufferline").setup({
      options = {
        separator_style = 'thin',
        -- hooks from nord.vim
        highlights = highlights,
        diagnostics = "nvim_lsp"
      }
    })
  end
}

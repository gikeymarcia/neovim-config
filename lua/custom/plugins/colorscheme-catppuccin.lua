-- https://github.com/catppuccin/nvim
return {
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    opts = {
      flavour = "frappe", -- latte, frappe, macchiato, mocha
      transparent_background = false,
      show_end_of_buffer = true,
      background = { -- :h background
          light = "latte",
          dark = "frappe",
      },
      styles = {
        comments = { "italic" },
        conditionals = { "bold" },
        keywords = { "bold" },
        functions = {},
        strings = {},
        variables = { "bold" },
        numbers = {},
        booleans = {},
        properties = {},
        types = {},
        operators = {},
      },
      -- dim_inactive = {
      --     enabled = true, -- dims the background color of inactive window
      --     shade = "light",
      --     percentage = 0.05, -- percentage of the shade to apply to the inactive window
      -- },
    }
  }
}

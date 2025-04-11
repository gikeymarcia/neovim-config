-- https://github.com/AlexvZyl/nordic.nvim
return {
  {
    "AlexvZyl/nordic.nvim",
    lazy = false,
    priority = 1000,
    config = function ()
      -- require('nordic').load()
      require('nordic').setup({
        bold_keywords = true,
        italic_comments = true,
        transparent = {
          bg = false,
          float = true
        },
        cursorline = {
          bold = false,
          bold_number = true
        },
        telescope = {
          style = 'classic'
        },
      })
    end
  }
}


-- https://github.com/sainnhe/sonokai/blob/master/doc/sonokai.txt
-- https://github.com/sainnhe/sonokai
return {
  {
    "sainnhe/sonokai",
    lazy = false,
    priority = 1000,
    config = function ()
      -- Available values: default, atlantis, andromeda, shusia, maia, espresso
      vim.g.sonokai_style = 'atlantis'
      vim.g.sonokai_enable_italic = true
      vim.g.sonokai_better_performance = 1
    end
  }
}

-- https://github.com/sainnhe/edge
-- https://github.com/sainnhe/edge/blob/master/doc/edge.txt
return {
  'sainnhe/edge',
  lazy = false,
  priority = 1000,
  config = function()
    vim.g.edge_enable_italic = true
    -- available styles: 'aura', 'default', 'neon'
    vim.g.edge_style = 'aura'
  end
}

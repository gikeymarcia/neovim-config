-- https://github.com/nvim-tree/nvim-tree.lua
-- :help nvim-tree-setup
-- :help nvim-tree-commands

vim.g.loaded_netrw = 1        -- disable netrw
vim.g.loaded_netrwPlugin = 1
vim.opt.termguicolors = true  -- set termguicolors to enable highlight groups

-- KEY MAPPINGS
local my_keybinds = {}
function my_keybinds.on_attach(bufnr)     -- :help nvim-tree.on_attach
  local tree_api = require("nvim-tree.api")
  local function opts(desc)
    return { desc = 'nvim-tree: ' .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
  end
  -- default mappings are off for now
  -- :help nvim-tree-mappings-default
  -- tree_api.config.mappings.default_on_attach(bufnr)

  -- custom mappings
  vim.keymap.set('n', '<CR>',   tree_api.node.open.edit,                  opts('Open'))
  vim.keymap.set('n', 'yy',     tree_api.fs.copy.node,                    opts('Copy'))
  vim.keymap.set('n', 'dd',     tree_api.fs.remove,                       opts('Delete file or directory'))
  vim.keymap.set('n', 'p',      tree_api.fs.paste,                        opts('Paste'))
  vim.keymap.set('n', 'o',      tree_api.fs.create,                       opts('Create'))
  vim.keymap.set('n', 'O',      tree_api.fs.create,                       opts('Create'))
  vim.keymap.set('n', 'ciw',    tree_api.fs.rename_basename,              opts('Rename: Basename'))
  vim.keymap.set('n', 'cw',     tree_api.fs.rename_sub,                   opts('Rename: Omit Filename'))

  vim.keymap.set('n', 'yp',     tree_api.fs.copy.absolute_path,           opts('Copy Absolute Path'))

  vim.keymap.set('n', 'zh',     tree_api.tree.toggle_hidden_filter,       opts('Toggle Dotfiles'))
  vim.keymap.set('n', 'zg',     tree_api.tree.toggle_gitignore_filter,    opts('Toggle Git Ignore'))
  vim.keymap.set('n', '<C-k>',  tree_api.node.show_info_popup,            opts('Info'))
  vim.keymap.set('n', '<BS>',   tree_api.node.navigate.parent_close,      opts('Close Directory'))
  vim.keymap.set('n', '/',      tree_api.tree.search_node,                opts('Search'))
  vim.keymap.set('n', '?',      tree_api.tree.toggle_help,                opts('Help'))
  -- mouse
  vim.keymap.set('n', '<2-LeftMouse>',  tree_api.node.open.edit,          opts('Open'))
end

-- Open on startup
local function open_nvim_tree(data)
  -- buffer is a directory
  local directory = vim.fn.isdirectory(data.file) == 1
  if directory then
    vim.cmd.cd(data.file)
    require("nvim-tree.api").tree.open()
  end
  -- -- buffer is a real file on the disk
  -- local real_file = vim.fn.filereadable(data.file) == 1
  -- if real_file then
  --   return
  -- end
  -- buffer is a [No Name]
  local no_name = data.file == "" and vim.bo[data.buf].buftype == ""
  if no_name then
    require("nvim-tree.api").tree.open()
  end
end
vim.api.nvim_create_autocmd({ "VimEnter" }, { callback = open_nvim_tree })

return {
  "nvim-tree/nvim-tree.lua",
  version = "*",
  lazy = false,
  dependencies = {
    "nvim-tree/nvim-web-devicons"
  },
  config = function()
    require('nvim-tree').setup {
      sort_by = "case_sensitive",
      renderer = {
        group_empty = true,
      },
      filters = {
        dotfiles = true,
      },
      on_attach = my_keybinds.on_attach
    }
  end,
  keys = {
    { "<F4>", "<cmd>NvimTreeToggle<CR>", desc = "Toggle nvim-tree" },
  },
}

-- https://github.com/junegunn/vim-easy-align
-- launch with 'ga' + motion
-- mostly used with 'gaap' to launch easy-align around paragraph (existing table)
-- To line up around the | divider use
--    gaap*|
-- READ MORE @ https://github.com/junegunn/vim-easy-align#usage

-- Keymaps for EasyAlign
vim.api.nvim_set_keymap('x', 'ga', [[<Plug>(EasyAlign)]], { noremap = false })
vim.api.nvim_set_keymap('n', 'ga', [[<Plug>(EasyAlign)]], { noremap = false })

return {
  'junegunn/vim-easy-align',
}

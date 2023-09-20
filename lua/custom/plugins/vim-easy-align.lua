-- https://github.com/junegunn/vim-easy-align
-- launch with 'ga' + motion
-- mostly used with 'gaap' to launch easy-align around paragraph (existing table)
-- To line up around the | divider use
--    gaap*|
-- READ MORE @ https://github.com/junegunn/vim-easy-align#usage
return {
  'junegunn/vim-easy-align',
  keys = {
    { "ga", "<Plug>(EasyAlign)", "n,x,v", desc = 'Use vim-easy-align plugin' },
  },
}

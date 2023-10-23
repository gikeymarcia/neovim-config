--[[

=====================================================================
==================== READ THIS BEFORE CONTINUING ====================
=====================================================================

Kickstart.nvim is *not* a distribution.

Kickstart.nvim is a template for your own configuration.
  The goal is that you can read every line of code, top-to-bottom, understand
  what your configuration is doing, and modify it to suit your needs.

  Once you've done that, you should start exploring, configuring and tinkering to
  explore Neovim!

  If you don't know anything about Lua, I recommend taking some time to read through
  a guide. One possible example:
  - https://learnxinyminutes.com/docs/lua/


  And then you can explore or search through `:help lua-guide`
  - https://neovim.io/doc/user/lua-guide.html


Kickstart Guide:

I have left several `:help X` comments throughout the init.lua
You should run that command and read that help section for more information.

In addition, I have some `NOTE:` items throughout the file.
These are for you, the reader to help understand what is happening. Feel free to delete
them once you know what you're doing, but they should serve as a guide for when you
are first encountering a few different constructs in your nvim config.

I hope you enjoy your Neovim journey,
- TJ

P.S. You can delete this when you're done too. It's your config now :)
--]]
-- Set <space> as the leader key
-- See `:help mapleader`
--  NOTE: Must happen before plugins are required (otherwise wrong leader will be used)
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Install package manager
--    https://github.com/folke/lazy.nvim
--    `:help lazy.nvim.txt` for more info
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system {
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    '--branch=stable', -- latest stable release
    lazypath,
  }
end
vim.opt.rtp:prepend(lazypath)

-- NOTE: Here is where you install your plugins.
--  You can configure plugins using the `config` key.
--
--  You can also configure plugins after the setup call,
--    as they will be available in your neovim runtime.
require('lazy').setup({
  -- NOTE: First, some plugins that don't require any configuration

  -- Git related plugins
  { 'tpope/vim-fugitive',
    lazy = false,
    keys = {
      { "<leader>G", "<cmd>G<cr>", 'n', desc = "Launch vim fugitive" },
    },
  },
  'tpope/vim-rhubarb',

  -- Detect tabstop and shiftwidth automatically
  'tpope/vim-sleuth',

  -- NOTE: This is where your plugins related to LSP can be installed.
  --  The configuration is done below. Search for lspconfig to find it below.
  {
    -- LSP Configuration & Plugins
    'neovim/nvim-lspconfig',
    dependencies = {
      -- Automatically install LSPs to stdpath for neovim
      { 'williamboman/mason.nvim', config = true },
      'williamboman/mason-lspconfig.nvim',

      -- Useful status updates for LSP
      -- NOTE: `opts = {}` is the same as calling `require('fidget').setup({})`
      { 'j-hui/fidget.nvim', tag = 'legacy', opts = {} },

      -- Additional lua configuration, makes nvim stuff amazing!
      'folke/neodev.nvim',
    },
  },

  {
    -- Autocompletion
    'hrsh7th/nvim-cmp',
    dependencies = {
      -- Snippet Engine & its associated nvim-cmp source
      'L3MON4D3/LuaSnip',
      'saadparwaiz1/cmp_luasnip',

      -- Adds LSP completion capabilities
      'hrsh7th/cmp-nvim-lsp',

      -- Adds a number of user-friendly snippets
      'rafamadriz/friendly-snippets',

      -- completions based on file path
      'hrsh7th/cmp-path',
      -- completions based on buffer words
      'hrsh7th/cmp-buffer',
      -- lspkind: https://github.com/onsails/lspkind.nvim
      'onsails/lspkind.nvim',
    },
  },

  -- Useful plugin to show you pending keybinds.
  { 'folke/which-key.nvim', opts = {} },
  {
    -- Adds git related signs to the gutter, as well as utilities for managing changes
    'lewis6991/gitsigns.nvim',
    opts = {
      -- See `:help gitsigns.txt`
      signs = {
        add = { text = '+' },
        change = { text = '~' },
        delete = { text = '_' },
        topdelete = { text = '‾' },
        changedelete = { text = '~' },
      },
      on_attach = function(bufnr)
        vim.keymap.set('n', '<leader>hp', require('gitsigns').preview_hunk, { buffer = bufnr, desc = 'Preview git hunk' })
        -- don't override the built-in and fugitive keymaps
        local gs = package.loaded.gitsigns
        vim.keymap.set({'n', 'v'}, ']c', function()
          if vim.wo.diff then return ']c' end
          vim.schedule(function() gs.next_hunk() end)
          return '<Ignore>'
        end, {expr=true, buffer = bufnr, desc = "Jump to next hunk"})
        vim.keymap.set({'n', 'v'}, '[c', function()
          if vim.wo.diff then return '[c' end
          vim.schedule(function() gs.prev_hunk() end)
          return '<Ignore>'
        end, {expr=true, buffer = bufnr, desc = "Jump to previous hunk"})
      end,
    },
  },

  {
    -- Theme inspired by Atom
    -- https://github.com/navarasu/onedark.nvim
    'navarasu/onedark.nvim',
    priority = 1000,
    opts = {
      -- Choices: 'dark' (default), 'darker', 'cool', 'deep', 'warm', 'warmer' and 'light'
      style = 'warmer',
    },
    -- config = function()
    --   vim.cmd.colorscheme 'onedark'
    -- end,
  },

  {
    -- Set lualine as statusline
    'nvim-lualine/lualine.nvim',
    -- See `:help lualine.txt`
    -- TODO update mechanism for downloading and installing nerd fonts
    opts = {
      options = {
        icons_enabled = true,
        theme = 'onedark',
        component_separators = { left = '', right = ''},
        section_separators = { left = '', right = ''},
      },
    },
  },

  {
    -- Add indentation guides even on blank lines
    'lukas-reineke/indent-blankline.nvim',
    -- Enable `lukas-reineke/indent-blankline.nvim`
    -- See `:help indent_blankline.txt`
    main = "ibl",
    opts = { },
  },

  -- "gc" to comment visual regions/lines
  { 'numToStr/Comment.nvim', opts = {} },

  -- Fuzzy Finder (files, lsp, etc)
  {
    'nvim-telescope/telescope.nvim',
    branch = '0.1.x',
    dependencies = {
      'nvim-lua/plenary.nvim',
      -- Fuzzy Finder Algorithm which requires local dependencies to be built.
      -- Only load if `make` is available. Make sure you have the system
      -- requirements installed.
      {
        'nvim-telescope/telescope-fzf-native.nvim',
        -- NOTE: If you are having trouble with this installation,
        --       refer to the README for telescope-fzf-native for more instructions.
        build = 'make',
        cond = function()
          return vim.fn.executable 'make' == 1
        end,
      },
    },
  },

  {
    -- Highlight, edit, and navigate code
    'nvim-treesitter/nvim-treesitter',
    dependencies = {
      'nvim-treesitter/nvim-treesitter-textobjects',
    },
    build = ':TSUpdate',
  },

  -- NOTE: Next Step on Your Neovim Journey: Add/Configure additional "plugins" for kickstart
  --       These are some example plugins that I've included in the kickstart repository.
  --       Uncomment any of the lines below to enable them.
  -- require 'kickstart.plugins.autoformat',
  -- require 'kickstart.plugins.debug',

  -- NOTE: The import below can automatically add your own plugins, configuration, etc from `lua/custom/plugins/*.lua`
  --    You can use this folder to prevent any conflicts with this init.lua if you're interested in keeping
  --    up-to-date with whatever is in the kickstart repo.
  --    Uncomment the following line and add your plugins to `lua/custom/plugins/*.lua` to get going.
  --
  --    For additional information see: https://github.com/folke/lazy.nvim#-structuring-your-plugins
  { import = 'custom.plugins' },
}, {})

-- [[ Setting options ]]
--     _       _ __    __           
--    (_)___  (_) /_  / /_  ______ _
--   / / __ \/ / __/ / / / / / __ `/
--  / / / / / / /__ / / /_/ / /_/ / 
-- /_/_/ /_/_/\__(_)_/\__,_/\__,_/  (init.lua settings)
-- See `:help vim.o` `:help option-summary`

-- DISPLAY SETTINGS
vim.cmd.colorscheme 'onedark'
vim.wo.number = true            -- show line numbers
vim.wo.relativenumber = true    -- use relative line numbers (for easier jumps)
vim.o.hlsearch = true           -- Highlight search results
vim.o.scrolloff = 2
vim.o.colorcolumn = "80"
vim.wo.signcolumn = 'yes'       -- Keep signcolumn on by default
vim.o.termguicolors = true      -- NOTE: make sure your terminal supports this
vim.o.updatetime = 250          -- Faster update time

-- SWAP FILE MADNESS
vim.o.swapfile = false
vim.o.backup = false
vim.o.undofile = true

-- EDITOR USABILITY TOGGLES
vim.o.completeopt = 'menuone,noselect' -- better completion experience
-- vim.o.clipboard = 'unnamedplus' -- Sync OS & nvim clipboard `:help 'clipboard'`
vim.o.mouse = 'a'               -- Enable mouse mode
vim.o.breakindent = true        -- Enable break indent
vim.o.timeoutlen = 300          -- ms wait time for mapped sequence to complete
vim.o.ignorecase = true         -- search: case insensitive
vim.o.smartcase = true          -- search: use case when Captial in search

-- [[ Basic Keymaps ]]

-- Keymaps for better default experience
-- See `:help vim.keymap.set()`
vim.keymap.set('n', '<leader>vrc', '<cmd>source $MYVIMRC<CR>', { desc = "Reload $MYVIMRC"})
vim.keymap.set('n', '<leader>j', '<cmd>cnext<CR>zz', { desc = 'next item in the quick fix list'})
vim.keymap.set('n', '<leader>k', '<cmd>cprev<CR>zz', { desc = 'prev item in the quick fix list'})
vim.keymap.set('n', '<leader>m', '<cmd>w<CR><cmd>!~/.config/nvim/scripts/pandoc/markdown-watch.sh "%" &<CR><CR>',
  { silent = true, desc = 'Live preview edits of markdown documents in $BROWSER'})
vim.keymap.set('n', '<F7>', '<cmd>set spell!<CR>', { desc = "Toggle spellcheck"})
vim.keymap.set('n', '<leader><leader>', '<cmd>set hlsearch!<CR>', { desc = "Toggle highlight search"})

-- Remap for dealing with word wrap
vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- Put relative moves into jumplist (Thanks ChatGPT 4 vimscript port)
HANDLE_JUMP = function(key)
    local count = vim.v.count1
    if count > 5 then
        return string.format("m'%s%s", count, key)
    else
        return key
    end
end
vim.api.nvim_set_keymap('n', 'k', [[v:lua.HANDLE_JUMP('k')]], {expr = true, noremap = true})
vim.api.nvim_set_keymap('n', 'j', [[v:lua.HANDLE_JUMP('j')]], {expr = true, noremap = true})


-- selctions
vim.keymap.set('v', '<C-y>', '"+y<CR>', { desc = 'yank to system clipboard'})
vim.keymap.set('n', 'vv', '0v$', { desc = 'visual select line'})
vim.keymap.set('n', 'n', "nzz", { desc = 'next search result (and center)'})
vim.keymap.set('n', 'N', "Nzz", { desc = 'previous search result (and center)'})
-- moving text
vim.keymap.set('v', 'J', "<cmd>m '>+1<CR>gv=gv", { desc = 'move visual line down'})
vim.keymap.set('v', 'K', "<cmd>m '<-2<CR>gv=gv", { desc = 'move visual line up'})
vim.keymap.set('v', '>', ">gv", { desc = 'outdent visual line'})
vim.keymap.set('v', '<', "<gv", { desc = 'indent visual line'})
vim.keymap.set('n', 'J', 'mzJ`z', { desc = 'smart line collapse'})

-- wrap words
vim.keymap.set('n', '<leader>"', 'ciW""<esc>P', { desc = 'wrap word in double quotes'})
vim.keymap.set('n', "<leader>'", "ciW''<esc>P", { desc = 'wrap word in single quotes'})
vim.keymap.set('n', '<leader>(', 'ciW()<esc>P', { desc = 'wrap word in parantheses'})
vim.keymap.set('n', '<leader><', 'ciW<><esc>P', { desc = 'wrap word in angle brackets'})
vim.keymap.set('n', '<leader>[', 'ciW[]<esc>P', { desc = 'wrap word in square brackets'})
vim.keymap.set('n', '<leader>{', 'ciW{}<esc>P', { desc = 'wrap word in curly braces'})
vim.keymap.set('n', '<leader>`', 'ciW``<esc>P', { desc = 'wrap word in backticks'})
vim.keymap.set('n', '<leader>_', 'ciW__<esc>P', { desc = 'wrap word in underscores'})

-- insert mode
vim.keymap.set('i', '<C-v>', '<esc><cmd>set paste<cr>a<C-r>*<esc><cmd>set paste!<cr>a', { desc = 'Paste from clipboard (with paste mode)'})

-- LEAVING OFF HERE
-- from old config @ 'relative moves into jump list'

-- [[ Highlight on yank ]]
-- See `:help vim.highlight.on_yank()`
local highlight_group = vim.api.nvim_create_augroup('YankHighlight', { clear = true })
vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function()
    vim.highlight.on_yank({ timeout=500 })
  end,
  group = highlight_group,
  pattern = '*',
})

--           _           _                   
--          (_)         | |                  
-- __      ___ _ __   __| | _____      _____ 
-- \ \ /\ / / | '_ \ / _` |/ _ \ \ /\ / / __|
--  \ V  V /| | | | | (_| | (_) \ V  V /\__ \
--   \_/\_/ |_|_| |_|\__,_|\___/ \_/\_/ |___/
--  (RESIZING / SPLITS & WINDOW MANAGEMENT)  
vim.keymap.set({ 'n', 'i' }, '<C-q>', "<esc><C-w>c", { desc = 'Close focused window' })
vim.keymap.set({ 'n', 'i' }, '<C-Up>', "<cmd>resize +1<CR>", { desc = 'GROW window vertically'})
vim.keymap.set({ 'n', 'i' }, '<C-Down>', "<cmd>resize -1<CR>", { desc = 'shrink window vertically' })
vim.keymap.set({ 'n', 'i' }, '<C-Right>', "<cmd>vert resize +2<CR>", { desc = 'GROW window horizontally' })
vim.keymap.set({ 'n', 'i' }, '<C-Left>', "<cmd>vert resize -2<CR>", { desc = 'shrink window horizontally' })
-- fast move focus (normal and insert modes)
vim.keymap.set({ 'n', 'i' }, '<C-h>', '<esc><C-w>h', { desc = 'Focus window to the LEFT'})
vim.keymap.set({ 'n', 'i' }, '<C-j>', '<esc><C-w>j', { desc = 'Focus window DOWN'})
vim.keymap.set({ 'n', 'i' }, '<C-k>', '<esc><C-w>k', { desc = 'Focus window UP'})
vim.keymap.set({ 'n', 'i' }, '<C-l>', '<esc><C-w>l', { desc = 'Focus window to the RIGHT'})
vim.keymap.set('n', '<Left>', '<cmd>bp<CR>', { desc = 'Go to previous buffer'})
vim.keymap.set('n', '<Right>', '<cmd>bn<CR>', { desc = 'Go to next buffer'})

-- [[ Configure Telescope ]]
-- See `:help telescope` and `:help telescope.setup()`
require('telescope').setup {
  defaults = {
    mappings = {
      i = {
        ['<C-u>'] = false,
        ['<C-d>'] = false,
      },
    },
  },
}

-- Enable telescope fzf native, if installed
pcall(require('telescope').load_extension, 'fzf')

-- See `:help telescope.builtin`
vim.keymap.set('n', '<leader>?', require('telescope.builtin').oldfiles, { desc = '[?] Find recently opened files' })
vim.keymap.set('n', '<leader>b', require('telescope.builtin').buffers, { desc = '[ ] Find existing buffers' })
vim.keymap.set('n', '<leader>/', function()
  -- You can pass additional configuration to telescope to change theme, layout, etc.
  require('telescope.builtin').current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
    winblend = 10,
    previewer = false,
  })
end, { desc = '[/] Fuzzily search in current buffer' })

vim.keymap.set('n', '<leader>gf', require('telescope.builtin').git_files, { desc = 'Search [G]it [F]iles' })
vim.keymap.set('n', '<leader>sf', require('telescope.builtin').find_files, { desc = '[S]earch [F]iles' })
-- vim.keymap.set('n', '<leader>p', require('telescope.builtin').find_files, { desc = '[S]earch [F]iles' })
vim.keymap.set('n', '<leader>sh', require('telescope.builtin').help_tags, { desc = '[S]earch [H]elp' })
vim.keymap.set('n', '<leader>sw', require('telescope.builtin').grep_string, { desc = '[S]earch current [W]ord' })
vim.keymap.set('n', '<leader>sg', require('telescope.builtin').live_grep, { desc = '[S]earch by [G]rep' })
vim.keymap.set('n', '<leader>ss', require('telescope.builtin').lsp_document_symbols, { desc = '[S]earch [s]ymbols' })
vim.keymap.set('n', '<leader>sd', require('telescope.builtin').diagnostics, { desc = '[S]earch [D]iagnostics' })
-- vim.keymap.set('n', '<leader>sR', require('telescope.builtin').resume, { desc = '[S]earch [R]resume' })
vim.keymap.set('n', '<leader>sr', require('telescope.builtin').lsp_references, { desc = '[S]earch [R]eferences' })
vim.keymap.set('n', '<leader>sk', require('telescope.builtin').keymaps, { desc = '[S]earch [K]eymaps' })

-- [[ Configure Treesitter ]]
-- See `:help nvim-treesitter`
require('nvim-treesitter.configs').setup {
  -- Add languages to be installed here that you want installed for treesitter
  modules = {},
  ensure_installed = { 'c', 'cpp', 'go', 'lua', 'python', 'rust', 'tsx', 'javascript', 'typescript', 'vimdoc', 'vim' },
  sync_install = true,
  ignore_install = { },

  -- Autoinstall languages that are not installed. Defaults to false (but you can change for yourself!)
  auto_install = false,

  highlight = { enable = true },
  indent = { enable = true },
  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = '<c-space>',
      node_incremental = '<c-space>',
      scope_incremental = '<c-s>',
      node_decremental = '<M-space>',
    },
  },
  textobjects = {
    select = {
      enable = true,
      lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
      keymaps = {
        -- You can use the capture groups defined in textobjects.scm
        ['aa'] = '@parameter.outer',
        ['ia'] = '@parameter.inner',
        ['af'] = '@function.outer',
        ['if'] = '@function.inner',
        ['ac'] = '@class.outer',
        ['ic'] = '@class.inner',
      },
    },
    move = {
      enable = true,
      set_jumps = true, -- whether to set jumps in the jumplist
      goto_next_start = {
        [']m'] = '@function.outer',
        [']]'] = '@class.outer',
      },
      goto_next_end = {
        [']M'] = '@function.outer',
        [']['] = '@class.outer',
      },
      goto_previous_start = {
        ['[m'] = '@function.outer',
        ['[['] = '@class.outer',
      },
      goto_previous_end = {
        ['[M'] = '@function.outer',
        ['[]'] = '@class.outer',
      },
    },
    swap = {
      enable = true,
      swap_next = {
        ['<leader>a'] = '@parameter.inner',
      },
      swap_previous = {
        ['<leader>A'] = '@parameter.inner',
      },
    },
  },
}

-- Diagnostic keymaps
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Go to previous diagnostic message' })
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'Go to next diagnostic message' })
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Open floating diagnostic message' })
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostics list' })

-- [[ Configure LSP ]]
--  This function gets run when an LSP connects to a particular buffer.
local on_attach = function(_, bufnr)
  -- NOTE: Remember that lua is a real programming language, and as such it is possible
  -- to define small helper and utility functions so you don't have to repeat yourself
  -- many times.
  --
  -- In this case, we create a function that lets us more easily define mappings specific
  -- for LSP related items. It sets the mode, buffer and description for us each time.
  local nmap = function(keys, func, desc)
    if desc then
      desc = 'LSP: ' .. desc
    end

    vim.keymap.set('n', keys, func, { buffer = bufnr, desc = desc })
  end

  nmap('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
  nmap('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')

  nmap('gd', vim.lsp.buf.definition, '[G]oto [D]efinition')
  nmap('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
  nmap('gI', require('telescope.builtin').lsp_implementations, '[G]oto [I]mplementation')
  nmap('<leader>D', vim.lsp.buf.type_definition, 'Type [D]efinition')
  nmap('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')
  nmap('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')

  -- See `:help K` for why this keymap
  nmap('K', vim.lsp.buf.hover, 'Hover Documentation')
  nmap('<C-s>', vim.lsp.buf.signature_help, 'Signature Documentation')

  -- Lesser used LSP functionality
  nmap('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
  nmap('<leader>wa', vim.lsp.buf.add_workspace_folder, '[W]orkspace [A]dd Folder')
  nmap('<leader>wr', vim.lsp.buf.remove_workspace_folder, '[W]orkspace [R]emove Folder')
  nmap('<leader>wl', function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, '[W]orkspace [L]ist Folders')

  -- Create a command `:Format` local to the LSP buffer
  vim.api.nvim_buf_create_user_command(bufnr, 'Format', function(_)
    vim.lsp.buf.format()
  end, { desc = 'Format current buffer with LSP' })
end

-- Enable the following language servers
--  Feel free to add/remove any LSPs that you want here. They will automatically be installed.
--
--  Add any additional override configuration in the following tables. They will be passed to
--  the `settings` field of the server config. You must look up that documentation yourself.
--
--  If you want to override the default filetypes that your language server will attach to you can
--  define the property 'filetypes' to the map in question.
local servers = {
  -- clangd = {},
  -- gopls = {},
  pyright = {},
  -- rust_analyzer = {},
  -- tsserver = {},
  -- html = { filetypes = { 'html', 'twig', 'hbs'} },

  lua_ls = {
    Lua = {
      workspace = { checkThirdParty = false },
      telemetry = { enable = false },
    },
  },
}

-- Setup neovim lua configuration
require('neodev').setup()

-- nvim-cmp supports additional completion capabilities, so broadcast that to servers
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

-- Ensure the servers above are installed
local mason_lspconfig = require 'mason-lspconfig'

mason_lspconfig.setup {
  ensure_installed = vim.tbl_keys(servers),
}

mason_lspconfig.setup_handlers {
  function(server_name)
    require('lspconfig')[server_name].setup {
      capabilities = capabilities,
      on_attach = on_attach,
      settings = servers[server_name],
      filetypes = (servers[server_name] or {}).filetypes,
    }
  end
}

-- [[ Configure nvim-cmp ]]
-- See `:help cmp`
local cmp = require 'cmp'
local luasnip = require 'luasnip'
local lspkind = require 'lspkind'
require('luasnip.loaders.from_vscode').lazy_load()
luasnip.config.setup {}

cmp.setup {
  formatting = {
    format = lspkind.cmp_format({
      mode = 'symbol',
      maxwidth = 50,
    ellipsis_char = '...',
    }),
  },
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
  mapping = cmp.mapping.preset.insert {
    ['<C-n>'] = cmp.mapping.select_next_item(),
    ['<C-p>'] = cmp.mapping.select_prev_item(),
    ['<C-d>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete {},
    ['<CR>'] = cmp.mapping.confirm {
      behavior = cmp.ConfirmBehavior.Replace,
      select = true,
    },
    ['<Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif luasnip.expand_or_locally_jumpable() then
        luasnip.expand_or_jump()
      else
        fallback()
      end
    end, { 'i', 's' }),
    ['<S-Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif luasnip.locally_jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, { 'i', 's' }),
  },
  sources = {
    { name = 'nvim_lsp' },
    { name = 'luasnip' },
    { name = 'path' },
    {
      name = 'buffer',
      option = {
        keyword_length = 2,
        get_bufnrs = function ()
          return vim.api.nvim_list_bufs()
        end
      }
    },
  },
}

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et

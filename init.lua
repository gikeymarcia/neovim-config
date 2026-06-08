--[[

Kickstart.nvim is *not* a distribution.

If you don't know anything about Lua, I recommend taking some time to read through
a guide. One possible example:
- https://learnxinyminutes.com/docs/lua/

And then you can explore or search through `:help lua-guide`
- https://neovim.io/doc/user/lua-guide.html

I hope you enjoy your Neovim journey,
- TJ

--]]
-- See `:help mapleader`
--  NOTE: Must happen before plugins are required (otherwise wrong leader will be used)
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '
-- enable nerd-font glyphs (diagnostic signs, etc.)
vim.g.have_nerd_font = true

-- Install package manager
--    https://github.com/folke/lazy.nvim
--    `:help lazy.nvim.txt` for more info
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not vim.uv.fs_stat(lazypath) then
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

require('lazy').setup({

  -- Git related plugins
  { 'tpope/vim-fugitive',
    lazy = false,
    keys = {
      { "<leader>G", "<cmd>G<cr>", 'n', desc = "Launch vim fugitive" },
    },
  },
  'tpope/vim-rhubarb',

  -- Trailing whitespace: highlight (all filetypes incl. markdown) + trim
  { 'echasnovski/mini.trailspace', version = false, opts = {} },

  -- Surround text objects: sa add / sd delete / sr replace (uses `s` prefix)
  { 'echasnovski/mini.surround', version = false, opts = {} },

  -- Detect tabstop and shiftwidth automatically
  'tpope/vim-sleuth',

  {
    -- LSP Configuration & Plugins
    'neovim/nvim-lspconfig',
    dependencies = {
      -- Language servers are installed from the OS package manager via
      -- ./install-language-servers-{Arch,MacOS}.sh and enabled with
      -- vim.lsp.enable() below. nvim-lspconfig only ships the default server
      -- configs that vim.lsp.config() consumes.

      -- Useful status updates for LSP
      -- NOTE: `opts = {}` is the same as calling `require('fidget').setup({})`
      { 'j-hui/fidget.nvim', tag = 'legacy', opts = {} },

      -- JSON Schema catalog (schemastore.org) fed to yamlls below
      'b0o/SchemaStore.nvim',
    },
  },

  {
    -- Configures lua_ls for editing your Neovim config: adds the right
    -- libraries on the fly as you `require()` modules.
    'folke/lazydev.nvim',
    ft = 'lua',
    opts = {
      library = {
        -- pull in luvit (vim.uv) types when `vim.uv` is referenced
        { path = '${3rd}/luv/library', words = { 'vim%.uv' } },
      },
    },
  },

  {
    -- Autocompletion.
    -- PLAN: migrate to blink.cmp (faster, actively developed) once its v2
    -- line lands and settles. Reminder: check blink.cmp v2 status in Dec 2026
    -- -> https://github.com/saghen/blink.cmp/releases
    'hrsh7th/nvim-cmp',
    event = "InsertEnter",
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
  },

  {
    -- Set lualine as statusline
    'nvim-lualine/lualine.nvim',
    dependencies = { "nvim-tree/nvim-web-devicons" },
    -- See `:help lualine.txt`
    opts = {
      options = {
        icons_enabled = true,
        theme = 'nord',
        component_separators = { left = '', right = ''},
        section_separators = { left = '', right = ''},
      },
    },
  },

  {
    -- Add indentation guides even on blank lines
    'lukas-reineke/indent-blankline.nvim',
    -- See `:help indent_blankline.txt`
    main = "ibl",
    opts = { },
  },

  -- Fuzzy Finder (files, lsp, etc)
  {
    'nvim-telescope/telescope.nvim',
    branch = 'master',
    version = '*',
    dependencies = {
      'nvim-lua/plenary.nvim',
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
    branch = "main",
    lazy = false,
    build = ':TSUpdate',
    dependencies = {
      -- textobjects: operate on functions/classes/arguments as motions.
      -- Configured in the treesitter section below; see
      -- doc/tree-sitter-text-objects-usage.txt for usage.
      { 'nvim-treesitter/nvim-treesitter-textobjects', branch = 'main' },
    },
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
vim.cmd.colorscheme 'nord'
vim.wo.number = true            -- show line numbers
vim.wo.relativenumber = true    -- use relative line numbers (for easier jumps)
vim.o.hlsearch = true           -- Highlight search results
vim.o.scrolloff = 2
vim.o.colorcolumn = "80"
vim.wo.signcolumn = 'yes'       -- Keep signcolumn on by default
vim.o.termguicolors = true      -- NOTE: make sure your terminal supports this
vim.o.updatetime = 250          -- Faster update time
vim.opt.cursorline = true       -- Show which line your cursor is on
-- Don't show the mode, since it's already in the status line
vim.opt.showmode = false
-- Sets how neovim will display certain whitespace characters in the editor.
vim.opt.list = true             --  See `:help 'list'` and `:help 'listchars'`
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }
-- Preview substitutions live, as you type!
vim.opt.inccommand = 'split'
vim.o.winborder = 'rounded'     -- rounded borders on floating windows (hover, signature, ...)

-- FOLDING (treesitter-aware). Start fully unfolded; fold manually with za / zM.
vim.o.foldmethod = 'expr'
vim.o.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
vim.o.foldlevelstart = 99

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
vim.opt.confirm = true

-- [[ Basic Keymaps ]]

-- Keymaps for better default experience
-- See `:help vim.keymap.set()`
vim.keymap.set('n', '<leader>vrc', '<cmd>source $MYVIMRC<CR>', { desc = "Reload $MYVIMRC"})
vim.keymap.set('n', '<leader>vl', function()
  local clients = vim.lsp.get_clients { bufnr = 0 }
  if vim.tbl_isempty(clients) then
    vim.notify('No LSP attached to this buffer', vim.log.levels.WARN)
    return
  end
  local names = vim.tbl_map(function(c) return c.name end, clients)
  vim.notify('LSP: ' .. table.concat(names, ', '))
end, { desc = '[V]iew [L]SP clients attached to buffer' })
vim.keymap.set('n', '<leader>vf', function()
  vim.notify('filetype: ' .. (vim.bo.filetype == '' and '(none)' or vim.bo.filetype))
end, { desc = '[V]iew [F]iletype of buffer' })
vim.keymap.set('n', '<leader>vh', function()
  local on = not vim.lsp.inlay_hint.is_enabled()
  vim.lsp.inlay_hint.enable(on)
  vim.notify('inlay hints ' .. (on and 'ON' or 'OFF'))
end, { desc = '[V]iew toggle inlay [H]ints' })
vim.keymap.set('n', '<leader>tw', function() require('mini.trailspace').trim() end, { desc = '[T]rim trailing [W]hitespace' })
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
vim.keymap.set('v', '<C-y>', '"+y', { desc = 'yank to system clipboard'})
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

-- [[ Highlight on yank ]]
-- See `:help vim.hl.on_yank()`
local highlight_group = vim.api.nvim_create_augroup('YankHighlight', { clear = true })
vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function()
    vim.hl.on_yank({ timeout=500 })
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
vim.opt.splitright = false
vim.opt.splitbelow = false
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
vim.keymap.set('n', '<leader>sh', require('telescope.builtin').help_tags, { desc = '[S]earch [H]elp' })
vim.keymap.set('n', '<leader>sw', require('telescope.builtin').grep_string, { desc = '[S]earch current [W]ord' })
vim.keymap.set('n', '<leader>sg', require('telescope.builtin').live_grep, { desc = '[S]earch by [G]rep' })
vim.keymap.set('n', '<leader>ss', require('telescope.builtin').lsp_document_symbols, { desc = '[S]earch [s]ymbols' })
vim.keymap.set('n', '<leader>sd', require('telescope.builtin').diagnostics, { desc = '[S]earch [D]iagnostics' })
vim.keymap.set('n', '<leader>sR', require('telescope.builtin').resume, { desc = '[S]earch [R]esume' })
vim.keymap.set('n', '<leader>sr', require('telescope.builtin').lsp_references, { desc = '[S]earch [R]eferences' })
vim.keymap.set('n', '<leader>sk', require('telescope.builtin').keymaps, { desc = '[S]earch [K]eymaps' })

-- [[ Configure Treesitter ]]
-- See `:help nvim-treesitter`
require('nvim-treesitter').setup {
  install_dir = vim.fn.stdpath('data') .. '/site',
}
require('nvim-treesitter').install { 'bash', 'css', 'desktop', 'dockerfile', 'git_config', 'gitcommit', 'gitignore', 'hcl', 'http', 'hyprlang', 'jinja', 'jinja_inline', 'json', 'go', 'lua', 'markdown', 'markdown_inline', 'python', 'readline', 'rust', 'ssh_config', 'terraform', 'tmux', 'javascript', 'typescript', 'vimdoc', 'vim', 'yaml', 'zsh' }

-- The `main` branch of nvim-treesitter no longer auto-enables highlighting via
-- a `highlight = { enable = true }` option. Start the treesitter highlighter
-- per-buffer for any filetype that has a parser installed (pcall guards the
-- case where a parser isn't available yet / still installing).
vim.api.nvim_create_autocmd('FileType', {
  group = vim.api.nvim_create_augroup('kickstart-treesitter', { clear = true }),
  callback = function()
    pcall(vim.treesitter.start)
  end,
})

-- [[ Treesitter textobjects ]]
-- Structural editing: select / move / swap by syntax node (function, class,
-- argument, ...). Full usage guide: doc/tree-sitter-text-objects-usage.txt
require('nvim-treesitter-textobjects').setup {
  select = { lookahead = true }, -- if cursor is before the textobject, jump to it
  move = { set_jumps = true }, --    record moves in the jumplist (<C-o> returns)
}

-- SELECT (operator-pending `o` + visual `x`): e.g. `daf`, `cif`, `vac`, `yaa`
local ts_select = require 'nvim-treesitter-textobjects.select'
local select_maps = {
  -- https://github.com/nvim-treesitter/nvim-treesitter-textobjects/blob/main/BUILTIN_TEXTOBJECTS.md
  ['af'] = '@function.outer',
  ['if'] = '@function.inner',
  ['ac'] = '@class.outer',
  ['ic'] = '@class.inner',
  ['aa'] = '@parameter.outer', -- a = argument
  ['ia'] = '@parameter.inner',
  ['ai'] = '@conditional.outer',
  ['ii'] = '@conditional.inner',
  ['al'] = '@loop.outer',
  ['il'] = '@loop.inner',
  ['a='] = '@assignment.outer',
  ['i='] = '@assignment.inner',
}
for lhs, capture in pairs(select_maps) do
  vim.keymap.set({ 'x', 'o' }, lhs, function()
    ts_select.select_textobject(capture, 'textobjects')
  end, { desc = 'TS select ' .. capture })
end

-- MOVE (normal/visual/operator-pending): jump between functions and arguments.
-- (class moves are left unmapped: ]c/[c belong to gitsigns hunks.)
local ts_move = require 'nvim-treesitter-textobjects.move'
local move_maps = {
  goto_next_start = { [']f'] = '@function.outer', [']a'] = '@parameter.inner' },
  goto_next_end = { [']F'] = '@function.outer' },
  goto_previous_start = { ['[f'] = '@function.outer', ['[a'] = '@parameter.inner' },
  goto_previous_end = { ['[F'] = '@function.outer' },
}
for fn, maps in pairs(move_maps) do
  for lhs, capture in pairs(maps) do
    vim.keymap.set({ 'n', 'x', 'o' }, lhs, function()
      ts_move[fn](capture, 'textobjects')
    end, { desc = 'TS ' .. fn .. ' ' .. capture })
  end
end

-- SWAP the argument under the cursor with the next / previous one.
local ts_swap = require 'nvim-treesitter-textobjects.swap'
vim.keymap.set('n', '<leader>a', function()
  ts_swap.swap_next '@parameter.inner'
end, { desc = 'Swap argument with next' })
vim.keymap.set('n', '<leader>A', function()
  ts_swap.swap_previous '@parameter.inner'
end, { desc = 'Swap argument with previous' })

-- Diagnostic keymaps
-- See :help vim.diagnostic.Opts
vim.diagnostic.config {
  jump = { float = true },
  severity_sort = true,
  float = { border = 'rounded', source = 'if_many' },
  underline = { severity = vim.diagnostic.severity.ERROR },
  signs = vim.g.have_nerd_font and {
    text = {
      [vim.diagnostic.severity.ERROR] = '󰅚 ',
      [vim.diagnostic.severity.WARN] = '󰀪 ',
      [vim.diagnostic.severity.INFO] = '󰋽 ',
      [vim.diagnostic.severity.HINT] = '󰌶 ',
    },
  } or {},
  virtual_text = {
    source = 'if_many',
    spacing = 2,
    format = function(diagnostic)
      local diagnostic_message = {
        [vim.diagnostic.severity.ERROR] = diagnostic.message,
        [vim.diagnostic.severity.WARN] = diagnostic.message,
        [vim.diagnostic.severity.INFO] = diagnostic.message,
        [vim.diagnostic.severity.HINT] = diagnostic.message,
      }
      return diagnostic_message[diagnostic.severity]
    end,
  },
  -- full, multi-line diagnostic rendered under the current line
  virtual_lines = { current_line = true },
}
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Open floating diagnostic message' })
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostics list' })

-- [[ Configure LSP ]]
--  These keymaps get set when a language server attaches to a buffer.
--  See `:help lsp-attach`. (Neovim 0.11+: on_attach is wired via this autocmd
--  rather than per-server, since mason-lspconfig v2 no longer exposes
--  setup_handlers and servers are enabled through vim.lsp.enable.)
vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
  callback = function(event)
    local bufnr = event.buf
    -- Helper to define buffer-local LSP mappings with a description.
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
  end,
})

-- Enable the following language servers.
--  Keys are lspconfig server names; values are per-server overrides that get
--  merged onto nvim-lspconfig's shipped defaults via vim.lsp.config().
--
--  There is NO mason here. Install the binaries with the per-OS script:
--    ./install-language-servers-Arch.sh     (pacman / AUR via yay / pipx)
--    ./install-language-servers-MacOS.sh    (brew / pipx / npm / cargo)
--  Each server auto-starts when its executable is found on PATH, and quietly
--  does nothing if it isn't -- so a machine missing a server just skips it
--  instead of erroring.
--
--  Ecosystem per server (most are NOT npm):
--    lua_ls                -> compiled binary (pacman / brew)
--    terraformls           -> Go binary (pacman / brew)
--    systemd_lsp           -> Rust binary (pacman on Arch; `cargo install systemd-lsp` elsewhere)
--    nginx_language_server -> Python (pipx)
--    pyright               -> node (pacman / brew; node is a managed dependency)
--    ansiblels             -> node (AUR / npm); also shells out to `ansible-lint`
--    yamlls                -> pacman / homebrew installed
local servers = {
  -- clangd = {},
  -- gopls = {},
  -- rust_analyzer = {},
  -- ts_ls = {},
  bashls = {},
  pyright = {
    settings = {
      python = {
        analysis = {
          inlayHints = {
            variableTypes = true,
            functionReturnTypes = true,
            callArgumentNames = true,
          },
        },
      },
    },
  },
  yamlls = {
    settings = {
      yaml = {
        -- use SchemaStore.nvim's catalog (more current) instead of the built-in
        schemaStore = { enable = false, url = '' },
        schemas = require('schemastore').yaml.schemas(),
      },
    },
  },
  ansiblels = {},
  terraformls = {},
  systemd_lsp = {},
  nginx_language_server = {},
  lua_ls = {
    settings = {
      Lua = {
        hint = { enable = false }, -- inlay hints
        workspace = { checkThirdParty = false },
        telemetry = { enable = false },
      },
    },
  },
}

-- nvim-cmp supports additional completion capabilities, so broadcast that to
-- every server via the wildcard config.
local capabilities = require('cmp_nvim_lsp').default_capabilities()
vim.lsp.config('*', { capabilities = capabilities })

-- Register per-server overrides.
for server, config in pairs(servers) do
  vim.lsp.config(server, config)
end

-- Enable the servers directly. Core auto-starts each on a matching buffer when
-- it finds the executable on PATH (installed via the per-OS install script),
-- and quietly does nothing if the binary is absent.
vim.lsp.enable(vim.tbl_keys(servers))

-- Show inline type hints from any server that supports them.
-- Toggle: :lua vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
vim.lsp.inlay_hint.enable(true)

-- [[ Configure nvim-cmp ]]
-- See `:help cmp`
local cmp = require 'cmp'
local luasnip = require 'luasnip'
local lspkind = require('lspkind')
require('luasnip.loaders.from_vscode').lazy_load()
luasnip.config.setup {}

cmp.setup {
  --- https://www.reddit.com/r/neovim/comments/16gd5zp/suppress_missing_fields_lsp_warnings_lualsp_and/
  ---@diagnostic disable-next-line: missing-fields
  formatting = {
    format = lspkind.cmp_format({
      mode = 'symbol',
      maxwidth = {
        -- prevent the popup from showing more than provided characters (e.g 50 will not show more than 50 characters)
        -- can also be a function to dynamically calculate max width such as
        -- menu = function() return math.floor(0.45 * vim.o.columns) end,
        menu = 50, -- leading text (labelDetails)
        abbr = 50, -- actual suggestion item
      },
    ellipsis_char = '...',
    show_labelDetails = true, -- show labelDetails in menu. Disabled by default
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
    -- lazydev: complete require() paths for your nvim config / plugins
    { name = 'lazydev', group_index = 0 },
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

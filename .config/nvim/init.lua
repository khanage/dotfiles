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

require('lazy').setup({
  -- Git related plugins
  'tpope/vim-fugitive',
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
      { 'j-hui/fidget.nvim',       tag = 'legacy', opts = {} },

      -- Additional lua configuration, makes nvim stuff amazing!
      'folke/neodev.nvim',
    },
  },

  -- Useful plugin to show you pending keybinds.
  'folke/which-key.nvim',

  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    opts = {
      integrations = {
        cmp = true,
        dap = true,
        dap_ui = true,
        nvimtree = true,
        treesitter = true,
        treesitter_context = true,
        mason = true,
        rainbow_delimiters = true,
        which_key = true,
        neogit = true,
        telescope = {
          enabled = true,
        },
        indent_blankline = {
          enabled = true,
          scope_color = "mocha",
          colored_indent_levels = true,
        },
        native_lsp = {
          enabled = true,
          virtual_text = {
            errors = { "italic" },
            hints = { "italic" },
            warnings = { "italic" },
            information = { "italic" },
          },
          underlines = {
            errors = { "underline" },
            hints = { "underline" },
            warnings = { "underline" },
            information = { "underline" },
          },
          inlay_hints = {
            background = true,
          },
        },
      }
    }
  },

  { 'akinsho/bufferline.nvim', dependencies = 'nvim-tree/nvim-web-devicons' },

  {
    -- Set lualine as statusline
    'nvim-lualine/lualine.nvim',
    dependencies = {
      'arkav/lualine-lsp-progress'
    },
    -- See `:help lualine.txt`
    config = function()
      local lualine = require('lualine')
      lualine.setup({
        options = {
          theme = 'catppuccin',
          section_separators = '',
          component_separators = '',
        },
        sections = {
          lualine_a = { { 'mode', separator = { right = '' } } },
          lualine_b = {
            { 'filetype', icon_only = true },
            {
              'filename',
              path = 3
            },
            {
              'diagnostics',
              sources = { 'nvim_diagnostic', 'nvim_lsp' }
            },
            'location'
          },
          lualine_c = {},
          lualine_x = { {
            'lsp_progress',
            separators = {
              component = ' ',
              progress = ' | ',
              percentage = { pre = '', post = '%% ' },
              title = { pre = '', post = ': ' },
              lsp_client_name = { pre = '[', post = ']' },
              spinner = { pre = '', post = '' },
              message = { pre = '(', post = ')', commenced = 'In Progress', completed = 'Completed' },
            },
            display_components = { 'lsp_client_name', 'spinner', { 'title', 'percentage', 'message' } },
            timer = { progress_enddelay = 500, spinner = 1000, lsp_client_name_enddelay = 1000 },
            spinner_symbols = { '🌑 ', '🌒 ', '🌓 ', '🌔 ', '🌕 ', '🌖 ', '🌗 ', '🌘 ' },
          }
          },
          lualine_y = { 'diff' },
          lualine_z = { { 'branch', separator = { left = '' } } },
        },
      })

      vim.api.nvim_create_augroup("lualine_augroup", { clear = true })
      vim.api.nvim_create_autocmd("User", {
        group = "lualine_augroup",
        pattern = "LspProgressStatusUpdated",
        callback = lualine.refresh,
      })
    end
  },

  -- Add indentation guides even on blank lines
  'lukas-reineke/indent-blankline.nvim',

  'https://gitlab.com/HiPhish/rainbow-delimiters.nvim',

  -- "gc" to comment visual regions/lines
  { 'numToStr/Comment.nvim',   opts = {} },

  -- Fuzzy Finder (files, lsp, etc)
  {
    'nvim-telescope/telescope.nvim',
    branch = '0.1.x',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'smartpde/telescope-recent-files',
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

  {
    'windwp/nvim-autopairs',
    dependencies = {
      'windwp/nvim-ts-autotag'
    },
    opts = {
      check_ts = true,
      ts_config = {
        lua = { "string" },
      }
    }
  },

  -- NvimTree
  {
    'nvim-tree/nvim-tree.lua',
    dependencies = {
      'kyazdani42/nvim-web-devicons'
    }
  },

  'tpope/vim-surround',

  'vim-scripts/ReplaceWithRegister',

  'mbbill/undotree',

  require "kickstart.plugins.autoformat",
  require "kickstart.plugins.debug",

  { import = 'custom.plugins' },
}, {})

-- [[ Setting options ]]
-- See `:help vim.o`
-- NOTE: You can change these options as you wish!

-- Make line numbers default
vim.wo.number = true

vim.o.incsearch = true
vim.o.scrolloff = 8
vim.o.colorcolumn = "80"

-- Enable mouse mode
vim.o.mouse = 'a'

-- Sync clipboard between OS and Neovim.
--  Remove this option if you want your OS clipboard to remain independent.
--  See `:help 'clipboard'`
vim.o.clipboard = 'unnamedplus'

-- Enable break indent
vim.o.breakindent = true

-- Save undo history
vim.o.swapfile = false
vim.o.backup = false
vim.o.undodir = os.getenv("HOME") .. "/.vim/undodir"
vim.o.undofile = true

-- Case-insensitive searching UNLESS \C or capital in search
vim.o.ignorecase = true
vim.o.smartcase = true

-- Keep signcolumn on by default
vim.wo.signcolumn = 'yes'

-- Decrease update time
vim.o.updatetime = 250
vim.o.timeoutlen = 300

-- Set completeopt to have a better completion experience
vim.o.completeopt = 'menu,menuone,noselect,preview'

-- NOTE: You should make sure your terminal supports this
vim.o.termguicolors = true
require("bufferline").setup()

-- NvimTree
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

vim.o.termguicolors = true

vim.o.relativenumber = true
vim.o.number = true

vim.o.tabstop = 2
vim.o.shiftwidth = 2
vim.o.expandtab = true
vim.o.autoindent = true

vim.o.wrap = false

vim.o.cursorline = true
vim.o.cursorcolumn = true

vim.o.backspace = "indent,eol,start"

-- split windows
vim.o.splitright = true
vim.o.splitbelow = true

-- [[ Basic Keymaps ]]

local keymap = vim.keymap

-- Keymaps for better default experience
-- See `:help vim.keymap.set()`
keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })

-- Remap for dealing with word wrap
keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

keymap.set('n', '<leader>u', vim.cmd.UndotreeToggle)

-- [[ Highlight on yank ]]
-- See `:help vim.highlight.on_yank()`
local highlight_group = vim.api.nvim_create_augroup('YankHighlight', { clear = true })
vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function()
    vim.highlight.on_yank()
  end,
  group = highlight_group,
  pattern = '*',
})

-- [[ Configure Telescope ]]
-- See `:help telescope` and `:help telescope.setup()`
local telescope = require('telescope')
local telescope_actions = require('telescope.actions')

telescope.setup {
  defaults = {
    mappings = {
      i = {
        ['<C-u>'] = false,
        ['<C-d>'] = false,
        ['<esc>'] = telescope_actions.close,
      },
    },
  },
}

telescope.load_extension("recent_files")

-- Enable telescope fzf native, if installed
pcall(telescope.load_extension, 'fzf')

-- See `:help telescope.builtin`
keymap.set('n', '<leader>?', require('telescope.builtin').oldfiles, { desc = '[?] Find recently opened files' })
keymap.set('n', '<leader><space>', require('telescope.builtin').buffers, { desc = '[ ] Find existing buffers' })
keymap.set('n', '<leader>/', function()
  -- You can pass additional configuration to telescope to change theme, layout, etc.
  require('telescope.builtin').current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
    winblend = 10,
    previewer = false,
  })
end, { desc = '[/] Fuzzily search in current buffer' })

keymap.set('n', '<leader>gf', require('telescope.builtin').git_files, { desc = 'Search [G]it [F]iles' })
keymap.set('n', '<leader>sf', require('telescope.builtin').find_files, { desc = '[S]earch [F]iles' })
keymap.set('n', '<leader>sh', require('telescope.builtin').help_tags, { desc = '[S]earch [H]elp' })
keymap.set('n', '<leader>sw', require('telescope.builtin').grep_string, { desc = '[S]earch current [W]ord' })
keymap.set('n', '<leader>sg', require('telescope.builtin').live_grep, { desc = '[S]earch by [G]rep' })
keymap.set('n', '<leader>sd', require('telescope.builtin').diagnostics, { desc = '[S]earch [D]iagnostics' })
keymap.set('n', '<leader>sr', require('telescope').extensions.recent_files.pick, { desc = '[S]earch [R]ecent' })
keymap.set('n', '<leader>ss', require('telescope.builtin').resume, { desc = '[S]earch Resume' })
keymap.set('n', '<leader>sc', function()
  require('telescope.builtin').find_files({ cwd = '~/.config/nvim' })
end, { desc = '[S]earch nvim [C]onfig' })

-- [[ Configure Treesitter ]]
-- See `:help nvim-treesitter`
require('nvim-treesitter.configs').setup {
  -- Add languages to be installed here that you want installed for treesitter
  ensure_installed = {
    'lua', 'rust', 'tsx', 'javascript', 'typescript',
    'vimdoc', 'vim', 'yaml', 'toml', 'sql', 'json', 'haskell',
    'html', 'c_sharp', 'bicep', 'make', 'dockerfile', 'kdl',
    'bash', 'terraform'
  },

  ignore_install = {},

  modules = {},

  sync_install = false,

  -- Autoinstall languages that are not installed. Defaults to false (but you can change for yourself!)
  auto_install = false,

  highlight = { enable = true },
  indent = { enable = true },
  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = "gnn",
      node_incremental = "grn",
      scope_incremental = "grc",
      node_decremental = "grm",
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
keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Go to previous diagnostic message' })
keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'Go to next diagnostic message' })
keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Open floating diagnostic message' })
keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostics list' })

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
  -- pyright = {},
  tsserver = {},
  html = { filetypes = { 'html', 'twig', 'hbs' } },
  csharp_ls = {},
  terraformls = {},
  bicep = {},
  azure_pipelines_ls = {},
  lua_ls = {
    Lua = {
      workspace = { checkThirdParty = false },
      telemetry = { enable = false },
    },
  },
  rust_analyzer = {},
}

-- Setup neovim lua configuration
require('neodev').setup()

-- nvim-cmp supports additional completion capabilities, so broadcast that to servers
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(
  vim.lsp.handlers.hover, {
    border = "rounded",
    focusable = true,
    focus = true,
  }
)

-- Ensure the servers above are installed
local mason_lspconfig = require 'mason-lspconfig'
local lsp_on_attach = require('custom.lsp').lsp_on_attach
local lsp_config = require('lspconfig')

mason_lspconfig.setup {
  ensure_installed = vim.tbl_keys(servers),
}

mason_lspconfig.setup_handlers {
  function(server_name)
    if (server_name == 'csharp_ls')
    then
      lsp_config[server_name].setup {
        capabilities = capabilities,
        on_attach = lsp_on_attach,
        settings = servers[server_name],
        filetypes = (servers[server_name] or {}).filetypes,
        root_dir = function(startpath)
          local lspconfig = lsp_config
          return lspconfig.util.root_pattern("*.sln")(startpath)
              or lspconfig.util.root_pattern("*.csproj")(startpath)
              or lspconfig.util.root_pattern("*.fsproj")(startpath)
              or lspconfig.util.root_pattern(".git")(startpath)
        end
      }
    elseif (server_name == 'rust_analyzer')
    then
    else
      lsp_config[server_name].setup {
        capabilities = capabilities,
        on_attach = lsp_on_attach,
        settings = servers[server_name],
        filetypes = (servers[server_name] or {}).filetypes,
      }
    end
  end
}

-- [[ Configure nvim-tree ]]
local HEIGHT_RATIO = 0.8
local WIDTH_RATIO = 0.5

local function nvim_tree_on_attach(bufnr)
  local api = require 'nvim-tree.api'

  local function opts(desc)
    return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = false, nowait = true }
  end

  api.config.mappings.default_on_attach(bufnr)

  keymap.set('n', '<C-t>', api.tree.change_root_to_parent, opts('Up'))
  keymap.set('n', '?', api.tree.toggle_help, opts('Help'))
end

require('nvim-tree').setup({
  view = {
    float = {
      enable = true,
      open_win_config = function()
        local screen_w = vim.o.columns
        local screen_h = vim.o.lines - vim.o.cmdheight
        local window_w = screen_w * WIDTH_RATIO
        local window_h = screen_h * HEIGHT_RATIO
        local window_w_int = math.floor(window_w)
        local window_h_int = math.floor(window_h)
        local center_x = (screen_w - window_w) / 2
        local center_y = ((vim.o.lines - window_h) / 2) - vim.o.cmdheight
        return {
          border = 'rounded',
          relative = 'editor',
          row = center_y,
          col = center_x,
          width = window_w_int,
          height = window_h_int
        }
      end,
    },
    width = function()
      return math.floor(vim.o.columns * WIDTH_RATIO)
    end,
  },
  on_attach = nvim_tree_on_attach,
})

keymap.set('n', '<leader>o', function() require('nvim-tree.api').tree.toggle({ find_file = true }) end,
  { desc = "nvim-tree: [O]pen the file tree", noremap = true, nowait = true })

require("catppuccin").setup({
})

vim.cmd.colorscheme "catppuccin"

local highlight = {
  "RainbowRed",
  "RainbowYellow",
  "RainbowBlue",
  "RainbowOrange",
  "RainbowGreen",
  "RainbowViolet",
  "RainbowCyan",
}
local hooks = require "ibl.hooks"
-- create the highlight groups in the highlight setup hook, so they are reset
-- every time the colorscheme changes
hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
  vim.api.nvim_set_hl(0, "RainbowRed", { fg = "#E06C75" })
  vim.api.nvim_set_hl(0, "RainbowYellow", { fg = "#E5C07B" })
  vim.api.nvim_set_hl(0, "RainbowBlue", { fg = "#61AFEF" })
  vim.api.nvim_set_hl(0, "RainbowOrange", { fg = "#D19A66" })
  vim.api.nvim_set_hl(0, "RainbowGreen", { fg = "#98C379" })
  vim.api.nvim_set_hl(0, "RainbowViolet", { fg = "#C678DD" })
  vim.api.nvim_set_hl(0, "RainbowCyan", { fg = "#56B6C2" })
end)

vim.g.rainbow_delimiters = { highlight = highlight }

hooks.register(hooks.type.SCOPE_HIGHLIGHT, hooks.builtin.scope_highlight_from_extmark)
require("ibl").setup { scope = { highlight = highlight } }

-- This module contains a number of default definitions
local rainbow_delimiters = require 'rainbow-delimiters'

vim.g.rainbow_delimiters = {
  strategy = {
    [''] = rainbow_delimiters.strategy['global'],
    vim = rainbow_delimiters.strategy['local'],
  },
  query = {
    [''] = 'rainbow-delimiters',
    lua = 'rainbow-blocks',
  },
  highlight = highlight,
}

-- Window management

keymap.set("n", "<leader>s-", "<C-w>s", { desc = "[S]plit window vertically" })
keymap.set("n", "<leader>s\\", "<C-w>v", { desc = "[S]plit window horizontally" })
keymap.set("n", "<leader>s=", "<C-w>=", { desc = "[S]plit windows [e]qual width" })
keymap.set("n", "<leader>sx", ":close<CR>", { desc = "[S]plit window should be [c]losed" })

keymap.set("n", "<leader>to", ":tabnew<CR>", { desc = "[T]ab [n]" })
keymap.set("n", "<leader>tx", ":tabclose<CR>", { desc = "[T]ab [c]lose" })
keymap.set("n", "<leader>tn", ":tabn<CR>", { desc = "[T]ab [n]ext" })
keymap.set("n", "<leader>tp", ":tabp<CR>", { desc = "[T]ab [p]rev" })

keymap.set("n", "<leader>bn", ":bn<CR>", { desc = "[B]uffer [n]ext" })
keymap.set("n", "<leader>bp", ":bp<CR>", { desc = "[B]uffer [p]revious" })
keymap.set("n", "<leader>bs", ":bs<CR>", { desc = "[B]uffer [s]how" })
keymap.set("n", "<leader>bx", ":bd<CR>", { desc = "[B]uffer (x) kill" })

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et

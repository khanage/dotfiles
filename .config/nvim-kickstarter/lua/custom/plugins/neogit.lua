return {
  'NeogitOrg/neogit',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'sindrets/diffview.nvim',
    'nvim-telescope/telescope.nvim',
    'ibhagwan/fzf-lua',
  },
  opts = function()

  end,
  lazy = true,
  config = function(_, opts)
    local neogit = require('neogit')
    neogit.setup(opts)
  end,
}

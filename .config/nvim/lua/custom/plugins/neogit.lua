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
  config = function(_, opts)
    local neogit = require('neogit')
    neogit.setup(opts)

    vim.keymap.set("n", "<leader>gg", require('neogit').open, { desc = "[G]o [G]it" })
  end,
}

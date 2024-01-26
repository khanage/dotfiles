return {
  'numToStr/FTerm.nvim',
  config = function(_, opts)
    local fterm = require('FTerm')

    fterm.setup(opts)

    vim.keymap.set({ "n", "t" }, "<C-P>", fterm.toggle, { desc = "Toggle the terminal" })
  end,
  opts = {
  }
}

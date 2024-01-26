return {
  'drybalka/tree-climber.nvim',
  config = function(_, _)
    local tree_climber = require('tree-climber')

    vim.keymap.set({ 'n', 'v', 'o' }, '<A-h>', function() tree_climber.goto_parent({ highlight = true }) end,
      { noremap = true, silent = true, desc = "TS: Goto parent" })

    vim.keymap.set({ 'n', 'v', 'o' }, '<A-l>', function() tree_climber.goto_child({ highlight = true }) end,
      { noremap = true, silent = true, desc = "TS: Goto child" })

    vim.keymap.set({ 'n', 'v', 'o' }, '<A-j>', function() tree_climber.goto_next({ highlight = true }) end,
      { noremap = true, silent = true, desc = "TS: Goto next" })

    vim.keymap.set({ 'n', 'v', 'o' }, '<A-k>', function() tree_climber.goto_prev({ highlight = true }) end,
      { noremap = true, silent = true, desc = "TS: Goto previous" })

    vim.keymap.set({ 'v', 'o' }, 'in', function() tree_climber.select_node({ highlight = true }) end,
      { noremap = true, silent = true, desc = "TS: Select node" })

    vim.keymap.set('n', '<c-k>', function() tree_climber.swap_prev({ highlight = true }) end,
      { noremap = true, silent = true, desc = "TS: Swap previous" })

    vim.keymap.set('n', '<c-j>', function() tree_climber.swap_next({ highlight = true }) end,
      { noremap = true, silent = true, desc = "TS: Swap next" })

    vim.keymap.set('n', '<c-h>', function() tree_climber.highlight_node({ highlight = true }) end,
      { noremap = true, silent = true, desc = "TS: Highlight node" })
  end
}

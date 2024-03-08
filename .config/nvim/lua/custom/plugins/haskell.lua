vim.g.haskell_tools = {
  hls = {
    on_attach = function(_client, bufnr, ht)
      local opts = { noremap = true, silent = true, buffer = bufnr, }
      -- haskell-language-server relies heavily on codeLenses,
      -- so auto-refresh (see advanced configuration) is enabled by default
      vim.keymap.set('n', '<leader>cl', vim.lsp.codelens.run, opts)
      -- Hoogle search for the type signature of the definition under the cursor
      vim.keymap.set('n', '<leader>hs', ht.hoogle.hoogle_signature, opts)
      -- Evaluate all code snippets
      vim.keymap.set('n', '<leader>ea', ht.lsp.buf_eval_all, opts)
      -- Toggle a GHCi repl for the current package
      vim.keymap.set('n', '<leader>rr', ht.repl.toggle, opts)
      -- Toggle a GHCi repl for the current buffer
      vim.keymap.set('n', '<leader>rf', function()
        ht.repl.toggle(vim.api.nvim_buf_get_name(0))
      end, opts)
      vim.keymap.set('n', '<leader>rq', ht.repl.quit, opts)
      vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
      vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
      vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
      vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
      vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)
      vim.keymap.set('n', '<leader>wa', vim.lsp.buf.add_workspace_folder, opts)
      vim.keymap.set('n', '<leader>wr', vim.lsp.buf.remove_workspace_folder, opts)
      vim.keymap.set('n', '<leader>wl', function()
        print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
      end, opts)
      vim.keymap.set('n', '<leader>D', vim.lsp.buf.type_definition, opts)
      vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)
      vim.keymap.set({ 'n', 'v' }, '<leader>ca', vim.lsp.buf.code_action, opts)
      vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
      vim.keymap.set('n', '<leader>f', function()
        vim.lsp.buf.format { async = true }
      end, opts)
    end,
  }
}

return {
  'mrcjkb/haskell-tools.nvim',
  dependencies = {
    "williamboman/mason.nvim"
  },
  version = '^3', -- Recommended
  ft = { 'haskell', 'lhaskell', 'cabal', 'cabalproject' },
}

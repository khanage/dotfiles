vim.g.haskell_tools = {
  hls = {
    on_attach = function(_client, bufnr, ht)
      local opts = function(description)
        return { noremap = true, silent = true, buffer = bufnr, desc = description }
      end
      -- haskell-language-server relies heavily on codeLenses,
      -- so auto-refresh (see advanced configuration) is enabled by default
      vim.keymap.set('n', '<leader>cl', vim.lsp.codelens.run, opts('[c]ode[l]ens'))
      -- Hoogle search for the type signature of the definition under the cursor
      vim.keymap.set('n', '<leader>hs', ht.hoogle.hoogle_signature, opts('[h]oogle [s]ignature'))
      -- Evaluate all code snippets
      vim.keymap.set('n', '<leader>ea', ht.lsp.buf_eval_all, opts('[e]val [a]ll'))
      -- Toggle a GHCi repl for the current package
      vim.keymap.set('n', '<leader>rr', ht.repl.toggle, opts('[r]epl [r]un'))
      -- Toggle a GHCi repl for the current buffer
      vim.keymap.set('n', '<leader>rf', function()
        ht.repl.toggle(vim.api.nvim_buf_get_name(0))
      end, opts('[r]epl [f]ile'))
      vim.keymap.set('n', '<leader>rq', ht.repl.quit, opts('[r]epl [q]uit'))
      vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts('[g]o to [d]eclation'))
      vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts('[g]o to [d]efinition'))
      vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts('Hover'))
      vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts('[g]o to [i]mplementation'))
      vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts('[s]ignature [h]elp'))
      vim.keymap.set('n', '<leader>wa', vim.lsp.buf.add_workspace_folder, opts('[w]orkspace: [a]dd folder'))
      vim.keymap.set('n', '<leader>wr', vim.lsp.buf.remove_workspace_folder, opts('[w]orkspace: [r]emove folder'))
      vim.keymap.set('n', '<leader>wl', function()
        print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
      end, opts('[w]orkspace: [l]ist folders'))
      vim.keymap.set('n', '<leader>D', vim.lsp.buf.type_definition, opts('type [d]efinition'))
      vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts('[r]e[n]ame'))
      vim.keymap.set({ 'n', 'v' }, '<leader>a', vim.lsp.buf.code_action, opts('code [a]ction'))
      vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts('[g]o to [r]eferences'))
      vim.keymap.set('n', '<leader>f', function()
        vim.lsp.buf.format { async = true }
      end, opts('[f]ormat buffer'))
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

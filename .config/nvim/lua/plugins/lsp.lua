return {
  "neovim/nvim-lspconfig",
  opts = function()
    local keys = require("lazyvim.plugins.lsp.keymaps").get()

    keys[#keys + 1] = { "<leader>a", vim.lsp.buf.code_action, desc = "Code [A]ction" }

    setup = {
      csharp_ls = function(_server, opts)
        require("omnisharp").setup({
          server = opts,
          root_dir = function(startpath)
            local lspconfig = require("lspconfig")
            return lspconfig.util.root_pattern("*.sln")(startpath)
              or lspconfig.util.root_pattern("*.csproj")(startpath)
              or lspconfig.util.root_pattern("*.fsproj")(startpath)
              or lspconfig.util.root_pattern(".git")(startpath)
          end,
        })

        return true
      end,
    }
  end,
}

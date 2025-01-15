return {
  "neovim/nvim-lspconfig",
  opts = function()
    local keys = require("lazyvim.plugins.lsp.keymaps").get()

    keys[#keys + 1] = { "<leader>a", vim.lsp.buf.code_action, desc = "Code [A]ction" }
  end,
}

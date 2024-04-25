return {
  {
    'mrcjkb/rustaceanvim',
    version = '^3',
    ft = { 'rust', 'toml' },
    dependencies = {
      'lvimuser/lsp-inlayhints.nvim',
      {
        'saecki/crates.nvim',
        tag = 'stable',
        dependencies = {
          'nvim-lua/plenary.nvim'
        },
      },
    },
    config = function()
      local lsp_inlayhints = require('lsp-inlayhints')
      lsp_inlayhints.setup()

      vim.api.nvim_create_augroup("LspAttach_inlayhints", {})
      vim.api.nvim_create_autocmd("LspAttach", {
        group = "LspAttach_inlayhints",
        callback = function(args)
          if not (args.data and args.data.client_id) then
            return
          end

          local bufnr = args.buf
          local client = vim.lsp.get_client_by_id(args.data.client_id)
          lsp_inlayhints.on_attach(client, bufnr)
        end,
      })

      local extension_path = vim.env.HOME .. '/.vscode/extensions/vadimcn.vscode-lldb-1.9.2/'
      local codelldb_path = extension_path .. 'adapter/codelldb'
      local liblldb_path = extension_path .. 'lldb/lib/liblldb'
      local this_os = vim.loop.os_uname().sysname;

      -- The path in windows is different
      if this_os:find "Windows" then
        codelldb_path = extension_path .. "adapter\\codelldb.exe"
        liblldb_path = extension_path .. "lldb\\bin\\liblldb.dll"
      else
        -- The liblldb extension is .so for linux and .dylib for macOS
        liblldb_path = liblldb_path .. (this_os == "Linux" and ".so" or ".dylib")
      end

      vim.g.rustaceanvim = function()
        return {
          inlay_hints = {
            highlight = "NonText"
          },
          tools = {
            hover_actions = {
              autofocus = true,
            },
            reload_workspace_from_cargo_toml = true,
          },
          server = {
            on_attach = function(client, bufnr)
              require('custom.lsp').lsp_on_attach(client, bufnr)

              vim.keymap.set('n', '<leader>cc', function() vim.cmd.RustLsp('openCargo') end,
                { desc = "Open [C]argo", buffer = bufnr })
              vim.keymap.set('n', '<leader>a', function() vim.cmd.RustLsp('codeAction') end,
                { desc = 'Codein [A]ction', silent = true, buffer = bufnr }
              )
              vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Open [E]rror float', buffer = bufnr })
            end,
            settings = {
              ['rust_analyzer'] = {
                cargo = {
                  allFeatures = true,
                  loadOutDirsFromCheck = true,
                  runBuildScripts = true,
                  target = 'all-targets'
                },
                -- Add clippy lints for Rust.
                checkOnSave = {
                  allFeatures = true,
                  command = "clippy",
                  extraArgs = { "--no-deps" },
                }
              },
              standalone = false,
            },
            dap = {
              adapter = require('rustaceanvim.config').get_codelldb_adapter(codelldb_path, liblldb_path)
            }
          }
        }
      end

      local crates = require('crates')
      crates.setup({
        popup = {
          autofocus = true,
        },
        on_attach = function(_, bufnr)
          vim.keymap.set('n', '<leader>ct', crates.toggle, { desc = '[C]rates [t]oggle', buffer = bufnr })
          vim.keymap.set('n', '<leader>cr', crates.reload, { desc = '[C]rates reload', buffer = bufnr })

          vim.keymap.set('n', '<leader>cv', crates.show_versions_popup, { desc = 'Crate version', buffer = bufnr })
          vim.keymap.set('n', '<leader>cf', crates.show_features_popup, { desc = 'Crate features', buffer = bufnr })
          vim.keymap.set('n', '<leader>cd', crates.show_dependencies_popup,
            { desc = 'Crate dependencies', buffer = bufnr })

          vim.keymap.set('n', '<leader>cu', crates.update_crate, { desc = 'Crate update', buffer = bufnr })
          vim.keymap.set('v', '<leader>cU', crates.upgrade_crate, { desc = 'Upgrade crates', buffer = bufnr })
          vim.keymap.set('n', '<leader>ca', crates.update_all_crates, { desc = 'Update all crates', buffer = bufnr })
          vim.keymap.set('n', '<leader>cA', crates.upgrade_all_crates,
            { desc = 'Upgrade all crates', buffer = bufnr })

          vim.keymap.set('n', '<leader>ce', crates.expand_plain_crate_to_inline_table,
            { desc = 'Expand crate to table', buffer = bufnr })

          vim.keymap.set('n', '<leader>cH', crates.open_homepage, { desc = 'Crate homepage', buffer = bufnr })
          vim.keymap.set('n', '<leader>cR', crates.open_repository, { desc = 'Crate repository', buffer = bufnr })
          vim.keymap.set('n', '<leader>cD', crates.open_documentation,
            { desc = 'Crate documentation', buffer = bufnr })

          vim.keymap.set('n', '<leader>cC', crates.open_crates_io, { desc = 'Open crates io', buffer = bufnr })
        end
      })
    end

  },
}

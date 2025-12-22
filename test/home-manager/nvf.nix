{pkgs, ...}: {
  enable = true;
  settings = {
    vim = {
      viAlias = true;
      vimAlias = true;

      keymaps = [
        {
          key = "<C-/>";
          mode = "t";
          silent = true;
          action = "<cmd>ToggleTerm<CR>";
        }
      ];

      options = {
        expandtab = true;
        shiftwidth = 2;
        tabstop = 2;
      };

      statusline.lualine.enable = true;

      autocomplete.nvim-cmp = {
        enable = true;
        mappings = {
          close = "<Esc>";
          complete = "<C-Space>";
          confirm = "<CR>";
          next = "<C-n>";
          previous = "<C-p>";
        };
      };

      debugger.nvim-dap = {
        enable = true;
        ui.enable = true;
      };

      theme = {
        enable = true;
        name = "nord";
        style = "night";
      };

      terminal.toggleterm = {
        enable = true;
        mappings.open = "<C-/>";
        setupOpts.direction = "float";
      };

      languages = {
        enableFormat = true;
        enableTreesitter = true;

        bash.enable = true;
        csharp = {
          enable = true;
          lsp.servers = ["roslyn_ls"];
        };
        lua.enable = true;
        nix = {
          enable = true;
          treesitter.enable = true;
        };

        elixir = {
          enable = true;
          elixir-tools.enable = true;
          format.enable = true;
          lsp.enable = true;
          treesitter.enable = true;
        };

        rust = {
          enable = true;
          extensions.crates-nvim.enable = true;
          dap.enable = true;
          lsp.opts = ''
            ['rust-analyzer'] = {
              cargo = {allFeature = true},
              checkOnSave = true,
              procMacro = {
                enable = true,
              },
            },
          '';
        };
      };

      lsp = {
        enable = true;
        formatOnSave = true;
        inlayHints.enable = true;
        lspkind.enable = true;
        lspSignature.enable = true;
        mappings = {
          codeAction = "<leader>a";
          goToDeclaration = "gd";
          goToDefinition = "gD";
          hover = "K";
        };
      };

      binds.whichKey = {
        enable = true;
      };

      comments.comment-nvim.enable = true;

      telescope = {
        enable = true;
        mappings = {
          diagnostics = "<leader>sd";
          findFiles = "<leader><leader>";
          liveGrep = "<leader>sg";
          lspDefinitions = "<leader>sd";
          lspDocumentSymbols = "<leader>ss";
          lspWorkspaceSymbols = "<leader>sw";
          lspReferences = "<leader>sr";
          lspImplementations = "<leader>si";
        };
        extensions = [
          {
            name = "fzf";
            packages = [pkgs.vimPlugins.telescope-fzf-native-nvim];
            setup = {fzf = {fuzzy = true;};};
          }
        ];
      };

      visuals = {
        fidget-nvim.enable = true;

        nvim-web-devicons.enable = true;
      };

      filetree.nvimTree = {
        enable = true;
        openOnSetup = false;
        setupOpts = {
          view.float = {
            enable = true;
            quit_on_focus_loss = true;
          };
        };
      };

      ui = {
        noice.enable = true;
      };

      mini.pairs = {
        enable = true;

        setupOpts = {
          mappings = {"'" = false;};
        };
      };
    };
  };
}

{pkgs, ...}: {
  enable = true;
  settings = {
    vim = {
      viAlias = true;
      vimAlias = true;
      clipboard.providers.wl-copy.enable = true;

      treesitter = {
        enable = true;
        textobjects.enable = true;
      };

      keymaps = [
        {
          key = "<C-/>";
          mode = "t";
          silent = true;
          action = "<cmd>ToggleTerm<CR>";
        }
        {
          key = "<Esc>";
          mode = "n";
          silent = true;
          action = "<cmd>:nohl<CR>";
        }
        {
          key = "<C-h>";
          mode = "n";
          silent = true;
          action = "<C-W>h";
        }
        {
          key = "<C-j>";
          mode = "n";
          silent = true;
          action = "<C-W>j";
        }
        {
          key = "<C-k>";
          mode = "n";
          silent = true;
          action = "<C-W>k";
        }
        {
          key = "<C-l>";
          mode = "n";
          silent = true;
          action = "<C-W>l";
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
        lazygit.enable = true;
      };

      languages = {
        enableFormat = true;
        enableDAP = true;
        enableTreesitter = true;
        enableExtraDiagnostics = true;

        bash.enable = true;
        csharp.enable = true;
        lua.enable = true;
        nix = {
          enable = true;
          lsp = {
            enable = true;
            servers = ["nixd"];
          };
        };

        elixir = {
          enable = true;
          elixir-tools.enable = true;
          format.enable = true;
          lsp.enable = true;
        };

        rust = {
          enable = true;
          extensions.crates-nvim.enable = true;
          dap.enable = true;
          lsp.opts = ''
            ['rust-analyzer'] = {
              cargo = {allFeatures = true},
              diagnostics = { enable = true },
              checkOnSave = true,
              procMacro = {
                enable = true,
              },
            },
          '';
        };
        haskell = {
          enable = true;
          dap.enable = true;
        };

        css.enable = true;
        html.enable = true;
        terraform.enable = true;
        hcl.enable = true;
        yaml.enable = true;
        json.enable = true;
        markdown.enable = true;
        sql.enable = true;
        ts.enable = true;
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
          buffers = "<leader><leader>";
          diagnostics = "<leader>sd";
          findFiles = "<leader>ff";
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
        setupOpts = {
          defaults = {
            file_ignore_patterns = ["%.lock"];
            color_devicons = true;
          };
        };
      };

      visuals = {
        fidget-nvim.enable = true;
        rainbow-delimiters.enable = true;
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
        borders.enable = true;
        noice.enable = true;
      };

      mini.pairs = {
        enable = true;

        setupOpts = {
          mappings = {
            "'" = false;
            # "{" = {
            #   action = "closeopen";
            #   pair = "{};";
            # };
          };
        };
      };
    };
  };
}

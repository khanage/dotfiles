return {
  { 'purescript-contrib/purescript-vim' },
  {
    'neovim/nvim-lspconfig',
    opts = {
      servers = {
        purescriptls = {
          settings = {
            purescript = {
              formatter = 'purs-tidy'
            }
          }
        }
      },
      setup = {
        purescriptls = function(_, opts)
          opts.root_dir = function(path)
            local util = require('lspconfig.util')
            if path:match("/.spago/") then
              return nil
            end
            return util.root_pattern('bower.json', 'psc-package.json', 'spago.dhall', 'flake.nix', 'shell.nix')(path)
          end
        end
      }
    }
  }
}

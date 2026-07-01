-- You can add your own plugins here or in other files in this directory!
--  I promise not to create any merge conflicts in this directory :)
--
-- See the kickstart.nvim README for more information
return {
  {
    -- uso kanagawa (al posto di tokyonight) poiché più simile al tema di JetBrains "Islands Dark"
    'rebelot/kanagawa.nvim',
    config = function()
      vim.cmd.colorscheme 'kanagawa'
    end,
  },
  {
    'christoomey/vim-tmux-navigator',
    event = 'VeryLazy',
    cmd = {
      'TmuxNavigateLeft',
      'TmuxNavigateDown',
      'TmuxNavigateUp',
      'TmuxNavigateRight',
      'TmuxNavigatePrevious',
    },
    config = function()
      vim.keymap.set('n', '<C-Left>', '<cmd>TmuxNavigateLeft<CR>')
      vim.keymap.set('n', '<C-Down>', '<cmd>TmuxNavigateDown<CR>')
      vim.keymap.set('n', '<C-Up>', '<cmd>TmuxNavigateUp<CR>')
      vim.keymap.set('n', '<C-Right>', '<cmd>TmuxNavigateRight<CR>')
    end,
  },
  {
    'sphamba/smear-cursor.nvim',
    opts = {},
  },
  {
    'mbbill/undotree',
    keys = {
      {
        '<leader>u',
        function()
          vim.cmd.UndotreeToggle()
          vim.cmd.UndotreeFocus()
        end,
        desc = 'Toggle Undotree and Focus',
      },
    },
  },
  require 'custom.plugins.harpoon',
  require 'custom.plugins.dotnet',
  {
    'LintaoAmons/scratch.nvim',
    event = 'VeryLazy',
  },
  {
    'Wansmer/symbol-usage.nvim',
    event = 'LspAttach', -- need run before LspAttach if you use nvim 0.9. On 0.10 use 'LspAttach'
    config = function()
      require('symbol-usage').setup {
        kinds = {
          vim.lsp.protocol.SymbolKind.Function,
          vim.lsp.protocol.SymbolKind.Method,
          vim.lsp.protocol.SymbolKind.Interface,
          vim.lsp.protocol.SymbolKind.Struct,
        },
        implementation = { enabled = true },
      }
    end,
  },
  {
    'nvim-lualine/lualine.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function()
      require('lualine').setup {
        sections = {
          lualine_c = {
            {
              'filename',
              path = 1, -- Show relative path
              fmt = function(str)
                local filename = vim.fn.fnamemodify(str, ':t')
                local path = vim.fn.fnamemodify(str, ':h') .. '/'
                if path == './' then
                  path = ' '
                end
                return path .. '%#TodoBgTEST#' .. filename .. '%*' -- run :highlight to see available colors
              end,
              symbols = {
                modified = ' ●', -- Text to show when file is modified
              },
            },
          },
        },
      }
    end,
  },
  {
    'nvim-treesitter/nvim-treesitter-context',
    config = function()
      require('treesitter-context').setup {
        multiwindow = true,
      }
    end,
  },
  {
    'github/copilot.vim',
    event = 'InsertEnter',
  },
  {
    'Kurren123/mssql.nvim',
    opts = {
      -- optional
      keymap_prefix = '<leader>m',
    },
    -- optional
    dependencies = { 'folke/which-key.nvim' },
  },
}

-- You can add your own plugins here or in other files in this directory!
--  I promise not to create any merge conflicts in this directory :)
--
-- See the kickstart.nvim README for more information
return {
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
  {
    'LintaoAmons/scratch.nvim',
    event = 'VeryLazy',
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
    'CopilotC-Nvim/CopilotChat.nvim',
    dependencies = {
      { 'github/copilot.vim' }, -- or zbirenbaum/copilot.lua
      { 'nvim-lua/plenary.nvim', branch = 'master' }, -- for curl, log and async functions
    },
    build = 'make tiktoken', -- Only on MacOS or Linux
    config = function()
      require('CopilotChat').setup {
        -- See Configuration section for options
        model = 'claude-3.7-sonnet-thought',
        contexts = {
          hiddenFiles = {
            resolve = function(input, source)
              return require('CopilotChat.context').filesHidden(source.winnr, input == 'full')
            end,
          },
        },
        -- You might also want to disable default header highlighting for copilot chat when doing this and set error header style and separator
        highlight_headers = false,
        separator = '---',
        error_header = '> [!ERROR] Error',
      }
      vim.keymap.set('n', '<leader>cc', ':CopilotChatToggle<CR>', { noremap = true, silent = true, desc = 'Toggle Copilot Chat' })
    end,
    -- See Commands section for default commands if you want to lazy load on them
  },
  {
    'OXY2DEV/markview.nvim',
    lazy = false,
    preview = {
      icon_provider = 'mini', -- "mini" or "devicons"
    },

    -- Completion for `blink.cmp`
    -- dependencies = { "saghen/blink.cmp" },
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

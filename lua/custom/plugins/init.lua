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
  require 'custom.plugins.harpoon',
  {
    'LintaoAmons/scratch.nvim',
    event = 'VeryLazy',
  },
  {
    'nvim-lualine/lualine.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    init = function()
      require('lualine').setup {
        sections = {
          lualine_c = {
            {
              'filename',
              color = function()
                return { fg = vim.fn.synIDattr(vim.fn.hlID 'Special', 'fg') }
              end,
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
    'MeanderingProgrammer/render-markdown.nvim',
    -- dependencies = { 'nvim-treesitter/nvim-treesitter', 'echasnovski/mini.nvim' }, -- if you use the mini.nvim suite
    -- dependencies = { 'nvim-treesitter/nvim-treesitter', 'echasnovski/mini.icons' }, -- if you use standalone mini plugins
    dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-tree/nvim-web-devicons' }, -- if you prefer nvim-web-devicons
    opts = {
      file_types = { 'markdown', 'copilot-chat' },
    },
  },
  {
    'exrezzo/CopilotChat.nvim',
    dependencies = {
      { 'github/copilot.vim' }, -- or zbirenbaum/copilot.lua
      { 'nvim-lua/plenary.nvim', branch = 'master' }, -- for curl, log and async functions
    },
    build = 'make tiktoken', -- Only on MacOS or Linux
    config = function()
      require('CopilotChat').setup {
        -- See Configuration section for options
        model = 'claude-3.5-sonnet',
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
}

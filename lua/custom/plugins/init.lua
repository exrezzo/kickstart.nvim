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
    'iamcco/markdown-preview.nvim',
    cmd = { 'MarkdownPreviewToggle', 'MarkdownPreview', 'MarkdownPreviewStop' },
    build = 'cd app && yarn install',
    init = function()
      vim.g.mkdp_filetypes = { 'markdown' }
    end,
    ft = { 'markdown' },
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
      }
      vim.keymap.set('n', '<leader>cc', ':CopilotChatToggle<CR>', { noremap = true, silent = true, desc = 'Toggle Copilot Chat' })
    end,
    -- See Commands section for default commands if you want to lazy load on them
  },
}

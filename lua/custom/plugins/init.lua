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
    'CopilotC-Nvim/CopilotChat.nvim',
    dependencies = {
      { 'github/copilot.vim' }, -- or zbirenbaum/copilot.lua
      { 'nvim-lua/plenary.nvim', branch = 'master' }, -- for curl, log and async functions
    },
    build = 'make tiktoken', -- Only on MacOS or Linux
    config = function()
      require('CopilotChat').setup {
        -- See Configuration section for options
        model = 'claude-3.5-sonnet',
        -- ho modificato il sorgente del plugin aggiungendo una funzione per il context
        -- scopiazzando e modificando la funzione M.files(winnr, with_content):
        --
        -- function M.filesHidden(winnr, with_content)
        --   local cwd = utils.win_cwd(winnr)
        --
        --   notify.publish(notify.STATUS, 'Scanning files')
        --
        --   local files = utils.scan_dir(cwd, {
        --     hidden = true,
        --     add_dirs = false,
        --     respect_gitignore = true,
        --   })
        --
        --   notify.publish(notify.STATUS, 'Reading files')
        --
        --   local out = {}
        --
        --   -- Create file list in chunks
        --   local chunk_size = 100
        --   for i = 1, #files, chunk_size do
        --     local chunk = {}
        --     for j = i, math.min(i + chunk_size - 1, #files) do
        --       table.insert(chunk, files[j])
        --     end
        --
        --     local chunk_number = math.floor(i / chunk_size)
        --     local chunk_name = chunk_number == 0 and 'file_map' or 'file_map' .. tostring(chunk_number)
        --
        --     table.insert(out, {
        --       content = table.concat(chunk, '\n'),
        --       filename = chunk_name,
        --       filetype = 'text',
        --     })
        --   end
        --
        --   -- Read all files if we want content as well
        --   if with_content then
        --     async.util.scheduler()
        --
        --     files = vim.tbl_filter(
        --       function(file)
        --         return file.ft ~= nil
        --       end,
        --       vim.tbl_map(function(file)
        --         return {
        --           name = utils.filepath(file),
        --           ft = utils.filetype(file),
        --         }
        --       end, files)
        --     )
        --
        --     for _, file in ipairs(files) do
        --       local file_data = get_file(file.name, file.ft)
        --       if file_data then
        --         table.insert(out, file_data)
        --       end
        --     end
        --   end
        --
        --   return out
        -- end
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

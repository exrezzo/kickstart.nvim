return {
  'ThePrimeagen/harpoon',
  branch = 'harpoon2',
  dependencies = { 'nvim-lua/plenary.nvim', 'nvim-telescope/telescope.nvim' },
  config = function()
    local harpoon = require 'harpoon'
    local harpoon_extensions = require 'harpoon.extensions'
    harpoon:extend(harpoon_extensions.builtins.highlight_current_file())
    harpoon:setup {
      settings = {
        save_on_toggle = true,
      },
    }

    vim.keymap.set('n', '<leader>ha', function()
      harpoon:list():add()
    end, { noremap = true, silent = true, desc = 'Add current file to Harpoon' })
    vim.keymap.set('n', '<leader>hl', function()
      harpoon.ui:toggle_quick_menu(harpoon:list())
    end, { noremap = true, silent = true, desc = 'Toggle Harpoon list' })

    vim.keymap.set('n', '<leader>h1', function()
      harpoon:list():select(1)
    end, { noremap = true, silent = true, desc = 'Select Harpoon list 1' })
    vim.keymap.set('n', '<leader>h2', function()
      harpoon:list():select(2)
    end, { noremap = true, silent = true, desc = 'Select Harpoon list 2' })
    vim.keymap.set('n', '<leader>h3', function()
      harpoon:list():select(3)
    end, { noremap = true, silent = true, desc = 'Select Harpoon list 3' })
    vim.keymap.set('n', '<leader>h4', function()
      harpoon:list():select(4)
    end, { noremap = true, silent = true, desc = 'Select Harpoon list 4' })

    -- Toggle previous & next buffers stored within Harpoon list
    vim.keymap.set('n', '<leader>hp', function()
      harpoon:list():prev()
    end, { noremap = true, silent = true, desc = 'Select previous Harpoon buffer' })
    vim.keymap.set('n', '<leader>hn', function()
      harpoon:list():next()
    end, { noremap = true, silent = true, desc = 'Select next Harpoon buffer' })
  end,
}

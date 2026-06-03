-- Neo-tree is a Neovim plugin to browse the file system
-- https://github.com/nvim-neo-tree/neo-tree.nvim

return {
  'nvim-neo-tree/neo-tree.nvim',
  version = '*',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-tree/nvim-web-devicons', -- not strictly required, but recommended
    'MunifTanjim/nui.nvim',
  },
  lazy = false,
  keys = {
    { '\\', ':Neotree reveal position=float<CR>', desc = 'NeoTree reveal', silent = true },
  },
  init = function()
    -- l'autocmd globale in init.lua spegne `cursorline` su WinLeave/BufLeave;
    -- per i buffer neo-tree lo vogliamo invece tenere acceso, altrimenti
    -- aprendo il filter popup (`/`) si perde la riga evidenziata sotto il cursore.
    vim.api.nvim_create_autocmd('FileType', {
      pattern = 'neo-tree',
      callback = function(args)
        vim.api.nvim_create_autocmd({ 'WinLeave', 'BufLeave' }, {
          buffer = args.buf,
          callback = function()
            vim.wo.cursorline = true
          end,
        })
      end,
    })
  end,
  opts = {
    filesystem = {
      window = {
        mappings = {
          ['\\'] = 'close_window',
          -- override dei default `/` (fuzzy_finder) e `#` (fuzzy_sorter)
          -- per tenere il filtro al submit (<CR>), invece di azzerarlo.
          -- Necessario perché in tmux non riceviamo <S-CR>/<C-CR> distinti da <CR>.
          ['/'] = { 'fuzzy_finder', config = { keep_filter_on_submit = true } },
          ['#'] = { 'fuzzy_sorter', config = { keep_filter_on_submit = true } },
          ['<leader>f'] = 'telescope_find', -- cerca file in folder
          ['<leader>g'] = 'telescope_grep', -- live_grep in folder
        },
        auto_expand_width = true,
      },
      find_args = { fd = { '--ignore-case' } },
      filtered_items = {
        visible = true,
        hide_dotfiles = false,
        hide_gitignored = false,
        hide_hidden = false,
        show_hidden_count = true,
      },
    },
    event_handlers = {
      {
        event = 'neo_tree_buffer_enter',
        handler = function()
          vim.opt_local.relativenumber = true
        end,
      },
    },
    commands = {
      -- cerca file in folder
      telescope_find = function(state)
        local node = state.tree:get_node()
        local path = node:get_id()

        -- Se il cursore è su un file invece che su una cartella,
        -- prendiamo il percorso della cartella che lo contiene
        if node.type ~= 'directory' then
          path = node:get_parent_id()
        end

        require('telescope.builtin').find_files {
          cwd = path,
        }
      end,

      --live_grep in folder
      telescope_grep = function(state)
        local node = state.tree:get_node()
        local path = node:get_id()

        if node.type ~= 'directory' then
          path = node:get_parent_id()
        end

        require('telescope.builtin').live_grep {
          cwd = path,
        }
      end,
    },
  },
}

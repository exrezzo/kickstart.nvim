return {
  'obsidian-nvim/obsidian.nvim',
  version = '*',
  ft = 'markdown',

  ---@module 'obsidian'
  ---@type obsidian.config
  opts = {
    legacy_commands = false,
    workspaces = {
      { name = 'brain', path = '~/brain' },
    },
    new_notes_location = 'notes_subdir',
    notes_subdir = 'Inbox',
    picker = {
      name = 'telescope.nvim',
    },
    callbacks = {
      enter_note = function(note)
        local buf = note.bufnr or vim.api.nvim_get_current_buf()
        local map = function(lhs, rhs, desc)
          vim.keymap.set('n', lhs, rhs, { buffer = buf, desc = desc })
        end

        map('<leader>on', ':Obsidian new ', 'Obsidian: new note')
        map('<leader>oo', '<cmd>Obsidian quick_switch<cr>', 'Obsidian: switch note')
        map('<leader>os', '<cmd>Obsidian search<cr>', 'Obsidian: search vault')
        map('<leader>ob', '<cmd>Obsidian backlinks<cr>', 'Obsidian: backlinks')
        map('<leader>ot', '<cmd>Obsidian today<cr>', "Obsidian: today's note")
        map('<leader>or', ':Obsidian rename ', 'Obsidian: rename note')
        map('<leader>of', '<cmd>Obsidian follow_link<cr>', 'Obsidian: follow link')
      end,
    },
  },
}

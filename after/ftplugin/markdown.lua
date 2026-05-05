-- AI-generated ftplugin for markdown files.
--
-- Overrides the built-in `gO` mapping (which opens a plain loclist) with a
-- custom Telescope picker that shows the document outline (headings) in a
-- floating window — consistent with how `gO` behaves on code files via
-- lsp_document_symbols.
--
-- Headings are colored by level and indented to reflect hierarchy.

vim.keymap.set('n', 'gO', function()
  local pickers = require 'telescope.pickers'
  local finders = require 'telescope.finders'
  local conf = require('telescope.config').values
  local actions = require 'telescope.actions'
  local action_state = require 'telescope.actions.state'
  local entry_display = require 'telescope.pickers.entry_display'

  local hl_by_level = {
    [1] = 'DiagnosticError',
    [2] = 'DiagnosticWarn',
    [3] = 'MarkdownOutlineH3',
    [4] = 'MarkdownOutlineH4',
    [5] = 'MarkdownOutlineH5',
    [6] = 'MarkdownOutlineH6',
  }

  -- Italic variants for h3+ (inherit color from Diagnostic groups, add italic)
  for level, base in pairs { [3] = 'DiagnosticInfo', [4] = 'DiagnosticHint', [5] = 'DiagnosticOk', [6] = 'Comment' } do
    local src = vim.api.nvim_get_hl(0, { name = base, link = false })
    vim.api.nvim_set_hl(0, hl_by_level[level], vim.tbl_extend('force', src, { italic = true }))
  end

  local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
  local entries = {}
  local in_code_block = false
  for i, line in ipairs(lines) do
    if line:match '^```' then
      in_code_block = not in_code_block
    elseif not in_code_block then
      local hashes, title = line:match '^(#+)%s+(.*)'
      if hashes then
        table.insert(entries, { title = title, lnum = i, level = #hashes })
      end
    end
  end

  local displayer = entry_display.create {
    separator = ' ',
    items = { { remaining = true } },
  }

  local cur_line = vim.api.nvim_win_get_cursor(0)[1]
  local default_idx = 1
  for i, entry in ipairs(entries) do
    if entry.lnum <= cur_line then
      default_idx = i
    end
  end

  pickers
    .new({}, {
      prompt_title = 'Document Outline',
      previewer = conf.grep_previewer {},
      default_selection_index = default_idx,
      finder = finders.new_table {
        results = entries,
        entry_maker = function(entry)
          local hl = hl_by_level[entry.level] or 'Comment'
          local indent = string.rep('  ', entry.level - 1)
          return {
            value = entry,
            display = function()
              return displayer { { indent .. entry.title, hl } }
            end,
            ordinal = entry.title,
            filename = vim.api.nvim_buf_get_name(0),
            lnum = entry.lnum,
            col = 1,
          }
        end,
      },
      sorting_strategy = 'ascending',
      sorter = conf.generic_sorter {},
      attach_mappings = function(prompt_bufnr)
        actions.select_default:replace(function()
          local selection = action_state.get_selected_entry()
          actions.close(prompt_bufnr)
          vim.api.nvim_win_set_cursor(0, { selection.lnum, 0 })
        end)
        return true
      end,
    })
    :find()
end, {
  buffer = 0,
  silent = true,
  desc = 'Open Document Symbols',
})

-- gO: outline di Feature/Rule/Scenario del file corrente in un picker Telescope,
-- coerente col gO degli altri filetype (Telescope LSP document symbols). Il
-- cucumber LS dichiara documentSymbolProvider ma ritorna il solo nodo "Feature:",
-- quindi il gO di default (mappato su LspAttach in init.lua) qui è inutilizzabile.

local bufnr = vim.api.nvim_get_current_buf()

-- l'ordine conta solo per leggibilità: i due punti dopo la keyword disambiguano
local keywords = { 'Feature', 'Rule', 'Background', 'Scenario Outline', 'Scenario Template', 'Scenario', 'Example' }

local function scenario_items()
  local items = {}
  for lnum, line in ipairs(vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)) do
    for _, kw in ipairs(keywords) do
      local title = line:match('^%s*' .. kw .. ':%s*(.*)')
      if title then
        local indent = (kw == 'Feature' or kw == 'Rule') and '' or '  '
        items[#items + 1] = { lnum = lnum, text = indent .. kw .. ': ' .. title }
        break
      end
    end
  end
  return items
end

local function scenario_picker()
  local items = scenario_items()
  if #items == 0 then
    vim.notify('Nessuno scenario nel file', vim.log.levels.INFO)
    return
  end

  -- pre-seleziona lo scenario in cui si trova il cursore: l'ultimo con lnum <= riga corrente
  local current_line = vim.api.nvim_win_get_cursor(0)[1]
  local selection_index = 1
  for i, item in ipairs(items) do
    if item.lnum > current_line then
      break
    end
    selection_index = i
  end

  local pickers = require 'telescope.pickers'
  local finders = require 'telescope.finders'
  local conf = require('telescope.config').values

  pickers
    .new({}, {
      prompt_title = 'Scenari',
      default_selection_index = selection_index,
      finder = finders.new_table {
        results = items,
        entry_maker = function(item)
          return {
            value = item,
            display = item.text,
            ordinal = item.text,
            filename = vim.api.nvim_buf_get_name(bufnr),
            bufnr = bufnr,
            lnum = item.lnum,
            col = 1,
          }
        end,
      },
      sorter = conf.generic_sorter {},
      previewer = conf.qflist_previewer {},
    })
    :find()
end

local function map_gO()
  vim.keymap.set('n', 'gO', scenario_picker, { buffer = bufnr, silent = true, desc = 'Outline scenari (Telescope)' })
end

map_gO()

-- L'LspAttach di init.lua rimappa gO su Telescope lsp_document_symbols quando il
-- cucumber LS attacca (dichiara la capability): ri-applichiamo la nostra mappa dopo.
vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('cucumber_gO_' .. bufnr, { clear = true }),
  buffer = bufnr,
  callback = function()
    vim.schedule(map_gO)
  end,
})

-- Override the runtime ]]/[[ section motions (ftplugin/go.vim) so they land
-- on the declaration name instead of column 0.

local ok, query = pcall(
  vim.treesitter.query.parse,
  'go',
  [[
    (function_declaration name: (identifier) @name)
    (method_declaration name: (field_identifier) @name)
    (type_declaration (type_spec name: (type_identifier) @name))
    (const_declaration (const_spec name: (identifier) @name))
    (var_declaration (var_spec name: (identifier) @name))
  ]]
)
if not ok then
  return
end

-- type/const/var can also appear inside functions; only jump to top-level ones
local function is_top_level(name_node)
  local node = name_node:parent()
  while node do
    if node:type():match '_declaration$' then
      local parent = node:parent()
      return parent ~= nil and parent:type() == 'source_file'
    end
    node = node:parent()
  end
  return false
end

local function declaration_names(bufnr)
  local parser_ok, parser = pcall(vim.treesitter.get_parser, bufnr, 'go')
  if not parser_ok or not parser then
    return {}
  end
  local tree = parser:parse()[1]
  if not tree then
    return {}
  end
  local positions = {}
  for _, node in query:iter_captures(tree:root(), bufnr) do
    if is_top_level(node) then
      local row, col = node:range()
      positions[#positions + 1] = { row, col }
    end
  end
  table.sort(positions, function(a, b)
    return a[1] == b[1] and a[2] < b[2] or a[1] < b[1]
  end)
  return positions
end

local function jump(dir)
  local positions = declaration_names(vim.api.nvim_get_current_buf())
  local cursor = vim.api.nvim_win_get_cursor(0)
  local row, col = cursor[1] - 1, cursor[2]

  local candidates = {}
  if dir == 1 then
    for _, pos in ipairs(positions) do
      if pos[1] > row or (pos[1] == row and pos[2] > col) then
        candidates[#candidates + 1] = pos
      end
    end
  else
    for i = #positions, 1, -1 do
      local pos = positions[i]
      if pos[1] < row or (pos[1] == row and pos[2] < col) then
        candidates[#candidates + 1] = pos
      end
    end
  end
  if #candidates == 0 then
    return
  end

  local target = candidates[math.min(vim.v.count1, #candidates)]
  vim.cmd "normal! m'"
  vim.api.nvim_win_set_cursor(0, { target[1] + 1, target[2] })
end

vim.keymap.set({ 'n', 'x', 'o' }, ']]', function()
  jump(1)
end, { buffer = true, silent = true, desc = 'Next declaration name' })
vim.keymap.set({ 'n', 'x', 'o' }, '[[', function()
  jump(-1)
end, { buffer = true, silent = true, desc = 'Prev declaration name' })

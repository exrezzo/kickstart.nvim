-- LSP/tooling per .NET (C#).
--
-- Roslyn LS è il language server ufficiale Microsoft (lo stesso di VS / VS Code).
-- È nettamente superiore a omnisharp su soluzioni grandi tipo armut-api:
-- supporta .sln/.slnx nativamente, code lens su test, decompilation, inlay hints,
-- semantic tokens precisi.
--
-- Il binario è installato via Mason come pacchetto `roslyn` (vedi mason-tool-installer
-- in init.lua). roslyn.nvim lo trova automaticamente e gestisce attach/restore/.sln picker.
--
-- Note operative:
--  - primo attach su armut-api: il restore + design-time build può richiedere alcuni minuti,
--    fidget.nvim mostra il progresso
--  - se ci sono più .sln nel cwd il plugin chiede quale usare (`:Roslyn target`)
--  - per forzare reload del workspace: `:Roslyn restart`
return {
  {
    'seblyng/roslyn.nvim',
    ---@module 'roslyn.config'
    ---@type RoslynNvimConfig
    ft = { 'cs' },
    opts = {},
  },
}

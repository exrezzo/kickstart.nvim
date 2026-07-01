return {
  {
    'OXY2DEV/markview.nvim',
    lazy = false,
    preview = {
      icon_provider = 'mini', -- "mini" or "devicons"
    },
    config = function()
      local presets = require('markview.presets').headings

      require('markview').setup {
        markdown = {
          headings = presets.glow,
        },
      }
    end,

    -- Completion for `blink.cmp`
    -- dependencies = { "saghen/blink.cmp" },
  },
  {
    -- migliora scrittura di liste aggiungendo trattino andando a capo
    -- >> e << spostano bullet
    -- <leader>x fa check/uncheck di liste
    'bullets-vim/bullets.vim',
    ft = 'markdown',
  },
}

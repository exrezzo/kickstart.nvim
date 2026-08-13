return {
  {
    'pwntester/octo.nvim',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'nvim-telescope/telescope.nvim', -- o fzf-lua
      'nvim-tree/nvim-web-devicons',
    },
    keys = {
      {
        '<leader>oi',
        '<CMD>Octo issue list<CR>',
        desc = 'List GitHub Issues',
      },
      {
        '<leader>op',
        '<CMD>Octo pr list<CR>',
        desc = 'List GitHub PullRequests',
      },
      {
        '<leader>od',
        '<CMD>Octo discussion list<CR>',
        desc = 'List GitHub Discussions',
      },
      {
        '<leader>on',
        '<CMD>Octo notification list<CR>',
        desc = 'List GitHub Notifications',
      },
      {
        '<leader>os',
        function()
          require('octo.utils').create_base_search_command { include_current_repo = true }
        end,
        desc = 'Search GitHub',
      },
    },
    config = function()
      require('octo').setup { use_local_fs = true }
    end,
  },
  {
    'esmuellert/codediff.nvim',
    cmd = 'CodeDiff',
    opts = {
      explorer = {
        view_mode = 'tree',
        focus_on_select = true,
      },
      diff = { ignore_trim_whitespace = true },
      keymaps = {
        view = {
          next_hunk = '<F3>',
          prev_hunk = '<F1>',
        },
      },
    },
  },
}

return {
  -- common dependencies
  { 'nvim-lua/plenary.nvim' },
  {
    'folke/snacks.nvim',
    dev = false,
    priority = 1000,
    lazy = false,
    opts = {
      styles = {},
      bigfile = { notify = false },
      quickfile = {},
      picker = {
        -- ui_select = false, -- replace `vim.ui.select` with the snacks picker
      },
      indent = {
        enabled = true,
        animate = {
          enabled = true,
          style = 'out',
          easing = 'linear',
          duration = {
            step = 20,
            total = 200,
          },
        },
        scope = {
          enabled = true,
          hl = 'SnacksIndentScope',
        },
        chunk = {
          enabled = true,
          hl = 'SnacksIndentChunk',
        },
      },
      scroll = {
        enabled = true,
        animate = {
          duration = { step = 15, total = 150 },
          easing = 'linear',
        },
      },
    },
  },
}

return {
  {
    'webhooked/kanso.nvim',
    lazy = false,
    enabled = true,
    priority = 100,
    config = function()
      require('kanso').setup {
        theme = 'zen',
      }
      vim.cmd.colorscheme 'kanso-zen'
      vim.api.nvim_create_autocmd('ColorScheme', {
        pattern = '*',
        callback = function()
          vim.api.nvim_set_hl(0, 'SnacksTerminal', { bg = 'none', nocombine = true })
          vim.api.nvim_set_hl(0, 'SnacksPickerBorder', { fg = '#316c71', bg = 'none', nocombine = true })
          -- better indent guides
          vim.api.nvim_set_hl(0, 'SnacksIndent', { fg = '#2a2a2a', nocombine = true })
          vim.api.nvim_set_hl(0, 'SnacksIndentScope', { fg = '#546e7a', nocombine = true })
          vim.api.nvim_set_hl(0, 'SnacksIndentChunk', { fg = '#75797f', nocombine = true })

          -- richer R syntax colors (works with kanso-zen's palette)
          -- pipe/assignment/formula operators: warm accent to stand out from arithmetic
          vim.api.nvim_set_hl(0, '@keyword.operator.r', { fg = '#c4746e', bold = true })
          -- named parameters in function calls: subtle but distinct
          vim.api.nvim_set_hl(0, '@variable.parameter.r', { fg = '#b6927b', italic = true })
          -- $ and @ field access (column names): distinct from plain variables
          vim.api.nvim_set_hl(0, '@variable.member.r', { fg = '#8ea4a2' })
          -- namespace (pkg:: prefix): muted teal
          vim.api.nvim_set_hl(0, '@module.r', { fg = '#8ea4a2', italic = true })
          -- function calls: keep the blue but make bolder
          vim.api.nvim_set_hl(0, '@function.call.r', { fg = '#8ba4b0' })
          -- function definitions: blue + bold
          vim.api.nvim_set_hl(0, '@function.r', { fg = '#8ba4b0', bold = true })
          -- strings: warmer green
          vim.api.nvim_set_hl(0, '@string.r', { fg = '#8a9a7b' })
          -- constants (NULL, NA, Inf, NaN): orange-ish to warn
          vim.api.nvim_set_hl(0, '@constant.builtin.r', { fg = '#c4746e', italic = true })
          -- booleans: warm amber
          vim.api.nvim_set_hl(0, '@boolean.r', { fg = '#c4b28a', bold = true })
          -- numbers: purple-ish to contrast with strings
          vim.api.nvim_set_hl(0, '@number.r', { fg = '#a292a3' })
          vim.api.nvim_set_hl(0, '@number.float.r', { fg = '#a292a3' })
          -- keywords (if, else, for, while, function, return): bold purple
          vim.api.nvim_set_hl(0, '@keyword.r', { fg = '#8992a7', bold = true })
          vim.api.nvim_set_hl(0, '@keyword.function.r', { fg = '#8992a7', bold = true, italic = true })
          vim.api.nvim_set_hl(0, '@keyword.return.r', { fg = '#8992a7', bold = true, italic = true })
          vim.api.nvim_set_hl(0, '@keyword.conditional.r', { fg = '#8992a7', bold = true })
          vim.api.nvim_set_hl(0, '@keyword.repeat.r', { fg = '#8992a7', bold = true })
          -- comments: keep italic, slightly brighter
          vim.api.nvim_set_hl(0, '@comment.r', { fg = '#7b8084', italic = true })
          -- operators (arithmetic, comparison): neutral but visible
          vim.api.nvim_set_hl(0, '@operator.r', { fg = '#a0a4a8' })
        end,
      })
    end,
  },
  { 'webhooked/oscura.nvim', enabled = true, lazy = false, priority = 1000, opts = {} },
  { 'Mofiqul/vscode.nvim', enabled = true, lazy = false, priority = 1000, opts = {} },
  { 'slugbyte/lackluster.nvim', enabled = true, lazy = false, priority = 1000, opts = {} },
  { 'projekt0n/github-nvim-theme', enabled = true, lazy = false, priority = 1000 },
  { 'forest-nvim/sequoia.nvim', enabled = false, lazy = false, priority = 1000 },
  { 'shaunsingh/nord.nvim', enabled = false, lazy = false, priority = 1000 },
  { 'folke/tokyonight.nvim', enabled = false, lazy = false, priority = 1000 },
  { 'EdenEast/nightfox.nvim', enabled = false, lazy = false, priority = 1000 },
  { 'p00f/alabaster.nvim', enabled = true, lazy = false, priority = 1000 },
  {
    'catppuccin/nvim',
    name = 'catppuccin',
    enabled = false,
    lazy = false,
    priority = 1000,
  },

  {
    'armannikoyan/rusty',
    enabled = false,
    lazy = false,
    priority = 1000,
    opts = {
      transparent = true,
      italic_comments = true,
      underline_current_line = true,
    },
  },

  {
    'oxfist/night-owl.nvim',
    enabled = false,
    lazy = false,
    priority = 1000,
    opts = {},
  },

  {
    'rebelot/kanagawa.nvim',
    enabled = true,
    lazy = false,
    priority = 1000,
    opts = {},
  },

  {
    'olimorris/onedarkpro.nvim',
    enabled = false,
    lazy = false,
    priority = 1000,
  },

  {
    'neanias/everforest-nvim',
    enabled = false,
    lazy = false,
    priority = 1000,
  },

  -- color html colors
  {
    'NvChad/nvim-colorizer.lua',
    enabled = true,
    event = 'BufReadPost',
    opts = {
      filetypes = { '*' },
      user_default_options = {
        RGB = true, -- #RGB hex codes
        RRGGBB = true, -- #RRGGBB hex codes
        names = false, -- "Name" codes like Blue or blue (too many false positives)
        RRGGBBAA = true, -- #RRGGBBAA hex codes
        AARRGGBB = false, -- 0xAARRGGBB hex codes
        rgb_fn = true, -- CSS rgb() and rgba() functions
        hsl_fn = true, -- CSS hsl() and hsla() functions
        css = false, -- Enable all CSS features: rgb_fn, hsl_fn, names, RGB, RRGGBB
        css_fn = false, -- Enable all CSS *functions*: rgb_fn, hsl_fn
        -- Available modes for `mode`: foreground, background,  virtualtext
        mode = 'virtualtext', -- Set the display mode.
        -- Available methods are false / true / "normal" / "lsp" / "both"
        -- True is same as normal
        tailwind = false, -- Enable tailwind colors
        -- parsers can contain values used in |user_default_options|
        sass = { enable = false, parsers = { 'css' } }, -- Enable sass colors
        virtualtext = '  ',
        virtualtext_inline = true,
        -- update color values even if buffer is not focused
        -- example use: cmp_menu, cmp_docs
        always_update = false,
        -- all the sub-options of filetypes apply to buftypes
      },
      buftypes = {},
    },
  },
}

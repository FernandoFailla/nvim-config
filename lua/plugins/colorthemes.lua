return {
  {
   "webhooked/kanso.nvim",
   lazy = false,
   enabled = true,
   priority = 100,
   config = function()
      require("kanso").setup({
        theme = "zen"
      })
     vim.cmd.colorscheme 'kanso-zen'
     vim.api.nvim_create_autocmd("ColorScheme", {
       pattern = "*",
       callback = function()
         vim.api.nvim_set_hl(0, "SnacksTerminal", { bg = "none", nocombine = true })
         vim.api.nvim_set_hl(0, "SnacksPickerBorder", { fg = "#316c71", bg = "none", nocombine = true })
       end,
     })
    end,
  },
  { 'webhooked/oscura.nvim', enabled = true, lazy = false, priority = 1000, opts = {} },
  { 'Mofiqul/vscode.nvim', enabled = true, lazy = false, priority = 1000, opts = {} },
  { 'slugbyte/lackluster.nvim', enabled = true, lazy = false, priority = 1000, opts = {} },
  { 'projekt0n/github-nvim-theme', enabled = true, lazy = false, priority = 1000 } ,
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
    enabled = false,
    opts = {
      filetypes = { '*' },
      user_default_options = {
        RGB = true, -- #RGB hex codes
        RRGGBB = true, -- #RRGGBB hex codes
        names = true, -- "Name" codes like Blue or blue
        RRGGBBAA = true, -- #RRGGBBAA hex codes
        AARRGGBB = false, -- 0xAARRGGBB hex codes
        rgb_fn = false, -- CSS rgb() and rgba() functions
        hsl_fn = false, -- CSS hsl() and hsla() functions
        css = false, -- Enable all CSS features: rgb_fn, hsl_fn, names, RGB, RRGGBB
        css_fn = false, -- Enable all CSS *functions*: rgb_fn, hsl_fn
        -- Available modes for `mode`: foreground, background,  virtualtext
        mode = 'background', -- Set the display mode.
        -- Available methods are false / true / "normal" / "lsp" / "both"
        -- True is same as normal
        tailwind = false, -- Enable tailwind colors
        -- parsers can contain values used in |user_default_options|
        sass = { enable = false, parsers = { 'css' } }, -- Enable sass colors
        virtualtext = '■',
        -- update color values even if buffer is not focused
        -- example use: cmp_menu, cmp_docs
        always_update = false,
        -- all the sub-options of filetypes apply to buftypes
      },
      buftypes = {},
    },
  },
}

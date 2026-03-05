return {
  {
    'FernandoFailla/marimo.nvim',
    dependencies = {
      'nvim-treesitter/nvim-treesitter',
    },
    ft = 'python', -- Lazy load on Python files
    config = function()
      require('marimo').setup()
    end,
  },
}

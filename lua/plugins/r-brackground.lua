return {
  {
    'FernandoFailla/r-background-jobs.nvim',
    branch = 'dags',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'nvim-telescope/telescope.nvim', -- Optional
    },
    config = function()
      require('r-background-jobs').setup()
    end,
  },
}

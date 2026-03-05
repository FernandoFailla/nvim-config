return{
    { -- Interactive Python cell execution with IPython kernels and browser output
    'ryan-ressmeyer/quench.nvim',
    build = ':UpdateRemotePlugins',
    init = function()
      vim.g.quench_nvim_web_server_host = '127.0.0.1'
      vim.g.quench_nvim_web_server_port = 8765
      -- Don't auto-start server on nvim launch, start on first cell run
      vim.g.quench_nvim_autostart_server = false
    end,
    config = function()
      require('quench').setup {
        web_server = {
          host = '127.0.0.1',
          port = 8765,
          autostart_server = false,
        },
      }

      -- Python-only keymaps under <leader>x (e[x]ecute)
      vim.api.nvim_create_autocmd('FileType', {
        pattern = 'python',
        callback = function()
          local opts = { noremap = true, silent = true, buffer = true }
          vim.keymap.set('n', '<leader>xc', ':QuenchRunCell<CR>', opts)
          vim.keymap.set('n', '<leader>xn', ':QuenchRunCellAdvance<CR>', opts)
          vim.keymap.set('v', '<leader>xc', ':QuenchRunSelection<CR>', opts)
          vim.keymap.set('n', '<leader>xl', ':QuenchRunLine<CR>', opts)
          vim.keymap.set('n', '<leader>xa', ':QuenchRunAll<CR>', opts)
          vim.keymap.set('n', '<leader>xo', ':QuenchOpen<CR>', opts)
          vim.keymap.set('n', '<leader>xs', ':QuenchStatus<CR>', opts)
          vim.keymap.set('n', '<leader>xk', ':QuenchInterruptKernel<CR>', opts)
          vim.keymap.set('n', '<leader>xr', ':QuenchResetKernel<CR>', opts)
        end,
      })
    end,
  },
}

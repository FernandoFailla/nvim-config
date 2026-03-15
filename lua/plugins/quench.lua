return {
  {
    'ryan-ressmeyer/quench.nvim',
    enabled = true,
    ft = 'python',
    build = ':UpdateRemotePlugins',
    config = function()
      vim.g.quench_nvim_web_server_host = '127.0.0.1'
      vim.g.quench_nvim_web_server_port = 8765
      vim.g.quench_nvim_autostart_server = true

      vim.api.nvim_create_autocmd('FileType', {
        pattern = 'python',
        callback = function()
          local opts = { noremap = true, silent = true, buffer = true }
          vim.keymap.set('n', '<leader>xc', ':QuenchRunCell<CR>', vim.tbl_extend('force', opts, { desc = 'Run cell' }))
          vim.keymap.set(
            'n',
            '<leader>xC',
            ':QuenchRunCellAdvance<CR>',
            vim.tbl_extend('force', opts, { desc = 'Run cell and advance' })
          )
          vim.keymap.set(
            'v',
            '<leader>xc',
            ':QuenchRunSelection<CR>',
            vim.tbl_extend('force', opts, { desc = 'Run selection' })
          )
          vim.keymap.set('n', '<leader>xl', ':QuenchRunLine<CR>', vim.tbl_extend('force', opts, { desc = 'Run line' }))
          vim.keymap.set(
            'n',
            '<leader>xa',
            ':QuenchRunAll<CR>',
            vim.tbl_extend('force', opts, { desc = 'Run all cells' })
          )
          vim.keymap.set(
            'n',
            '<leader>xo',
            ':QuenchOpen<CR>',
            vim.tbl_extend('force', opts, { desc = 'Open Quench browser' })
          )
          vim.keymap.set(
            'n',
            '<leader>xs',
            ':QuenchStatus<CR>',
            vim.tbl_extend('force', opts, { desc = 'Quench status' })
          )
          vim.keymap.set(
            'n',
            '<leader>xi',
            ':QuenchInterruptKernel<CR>',
            vim.tbl_extend('force', opts, { desc = 'Interrupt kernel' })
          )
          vim.keymap.set(
            'n',
            '<leader>xR',
            ':QuenchResetKernel<CR>',
            vim.tbl_extend('force', opts, { desc = 'Reset kernel' })
          )
        end,
      })
    end,
  },
}

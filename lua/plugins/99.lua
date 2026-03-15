return {
  {
    'ThePrimeagen/99',
    config = function()
      local _99 = require '99'

      local cwd = vim.uv.cwd()
      local basename = vim.fs.basename(cwd)
      _99.setup {
        logger = {
          level = _99.DEBUG,
          path = '/tmp/' .. basename .. '.99.debug',
          print_on_error = true,
        },

        -- When setting this to something that is not inside the CWD tools
        -- such as claude code or opencode will have permission issues
        -- and generation will fail
        tmp_dir = './tmp',

        completion = {
          --- What autocomplete engine to use
          source = 'blink',
          custom_rules = {
            'scratch/custom_rules/',
          },
        },

        md_files = {
          'AGENT.md',
        },
      }

      -- Visual: select code, write prompt, send to AI and replace selection
      vim.keymap.set('v', '<leader>9v', function()
        _99.visual()
      end, { desc = '99: visual prompt' })

      -- Search: agentic search across the project (results in quickfix)
      vim.keymap.set('n', '<leader>9s', function()
        _99.search()
      end, { desc = '99: search' })

      -- Vibe: agentic coding mode
      vim.keymap.set('n', '<leader>9a', function()
        _99.vibe()
      end, { desc = '99: vibe (agent)' })

      -- Open: view last interaction results
      vim.keymap.set('n', '<leader>9o', function()
        _99.open()
      end, { desc = '99: open last result' })

      -- Stop all in-flight requests
      vim.keymap.set('n', '<leader>9x', function()
        _99.stop_all_requests()
      end, { desc = '99: stop all requests' })

      -- View logs
      vim.keymap.set('n', '<leader>9l', function()
        _99.view_logs()
      end, { desc = '99: view logs' })

      -- Select model via Telescope
      vim.keymap.set('n', '<leader>9m', function()
        require('99.extensions.telescope').select_model()
      end, { desc = '99: select model' })
    end,
  },
}

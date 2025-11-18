return {

  { -- for lsp features in code cells / embedded code
    'jmbuhr/otter.nvim',
    dev = false,
    dependencies = {
      {
        'neovim/nvim-lspconfig',
        'nvim-treesitter/nvim-treesitter',
      },
    },
    opts = {},
  },

  {
    'neovim/nvim-lspconfig',
    dependencies = {
      { 'williamboman/mason.nvim' },
      { 'williamboman/mason-lspconfig.nvim' },
      { 'WhoIsSethDaniel/mason-tool-installer.nvim' },
      { -- nice loading notifications
        -- PERF: but can slow down startup
        'j-hui/fidget.nvim',
        enabled = false,
        opts = {},
      },
      {
        {
          'folke/lazydev.nvim',
          ft = 'lua', -- only load on lua files
          opts = {
            library = {
              -- See the configuration section for more details
              -- Load luvit types when the `vim.uv` word is found
              { path = 'luvit-meta/library', words = { 'vim%.uv' } },
            },
          },
        },
        { 'Bilal2453/luvit-meta', lazy = true }, -- optional `vim.uv` typings
      },
      { 'folke/neoconf.nvim', opts = {}, enabled = false },
    },
    config = function()
      require('mason').setup {
        ensure_installed = {
          'lua-language-server',
          'bash-language-server',
          'css-lsp',
          'html-lsp',
          'json-lsp',
          'haskell-language-server',
          'pyright',
          'r-languageserver',
          'texlab',
          'dotls',
          'svelte-language-server',
          'typescript-language-server',
          'yaml-language-server',
          'clangd',
          'css-lsp',
          'emmet-ls',
          'html-lsp',
          'sqlls'
          -- 'julia-lsp'
          -- 'rust-analyzer',
          --'marksman',
        },
      }
      require('mason-tool-installer').setup {
        ensure_installed = {
          'black',
          'stylua',
          'shfmt',
          'isort',
          'tree-sitter-cli',
          'jupytext',
        },
      }

      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
        callback = function(event)
          local function map(keys, func, desc)
            vim.keymap.set('n', keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
          end

          local client = vim.lsp.get_client_by_id(event.data.client_id)
          assert(client, 'LSP client not found')

          ---@diagnostic disable-next-line: inject-field
          client.server_capabilities.document_formatting = true

          map('gd', vim.lsp.buf.definition, '[g]o to [d]efinition')
          map('gD', vim.lsp.buf.type_definition, '[g]o to type [D]efinition')
          map('<leader>lq', vim.diagnostic.setqflist, '[l]sp diagnostic [q]uickfix')
        end,
      })

      -- local capabilities = vim.lsp.protocol.make_client_capabilities()
      -- capabilities = vim.tbl_deep_extend('force', capabilities, require('cmp_nvim_lsp').default_capabilities())
      -- capabilities.textDocument.completion.completionItem.snippetSupport = true
      local capabilities = require('blink.cmp').get_lsp_capabilities({}, true)

      -- also needs:
      -- $home/.config/marksman/config.toml :
      -- [core]
      -- markdown.file_extensions = ["md", "markdown", "qmd"]
      -- vim.lsp.config.marksman = {
      --   cmd = { 'marksman', 'server' },
      --   filetypes = { 'markdown', 'quarto' },
      --   root_markers = { '.git', '.marksman.toml', '_quarto.yml' },
      --   capabilities = capabilities,
      -- }

      vim.lsp.config.r_language_server = {
        cmd = { 'R', '--slave', '-e', 'languageserver::run()' },
        filetypes = { 'r', 'rmd', 'rmarkdown' }, -- not directly using it for quarto (as that is handled by otter and often contains more languanges than just R)
        root_markers = { '.git' },
        capabilities = capabilities,
        settings = {
          r = {
            lsp = {
              rich_documentation = true,
            },
          },
        },
      }

      vim.lsp.config.cssls = {
        cmd = { 'vscode-css-language-server', '--stdio' },
        filetypes = { 'css', 'scss', 'less' },
        root_markers = { 'package.json', '.git' },
        capabilities = capabilities,
      }

      -- vim.lsp.config.html = {
      --   cmd = { 'vscode-html-language-server', '--stdio' },
      --   filetypes = { 'html' },
      --   root_markers = { 'package.json', '.git' },
      --   capabilities = capabilities,
      -- }

      -- vim.lsp.config.emmet_language_server = {
      --   cmd = { 'emmet-language-server', '--stdio' },
      --   filetypes = { 'html', 'css', 'scss', 'javascript', 'javascriptreact', 'typescript', 'typescriptreact' },
      --   root_markers = { '.git' },
      --   capabilities = capabilities,
      -- }

      vim.lsp.config.svelte = {
        cmd = { 'svelteserver', '--stdio' },
        filetypes = { 'svelte' },
        root_markers = { 'package.json', '.git' },
        capabilities = capabilities,
      }

      vim.lsp.config.yamlls = {
        cmd = { 'yaml-language-server', '--stdio' },
        filetypes = { 'yaml', 'yaml.docker-compose' },
        root_markers = { '.git' },
        capabilities = capabilities,
        settings = {
          yaml = {
            schemaStore = {
              enable = true,
              url = '',
            },
          },
        },
      }

      vim.lsp.config.jsonls = {
        cmd = { 'vscode-json-language-server', '--stdio' },
        filetypes = { 'json', 'jsonc' },
        root_markers = { '.git' },
        capabilities = capabilities,
      }

      vim.lsp.config.texlab = {
        cmd = { 'texlab' },
        filetypes = { 'tex', 'plaintex', 'bib' },
        root_markers = { '.latexmkrc', '.git' },
        capabilities = capabilities,
      }

      vim.lsp.config.dotls = {
        cmd = { 'dot-language-server', '--stdio' },
        filetypes = { 'dot', 'gv' },
        root_markers = { '.git' },
        capabilities = capabilities,
      }

      vim.lsp.config.ts_ls = {
        cmd = { 'typescript-language-server', '--stdio' },
        filetypes = { 'js', 'javascript', 'typescript', 'ojs' },
        root_markers = { 'package.json', 'tsconfig.json', '.git' },
        capabilities = capabilities,
      }

      local function get_quarto_resource_path()
        local function strsplit(s, delimiter)
          local result = {}
          for match in (s .. delimiter):gmatch('(.-)' .. delimiter) do
            table.insert(result, match)
          end
          return result
        end

        local f = assert(io.popen('quarto --paths', 'r'))
        local s = assert(f:read '*a')
        f:close()
        return strsplit(s, '\n')[2]
      end

      local lua_library_files = vim.api.nvim_get_runtime_file('', true)
      local lua_plugin_paths = {}
      local resource_path = get_quarto_resource_path()
      if resource_path == nil then
        vim.notify_once 'quarto not found, lua library files not loaded'
      else
        table.insert(lua_library_files, resource_path .. '/lua-types')
        table.insert(lua_plugin_paths, resource_path .. '/lua-plugin/plugin.lua')
      end

      vim.lsp.config.lua_ls = {
        cmd = { 'lua-language-server' },
        filetypes = { 'lua' },
        root_markers = { '.luarc.json', '.luarc.jsonc', '.luacheckrc', '.stylua.toml', 'stylua.toml', 'selene.toml', 'selene.yml', '.git' },
        capabilities = capabilities,
        settings = {
          Lua = {
            completion = {
              callSnippet = 'Replace',
            },
            runtime = {
              version = 'LuaJIT',
              -- plugin = lua_plugin_paths, -- handled by lazydev
            },
            diagnostics = {
              disable = { 'trailing-space' },
            },
            workspace = {
              -- library = lua_library_files, -- handled by lazydev
              checkThirdParty = false,
            },
            doc = {
              privateName = { '^_' },
            },
            telemetry = {
              enable = false,
            },
          },
        },
      }

      vim.lsp.config.vimls = {
        cmd = { 'vim-language-server', '--stdio' },
        filetypes = { 'vim' },
        root_markers = { '.git' },
        capabilities = capabilities,
      }

      vim.lsp.config.julials = {
        cmd = { 'julia', '--startup-file=no', '--history-file=no', '-e', 'using LanguageServer; runserver()' },
        filetypes = { 'julia' },
        root_markers = { 'Project.toml', '.git' },
        capabilities = capabilities,
      }

      vim.lsp.config.bashls = {
        cmd = { 'bash-language-server', 'start' },
        filetypes = { 'sh', 'bash' },
        root_markers = { '.git' },
        capabilities = capabilities,
      }

      -- Add additional languages here.
      -- See `:h lspconfig-all` for the configuration.
      -- Like e.g. Haskell:
      -- vim.lsp.config.hls = {
      --   cmd = { 'haskell-language-server-wrapper', '--lsp' },
      --   filetypes = { 'haskell', 'lhaskell', 'cabal' },
      --   root_markers = { 'hie.yaml', 'stack.yaml', 'cabal.project', '*.cabal', 'package.yaml', '.git' },
      --   capabilities = capabilities,
      -- }

      vim.lsp.config.clangd = {
        cmd = { 'clangd' },
        filetypes = { 'c', 'cpp', 'objc', 'objcpp', 'cuda', 'proto' },
        root_markers = { '.clangd', '.clang-tidy', '.clang-format', 'compile_commands.json', 'compile_flags.txt', 'configure.ac', '.git' },
        capabilities = capabilities,
      }

      vim.lsp.config.rust_analyzer = {
        cmd = { 'rust-analyzer' },
        filetypes = { 'rust' },
        root_markers = { 'Cargo.toml', 'rust-project.json', '.git' },
        capabilities = capabilities,
      }

      -- vim.lsp.config.ruff_lsp = {
      --   cmd = { 'ruff-lsp' },
      --   filetypes = { 'python' },
      --   root_markers = { 'pyproject.toml', 'setup.py', 'setup.cfg', 'requirements.txt', 'Pipfile', '.git' },
      --   capabilities = capabilities,
      -- }

      -- See https://github.com/neovim/neovim/issues/23291
      -- disable lsp watcher.
      -- Too lags on linux for python projects
      -- because pyright and nvim both create too many watchers otherwise
      if capabilities.workspace == nil then
        capabilities.workspace = {}
        capabilities.workspace.didChangeWatchedFiles = {}
      end
      capabilities.workspace.didChangeWatchedFiles.dynamicRegistration = false

      vim.lsp.config.pyright = {
        cmd = { 'pyright-langserver', '--stdio' },
        filetypes = { 'python' },
        root_markers = { '.git', 'setup.py', 'setup.cfg', 'pyproject.toml', 'requirements.txt' },
        capabilities = capabilities,
        settings = {
          python = {
            analysis = {
              autoSearchPaths = true,
              useLibraryCodeForTypes = true,
              diagnosticMode = 'workspace',
            },
          },
        },
      }
    end,
  },
}

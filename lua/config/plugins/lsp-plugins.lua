return {
  -- plugins to see the hierarchical view of symbols from lsp in buffer
  {
    'stevearc/aerial.nvim',
    dependencies = {
       "nvim-treesitter/nvim-treesitter",
       "nvim-tree/nvim-web-devicons"
    },
    opts = {
      backends = {"lsp"},
      lsp = {
        diagnostics_trigger_update = true,
        update_when_errors = false,
      },
      on_attach = function(bufnr)
        vim.keymap.set("n", "{", "<cmd>AerialPrev<CR>", { buffer = bufnr })
        vim.keymap.set("n", "}", "<cmd>AerialNext<CR>", { buffer = bufnr })
        vim.keymap.set("n", "ga", "<cmd>AerialToggle!<CR>", { desc = 'toggle [a]erial' })
      end,
      extensions = {
        aerial = {
          format_symbol = function(symbol_path, filetype)
            if filetype == "json" or filetype == "yaml" then
              return table.concat(symbol_path, ".")
            else
              return symbol_path[#symbol_path]
            end
          end,
          show_columns = "both",
        },
      },
    },
    config = function(_, opts)
      require('aerial').setup(opts)
      require("telescope").load_extension("aerial")
      vim.keymap.set("n", "<leader>ta", "<cmd>Telescope aerial<CR>", { desc = '[a]erial picker' })
    end
  },
  {
    'utilyre/barbecue.nvim',
    name = 'barbecue',
    version = '*',
    dependencies = {
      'SmiteshP/nvim-navic',
      'nvim-tree/nvim-web-devicons',
    },
    opts = {},
  },
  {
    'linux-cultist/venv-selector.nvim',
    dependencies = {
      'neovim/nvim-lspconfig',
      'nvim-telescope/telescope.nvim',
      'mfussenegger/nvim-dap-python'
    },
    opts = {
      name = "venv",
    },
    event = 'VeryLazy', -- Optional: needed only if you want to type `:VenvSelect` without a keymapping
    keys = {
      -- Keymap to open VenvSelector to pick a venv.
      { '<leader>vS', '<cmd>VenvSelect<cr>' },
      -- Keymap to retrieve the venv from a cache (the one previously used for the same project directory).
      { '<leader>vc', '<cmd>VenvSelectCached<cr>' },
    },
  },

  -- LSP Configuration & Plugins
  {
    'neovim/nvim-lspconfig',

    dependencies = {
      { 'williamboman/mason.nvim', config = true }, -- NOTE: Must be loaded before dependants
      'williamboman/mason-lspconfig.nvim',
      'WhoIsSethDaniel/mason-tool-installer.nvim',
      { 'j-hui/fidget.nvim',       opts = {} },
      { 'folke/neodev.nvim',       opts = {} },
      { "navbuddy" }
    },

    config = function()
      -- setup behavior after lsp attaches to a buffer
      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('lsp-attach', { clear = true }),

        callback = function(event)
          -- Function that sets up keymappings after lsp has attached to current buffer
          local map = function(keys, func, desc)
            vim.keymap.set('n', keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
          end

          local fullscreen_telescope_config = {
            prompt_prefix = "   ",
            selection_caret = "  ",
            sorting_strategy = "ascending",
            layout_strategy = "horizontal",
            layout_config = {
              horizontal = {
                mirror = false,
                prompt_position = 'top',
                width = 0.95,
                height = 0.95,
                preview_cutoff = 10,
                preview_width = 0.60,
              }
            },
            border = true,
            color_devicons = true,
            borderchars = { '─', '│', '─', '│', '┌', '┐', '┘', '└' },
            file_ignore_patterns = {
              "^%.git/",
              "^%.git$",
              ".DS_Store",
            },
            mappings = {
              i = {
                ["<C-c>"] = false
              }
            }
          }
          _G.custom_telescope_config = function(telescope_fn)
            telescope_fn(fullscreen_telescope_config)
          end

          map('gd',
              function()
                custom_telescope_config(require('telescope.builtin').lsp_definitions)
              end,
              '[G]oto [D]efinition')
          map('gD',
              function()
                custom_telescope_config(vim.lsp.buf.declaration)
              end,
              '[G]oto [D]eclaration')
          map('gr',
              function()
                custom_telescope_config(require('telescope.builtin').lsp_references)
              end,
              '[G]oto [R]eferences')
          map('gI',
              function()
                custom_telescope_config(require('telescope.builtin').lsp_implementations)
              end,
              '[G]oto [I]mplementation')
          map('gt',
              function()
                custom_telescope_config(require('telescope.builtin').lsp_type_definitions)
              end,
              'Type [D]efinition')
          map('gR', vim.lsp.buf.rename, '[R]e[n]ame')
          map('gk', vim.lsp.buf.hover, 'Hover Documentation')

          -- The following two autocommands are used to highlight references of the
          --  word under your cursor when your cursor rests there for a little while.
          --
          -- When you move your cursor, the highlights will be cleared (the second autocommand).
          local client = vim.lsp.get_client_by_id(event.data.client_id)
          if client and client.server_capabilities.documentHighlightProvider then
            local highlight_augroup = vim.api.nvim_create_augroup('lsp-highlight', { clear = false })
            vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
              buffer = event.buf,
              group = highlight_augroup,
              callback = vim.lsp.buf.document_highlight,
            })

            vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
              buffer = event.buf,
              group = highlight_augroup,
              callback = vim.lsp.buf.clear_references,
            })

            vim.api.nvim_create_autocmd('LspDetach', {
              group = vim.api.nvim_create_augroup('lsp-detach', { clear = true }),
              callback = function(event2)
                vim.lsp.buf.clear_references()
                vim.api.nvim_clear_autocmds { group = 'lsp-highlight', buffer = event2.buf }
              end,
            })
          end
        end,
      })

      -- setup LSP capabilities based on plugins -
      local capabilities = vim.lsp.protocol.make_client_capabilities()
      capabilities = vim.tbl_deep_extend('force', capabilities, require('cmp_nvim_lsp').default_capabilities())

      -- configure language servers for LSP -
      local servers = {
        clangd = {
        },
        pyright = {},
        lua_ls = {
          settings = {
            Lua = {
              completion = {
                callSnippet = 'Replace',
              },
            },
          },
        },
      }

      --  Language server manager
      require('mason').setup()
      -- Language server Dependant tools manager
      local ensure_installed = vim.tbl_keys(servers or {})
      require('mason-tool-installer').setup { ensure_installed = ensure_installed }

      -- LSP config tool
      require('mason-lspconfig').setup {
        handlers = {
          function(server_name)
            local server = servers[server_name] or {}
            -- This handles overriding only values explicitly passed
            -- by the server configuration above.
            server.capabilities = vim.tbl_deep_extend('force', {}, capabilities, server.capabilities or {})
            require('lspconfig')[server_name].setup(server)
          end,
        },
      }
    end,
  },
}

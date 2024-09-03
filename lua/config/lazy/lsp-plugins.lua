return {
  -- plugins to see the hierarchical view of symbols from lsp in buffer
  {
    "SmiteshP/nvim-navbuddy",
    name = 'navbuddy',
    dependencies = {
      "SmiteshP/nvim-navic",
      "MunifTanjim/nui.nvim"
    },
    opts = {
      lsp = { auto_attach = true },
    },
    config = function(_, opts)
      local actions = require("nvim-navbuddy.actions")
      local navbuddy = require("nvim-navbuddy")

      navbuddy.setup(vim.tbl_deep_extend("force", {
        mappings = {
          ["<C-left>"] = actions.parent(),    -- Move to left panel
          ["<C-right>"] = actions.children(), -- Move to right panel
        }
      }, opts))

      vim.keymap.set('n', '<leader>o', '<cmd>:lua require("nvim-navbuddy").open() <CR>',
        { noremap = true, silent = true, desc = 'go to symb[O]l' })
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

          map('gd', require('telescope.builtin').lsp_definitions, '[G]oto [D]efinition')
          map('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
          map('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
          map('gI', require('telescope.builtin').lsp_implementations, '[G]oto [I]mplementation')
          map('gt', require('telescope.builtin').lsp_type_definitions, 'Type [D]efinition')
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
        --[[         pylyzer = {}, ]]
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

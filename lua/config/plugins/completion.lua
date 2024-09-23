return {
  { -- Autocompletion
    'hrsh7th/nvim-cmp',
    -- event = { 'InsertEnter', 'CmdlineEnter' },
    dependencies = {
      'LuaSnip',
      -- nvim-cmp sources
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-path',
      'hrsh7th/cmp-buffer',
    },
    config = function()
      local luasnip = require 'luasnip'
      luasnip.config.setup {}

      local cmp = require 'cmp'

      local common_mappings = {
        ['<C-b>'] = cmp.mapping(cmp.mapping.scroll_docs(-4), { 'i', 's', 'c' }),
        ['<C-f>'] = cmp.mapping(cmp.mapping.scroll_docs(4), { 'i', 's', 'c' }),

        ['<enter>'] = cmp.mapping(cmp.mapping.confirm { select = true, }, { 'i', 's', 'c' }),
        ['<down>'] = cmp.mapping(cmp.mapping.select_next_item(), { 'i', 's', 'c' }),
        ['<up>'] = cmp.mapping(cmp.mapping.select_prev_item(), { 'i', 's', 'c' }),

        -- Manually trigger a completion from nvim-cmp.
        ['<C-space>'] = cmp.mapping(cmp.mapping.complete(), { 'i', 's', 'c' }),

        -- <c-l> will move you to the right of each of the expansion locations.
        -- <c-h> is similar, except moving you backwards.
        ['<C-right>'] = cmp.mapping(function()
          if luasnip.expand_or_locally_jumpable() then
            luasnip.expand_or_jump()
          end
        end, { 'i', 's', 'c' }),
        ['<C-left>'] = cmp.mapping(function()
          if luasnip.locally_jumpable(-1) then
            luasnip.jump(-1)
          end
        end, { 'i', 's', 'c' }),
      }

      cmp.setup {
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        completion = { completeopt = 'menu,menuone,noinsert' },
        mapping = cmp.mapping.preset.insert(common_mappings),
        sources = {
          { name = 'nvim_lsp' },
        },
      }

      cmp.setup.cmdline('/', {
        completion = { completeopt = 'menu,menuone,noinsert' },
        mapping = cmp.mapping.preset.insert(common_mappings),
        sources = {
          { name = 'buffer' }
        }
      })

      cmp.setup.cmdline(':', {
        completion = { completeopt = 'menu,menuone,noinsert' },
        mapping = cmp.mapping.preset.insert(common_mappings),
        sources = cmp.config.sources({
          { name = 'path' }
        }, {
          { name = 'cmdline' }
        }),
      })
    end,

  },
}

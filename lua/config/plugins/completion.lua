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
      'hrsh7th/cmp-cmdline',
      'hrsh7th/cmp-nvim-lsp-signature-help',
    },
    config = function()
      local luasnip = require 'luasnip'
      local cmp = require 'cmp'
      luasnip.config.setup {}

      local function next_completion(fallback)
        if cmp.visible() then
          cmp.select_next_item()
        elseif luasnip.expand_or_jumpable() then
          luasnip.expand_or_jump()
        else
          fallback()  -- Fallback to the default behavior if no completion is visible
        end
      end

      local function prev_completion(fallback)
        if cmp.visible() then
          cmp.select_prev_item()
        elseif luasnip.jumpable(-1) then
          luasnip.jump(-1)
        else
          fallback()  -- Fallback to the default behavior if no completion is visible
        end
      end

       local function ignore_completion(fallback)
        if cmp.visible() then
          cmp.abort()
        elseif luasnip.jumpable(-1) then
          luasnip.jump(-1)
        else
          fallback()  -- Fallback to the default behavior if no completion is visible
        end
      end

      local common_mappings = {
        ['<Tab>'] = cmp.mapping(next_completion, { 'i', 's', 'c' }),
        ['<down>'] =  cmp.mapping(next_completion, { 'i', 's', 'c' }),
        ['<S-Tab>'] = cmp.mapping(prev_completion, { 'i', 's', 'c' }),
        ['<up>'] =  cmp.mapping(prev_completion, { 'i', 's', 'c' }),
        -- ['<CR>'] = cmp.mapping(accept_completion, { 'i', 's', 'c' }),
        ['<CR>'] = cmp.config.disable,
        ['<ESC>'] = cmp.mapping(ignore_completion, { 'i', 's', 'c' }),
        ['<C-b>'] = cmp.mapping(cmp.mapping.scroll_docs(-4), { 'i', 's', 'c' }),
        ['<C-f>'] = cmp.mapping(cmp.mapping.scroll_docs(4), { 'i', 's', 'c' }),
      }

      cmp.setup {
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        completion = {
          completeopt = 'menuone,noinsert'
        },
        preselect = cmp.PreselectMode.None,
        mapping = cmp.mapping.preset.insert(common_mappings),
        sources = {
          { name = "nvim_lsp", keyword_length = 2, priority = 100, max_item_count = 5 },
          { name = "luasnip", keyword_length = 2, priority = 50, max_item_count = 2 },
          { name = "nvim_lsp_signature_help" },
          {
            name = "buffer",
            keyword_length = 1,
            max_item_count = 5,
          },
          { name = "tmux", keyword_length = 2, max_item_count = 3 },
          { name = "path", keyword_length = 2, max_item_count = 3 },
        },
      }

      cmp.setup.cmdline({'/', '?'}, {
        mapping = cmp.mapping.preset.cmdline(),
        sources = {
          { name = 'buffer' }
        }
      })

      cmp.setup.cmdline(":", {
        mapping = cmp.mapping.preset.cmdline(),
        sources = cmp.config.sources({
          { name = "cmdline", priority = 100 },
          { name = "buffer", priority = 80 },
        }),
      })
    end,

  },
}

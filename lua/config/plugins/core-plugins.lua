return {
  -- vim helpers for other plugins
  {
    'nvim-lua/plenary.nvim',
    config = function()
      if pcall(require, "plenary") then
        RELOAD = require("plenary.reload").reload_module

        R = function(name)
          RELOAD(name)
          return require(name)
        end
      end
    end
  },

  -- Detect tabstop and shiftwidth automatically
  'tpope/vim-sleuth',

  -- "gc" to comment visual regions/lines
  { 'numToStr/Comment.nvim', opts = {} },

  -- plugin to show you pending keybinds.
  {
    'folke/which-key.nvim',
    event = 'VimEnter', -- Sets the loading event to 'VimEnter'
    opts = {
      sort = {"alphanum", "manual"},
      filter = function(mapping)
        return mapping.desc and mapping.desc ~= ""
      end

    }
  },

  -- formatting syntax for buffers
  {
    'stevearc/conform.nvim',
    lazy = true,
    opts = {
      notify_on_error = false,
      format_on_save = {
        timeout_ms = 500,
        lsp_format = "fallback",
      },
      formatters_by_ft = {},
    },
  },

  -- undotree
  {
    "mbbill/undotree",
    keys = {
      {
        "<leader>tu",
        "<cmd>UndotreeToggle<CR>",
        desc = "Toggle [u]ndotree",
      },
    },
  },

  -- flash.nvim
  {
    "folke/flash.nvim",
    event = "VeryLazy",
    opts = {
      modes = {
        char = {
          jump_labels = true,
        }
      }
    },
    keys = {
      { "s", mode = { "n", "x", "o" }, function() require("flash").jump() end, desc = "[f]lash" },
      { "s", mode = "o", function() require("flash").remote() end, desc = "[f]lash" },
      { "<c-s>", mode = { "c" }, function() require("flash").toggle() end, desc = "Flash [s]earch" },
    },
  },


  -- Collection of various small independent plugins/modules
  {
    'echasnovski/mini.nvim',
    config = function()
      -- Better Around/Inside textobjects
      --
      -- Examples:
      --  - va)  - [V]isually select [A]round [)]paren
      --  - yinq - [Y]ank [I]nside [N]ext [']quote
      --  - ci'  - [C]hange [I]nside [']quote
      require('mini.ai').setup { n_lines = 500 }

      -- Add/delete/replace surroundings (brackets, quotes, etc.)
      --
      -- - saiw) - [S]urround [A]dd [I]nner [W]ord [)]Paren
      -- - sd'   - [S]urround [D]elete [']quotes
      -- - sr)'  - [S]urround [R]eplace [)] [']
      require('mini.surround').setup()

      -- Simple and easy statusline.
      local statusline = require 'mini.statusline'
      statusline.setup { use_icons = vim.g.have_nerd_font }

      ---@diagnostic disable-next-line: duplicate-set-field
      statusline.section_location = function()
        return '%2l:%-2v'
      end
    end,
  },

  -- indent-blankline
  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    opts = {},
  }
}

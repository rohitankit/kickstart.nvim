return {
  -- Telescope is a fuzzy finder that comes with a lot of different things that
  -- it can fuzzy find! it can search many different aspects of Neovim like
  -- files, git branches, definitions, and more
  {
    'nvim-telescope/telescope.nvim',
    event = 'VimEnter',
    branch = '0.1.x',
    dependencies = {
      'nvim-lua/plenary.nvim',
      {
        'nvim-telescope/telescope-fzf-native.nvim',
        build = 'make',
        cond = function()
          return vim.fn.executable 'make' == 1
        end,
      },
      { 'nvim-telescope/telescope-ui-select.nvim' },
      {
        'nvim-tree/nvim-web-devicons',
        enabled = vim.g.have_nerd_font
      },
      {
        'nvim-telescope/telescope-live-grep-args.nvim',
        version = "^1.0.0",
      },
      { 'nvim-telescope/telescope-hop.nvim' }
    },
    config = function()
      local telescope = require("telescope")
      local live_grep_actions = require("telescope-live-grep-args.actions")
      -- local tscope_entry_display = require("config.helpers.tscope_entry_display")

      telescope.setup {
        extensions = {
          ['ui-select'] = {
            require('telescope.themes').get_dropdown(),
          },
          quicknote = {
            defaultScope = "CWD",
          },
          live_grep_args = {
            auto_quoting = true,
            mappings = {
              i = {
                ["<C-k>"] = live_grep_actions.quote_prompt(),
                ["4"] = live_grep_actions.quote_prompt({ postfix = " --iglob **/*.{h,cpp}" }),
                ["5"] = live_grep_actions.quote_prompt({ postfix = " --iglob **/*.{py}" }),
                ["6"] = live_grep_actions.quote_prompt({ postfix = " -w --iglob **/*.{h,cpp}" }),
              }
            }
          },
        },
      }

      -- Enable Telescope extensions if they are installed
      pcall(telescope.load_extension, 'fzf')
      pcall(telescope.load_extension, 'ui-select')
      pcall(telescope.load_extension, 'live_grep_args')
      pcall(telescope.load_extension, 'quicknote')

      -- Keymaps for telescope
      local builtin = require 'telescope.builtin'
      local live_grep_args_shortcuts = require("telescope-live-grep-args.shortcuts")
      vim.keymap.set('n', '<leader>fh', builtin.help_tags, { desc = '[F]ind [H]elp' })
      vim.keymap.set('n', '<leader>fk', builtin.keymaps, { desc = '[F]ind [K]eymaps' })
      vim.keymap.set('n', '<leader>ft', builtin.builtin, { desc = '[F]ind select [T]elescope' })
      vim.keymap.set('n', '<leader>fr', builtin.resume, { desc = '[F]ind [R]esume' })

      vim.keymap.set('n', '<leader>f/', live_grep_args_shortcuts.grep_word_under_cursor_current_buffer,
        { desc = '[F]ind in [/] current buffer' })
      vim.keymap.set('n', '<leader>fw', live_grep_args_shortcuts.grep_word_under_cursor,
        { desc = '[F]ind current [W]ord' })
      vim.keymap.set('n', '<leader>fg', ":lua require('telescope').extensions.live_grep_args.live_grep_args()<CR>",
        { desc = '[F]ind by [g]rep' })
      vim.keymap.set('n', '<leader>fv', live_grep_args_shortcuts.grep_visual_selection,
        { desc = '[F]ind by [G]rep' })

      vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = '[F]ind [F]iles' })
      vim.keymap.set('n', '<leader>f.', builtin.oldfiles, { desc = '[F]ind Recent Files ("." for repeat)' })
      vim.keymap.set('n', '<leader><leader>', builtin.buffers, { desc = '[ ] Find existing buffers' })
	-- { entry_maker = tscope_entry_display.format_picker_result() }
	-- https://github.com/nvim-telescope/telescope.nvim/wiki/Configuration-Recipes#customize-buffers-display-to-look-like-leaderf

      vim.keymap.set('n', '<leader>fb', builtin.git_branches, { desc = '[F]ind git [B]ranch' })
    end,
  },
}

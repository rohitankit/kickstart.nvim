-- Telescope is a fuzzy finder that comes with a lot of different things that
-- it can fuzzy find! it can search many different aspects of Neovim like
-- files, git branches, definitions, and more

return {
  {
    'nvim-telescope/telescope.nvim',
    event = 'VimEnter',
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
      },
      {
        'nvim-telescope/telescope-hop.nvim'
      },
    },
    config = function()
      local telescope = require("telescope")
      local live_grep_actions = require("telescope-live-grep-args.actions")

      local telescope_config = {
        prompt_prefix = "   ",
        selection_caret = "  ",
        sorting_strategy = "ascending",
        layout_strategy = "horizontal",
        border = true,
        color_devicons = true,
        borderchars = { '─', '│', '─', '│', '┌', '┐', '┘', '└' },
        file_ignore_patterns = {
          "^%.git/",
          "^%.git$",
          ".DS_Store",
        },
      }
      local default_mappings = {
        mappings = {
          i = {
            ["<C-c>"] = false,
            ["<C-down>"] = R("telescope").extensions.hop.hop,
          },
          n = {
            ["<C-down>"] = R("telescope").extensions.hop.hop,
          },
        }
      }
      local default_layout_conf = {
        layout_config = {
          horizontal = {
            prompt_position = "top",
          },
        }
      }
      local default_config = vim.tbl_extend('error', telescope_config, default_mappings, default_layout_conf)

      local fullscreen_layout_conf = {
        layout_config = {
          horizontal = {
            mirror = false,
            prompt_position = 'top',
            width = 0.95,
            height = 0.95,
            preview_cutoff = 10,
            preview_width = 0.60,
          }
        }
      }

      telescope.setup {
        defaults = default_config,
        pickers = {
          find_files = {
            hidden = true,
            layout_config = fullscreen_layout_conf.layout_config,
          },
          live_grep = { "--hidden" },
          buffers = {
            sort_mru = true,
          },
          oldfiles = {
            cwd_only = true,
          },
          lsp_document_symbols = {
            symbol_width = 40,
          }
        },
        extensions = {
          ['ui-select'] = {
            require('telescope.themes').get_dropdown(),
            layout_config = {
              width = 100,
              height = 30,
            }
          },
          quicknote = {
            defaultScope = "CWD",
          },
          live_grep_args = vim.tbl_extend('error', telescope_config, fullscreen_layout_conf, {
            auto_quoting = true,
            mappings = {
              i = {
                ["<C-f>"] = live_grep_actions.quote_prompt({ postfix = " -w"}),
                ["<C-u>"] = live_grep_actions.quote_prompt({ postfix = " --iglob **/*.{h,cpp}" }),
                ["<C-i>"] = live_grep_actions.quote_prompt({ postfix = "--iglob **/*.{h,cpp}" }),
                ["<C-o>"] = live_grep_actions.quote_prompt({ postfix = " --iglob **/*.{py}" }),
              }
            }
          }),
          hop = {
            trace_entry = true,
            sign_hl = { "WarningMsg", "Title" },
            line_hl = { "CursorLine", "Normal" },
          },
        },
      }

      local builtin = require 'telescope.builtin'

      -- Enable Telescope extensions if they are installed
      pcall(telescope.load_extension, 'fzf')
      pcall(telescope.load_extension, 'ui-select')
      pcall(telescope.load_extension, 'live_grep_args')
      pcall(telescope.load_extension, 'quicknote')

      -- Keymaps for telescope
      vim.keymap.set('n', '<leader><leader>', builtin.buffers, { desc = '[ ] Find existing buffers' })

      vim.keymap.set('n', '<leader>fh', builtin.help_tags, { desc = '[F]ind [H]elp' })
      vim.keymap.set('n', '<leader>fr', builtin.resume, { desc = '[F]ind [R]esume' })
      vim.keymap.set('n', '<leader>f/', builtin.current_buffer_fuzzy_find, { desc = '[F]ind in [/] current buffer' })

      vim.keymap.set('n', '<leader>f.', builtin.oldfiles, { desc = '[F]ind Recent Files ("." for repeat)' })
      vim.keymap.set('n', '<leader>ft', builtin.builtin, { desc = '[F]ind select [T]elescope' })
      vim.keymap.set('n', '<leader>fk', builtin.keymaps, { desc = '[F]ind [K]eymaps' })
      vim.keymap.set('n', '<leader>fb', builtin.git_branches, { desc = '[F]ind git [B]ranch' })

      local live_grep_args_shortcuts = require("telescope-live-grep-args.shortcuts")

      vim.keymap.set('n', '<leader>fg', ":lua require('telescope').extensions.live_grep_args.live_grep_args()<CR>",
        { desc = '[F]ind by [g]rep' })
      vim.keymap.set('n', '<leader>fw', live_grep_args_shortcuts.grep_word_under_cursor_current_buffer,
        { desc = '[f]ind current [w]ord' })
      vim.keymap.set('n', '<leader>fW', live_grep_args_shortcuts.grep_word_under_cursor,
        { desc = '[F]ind current [W]ord' })
      vim.keymap.set({"v", "n"}, '<leader>fv', live_grep_args_shortcuts.grep_word_visual_selection_current_buffer,
        { desc = '[f]ind by [v]isual_selection' })
      vim.keymap.set('v', '<leader>fV', live_grep_args_shortcuts.grep_visual_selection,
        { desc = '[f]ind by [v]isual_selection' })

      vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = '[F]ind [F]iles' })
    end,
  },
}

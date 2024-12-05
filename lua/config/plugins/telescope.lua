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
      local actions = require("telescope.actions")

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
                ["<C-i>"] = live_grep_actions.quote_prompt({ postfix = " --iglob **/*.{h,cpp}" }),
                ["<C-o>"] = live_grep_actions.quote_prompt({ postfix = " --iglob **/*.{py}" }),
                ["<S-Down>"] = actions.cycle_history_next,
                ["<S-Up>"] = actions.cycle_history_prev,
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

     -- Enable Telescope extensions if they are installed
      local builtin = require 'telescope.builtin'
      pcall(telescope.load_extension, 'fzf')
      pcall(telescope.load_extension, 'ui-select')

      -- Telescope keymaps
      vim.keymap.set('n', '<leader>th', builtin.help_tags, { desc = '[h]elp docs' })
      vim.keymap.set('n', '<leader>tt', builtin.builtin, { desc = '[t]elescope pickers' })
      vim.keymap.set('n', '<leader>tk', builtin.keymaps, { desc = '[k]eymaps' })
      vim.keymap.set('n', '<leader>tj', builtin.jumplist, { desc = '[j]umplist' })
      vim.keymap.set('n', '<leader>td', builtin.diagnostics, { desc = 'Buffer [d]iagnostics' })
      vim.keymap.set('n', '<leader>tm', builtin.marks, { desc = '[m]arks' })
      vim.keymap.set('n', '<leader>tM', builtin.man_pages, { desc = '[M]an pages' })
      vim.keymap.set('n', '<leader>t"', builtin.registers, { desc = 'registers' })
      vim.keymap.set('n', '<leader>ts', builtin.lsp_document_symbols, { desc = '[s]ymbols' })

      -- Find keymaps
      vim.keymap.set('n', '<leader><leader>', builtin.buffers, { desc = '[ ] Find existing buffers' })
      vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = '[f]iles' })
      vim.keymap.set('n', '<leader>fr', builtin.resume, { desc = '[r]esume' })
      vim.keymap.set('n', '<leader>f.', builtin.oldfiles, { desc = 'Find Recent Files' })
      vim.keymap.set('n', '<leader>fj', builtin.jumplist , { desc = '[j]umplist' })
      vim.keymap.set('n', '<leader>fd', builtin.diagnostics, { desc = 'Buffer [d]iagnostics' })
      vim.keymap.set('n', '<leader>fm', builtin.marks, { desc = '[m]arks' })
      vim.keymap.set('n', '<leader>fM', builtin.man_pages, { desc = '[M]an pages' })
      vim.keymap.set('n', '<leader>f"', builtin.registers, { desc = 'registers' })
      vim.keymap.set('n', '<leader>fs', builtin.lsp_document_symbols, { desc = '[s]ymbols' })

      pcall(telescope.load_extension, 'live_grep_args')
      local live_grep_args_shortcuts = require("telescope-live-grep-args.shortcuts")
      vim.keymap.set('n', '<leader>f/', builtin.current_buffer_fuzzy_find, { desc = '[/] - current buffer' })
      vim.keymap.set('n', '<leader>fg', ":lua require('telescope').extensions.live_grep_args.live_grep_args()<CR>",
        { desc = '[g]rep project' })
      vim.keymap.set('n', '<leader>fw', live_grep_args_shortcuts.grep_word_under_cursor_current_buffer,
        { desc = '[w]ord in buffer' })
      vim.keymap.set('n', '<leader>fW', live_grep_args_shortcuts.grep_word_under_cursor,
        { desc = '[W]ord in project' })
      vim.keymap.set({"v"}, '<leader>fw', live_grep_args_shortcuts.grep_word_visual_selection_current_buffer,
        { desc = '[v]isual selection in buffer' })
      vim.keymap.set('v', '<leader>fW', live_grep_args_shortcuts.grep_visual_selection,
        { desc = '[V]isual selection in project' })

      -- Search in specific directory

      -- Git keymaps
      local git_hunks = function()
        require("telescope.pickers")
          .new({
            finder = require("telescope.finders").new_oneshot_job({ "git", "jump", "--stdout", "diff" }, {
              entry_maker = function(line)
                local filename, lnum_string = line:match("([^:]+):(%d+).*")

                -- I couldn't find a way to use grep in new_oneshot_job so we have to filter here.
                -- return nil if filename is /dev/null because this means the file was deleted.
                if filename:match("^/dev/null") then
                  return nil
                end

                return {
                  value = filename,
                  display = line,
                  ordinal = line,
                  filename = filename,
                  lnum = tonumber(lnum_string),
                }
              end,
            }),
            sorter = require("telescope.sorters").get_generic_fuzzy_sorter(),
            previewer = require("telescope.config").values.grep_previewer({}),
            results_title = "Git hunks",
            prompt_title = "Git hunks",
            layout_strategy = "flex",
          }, {})
          :find()
      end

      vim.keymap.set('n', '<leader>gb', builtin.git_branches, { desc = '[B]ranch telescope view' })
      vim.keymap.set("n", "<Leader>gh", git_hunks, { desc = 'unstaged [H]unks telescope view' })

    -- QuickFix keymaps
      vim.keymap.set('n', '<leader>qh', builtin.quickfixhistory, { desc = 'quickfix [h]istory' })

    -- Quicknote keymaps
    -- pcall(telescope.load_extension, 'quicknote')

    end,
  },
}

return {
  -- Adds git related signs to the gutter, as well as utilities for managing changes
  {
    'lewis6991/gitsigns.nvim',
    opts = {
      signs = {
        add = { text = '+' },
        change = { text = '~' },
        delete = { text = '_' },
        topdelete = { text = '‾' },
        changedelete = { text = '~' },
      },
      on_attach = function(bufnr)
        local gitsigns = require 'gitsigns'

        local function map(mode, l, r, opts)
          opts = opts or {}
          opts.buffer = bufnr
          vim.keymap.set(mode, l, r, opts)
        end

        map('n', '<leader>gp', gitsigns.preview_hunk, { desc = '[p]review Hunk' })
        map('n', '<leader>gs', gitsigns.stage_hunk, { desc = '[s]tage Hunk' })
        map('n', '<leader>gu', gitsigns.reset_hunk, { desc = '[u] Reset Hunk' })
        map('n', '<leader>g+', function()
          if vim.wo.diff then
            vim.cmd.normal { ']c', bang = true }
          else
            gitsigns.nav_hunk 'next'
          end
        end,
        { desc = "[+]next git hunk" })

        map('n', '<leader>g-', function()
          if vim.wo.diff then
            vim.cmd.normal { '[c', bang = true }
          else
            gitsigns.nav_hunk 'prev'
          end
        end,
        { desc = "[-]prev git hunk" })

        map('n', '<leader>gb', function()
            gitsigns.blame_line { full = true }
          end,
          { desc = '[b]lame' }
        )
        map('n', '<leader>gt', gitsigns.toggle_current_line_blame, { desc = '[t]oggle Blame' })

        map('n', '<leader>gd', gitsigns.diffthis, { desc = '[d]iff' })
        map('n', '<leader>gD', function()
            gitsigns.diffthis '~'
          end,
          { desc = '[D]iff' }
        )
      end,
    },
  },
}

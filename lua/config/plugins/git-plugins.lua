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

        -- Navigation
        map('n', '<leader>+', function()
          if vim.wo.diff then
            vim.cmd.normal { ']c', bang = true }
          else
            gitsigns.nav_hunk 'next'
          end
        end)
        map('n', '<leader>-', function()
          if vim.wo.diff then
            vim.cmd.normal { '[c', bang = true }
          else
            gitsigns.nav_hunk 'prev'
          end
        end)

        -- Actions with Hunk
        map('v', '<leader>gs', function()
            gitsigns.stage_hunk { vim.fn.line '.', vim.fn.line 'v' }
          end,
          { desc = '[G]it [S]tage Hunk' }
        )
        map('v', '<leader>gr', function()
            gitsigns.reset_hunk { vim.fn.line '.', vim.fn.line 'v' }
          end,
          { desc = '[G]it [R]eset Hunk' }
        )
        map('n', '<leader>gp', gitsigns.preview_hunk, { desc = '[G]it [P]review Hunk' })

        -- Actions with Buffer
        map('n', '<leader>gs', gitsigns.stage_buffer, { desc = '[G]it [S]tage Buffer' })
        map('n', '<leader>gr', gitsigns.reset_buffer, { desc = '[G]it [R]eset Buffer' })
        map('n', '<leader>gb', function()
            gitsigns.blame_line { full = true }
          end,
          { desc = '[G]it [B]lame' }
        )
        map('n', '<leader>gt', gitsigns.toggle_current_line_blame, { desc = '[G]it [T]oggle Blame' })
        map('n', '<leader>gd', gitsigns.diffthis, { desc = '[G]it [d]iff' })
        map('n', '<leader>gD', function()
            gitsigns.diffthis '~'
          end,
          { desc = '[G]it [D]iff' }
        )
      end,
    },
  },
}

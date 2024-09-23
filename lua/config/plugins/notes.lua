return {
  {
    "backdround/global-note.nvim",
    config = function()
      local global_note = require("global-note")
      global_note.setup({
        filename = "ticket_note.md",
        directory = "/home/ir/dev/misc",
      });

      vim.keymap.set("n", "<leader>n", global_note.toggle_note, {
        desc = "Toggle global note",
      })
    end
  },
  {
    'winter-again/annotate.nvim',
    dependencies = { 'kkharji/sqlite.lua' },
    config = function()
      require('annotate').setup({
        -- path for the sqlite db file
        db_uri = "/home/ir/dev/misc/neovim-notes/annotations_db",
        -- sign column symbol to use
        annot_sign = '',
        -- highlight group for symbol
        annot_sign_hl = 'Comment',
        -- highlight group for currently active annotation
        annot_sign_hl_current = 'FloatBorder',
        -- width of floating annotation window
        annot_win_width = 25,
        -- padding to the right of the floating annotation window
        annot_win_padding = 2
      })

      vim.keymap.set('n', '<leader>a', "<cmd>:lua require('annotate').create_annotation()<CR>",
        { noremap = true, silent = true, desc = 'create [A]nnotation' })
    end
  },
}

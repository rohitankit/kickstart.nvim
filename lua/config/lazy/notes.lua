return {
  {
    "backdround/global-note.nvim",
    config = function()
      local global_note = require("global-note")
      global_note.setup({
        filename = "ticket_note.md",
        directory = "/home/ir/dev/miscellaneous",
      });

      vim.keymap.set("n", "<leader>n", global_note.toggle_note, {
        desc = "Toggle global note",
      })
    end
  },
  {
    "RutaTang/quicknote.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      require("quicknote").setup({
        mode = "portable",
        sign = "",
        filetype = "md",
        git_branch_recognizable = false,
      })
    end
  },
}

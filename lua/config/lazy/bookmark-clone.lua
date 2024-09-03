return {
  -- {
  --   'crusj/bookmarks.nvim',
  --   keys = {
  --     { "<tab><tab>", mode = { "n" } },
  --   },
  --   branch = 'main',
  --   dependencies = { 'nvim-web-devicons' },
  --   config = function()
  --     require("bookmarks").setup()
  --     require("telescope").load_extension("bookmarks")
  --   end
  -- },
  {
    "LintaoAmons/bookmarks.nvim",
    dependencies = {
      { "nvim-telescope/telescope.nvim" },
      { "stevearc/dressing.nvim" }
    },
    opts = {
      json_db_path = vim.fs.normalize(vim.fn.stdpath("config") .. "/bookmarks.db.json"),
      signs = {
        mark = { icon = "󰃁", color = "red", line_bg = "#572626" },
      },
    },
  }
}

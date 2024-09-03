local function get_filename_from_path(path)
  return path:match("^.+/(.+)$")
end

return {
  {
    "LintaoAmons/bookmarks.nvim",
    dependencies = {
      { "nvim-telescope/telescope.nvim" },
      { "stevearc/dressing.nvim" },
      { "RutaTang/quicknote.nvim" },
    },
    opts = {
      json_db_path = "/home/ir/dev/misc/neovim-notes/bookmarks.db.json",
      signs = {
        mark = { icon = "󰃁", color = "magenta", line_bg = "#1e2124" },
      },
      enable_backup = false,
      show_calibrate_result = true,
      auto_calibrate_cur_buf = true,
      treeview = {
        bookmark_format = function(bookmark)
          local filename = get_filename_from_path(bookmark.location.path)
          return bookmark.name .. " - " .. filename .. " : " .. bookmark.location.line
        end,
        keymap = {
          quit = { "q", "<ESC>" },
          refresh = "R",
          create_folder = "a",
          tree_cut = "dd",
          tree_paste = "p",
          collapse = "o",
          delete = "r",
          active = "s",
          copy = "yy",
        },
      },
      hooks = {
        {
          callback = function(_, _)
            require('quicknote').OpenNoteAtCurrentLine()
          end,
        },
      },
    },
    config = function(_, opts)
      local bookmarks = require("bookmarks")
      local quicknote = require('quicknote')
      bookmarks.setup(opts)

      vim.keymap.set({ "n", "v" }, "<leader>fm", "<cmd>BookmarksGoto<cr>",
        { desc = "Go to bookmark at current active BookmarkList" })
      vim.keymap.set({ "n", "v" }, "<leader>ma", "<cmd>BookmarksCommands<cr>",
        { desc = "Find and trigger a bookmark command." })

      local map = function(keys, func, desc)
        vim.keymap.set({ "n", "v" }, keys, func, { desc = 'Bookmarks: ' .. desc })
      end

      map('<leader>mm',
        function()
          -- local line_no = vim.api.nvim_win_get_cursor(0)[1]
          -- quicknote.NewNoteAtLine(line_no)
          -- quicknote.OpenNoteAtLine(line_no)
          -- quicknote.NewNoteAtCurrentLine()
          vim.cmd("BookmarksMark")
        end, 'Toggle Bookmark')

      map('<leader>mt',
        function()
          vim.cmd("BookmarksTree")
        end, 'Toggle Tree')
    end
  }
}

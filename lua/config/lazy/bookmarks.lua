local function get_filename_from_path(path)
  return path:match("^.+/(.+)$")
end

return {
  {
    "LintaoAmons/bookmarks.nvim",
    dependencies = {
      { "nvim-telescope/telescope.nvim" },
      { "stevearc/dressing.nvim" },
      { "winter-again/annotate.nvim" },
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
            if not require('bookmarks').api.find_existing_bookmark_under_cursor() then
              require('annotate').create_annotation()
              require('bookmarks').api.calibrate_current_window()
            end
          end,
          trigger_point = "AFTER_GOTO_BOOKMARK",
        },
        {
          callback = function(_, _)
            require('annotate').create_annotation()
          end,
          trigger_point = "AFTER_CREATE_BOOKMARK",
        },
      },
    },
    config = function(_, opts)
      local bookmarks = require("bookmarks")
      bookmarks.setup(opts)

      vim.keymap.set({ "n", "v" }, "<leader>fm", "<cmd>BookmarksGoto<CR>",
        { desc = "Go to bookmark at current active BookmarkList" })
      vim.keymap.set({ "n", "v" }, "<leader>bk", "<cmd>BookmarksCommands<CR>",
        { desc = "Find and trigger a bookmark command." })

      local map = function(l, r, desc)
        vim.keymap.set({ "n", "v" }, l, r, { desc = 'Book[M]arks: ' .. desc })
      end

      map('ma',
        '<Cmd>BookmarksCommands<CR>',
        'list [A]ctions')

      map('mm',
        '<Cmd>BookmarksMark<CR>',
        'Toggle [M]ark')

      map('mt',
        '<Cmd>BookmarksTree<CR>',
        'Toggle [T]ree')
    end,
  },
}

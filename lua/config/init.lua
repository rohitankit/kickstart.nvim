require 'config.keymaps'
require 'config.options'
require 'config.lazy_init'

-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
--  See `:help vim.highlight.on_yank()`
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})


-- Creates new Buffer for help pages in the current window
--  instead of a in a horizontal split
local split_pages = { "copilot-chat" }

vim.api.nvim_create_autocmd("BufEnter", {
  group = vim.api.nvim_create_augroup("HelpReplaceWindow", { clear = true }),
  callback = function()
    -- Some markdown files that should be split instead of
    --  opening in a new window
    local buf_filename = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(0), ':t')
    for _, file_to_split in ipairs(split_pages) do
      if string.find(buf_filename, file_to_split, 0, true) then
        return
      end
    end

    if (vim.bo.filetype == "help" or vim.bo.filetype == "markdown") and vim.b.already_opened == nil then
      -- remember we already opened this buffer
      vim.b.already_opened = true

      -- close the original window
      local original_win = vim.fn.win_getid(vim.fn.winnr('#'))
      local help_win = vim.api.nvim_get_current_win()
      if original_win ~= help_win then
        vim.api.nvim_win_close(original_win, false)
      end

      -- put the help buffer in the buffer list
      vim.bo.buflisted = true
    end
  end,
})

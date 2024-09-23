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

-- Exception file types
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
      -- close the original window
      local original_win = vim.fn.win_getid(vim.fn.winnr('#'))
      local help_win = vim.api.nvim_get_current_win()
      if original_win ~= help_win then
        vim.api.nvim_win_close(original_win, false)
      end

      -- put the help buffer in the buffer list
      vim.bo.buflisted = true

      -- remember we already opened this buffer
      vim.b.already_opened = true
    end
  end,
})

-- -- Quickfix list autocmds
-- local wininfo = vim.fn.getwininfo(vim.api.nvim_get_current_win())
--
-- local is_qf = wininfo[0]['quickfix']
-- local is_loclist = wininfo[0]['loclist']
-- vim.api.nvim_create_autocmd("BufEnter", {
--   group = vim.api.nvim_create_augroup("NavigateList", { clear = true }),
--   callback = function()
--     local wininfo = vim.fn.getwininfo(vim.api.nvim_get_current_win())
--     local is_qf = wininfo[0]['quickfix']
--     local is_loclist = wininfo[0]['loclist']
--     if is_loclist == 1 then
--       vim.keymap.set('n', '<leader>w', '<cmd>:w<CR>', { noremap = true, silent = true, desc = '[w]rite buffer' , buffer = vim.api.nvim_get_current_buf()})
--     elseif is_qf == 1 then
--   end,
-- })
--
--
--

local function set_location_list_mappings(win_id)
  -- Set key mappings for the location list window
  vim.keymap.set('n', 'j',
    function()
      vim.cmd('lnext')
      vim.cmd('wincmd p')
    end,
    { buffer = vim.api.nvim_win_get_buf(win_id) })

  vim.keymap.set('n', 'k',
    function()
      vim.cmd('lprev')
      vim.cmd('wincmd p')
    end,
    { buffer = vim.api.nvim_win_get_buf(win_id) })
end

local function set_quickfix_mappings(win_id)
  -- Set key mappings for the quickfix list window
  vim.keymap.set('n', 'j',
    function()
      vim.cmd('cnext')
      vim.cmd('wincmd p')
    end,
    { buffer = vim.api.nvim_win_get_buf(win_id) })

  vim.keymap.set('n', 'k',
    function()
      vim.cmd('cnext')
      vim.cmd('wincmd p')
    end,
    { buffer = vim.api.nvim_win_get_buf(win_id) })
end

-- Apply key mappings when entering a window
-- vim.api.nvim_create_autocmd('BufWinEnter', {
--   pattern = '*',
--   callback = function()
--     local win_id = vim.api.nvim_get_current_win()
--
--     -- Check if the current window has a location list
--     local location_list_exists = vim.fn.getloclist(win_id)
--     if #location_list_exists > 0 then
--       set_location_list_mappings(win_id)
--     end
--
--     -- Check if the current window has a quickfix list
--     local quickfix_exists = vim.fn.getqflist()
--     if #quickfix_exists > 0 then
--       set_quickfix_mappings(win_id)
--     end
--   end
-- })

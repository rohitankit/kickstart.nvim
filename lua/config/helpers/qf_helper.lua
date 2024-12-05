function ToggleQuickFixList()
  local is_quickfix_open = false
  for _, win in pairs(vim.fn.getwininfo()) do
    if win.quickfix == 1 then
      is_quickfix_open = true
      break
    end
  end

  if is_quickfix_open then
    vim.cmd("cclose")
  else
    vim.cmd("copen")
  end
end
-- vim.api.nvim_set_keymap(
--   "n",
--   "<leader>tq",
--   ":lua ToggleQuickFixList()<CR>",
--   { noremap = true, silent = true, desc = "Toggle QuickFix List" }
-- )
--
-- vim.api.nvim_set_keymap("n", "<leader>tf", "<leader>uf", { desc = "Toggle AutoFormat" })
-- vim.api.nvim_set_keymap("n", "<leader>td", "<leader>ud", { desc = "Toggle LSP Diagnostics" })
--

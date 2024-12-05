function close_window_with_filetype(filetype)
  local win_ids = vim.api.nvim_list_wins()
  for _, win_id in ipairs(win_ids) do
    local buf_id = vim.api.nvim_win_get_buf(win_id)
    local buf_filetype = vim.api.nvim_buf_get_option(buf_id, "filetype")
    if buf_filetype == filetype then
      vim.api.nvim_win_close(win_id, false)
      return true
    end
  end
  return false
end

function check_filetype(filetype)
  local win_ids = vim.api.nvim_list_wins()
  for _, win_id in ipairs(win_ids) do
    local buf_id = vim.api.nvim_win_get_buf(win_id)
    local buf_filetype = vim.api.nvim_buf_get_option(buf_id, "filetype")
    if buf_filetype == filetype then
      return true
    end
  end
  return false
end


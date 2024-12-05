return {
  {
    'akinsho/toggleterm.nvim',
    version = "*",
    config = function()
      require('toggleterm').setup()

      vim.keymap.set("n", "<C-y>", ":ToggleTerm direction=float<CR>", {silent = true})
      vim.keymap.set('t', "<C-y>", '<C-\\><C-n>:q<CR>', { desc = 'Exit terminal mode' })
    end
  }
}

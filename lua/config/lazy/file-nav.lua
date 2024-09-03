-- Toggle Nvim-Tree in vertical split
vim.api.nvim_set_keymap('n', '<C-b>', ':NvimTreeToggle<cr>', { silent = true, noremap = true })

-- Toggle telescope file browser
vim.keymap.set('n', '<space>fB', ':Telescope file_browser<CR>', { silent = true, noremap = true })

return {
  -- nvim-tree, tree navigation like vscode
  {
    'nvim-tree/nvim-tree.lua',
    version = '*',
    lazy = false,
    dependencies = {
      'nvim-tree/nvim-web-devicons',
    },
    opts = {
      hijack_cursor = true,
      disable_netrw = true,
      hijack_unnamed_buffer_when_opening = true,
      update_focused_file = {
        enable = true,
      },
      git = {
        enable = false,
      },
    },
  },

  {
    'nvim-telescope/telescope-file-browser.nvim',
    dependencies = { 'nvim-telescope/telescope.nvim', 'nvim-lua/plenary.nvim' },
  },
}

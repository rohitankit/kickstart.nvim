return {
  {
    'folke/tokyonight.nvim',
    priority = 1000, -- Make sure to load this before all the other start plugins.
    init = function()
      vim.cmd.hi 'Comment gui=none'
    end,
  },
  {
    "scottmckendry/cyberdream.nvim",
    lazy = false,
    priority = 1000,
    init = function()
      vim.cmd.colorscheme 'cyberdream'
      -- vim.cmd.hi 'Comment gui=none'
    end,
    opts = {
      extensions = {
        telescope = true
      },
    },
  }
}

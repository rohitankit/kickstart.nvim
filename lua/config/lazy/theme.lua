return {
  {
    'folke/tokyonight.nvim',
    priority = 1000, -- Make sure to load this before all the other start plugins.
    init = function()
      vim.cmd.colorscheme 'tokyonight-night'
      vim.cmd.colorscheme 'tokyonight-storm'
      vim.cmd.colorscheme 'tokyonight-moon'

      vim.cmd.hi 'Comment gui=none'
    end,
  },
}

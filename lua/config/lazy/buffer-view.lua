return {
  -- plugin to see list of opened buffers
  {
    'akinsho/bufferline.nvim',
    version = '*',
    dependencies = 'nvim-tree/nvim-web-devicons',
    opts = {
      options = {
        offsets = {
          {
            filetype = 'NvimTree',
            text = 'File Explorer',
            highlight = 'Directory',
            seperator = true,
          },
        },
      },
    },
  },

  {
    "tiagovla/scope.nvim",
    opts = {}
  }

  -- plugin to see list of opened buffers specific to each window
  -- https://github.com/mrjones2014/winbarbar.nvim
  -- https://github.com/zefei/vim-wintabs
}

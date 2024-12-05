function ToggleNoiceHistory()
  if check_filetype("noice") then
    close_window_with_filetype("noice")
  else
    vim.cmd("NoiceHistory")
  end
end

return {
  -- Themes
  {
    'folke/tokyonight.nvim',
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
    keys = {
      { "<leader>a", "", desc = "ai" },
      { "<leader>b", "", desc = "buffer" },
      { "<leader>t", "", desc = "telescope/toggle" },
      { "<leader>f", "", desc = "find"},
      { "<leader>g", "", desc = "git" },
      { "<leader>q", "", desc = "quickfix/quit" },
      { "<leader>n", "", desc = "note" },
      { "<leader>l", "", desc = "location list" },
    },
  },

  -- trouble
  {
    "folke/trouble.nvim",
    opts = {}, -- for default options, refer to the configuration section for custom setup.
    cmd = "Trouble",
    keys = {
      {
        "<leader>e",
        "<cmd>Trouble diagnostics toggle<cr>",
        desc = "Buffer Diagnostic [e]rrors (Trouble)",
      },
      {
        "<leader>E",
        "<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
        desc = "Buffer Diagnostic [E]rrors (Trouble)",
      },
      {
        "gs",
        "<cmd>Trouble symbols toggle focus=false win.position=right<cr>",
        desc = "[s]ymbols (Trouble)",
      },
      {
        "gl",
        "<cmd>Trouble lsp toggle focus=false win.position=right<cr>",
        desc = "[l]sp (Trouble)",
      },
      {
        "<leader>l",
        "<cmd>Trouble loclist toggle<cr>",
        desc = "[l]ocation List (Trouble)",
      },
      {
        "<leader>qf",
        "<cmd>Trouble qflist toggle<cr>",
        desc = "Quick [f]ix List (Trouble)",
      },
    },
  },

  -- noice
  {
    "folke/noice.nvim",
    event = "VeryLazy",
    opts = function(_, opts)
      opts.presets = {
        command_palette = {
          views = {
            cmdline_popup = {
              position = {
                row = "50%",
                col = "50%",
              },
              size = {
                min_width = 60,
                width = "auto",
                height = "auto",
              },
            },
            popupmenu = {
              relative = "editor",
              position = {
                row = 23,
                col = "50%",
              },
              size = {
                width = 60,
                height = "auto",
                max_height = 15,
              },
              border = {
                style = "rounded",
                padding = { 0, 1 },
              },
              win_options = {
                winhighlight = { Normal = "Normal", FloatBorder = "NoiceCmdlinePopupBorder" },
              },
            },
          },
        },
      }
      -- opts.lsp.signature = {
      --   opts = { size = { max_height = 15 } },
      -- }
    end,
    keys = {
      { "<leader>tn", ToggleNoiceHistory, desc = "Toggle [n]oice history" },
    },
  },


}

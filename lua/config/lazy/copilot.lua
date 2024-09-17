vim.g.copilot_node_command = "~/.nvm/versions/node/v22.6.0/bin/node"

local prompts = {
  -- Code related prompts
  Explain = "Please explain how the following code works.",
  Review = "Please review the following code and provide suggestions for improvement.",
  Tests = "Please explain how the selected code works, then generate unit tests for it.",
  Refactor = "Please refactor the following code to improve its clarity and readability.",
  FixCode = "Please fix the following code to make it work as intended.",
  FixError = "Please explain the error in the following text and provide a solution.",
  BetterNamings = "Please provide better names for the following variables and functions.",
  Documentation = "Please provide documentation for the following code.",
}

return {
  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    event = "InsertEnter",
    lazy = true,
    config = function()
      require("copilot").setup({})
    end,
  },
  {
    "CopilotC-Nvim/CopilotChat.nvim",
    branch = "canary",
    dependencies = {
      { "zbirenbaum/copilot.lua" },
      { "nvim-lua/plenary.nvim" },
    },
    lazy = true,
    opts = {
      debug = true,
      allow_insecure = false,
      auto_follow_cursor = false,
      context = 'buffer',
      prompts = prompts,
      mappings = {
        -- Use tab for completion
        complete = {
          detail = "Use @<Tab> or /<Tab> for options.",
          insert = "<Tab>",
        },
        -- Close the chat
        close = {
          normal = "<C-x>",
          insert = "<C-x>",
        },
        -- Reset the chat buffer
        reset = {
          normal = "<C-r>",
          insert = "<C-r>",
        },
        -- Submit the prompt to Copilot
        submit_prompt = {
          normal = "<CR>",
          insert = "<C-CR>",
        },
      },
    },
    config = function(_, opts)
      -- Setting up plugin
      local chat = require("CopilotChat")
      local select = require("CopilotChat.select")
      opts.selection = select.unnamed
      chat.setup(opts)

      -- Setting up autocomplete with copilot
      require("CopilotChat.integrations.cmp").setup()

      local function is_visual_mode()
        local mode = vim.fn.mode()
        return mode == 'v' or mode == 'V' or mode == ''
      end


      -- Different copilot commands/keybinds
      --  create chat with visual selection as context if in visual mode
      --  else create chat with buffer as context
      vim.api.nvim_create_user_command("CopilotChatBuffer", function(args)
        if args.args == "" then
          return
        end
        if is_visual_mode() then
          chat.ask(args.args, { selection = select.visual })
        else
          chat.ask(args.args, { selection = select.buffer })
        end
      end, { nargs = "*", range = true })

      --  Turns CopilotChat buffer
      vim.api.nvim_create_autocmd("BufEnter", {
        pattern = "copilot-*",
        callback = function()
          vim.opt_local.relativenumber = true
          vim.opt_local.number = true

          -- Get current filetype and set it to markdown if the current filetype is copilot-chat
          local ft = vim.bo.filetype
          if ft == "copilot-chat" then
            vim.bo.filetype = "markdown"
          end
        end,
      })

      ---- Add which-key mappings
      local wk = require("which-key")
      wk.add({
        { "<leader>g",  group = "+Copilot Chat" }, -- group
        { "<leader>gp", desc = "Quick chat" },
        { "<leader>ga", desc = "Show Copilot prompt_actions" },
        { "<leader>gt", desc = "Quick Chat toggle" },
      })
    end,
    keys = {
      {
        "<leader>ga",
        function()
          local actions = require("CopilotChat.actions")
          require("CopilotChat.integrations.telescope").pick(actions.prompt_actions())
        end,
        desc = "CopilotChat - Prompt actions",
      },
      {
        "<leader>ga",
        ":lua require('CopilotChat.integrations.telescope').pick(require('CopilotChat.actions').prompt_actions({selection = require('CopilotChat.select').visual}))<CR>",
        mode = "v",
        desc = "CopilotChat - Prompt actions",
      },
      -- Quick chat with Copilot
      {
        "<leader>gc",
        function()
          local input = vim.fn.input("Quick Chat: ")
          if input ~= "" then
            vim.cmd("CopilotChatBuffer " .. input)
          end
        end,
        desc = "CopilotChat - Quick chat",
      },
      {
        "<leader>gc",
        function()
          local input = vim.fn.input("Quick Chat: ")
          if input ~= "" then
            vim.cmd("CopilotChatBuffer " .. input)
          end
        end,
        mode = "v",
        desc = "CopilotChat - Quick chat",
      },
      { "<leader>gt", "<cmd>CopilotChatToggle<cr>", desc = "CopilotChat - Toggle" },
    },
  },
}

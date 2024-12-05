function AutoFormatOnSave()
  local Job = require("plenary.job")
  Job:new({
    command = "make",
    args = { "clang-format-patch-stack" },
    on_exit = function(job, return_val)
      vim.schedule(function()
        vim.cmd("e")
      end)
    end,
  }):start()
end
-- vim.cmd([[
-- autocmd BufWritePost *.cpp,*.h lua AutoFormatOnSave()
-- ]])
--
return {}

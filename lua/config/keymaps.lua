--[=========================== Basic Keymaps =============================]

-- Clear highlight on Esc
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- Motions keymaps
vim.keymap.set('i', 'jk', '<Esc>')
vim.keymap.set("i", "<C-c>", "<Esc>")
-- Add custom mark behavior to jump motions
vim.api.nvim_set_keymap('n', 'k', [[:<C-U>execute 'normal!' (v:count > 5 ? "m'" : '') . v:count . 'k'<CR>]], { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', 'j', [[:<C-U>execute 'normal!' (v:count > 5 ? "m'" : '') . v:count . 'j'<CR>]], { noremap = true, silent = true })

-- Diagnostic keymaps
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Go to previous [D]iagnostic message' })
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'Go to next [D]iagnostic message' })

-- Terminal mode keymaps
vim.keymap.set('t', '<Esc>x', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

-- Split navigation keymaps
vim.keymap.set('n', '<C-left>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
vim.keymap.set('n', '<C-right>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
vim.keymap.set('n', '<C-down>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
vim.keymap.set('n', '<C-up>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

-- Copy keymaps
-- Keymaps to use osc-52 to copy to system clipboard
vim.keymap.set('n', 'y', '"+y')
vim.keymap.set('v', 'y', '"+y')
-- Other copy-keymaps
vim.keymap.set({"n", "v"}, "<leader>y", [["+y]], { desc = '[y]ank to clipboard' })
vim.keymap.set("n", "<leader>Y", [["+Y]], { desc = '[Y]ank line to clipboard' })
vim.keymap.set("x", "<leader>p", [["_dP]], { desc = '[p]aste clipboard' })
vim.keymap.set({"n", "v"}, "<leader>d", [["_d]], { desc = '[d]elete to null register' })

-- Git Diff keymaps
if vim.opt.diff:get() then
  -- Map Q to :cquit in diff mode
  vim.api.nvim_set_keymap('n', 'Q', ':cquit<CR>', { noremap = true, silent = true })
end

-- visual keymaps
vim.keymap.set('n', '<leader>gv', 'gv', { desc = 'last [v]isual selection' })

-- misc keymaps
-- vim.api.nvim_set_keymap('i', 'S', 'setline(".",substitute(getline(line(".")),"^\s*",matchstr(getline(line(".")-1),"^\s*"),""))', { noremap = true })


--[=========================== Buffer Keymaps =============================]

vim.keymap.set('n', '<leader>w', '<cmd>:w<CR>', { noremap = true, silent = true, desc = '[w]rite buffer' })

vim.keymap.set('n', '<leader>bn', '<cmd>:bn<CR>', { noremap = true, silent = true, desc = '[n]ext buffer ' })
vim.keymap.set('n', '<leader>bp', '<cmd>:bp<CR>', { noremap = true, silent = true, desc = '[p]revious buffer ' })

vim.keymap.set('n', '<leader><Tab>', '<cmd>:bn<CR>',
  { noremap = true, silent = true, desc = 'move to next buffer' })
vim.keymap.set('n', '<leader><S-Tab>', '<cmd>:bp<CR>',
  { noremap = true, silent = true, desc = 'move to prev buffer' })

vim.keymap.set('n', '<leader>bd', '<cmd>:bd<CR>', { noremap = true, silent = true, desc = '[d]elete buffer' })

-- vim.keymap.set('n', '<leader>x', '<cmd>silent! bp | sp | silent! bn | bd!<CR>',
--   { noremap = true, silent = true, desc = 'e[x]it buffer' })
vim.keymap.set('n', '<leader>x', ':bwipeout<CR>',
               { noremap = true, silent = true, desc = 'e[x]it buffer' })

vim.keymap.set('n', '<leader>bq', '<cmd>:q<CR>', { noremap = true, silent = true, desc = ' [q]uit buffer '})
vim.keymap.set('n', '<leader>bt', '<cmd>:tab split <CR>',
  { noremap = true, silent = true, desc = 'duplicate buffer in new [t]ab' })


--[=========================== Tab Keymaps =============================]

_G.go_to_tab = function(tab_num)
  if tab_num >= 1 and tab_num <= vim.fn.tabpagenr("$") then
    vim.cmd('tabn ' .. tab_num)
  else
    print('Invalid tab number')
  end
end

-- Map the function to key combinations
local function set_tab_keymap(number)
  vim.api.nvim_set_keymap(
    'n',
    '<Leader>' .. number .. 't',
    '<Cmd>lua go_to_tab(' .. number .. ')<CR>',
    { noremap = true, silent = true }
  )
end

-- go to tab
for i = 1, 5 do
  set_tab_keymap(i)
end

--[========================== Misc Keymaps =============================]

function PrintCurrentFilePath()
  local path = vim.fn.expand("%:p")
  vim.notify(path, vim.log.levels.INFO, {
    title = "Current File's Absolute Path",
  })
end

vim.cmd([[
    nnoremap <leader>pp :lua PrintCurrentFilePath()<CR>
]])

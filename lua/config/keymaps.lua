--[============== Setting Neovim/Vim global variables =================]
-- Set <space> as the leader key
-- Must happen before plugins are loaded (otherwise wrong leader will be used)
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

--[=========================== Basic Keymaps =============================]
-- Clear highlight on Esc
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

vim.keymap.set('i', 'jk', '<Esc>')
vim.keymap.set("i", "<C-c>", "<Esc>")

-- Diagnostic keymaps
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Go to previous [D]iagnostic message' })
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'Go to next [D]iagnostic message' })
vim.keymap.set('n', '<leader>e', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })
vim.keymap.set('n', '<leader>qf', '<cmd>copen<CR>')

-- This won't work in all terminal emulators/tmux/etc. Try your own mapping
--  or just use <C-\><C-n> to exit terminal mode
vim.keymap.set('t', '<Esc>x', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

-- Keybinds to make split navigation easier.
--  Use CTRL+<lf,rt,up,dn> to switch between windows
vim.keymap.set('n', '<C-left>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
vim.keymap.set('n', '<C-right>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
vim.keymap.set('n', '<C-down>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
vim.keymap.set('n', '<C-up>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

-- Keymaps to use osc-52 to copy to system clipboard
vim.keymap.set('n', 'y', '"+y')
vim.keymap.set('v', 'y', '"+y')

-- Other useful keymaps
vim.keymap.set({"n", "v"}, "<leader>y", [["+y]])
vim.keymap.set("n", "<leader>Y", [["+Y]])

vim.keymap.set("x", "<leader>p", [["_dP]])

vim.keymap.set({"n", "v"}, "<leader>d", [["_d]])

--[=========================== Buffer Keymaps =============================]
-- Command to move buffer to next tab

vim.keymap.set('n', '<leader>w', '<cmd>:w<CR>', { noremap = true, silent = true, desc = '[w]rite buffer' })

vim.keymap.set('n', '<leader>bn', '<cmd>:bn<CR>', { noremap = true, silent = true, desc = 'move to [b]uffer [n]ext' })
vim.keymap.set('n', '<leader>bp', '<cmd>:bp<CR>', { noremap = true, silent = true, desc = 'move to [b]uffer [p]revious' })

vim.keymap.set('n', '<leader><Tab>', '<cmd>:bn<CR>',
  { noremap = true, silent = true, desc = 'move to [b]uffer [n]ext' })
vim.keymap.set('n', '<leader><S-Tab>', '<cmd>:bp<CR>',
  { noremap = true, silent = true, desc = 'move to [b]uffer [p]revious' })

vim.keymap.set('n', '<leader>bd', '<cmd>:bd<CR>', { noremap = true, silent = true, desc = '[b]uffer [d]elete' })
vim.keymap.set('n', '<leader>x', '<cmd>silent! bp | sp | silent! bn | bd!<CR>',
  { noremap = true, silent = true, desc = 'buffer e[x]it' })
vim.keymap.set('n', '<leader>qq', '<cmd>:q<CR>', { noremap = true, silent = true, desc = 'buffer [q]uit' })

vim.keymap.set('n', '<leader>bt', '<cmd>:tab split <CR>',
  { noremap = true, silent = true, desc = 'duplicate [b]uffer in new [t]ab' })

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
    { noremap = true, silent = true, desc = 'move to [n]th [t]ab' }
  )
end

-- next tab
vim.keymap.set('n', '<leader>t', function()
  vim.cmd 'tabn'
end, { noremap = true, silent = true, desc = 'Go to next [t]ab' })

-- previous tab
vim.keymap.set('n', '<leader>T', function()
  vim.cmd 'tabN'
end, { noremap = true, silent = true, desc = 'Go to previous [T]ab' })

-- go to tab
for i = 1, 5 do
  set_tab_keymap(i)
end

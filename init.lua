-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out,                            "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

-- Make sure to setup `mapleader` and `maplocalleader` before
-- loading lazy.nvim so that mappings are correct.
-- This is also a good place to setup other settings (vim.opt)
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"
vim.g.netrw_bufsettings = 'noma nomod nu rnu nobl nowrap ro'
vim.wo.wrap = false

vim.opt.ignorecase = true
vim.opt.smartcase = true

require("lazy").setup({
  spec = {
    { import = "plugins" },
  },
  install = { colorscheme = { "habamax" } },
  checker = { enabled = true },
})


vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.expandtab = true
vim.opt.shiftwidth = 4
vim.opt.tabstop = 4
vim.opt.softtabstop = 4

vim.keymap.set('n', '<C-h>', '<C-w>h')
vim.keymap.set('n', '<C-j>', '<C-w>j')
vim.keymap.set('n', '<C-k>', '<C-w>k')
vim.keymap.set('n', '<C-l>', '<C-w>l')
vim.keymap.set('n', '<C-S-h>', '<C-w>H')
vim.keymap.set('n', '<C-S-j>', '<C-w>J')
vim.keymap.set('n', '<C-S-k>', '<C-w>K')
vim.keymap.set('n', '<C-S-l>', '<C-w>L')
vim.keymap.set('n', '<C-S-r>', '<C-w>r')
vim.keymap.set('n', '<C-S-e>', '<C-w>R')
vim.keymap.set('n', '<M-h>', '<cmd>vertical resize -2<CR>')
vim.keymap.set('n', '<M-l>', '<cmd>vertical resize +2<CR>')
vim.keymap.set('n', '<M-k>', '<cmd>resize +2<CR>')
vim.keymap.set('n', '<M-j>', '<cmd>resize -2<CR>')
vim.keymap.set('n', '<C-S-h>', '<C-w>H')
vim.keymap.set('n', '<Space><Space>', ':noh<CR>')
vim.keymap.set('n', '<C-S-a><C-S-i>', ':AvanteAsk<CR>')
vim.keymap.set('n', '<C-S-a><C-S-c>', ':AvanteChat<CR>')
vim.keymap.set('n', '<C-S-a><C-S-x>', ':AvanteClear<CR>')
vim.keymap.set('n', '<C-S-a><C-S-t>', ':AvanteToggle<CR>')
vim.keymap.set('n', '<leader>V', ':vsplit<CR>', { desc = 'Vertical terminal split' })
vim.keymap.set('n', '<leader>H', ':split<CR>', { desc = 'Horizontal terminal split' })
vim.keymap.set('n', '<leader>vt', ':vsplit term://bash<CR>', { desc = 'Vertical terminal split' })
vim.keymap.set('n', '<leader>ht', ':split term://bash<CR>', { desc = 'Horizontal terminal split' })
vim.keymap.set('n', '<leader>cd', ':cd %:p:h<CR>', { desc = 'Change directory to current buffer parent' })
vim.keymap.set('n', '<C-S-o>', ':bprevious<CR>', { desc = 'Explore buffer history, last buffer, etc.' })
vim.keymap.set('n', '<C-S-i>', ':bnext<CR>', { desc = 'Explore buffer history, next buffer, etc.' })
vim.keymap.set('n', '<leader>d<leader>', ':%s/\\v^ +$//g<CR>', { desc = 'Delete all whitespace lines' })
vim.keymap.set('n', '<leader>th', ':TermHere<CR>', { desc = 'Open terminal in current file directory' })

-- file paths
vim.keymap.set('n', '<leader>ev', ':e $MYVIMRC<CR>')
vim.keymap.set('n', '<leader>src', ':Oil ~/Source/<CR>')

vim.keymap.set('v', '<leader>el', ":lua<CR>", { desc = 'Execute selected lua text' })
vim.keymap.set('v', 'gx', '!open<CR>')

vim.keymap.set('t', '<ESC><ESC>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

vim.api.nvim_create_user_command('TermHere', function()
  local file_dir = vim.fn.expand('%:p:h')
  vim.cmd('terminal cd ' .. file_dir .. ' && $SHELL')
end, {})

-- Auto enter normal mode when terminal buffer gets focus
vim.api.nvim_create_autocmd("BufEnter", {
  pattern = "term://*",
  command = "stopinsert"
})

vim.api.nvim_create_user_command('DelSwap', function()
  vim.fn.delete(vim.fn.expand("~/.local/state/nvim/swap/*.swp"))
end, {})

vim.opt.guicursor = "n-v-c:block,i-ci-ve:ver25,r-cr:hor20,o:hor50"


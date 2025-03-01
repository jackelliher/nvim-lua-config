return {
  'nvim-telescope/telescope.nvim',
  dependencies = {
    'nvim-lua/plenary.nvim',
    { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' }
  },
  config = function()
    require('telescope').setup({
      extensions = {
        fzf = {
          fuzzy = true,
          override_generic_sorter = true,
          override_file_sorter = true,
        }
      }
    })
    require('telescope').load_extension('fzf')

    -- Keymaps
    local builtin = require('telescope.builtin')

    vim.keymap.set('n', '<leader>fig', function()
      local current_file_dir = vim.fn.expand('%:p:h')
      require('telescope.builtin').live_grep({
        cwd = current_file_dir,
      })
    end)
    vim.keymap.set('n', '<leader>fi', function()
      local current_file_dir = vim.fn.expand('%:p:h')
      require('telescope.builtin').find_files({
        cwd = current_file_dir,
      })
    end)
    vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
    vim.keymap.set('n', '<leader>fg', builtin.live_grep, {}) -- Requires ripgrep
    vim.keymap.set('n', '<leader>fb', builtin.buffers, {})
    vim.keymap.set('n', '<leader>fh', builtin.help_tags, {})
  end
}

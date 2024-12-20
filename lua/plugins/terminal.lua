return {
  {
    'akinsho/toggleterm.nvim',
    version = "*",
    config = function()
      require("toggleterm").setup{
        open_mapping = [[<c-S-t>]],
        direction = 'float',
        winbar = {
          enabled = false,
          name_formatter = function(term) --  term: Terminal
            return term.name
          end
        },
      }
      local Terminal = require('toggleterm.terminal').Terminal
      local term = Terminal:new({
        cmd = "bash --rcfile ~/.bashrc -i -c 'source ~/.bashrc && aichat'",
        direction = "float",
        hidden = true
      })
      vim.keymap.set("n", "<leader>ai", function()
       term:toggle()
      end, { desc = "Toggle terminal" })
    end
  }
}

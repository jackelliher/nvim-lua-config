return {
  {
    'akinsho/toggleterm.nvim',
    version = "*",
    config = function()

      if vim.fn.has('win32') == 1 then
        vim.cmd("let &shell = 'powershell'")
        vim.cmd(
          "let &shellcmdflag = '-NoLogo -NoProfile -ExecutionPolicy RemoteSigned -Command [Console]::InputEncoding=[Console]::OutputEncoding=[System.Text.Encoding]::UTF8;'")
        vim.cmd("let &shellredir = '2>&1 | Out-File -Encoding UTF8 %s; exit $LastExitCode'")
        vim.cmd("let &shellpipe = '2>&1 | Out-File -Encoding UTF8 %s; exit $LastExitCode'")
        vim.cmd("set shellquote= shellxquote=")
        vim.cmd("set shellquote= shellxquote=")
      end

      require("toggleterm").setup {
        size = 10,
        hide_numbers = true,
        shade_filetypes = {},
        shade_terminals = true,
        shading_factor = 2,
        start_in_insert = true,
        insert_mappings = true,
        persist_size = true,
        close_on_exit = true,
        direction = 'float',
        float_opts = {
          border = "curved",
          winblend = 0,
          highlights = {
            border = "Normal",
            background = "Normal"
          }
        },
        open_mapping = [[<c-S-t>]],
        winbar = {
          enabled = false,
          name_formatter = function(term)
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

      local claudeTerm = Terminal:new({
        cmd = "bash --rcfile ~/.bashrc -i -c 'source ~/.bashrc && claude'",
        direction = "float",
        hidden = true
      })

      vim.keymap.set("n", "<leader>cla", function()
        claudeTerm:toggle()
      end, { desc = "Toggle terminal" })

      -- Define the terminal instance
      local yipyapCli = Terminal:new({
        cmd = "bash --rcfile ~/.bashrc -i -c 'source ~/.bashrc && yipyap'",
        float_opts = {
          border = "curved",
          width = 80,
          height = 20,
        },
        direction = "float",
        hidden = true
      })

      -- Set keybinding
      vim.keymap.set("n", "<leader>yy", function()
        yipyapCli:toggle()
      end)
    end
  }
}

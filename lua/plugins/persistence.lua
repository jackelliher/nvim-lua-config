return {
  "olimorris/persisted.nvim",
  config = function()
    require("persisted").setup({
      save_dir = vim.fn.expand(vim.fn.stdpath("data") .. "/sessions/"),
      autoload = true,      -- auto load last session
      autosave = true,      -- auto save session
    })

    -- Keymaps
    vim.keymap.set("n", "<leader>ss", ":SessionSave<CR>")
    vim.keymap.set("n", "<leader>sl", ":SessionLoad<CR>")
    vim.keymap.set("n", "<leader>sd", ":SessionDelete<CR>")
  end
}


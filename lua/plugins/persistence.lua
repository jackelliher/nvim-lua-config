return {
  "olimorris/persisted.nvim",
  config = function()
    require("persisted").setup({
      save_dir = vim.fn.expand(vim.fn.stdpath("data") .. "/sessions/"),
      autoload = true,      -- auto load last session
      autosave = false,      -- auto save session
    })

    -- Keymaps
    vim.keymap.set("n", "<leader>sf", ":SessionSelect<CR>")
    vim.keymap.set("n", "<leader>st", ":SessionToggle<CR>")
    vim.keymap.set("n", "<leader>ss", ":SessionSave<CR>")
    vim.keymap.set("n", "<leader>sl", ":SessionLoad<CR>")
    vim.keymap.set("n", "<leader>sd", ":SessionDelete<CR>")
  end
}


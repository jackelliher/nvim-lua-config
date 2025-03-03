return {
  "olimorris/persisted.nvim",
  config = function()
    local session_dir = vim.fn.expand(vim.fn.stdpath("data") .. "/sessions/")
    require("persisted").setup({
      save_dir = session_dir,
      autoload = false,      -- auto load last session
      autosave = false,      -- auto save session
    })

    -- Keymaps
    vim.keymap.set("n", "<leader>show", function() vim.notify(session_dir) end)
    vim.keymap.set("n", "<leader>sf", ":SessionSelect<CR>")
    vim.keymap.set("n", "<leader>st", ":SessionToggle<CR>")
    vim.keymap.set("n", "<leader>ss", ":SessionSave<CR>")
    vim.keymap.set("n", "<leader>sl", ":SessionLoad<CR>")
    vim.keymap.set("n", "<leader>sd", ":SessionDelete<CR>")
  end
}


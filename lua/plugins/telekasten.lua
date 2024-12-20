return {
    "renerocksai/telekasten.nvim",
    dependencies = { "nvim-telescope/telescope.nvim" },
    config = function()
        require('telekasten').setup({
            home = vim.fn.expand("~/notes"), -- Put notes in ~/notes
        })

        -- Keymaps
        vim.keymap.set("n", "<leader>zn", "<cmd>Telekasten new_note<CR>",
            { desc = "New Note" })
        vim.keymap.set("n", "<leader>zf", "<cmd>Telekasten find_notes<CR>",
            { desc = "Find Notes" })
        vim.keymap.set("n", "<leader>zg", "<cmd>Telekasten search_notes<CR>",
            { desc = "Search Notes" })
        vim.keymap.set("n", "<leader>zt", "<cmd>Telekasten goto_today<CR>",
            { desc = "Today's Note" })
    end,
}

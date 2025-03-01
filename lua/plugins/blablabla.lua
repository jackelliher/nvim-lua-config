return {
  dir = vim.fn.stdpath("config") .. "/lua/blablabla",
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
  keys = {
    {
      "<leader>bbb",
      function()
        require("blablabla").Comment()
      end,
      mode = "v"
    }
  }
}

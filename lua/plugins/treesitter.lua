return {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  config = function()
    require("nvim-treesitter.configs").setup({
      ensure_installed = {
        "lua",
        "typescript",
        "javascript",
        "python",
        "rust",
        "go",
        "html",
        "css",
        "json",
        "yaml",
        "markdown",
        "bash",
        "regex",
      },

      -- Install parsers synchronously
      sync_install = false,
      auto_install = true,

      -- Basic Features
      highlight = {
        enable = true,
        additional_vim_regex_highlighting = false,
        -- disable slow treesitter highlight for large files
        disable = function(_, buf)
          local max_filesize = 100 * 1024   -- 100 KB
          local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
          if ok and stats and stats.size > max_filesize then
            return true
          end
        end,
      },

      -- Enable autotagging (w/ nvim-ts-autotag plugin)
      autotag = {
        enable = true,
      },

      -- Enable rainbow parentheses (w/ nvim-ts-rainbow plugin)
      rainbow = {
        enable = true,
        extended_mode = true,
        max_file_lines = nil,
      },

      -- Enable code context (w/ nvim-treesitter-context plugin)
      context_commentstring = {
        enable = true,
        enable_autocmd = false,
      },
    })
  end
}

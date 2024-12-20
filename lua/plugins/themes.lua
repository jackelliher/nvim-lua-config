return {
  "folke/tokyonight.nvim",
  lazy = false,
  priority = 1000,
  config = function()
    require("tokyonight").setup({
      on_highlights = function(hl, c)
        -- Create custom highlights for active/inactive windows
        hl.ActiveWindow = {
          bg = c.bg -- use the theme's background color for active window
        }
        hl.InactiveWindow = {
          bg = c.bg_dark -- use the theme's darker background for inactive windows
        }
      end,
      style = "storm", -- storm, night, moon, or day
      transparent = false, -- true for transparent background
      terminal_colors = true,
      styles = {
        comments = { italic = true },
        keywords = { italic = true },
        sidebars = "dark",
        floats = "dark",
      },
    })
    vim.cmd([[colorscheme tokyonight]])
    -- Set up the window highlighting
    vim.api.nvim_create_autocmd("WinEnter", {
      callback = function()
        vim.opt_local.winhighlight = "Normal:ActiveWindow,NormalNC:InactiveWindow"
      end
    })
  end,
}

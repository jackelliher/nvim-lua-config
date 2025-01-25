---@meta

vim = vim

-- Get full Neovim Lua API type definitions
local types = require("lua-dev").setup({
    lspconfig = {
        settings = {
            Lua = {
                runtime = {
                    version = 'LuaJIT'
                },
                completion = {
                    callSnippet = "Replace"
                },
                workspace = {
                    checkThirdParty = false,
                    library = vim.api.nvim_get_runtime_file("", true)
                }
            }
        }
    }
})

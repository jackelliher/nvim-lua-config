return {
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "L3MON4D3/LuaSnip",
      "saadparwaiz1/cmp_luasnip",
      "hrsh7th/cmp-vsnip",
      "hrsh7th/vim-vsnip",
    },
    config = function()
      local cmp = require("cmp")
      local luasnip = require("luasnip")

      -- Load friendly-snippets
      require("luasnip.loaders.from_vscode").lazy_load()
      cmp.setup({
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        mapping = cmp.mapping.preset.insert({
          ['<C-b>'] = cmp.mapping.scroll_docs(-4),
          ['<C-f>'] = cmp.mapping.scroll_docs(4),
          ['<C-Space>'] = cmp.mapping.complete(),
          ['<CR>'] = cmp.mapping.confirm({ select = true }),
        }),
        sources = cmp.config.sources({
          { name = 'nvim_lsp' },
          { name = 'luasnip' },
        }),
      })
      vim.keymap.set({ "i" }, "<C-K>", function() luasnip.expand() end, { silent = true })
      vim.keymap.set({ "i", "s" }, "<C-L>", function() luasnip.jump(1) end, { silent = true })
      vim.keymap.set({ "i", "s" }, "<C-J>", function() luasnip.jump(-1) end, { silent = true })

      vim.keymap.set({ "i", "s" }, "<C-E>", function()
        if luasnip.choice_active() then
          luasnip.change_choice(1)
        end
      end, { silent = true })
    end,
  },
  {
    "dsznajder/vscode-es7-javascript-react-snippets",
    dependencies = {
      "L3MON4D3/LuaSnip"
    }
  },
  {
    "nanotee/sqls.nvim",
    config = function()
      require("lspconfig").sqls.setup {}
    end
  },
  {
    "folke/neodev.nvim",
    config = function()
      require("neodev").setup({})
    end,
    ft = "lua",
    priority = 100,
    opts = {
      -- Enable type information and completion for Neovim Lua API
      library = {
        enabled = true,
        runtime = true,
        types = true,
        plugins = true,
      },
      setup_jsonls = true, -- Configure jsonls to get settings completion
      lspconfig = true,    -- Configure lua-language-server for neovim config development
      pathStrict = true,   -- Only load library for .nvim.lua files
    },
  },
  {
    "L3MON4D3/LuaSnip",
    dependencies = {
      "rafamadriz/friendly-snippets",
      build = "make install_jsregexp"
    },
    config = function()
      local luasnip = require('luasnip')
      vim.keymap.set({ "i", "s" }, "<C-k>", function()
        if luasnip.expand_or_jumpable() then
          luasnip.expand_or_jump()
        end
      end)

      vim.keymap.set({ "i", "s" }, "<C-j>", function()
        if luasnip.jumpable(-1) then
          luasnip.jump(-1)
        end
      end)
    end
  },
  {
    "williamboman/mason.nvim",
    config = function()
      require("mason").setup {}
    end
  },
  {
    "jay-babu/mason-null-ls.nvim",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "williamboman/mason.nvim",
      "nvimtools/none-ls.nvim",
    },
    config = function()
      require("mason-null-ls").setup({
        automatic_setup = true,
        ensure_installed = {
          "prettier",
          "stylua"
        },
        handlers = {},
      })

      local null_ls = require("null-ls")
      null_ls.setup({
        sources = {
          null_ls.builtins.formatting.stylua,
          null_ls.builtins.formatting.prettier,
        }
      })
    end,
  },
  {
    "williamboman/mason-lspconfig.nvim",
    config = function()
      local mslp = require("mason-lspconfig")
      mslp.setup {
        ensure_installed = {
          "cssls",
          "tailwindcss",
          "lua_ls",
          "pyright",
          "ts_ls",
        }
      }
      mslp.setup_handlers({
        function(server_name)
          require("lspconfig")[server_name].setup {}
        end
      })
    end
  },
  {
    "neovim/nvim-lspconfig",
    config = function()
      local lspconfig = require('lspconfig')
      lspconfig.lua_ls.setup({
        settings = {
          Lua = {
            runtime = {
              -- Tell the language server which version of Lua you're using
              version = 'LuaJIT',
            },
            diagnostics = {
              -- Get the language server to recognize the `vim` global
              globals = { 'vim' },
            },
            workspace = {
              -- Make the server aware of Neovim runtime files
              library = vim.api.nvim_get_runtime_file("", true),
              checkThirdParty = false, -- Disable third party checking
            },
            -- Do not send telemetry data
            telemetry = {
              enable = false,
            },
          },
        },
        capabilities = require('cmp_nvim_lsp').default_capabilities(),
      })
      vim.keymap.set('n', 'gd', vim.lsp.buf.definition)
      vim.keymap.set('n', 'K', vim.lsp.buf.hover)
      vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename)
      vim.keymap.set({ 'v', 'n' }, '<leader>f', vim.lsp.buf.format)
      vim.keymap.set('n', 'gl', vim.diagnostic.open_float)
      vim.keymap.set('n', '[d', vim.diagnostic.goto_prev)
      vim.keymap.set('n', ']d', vim.diagnostic.goto_next)
      vim.keymap.set({ 'n', 'v' }, '<leader>ca', vim.lsp.buf.code_action)
      vim.keymap.set('n', 'K', vim.lsp.buf.hover)
      vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help)
    end
  }
}

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
          ["<C-b>"] = cmp.mapping.scroll_docs(-4),
          ["<C-f>"] = cmp.mapping.scroll_docs(4),
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<CR>"] = cmp.mapping.confirm({ select = true }),
        }),
        sources = cmp.config.sources({
          { name = "nvim_lsp" },
          { name = "luasnip" },
        }),
      })
      vim.keymap.set({ "i" }, "<C-K>", function()
        luasnip.expand()
      end, { silent = true })
      vim.keymap.set({ "i", "s" }, "<C-L>", function()
        luasnip.jump(1)
      end, { silent = true })
      vim.keymap.set({ "i", "s" }, "<C-J>", function()
        luasnip.jump(-1)
      end, { silent = true })

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
      "L3MON4D3/LuaSnip",
    },
  },
  {
    "nanotee/sqls.nvim",
    config = function()
      require("lspconfig").sqls.setup({})
    end,
  },
  {
    "folke/lazydev.nvim",
    ft = "lua", -- only load on lua files
    opts = {
      library = {
        -- Load luvit types when the `vim.uv` word is found
        { path = "${3rd}/luv/library", words = { "vim%.uv" } },
      },
    },
  },
  {
    "L3MON4D3/LuaSnip",
    dependencies = {
      "rafamadriz/friendly-snippets",
      build = "make install_jsregexp",
    },
    config = function()
      local luasnip = require("luasnip")
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
    end,
  },
  "williamboman/mason.nvim",
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
          "stylua",
        },
        handlers = {},
        automatic_installation = true,
      })

      local null_ls = require("null-ls")
      null_ls.setup({
        sources = {
          null_ls.builtins.formatting.stylua,
          null_ls.builtins.formatting.prettier,
        },
      })
    end,
  },
  {
    "williamboman/mason-lspconfig.nvim",
    config = function()
      require("mason-lspconfig")
    end,
  },
  {
    "Hoffs/omnisharp-extended-lsp.nvim",
    lazy = true,
  },
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        omnisharp = {},
      },
      setup = {
        omnisharp = function(_, _)
          require("lazyvim.util").on_attach(function(client, _)
            if client.name == "omnisharp" then
              ---@type string[]
              local tokenModifiers =
                  client.server_capabilities.semanticTokensProvider.legend.tokenModifiers
              for i, v in ipairs(tokenModifiers) do
                tokenModifiers[i] = v:gsub(" ", "_")
             end
              ---@type string[]
              local tokenTypes = client.server_capabilities.semanticTokensProvider.legend.tokenTypes
              for i, v in ipairs(tokenTypes) do
                tokenTypes[i] = v:gsub(" ", "_")
              end
            end
          end)
        end,
      },
    },
    config = function()
      local lspconfig = require("lspconfig")
      local mason = require("mason")
      local masonlsp = require("mason-lspconfig")

      mason.setup()
      masonlsp.setup({
        automatic_installation = true,
        ensure_installed = {
          "cssls",
          "tailwindcss",
          "lua_ls",
          "pyright",
          "ts_ls",
          "rust_analyzer",
          "omnisharp",
        },
      })

      masonlsp.setup_handlers({
        function(server_name)
          require("lspconfig")[server_name].setup({
            capabilities = require("cmp_nvim_lsp").default_capabilities(),
            -- Default keymaps for all servers
            on_attach = function(_, bufnr)
              vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, { buffer = bufnr })
              vim.keymap.set("n", "gd", vim.lsp.buf.definition, { buffer = bufnr })
              vim.keymap.set("n", "gr", vim.lsp.buf.references, { buffer = bufnr })
            end,
          })
        end,
      })

      lspconfig.lua_ls.setup({
        settings = {
          Lua = {
            runtime = {
              -- Tell the language server which version of Lua you're using
              version = "LuaJIT",
            },
            diagnostics = {
              -- Get the language server to recognize the `vim` global
              globals = { "vim" },
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
        capabilities = require("cmp_nvim_lsp").default_capabilities(),
      })

      local capabilities = require("cmp_nvim_lsp").default_capabilities()

      lspconfig.ts_ls.setup({
        capabilities = capabilities,
      })

      -- C# LSP configuration
      lspconfig.omnisharp.setup({
        capabilities = capabilities,
        enable_roslyn_analyzers = true,
        enable_import_completion = true,
        organize_imports_on_format = true,
        enable_decompilation_support = true,
        handlers = {
          ["textDocument/definition"] = require("omnisharp_extended").handler,
        },
        settings = {
          omnisharp = {
            useModernNet = true,
            enableRoslynAnalyzers = true,
            enableImportCompletion = true,
            organizeImportsOnFormat = true,
            enableDecompilationSupport = true,
          },
        },
      })

      -- Keymaps
      vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, { desc = "Rename symbol under cursor" })
      vim.keymap.set("n", "gd", vim.lsp.buf.definition, { desc = "Go to definition" })
      vim.keymap.set("n", "gr", vim.lsp.buf.references, { desc = "Show references" })
      vim.keymap.set("n", "gd", vim.lsp.buf.definition, { desc = "Go to definition" })
      vim.keymap.set("n", "gD", vim.lsp.buf.type_definition, { desc = "Go to definition" })
      vim.keymap.set("n", "K", vim.lsp.buf.hover, { desc = "Show hover documentation" })
      vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, { desc = "Rename symbol under cursor" })
      vim.keymap.set({ "v", "n" }, "<leader>f", vim.lsp.buf.format, { desc = "Format document" })
      vim.keymap.set("n", "gl", vim.diagnostic.open_float, { desc = "Show diagnostics in floating window" })
      vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, { desc = "Show code actions" })
      vim.keymap.set("n", "K", vim.lsp.buf.hover, { desc = "Show hover documentation" })
      vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, { desc = "Show signature help" })
      vim.keymap.set("n", "gi", vim.lsp.buf.implementation, { desc = "Show signature help" })
    end,
  },
}

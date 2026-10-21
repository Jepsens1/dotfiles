return {
    "neovim/nvim-lspconfig",
    dependencies = {
        "saghen/blink.cmp",
        "mason-org/mason.nvim",
        "mason-org/mason-lspconfig.nvim",
        "nvim-telescope/telescope.nvim",
    },
    config = function()
        vim.diagnostic.config({
            virtual_text = true,
        })

        -- Recognize the `vim` global in Neovim config.
        vim.lsp.config("lua_ls", {
            settings = {
                Lua = {
                    diagnostics = {
                        globals = { "vim" },
                    },
                    workspace = {
                        library = { vim.env.VIMRUNTIME },
                        checkThirdParty = false,
                    },
                },
            },
        })
        vim.lsp.config("roslyn_ls", {
            cmd_env = {
                DOTNET_ROOT = vim.fn.expand("~/.local/share/mise/dotnet-root"),
            },
        })

        require("mason-lspconfig").setup({
            ensure_installed = {
                "lua_ls",
                "roslyn_ls",
                "clangd",
                "pyright",
                "gopls",
                "ts_ls",
                "ruby_lsp",
                "html",
                "jsonls",
                "cssls",
                "yamlls",
                "bashls",
            },
        })

        local builtin = require("telescope.builtin")
        local map = function(mode, keys, func, desc)
            vim.keymap.set(mode, keys, func, { desc = desc })
        end

        map("n", "K", vim.lsp.buf.hover, "Hover")
        map("n", "gd", builtin.lsp_definitions, "Go to definition")
        map("n", "gD", vim.lsp.buf.declaration, "Go to declaration")
        map("n", "grn", vim.lsp.buf.rename, "Rename symbol")
        map({ "n", "x" }, "gra", vim.lsp.buf.code_action, "Code action")
        map("n", "grr", builtin.lsp_references, "References")
        map("n", "gri", builtin.lsp_implementations, "Implementation")
        map("n", "grt", builtin.lsp_type_definitions, "Type definition")
        map("n", "gO", builtin.lsp_document_symbols, "Symbols in this file")
        map({ "i", "s" }, "<C-s>", vim.lsp.buf.signature_help, "Signature help")
    end,
}

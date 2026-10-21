return {
    "stevearc/conform.nvim",
    event = "BufWritePre",
    dependencies = { "mason-org/mason.nvim" },
    opts = {
        formatters_by_ft = {
            lua = { "stylua" },
            python = { "ruff_format" },
            javascript = { "prettierd", "prettier", stop_after_first = true },
            typescript = { "prettierd", "prettier", stop_after_first = true },
            typescriptreact = { "prettierd", "prettier", stop_after_first = true },
            css = { "prettier" },
            json = { "prettier" },
            yaml = { "prettier" },
            markdown = { "prettier" },
            c = { "clang-format" },
            cpp = { "clang-format" },
            cs = { "csharpier" },
            sh = { "shfmt" },
            bash = { "shfmt" },
            go = { "gofmt" },
        },
        format_on_save = {
            lsp_format = "fallback",
            timeout_ms = 1000,
        },
    },
}

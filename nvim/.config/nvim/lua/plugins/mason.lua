return {
    "mason-org/mason.nvim",
    lazy = false,
    opts = {
        ui = {
            icons = {
                package_installed = "✓",
                package_pending = "➜",
                package_uninstalled = "✗",
            },
        },
    },
    keys = {
        { "<leader>m", "<cmd>Mason<cr>", desc = "Open Mason" },
    },
}

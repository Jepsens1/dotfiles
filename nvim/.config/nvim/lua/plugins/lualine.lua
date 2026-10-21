return {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {
        options = {
            theme = "auto",
        },
        sections = {
            lualine_b = {
                "branch",
                {
                    "diff",
                    source = function()
                        local gs = vim.b.gitsigns_status_dict
                        if gs then
                            return {
                                added = gs.added,
                                modified = gs.changed,
                                removed = gs.removed,
                            }
                        end
                    end,
                },
                "diagnostics",
            },
            lualine_c = {
                {
                    "filename",
                    path = 1,
                },
            },
            lualine_x = { "lsp_status", "filetype" },
            lualine_y = { "searchcount", "selectioncount", "progress" },
        },
        extensions = { "nvim-tree" },
    },
}

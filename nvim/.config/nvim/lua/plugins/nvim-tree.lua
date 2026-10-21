return {
    "nvim-tree/nvim-tree.lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {
        filters = {
            dotfiles = false,
        },
        update_focused_file = {
            enable = true,
        },
    },
    keys = {
        { "<leader>e", "<cmd>NvimTreeToggle<cr>", desc = "Toggle file tree" },
    },
    cmd = { "NvimTreeToggle", "NvimTreeOpen" },
}

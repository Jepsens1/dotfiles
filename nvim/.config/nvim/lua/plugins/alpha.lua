return {
    "goolord/alpha-nvim",
    event = "VimEnter",
    config = function()
        local dashboard = require("alpha.themes.dashboard")
        local header = vim.fn.system({ "figlet", "-f", "slant", "-w", "80", "Neovim" })
        dashboard.section.header.val = vim.split(header, "\n", { trimempty = true })
        dashboard.section.header.opts.hl = "Title"
        dashboard.section.buttons.val = {
            dashboard.button("f", "Find file", "<cmd>Telescope find_files<cr>"),
            dashboard.button("g", "Live grep", "<cmd>Telescope live_grep<cr>"),
            dashboard.button("r", "Recent files", "<cmd>Telescope oldfiles<cr>"),
            dashboard.button("e", "File tree", "<cmd>NvimTreeToggle<cr>"),
            dashboard.button("q", "Quit", "<cmd>qa<cr>"),
        }
        require("alpha").setup(dashboard.config)
    end,
}

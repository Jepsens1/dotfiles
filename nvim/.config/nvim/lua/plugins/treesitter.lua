return {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    lazy = false,
    build = ":TSUpdate",
    config = function()
        local ts = require("nvim-treesitter")
        ts.install({
            "c",
            "c_sharp",
            "lua",
            "vim",
            "vimdoc",
            "query",
            "markdown",
            "markdown_inline",
            "python",
            "json",
            "yaml",
            "bash",
            "cpp",
            "css",
            "go",
            "hcl",
            "html",
            "javascript",
            "powershell",
            "ruby",
            "xml",
        })

        vim.api.nvim_create_autocmd("FileType", {
            group = vim.api.nvim_create_augroup("treesitter-start", { clear = true }),
            callback = function(args)
                local lang = vim.treesitter.language.get_lang(args.match)
                if not lang then
                    return
                end

                if not vim.tbl_contains(ts.get_installed("parsers"), lang) then
                    if vim.tbl_contains(ts.get_available(), lang) then
                        ts.install(lang):await(function(err, installed)
                            if err or not installed then
                                return
                            end

                            if vim.api.nvim_buf_is_valid(args.buf) and vim.bo[args.buf].filetype == args.match then
                                vim.treesitter.start(args.buf, lang)
                            end
                        end)
                    end
                    return
                end

                vim.treesitter.start(args.buf, lang)
            end,
        })
    end,
}

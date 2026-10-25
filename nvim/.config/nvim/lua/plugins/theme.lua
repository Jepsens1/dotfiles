local pointer = vim.fn.expand("~/.cache/theme/neovim-spec")
local spec_path

if vim.fn.filereadable(pointer) == 1 then
    spec_path = vim.fn.readfile(pointer)[1]
end

if spec_path == nil or spec_path == "" or vim.fn.filereadable(spec_path) ~= 1 then
    spec_path = vim.fn.expand("~/.config/theme/themes/tokyo-night/neovim.lua")
end

return dofile(spec_path)

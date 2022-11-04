-- Styles   =================================================================================
local my = {}

my.setup_highlight = function()
    local palette = vim.g.momiji_palette
    local highlight = vim.fn["MomijiHighlight"]
    highlight("TelescopeSelection", { fg = palette.black, bg = palette.blue })
    highlight("TelescopeMultiSelection", { fg = palette.black, bg = palette.lightblue })
    highlight("TelescopeMatching", { fg = palette.lightyellow })
end

if vim.g.colors_name == "momiji" then
    my.setup_highlight()
else
    local group = vim.api.nvim_create_augroup("local-with-telescope-style", { clear = true })
    vim.api.nvim_create_autocmd("ColorScheme", {
        pattern = "momiji",
        once = true,
        group = group,
        callback = my.setup_highlight,
    })
end

return my

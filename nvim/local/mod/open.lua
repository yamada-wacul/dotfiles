vim.keymap.set("n", "gx", function()
    require("local.mod.open").open()
end, { silent = true, desc = "Open files or urls under the cursor" })

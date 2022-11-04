local cwd = require("local.mod.cwd")
cwd:setup({
    hooks = {
        ["wcl48"] = {
            match = function(self, fullpath)
                return string.match(fullpath, "/wcl48/") ~= nil
            end,
            enter = function(self, _)
            end,
            leave = function(self, _)
            end,
        },
    },
})

# cwd.nvim

NeovimのCWDに基づく処理を実行する。
enter, leaveの2種類の処理をサポートする。

## usage

### setup

最初に呼ばないといけないやつ。

```lua
local cwd = require("local.mod.cwd")
cwd:setup({
    suspend_hook_on_setup = false,
    hooks = {
        ["hook-key-1"] = {
            ... -- set hook の cwd.set の <body> と同じ内容
        },
    },
})
```

### set hook

hookを新しく追加したり、追加したhookを差し替えたり（keyで管理されている）したいときはこれ。

```lua
local cwd = require("local.mod.cwd")

-- cwd.set(<key>, <body>)
cwd:set("hook-key-2", {
    -- 対象ディレクトリの指定は、match 関数で判定する
    match = function(self, fullpath)
        return fullpath:sub(-7) == "foo/bar"
    end,

    -- UNDONE: scope = ['global'], -- buffer, window, tabpage or global

    -- 条件に合致したときに実行する関数
    enter = function(self, fullpath)
        self.old_tabstop = vim.o.tabstop
        self.old_shiftwidth = vim.o.shiftwidth
        vim.o.tabstop = 4
        vim.o.shiftwidth = 4
    end,

    -- 条件に合致しなくなったときに実行する関数
    leave = function(self, fullpath)
        vim.o.tabstop = self.old_tabstop
        vim.o.shiftwidth = self.old_shiftwidth
    end,
})
```

### others

その他。

```lua
local cwd = require("local.mod.cwd")
cwd:del("hook-key-x") -- 指定のhookを消す
cwd:clear() -- hook全部消す
cwd:list() -- hook全部取得する
```

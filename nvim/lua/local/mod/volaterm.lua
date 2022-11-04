local M = {}

local function open_volaterm(opts)
    opts = vim.tbl_extend("keep", opts or vim.empty_dict(), {
        exec = vim.o.shell,
    })
    local bufnr = vim.api.nvim_get_current_buf()
    vim.b[bufnr].volaterm = 1
    vim.b[bufnr].volaterm_mode = "t"
    opts = vim.tbl_extend("force", opts, {
        on_exit = function()
            vim.api.nvim_buf_delete(bufnr, { force = true, unload = true })
        end,
    })
    -- 終了時にバッファを消すterminalを開く
    vim.fn.termopen(opts.exec, opts)
end

function M.open(opts)
    if require("local.lib.initbuf").current() then
        vim.cmd("enew")
    end
    open_volaterm(opts)
end

function M.split(size, mods, opts)
    -- 指定方向に画面分割
    vim.cmd(mods .. " " .. "new")
    open_volaterm(opts)
    -- 指定方向にresize
    if size ~= 0 then
        vim.cmd(mods .. " resize " .. size)
    end
end

function M.save_mode()
    if vim.b.volaterm == 1 then
        vim.b.volaterm_mode = vim.fn.mode()
        vim.cmd("stopinsert")
    end
end

function M.restore_mode()
    if vim.b.volaterm == 1 and vim.b.volaterm_mode == "t" then
        vim.cmd("startinsert")
    end
end

return M

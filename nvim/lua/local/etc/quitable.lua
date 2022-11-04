-- 空のバッファはquit時に自動で閉じる
local wipeout_queue = {}

local function enqueue()
    if require("local.lib.initbuf").current() then
        table.insert(wipeout_queue, vim.api.nvim_get_current_buf())
    end
end

local M = {}

function M.quit_empty_buffers()
    wipeout_queue = {}
    local cur = vim.fn.bufnr()
    for _, b in ipairs(vim.api.nvim_list_bufs()) do
        vim.api.nvim_buf_call(b, enqueue)
    end
    vim.cmd("buffer!" .. cur)

    for _, b in ipairs(wipeout_queue) do
        vim.cmd(b .. "bwipeout!")
    end
end

return M

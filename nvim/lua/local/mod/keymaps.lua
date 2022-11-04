local attrs = { "buffer", "expr", "nowait", "script", "silent" }
local fields = { "cmd", "attr", "lhs", "rhs" }
local lens = vim.tbl_map(function(f)
    return "l_" .. f
end, fields)

local S = {}

S.cmd = function(m)
    if m.noremap == 1 then
        return m.mode .. "noremap"
    end
    return m.mode .. "map    "
end

local function has_attr(m, attr)
    return m[attr] == 1
end

S.attr = function(_)
    local livings = vim.tbl_filter(has_attr, attrs)
    if #livings > 0 then
        return "<" .. table.concat(livings, "> <") .. ">"
    end
    return ""
end

S.lhs = function(m)
    return m.lhs
end

S.rhs = function(m)
    local rhs = m.rhs
    if rhs == nil or rhs == "" then
        return "<Nop>"
    end
    return rhs
end

local function fold(fn, list, init)
    local memo = init
    for _, v in ipairs(list) do
        memo = fn(memo, v)
    end
    return memo
end

local function assign(x, y)
    return vim.tbl_extend("force", x, y)
end

local function map_object(m)
    return fold(
        assign,
        vim.tbl_map(
            function(pair)
                return vim.tbl_extend("force", pair, { [pair.k] = pair.v, ["l_" .. pair.k] = string.len(pair.v) })
            end,
            vim.tbl_map(function(f)
                return vim.tbl_extend("force", m, { k = f, v = S[f](m) })
            end, fields)
        ),
        vim.empty_dict()
    )
end

local function filter_prefix(maps, prefix)
    local l_prefix = string.len(prefix)
    return vim.tbl_filter(function(m)
        return string.sub(m.lhs, 1, l_prefix) ~= prefix
    end, maps)
end

local function filter_plugmap(maps)
    return filter_prefix(maps, "<Plug>")
end

local function filter_snrmap(maps)
    return filter_prefix(maps, "<SNR>")
end

local function init_maxs()
    return fold(
        assign,
        vim.tbl_map(function(l)
            return { [l] = 0 }
        end, lens),
        vim.empty_dict()
    )
end

local M = {}

--- Get map informations
-- @params ... The target mode in any of '', 'n', 'v', 'x', 's', 'o', 'i', 'l', 'c', 't'.
-- @return A list of the keymap information.
-- @usage local keymap_list = m.get_keymaps('n', 'i', 'o')
M.get_keymaps = function(...)
    local maps = fold(
        assign,
        vim.tbl_map(function(mode)
            local maps = vim.api.nvim_get_keymap(mode)
            maps = filter_plugmap(maps)
            maps = filter_snrmap(maps)
            return maps
        end, { ... }),
        {}
    )
    local maxs = init_maxs()
    return vim.tbl_map(function(m)
        local obj = map_object(m)
        maxs = fold(function(memo, l)
            if obj[l] > memo[l] then
                memo[l] = obj[l]
            end
            return memo
        end, lens, maxs)
        function obj:cmdstring()
            return table.concat(
                vim.tbl_map(
                    function(f)
                        local lf = "l_" .. f
                        return self[f] .. string.rep(" ", maxs[lf] - self[lf])
                    end,
                    vim.tbl_filter(function(f)
                        return maxs["l_" .. f] > 0
                    end, fields)
                ),
                " "
            )
        end
        return obj
    end, maps)
end

M.show_keymaps = function(...)
    local maps = M.get_keymaps(...)
    local lines = {}
    for _, m in pairs(maps) do
        table.insert(lines, m:cmdstring())
    end

    local buf = vim.api.nvim_create_buf(false, true)
    vim.bo[buf].filetype = "vim"
    vim.bo[buf].buftype = "nofile"
    vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
    local win = vim.api.nvim_open_win(buf, true, {
        relative = "editor",
        anchor = "NW",
        width = vim.o.columns,
        height = vim.o.lines - 2,
        row = 0,
        col = 0,
        focusable = true,
        style = "minimal",
    })
    vim.wo[win].winhighlight = "Normal:Normal,NormalNC:Normal"
end

M.show_keymaps_func = function(...)
    local args = ...
    return function()
        M.show_keymaps(args)
    end
end

return M

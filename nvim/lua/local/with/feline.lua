local feline = require("feline")

local modeTexts = {
    n = "\u{E7C5}  ",
    no = "\u{E7C5}  ",
    i = "\u{FFAE6}  ",
    ic = "\u{FFAE6}  ",
    r = "\u{FF954}  ",
    rm = "\u{FF954}  ",
    ["r?"] = "\u{FF954}  ",
    v = "\u{FF761}  ",
    [""] = "\u{FF767}  ",
    V = "\u{FF760}  ",
    s = "\u{FFB51}  ",
    S = "\u{FFB51}  ",
    ["^S"] = "\u{FFB51}  ",
    R = "\u{FF954}  ",
    Rv = "\u{FF954}  ",
    c = "： ",
    cv = "： ",
    ce = "： ",
    t = "\u{F120}  ",
    ["!"] = "\u{F120}  ",
}

local modeColors = {}
local palette = {}

local function hlDark()
    local modeColor = modeColors[vim.fn.mode()]
    return { fg = palette.black, bg = modeColor.deep }
end

local function hlDarkSep()
    local modeColor = modeColors[vim.fn.mode()]
    return { fg = modeColor.deep, bg = modeColor.light }
end

local function hlLight()
    local modeColor = modeColors[vim.fn.mode()]
    return { fg = palette.black, bg = modeColor.light }
end

local function hlLightSep()
    local modeColor = modeColors[vim.fn.mode()]
    return { fg = palette.black, bg = modeColor.light }
end

local function hlLightTerm()
    local modeColor = modeColors[vim.fn.mode()]
    return { fg = modeColor.light, bg = palette.grayscale2 }
end

local M = {}

M.setup = function(newPalette)
    palette = newPalette
    modeColors = {
        n = { deep = palette.green, light = palette.lightgreen },
        no = { deep = palette.green, light = palette.lightgreen },
        i = { deep = palette.blue, light = palette.lightblue },
        ic = { deep = palette.blue, light = palette.lightblue },
        r = { deep = palette.cyan, light = palette.lightcyan },
        rm = { deep = palette.cyan, light = palette.lightcyan },
        ["r?"] = { deep = palette.cyan, light = palette.lightcyan },
        v = { deep = palette.yellow, light = palette.lightyellow },
        [""] = { deep = palette.yellow, light = palette.lightyellow },
        V = { deep = palette.yellow, light = palette.lightyellow },
        s = { deep = palette.magenta, light = palette.lightmagenta },
        S = { deep = palette.magenta, light = palette.lightmagenta },
        [""] = { deep = palette.magenta, light = palette.lightmagenta },
        R = { deep = palette.magenta, light = palette.lightmagenta },
        Rv = { deep = palette.magenta, light = palette.lightmagenta },
        c = { deep = palette.red, light = palette.lightred },
        cv = { deep = palette.red, light = palette.lightred },
        ce = { deep = palette.red, light = palette.lightred },
        ["!"] = { deep = palette.red, light = palette.lightred },
        t = { deep = palette.red, light = palette.lightred },
    }

    local active_left = {
        {
            -- モード
            provider = function()
                return "\u{00A0}" .. modeTexts[vim.fn.mode()]
            end,
            hl = hlDark,
            right_sep = {
                str = "\u{E0B0}\u{00A0}",
                hl = hlDarkSep,
            },
        },
        {
            -- 現在のディレクトリ名
            provider = function()
                return vim.fn.fnamemodify(vim.fn.getcwd(), ":t")
            end,
            hl = hlLight,
            right_sep = {
                str = "\u{00A0}\u{E0B1}",
                hl = hlLightSep,
            },
        },
        {
            -- バッファのファイル名
            enabled = function()
                -- バッファがファイルを開いているかどうか
                return vim.fn.empty(vim.fn.expand("%:t")) ~= 1
            end,
            provider = {
                name = "file_info",
                opts = {
                    colored_icon = false,
                    file_modified_icon = "",
                    type = "relative",
                },
            },
            hl = hlLight,
            left_sep = {
                str = " ",
                hl = hlLightSep,
            },
        },
        {
            -- 左の終端
            provider = " ",
            hl = hlLight,
            right_sep = {
                str = "\u{E0B0}\u{00A0}",
                hl = hlLightTerm,
            },
        },
    }
    local inactive_left = {
        {
            -- QuickFixのタイトル
            enabled = function()
                -- バッファがQuickfixかどうか
                return vim.bo.filetype == "qf"
            end,
            provider = function()
                local prof = vim.fn.getqflist({ title = true })
                local title = prof.title
                if title == ":setqflist()" then
                    return "Quickfix"
                else
                    return title
                end
            end,
            hl = { fg = palette.grayscale5, bg = palette.grayscale3 },
            left_sep = {
                str = " ",
                hl = { fg = palette.grayscale5, bg = palette.grayscale3 },
            },
        },
        {
            -- バッファのファイル名
            enabled = function()
                -- バッファがファイルを開いているかどうか
                return vim.fn.empty(vim.fn.expand("%:t")) ~= 1
            end,
            provider = {
                name = "file_info",
                opts = {
                    colored_icon = false,
                    file_modified_icon = "",
                    type = "relative",
                },
            },
            hl = { fg = palette.grayscale5, bg = palette.grayscale3 },
            left_sep = {
                str = " ",
                hl = { fg = palette.grayscale5, bg = palette.grayscale3 },
            },
        },
        {
            provider = " ",
            hl = { fg = palette.grayscale5, bg = palette.grayscale3 },
            right_sep = {
                str = "\u{E0B0}\u{00A0}",
                hl = { fg = palette.grayscale3, bg = palette.grayscale2 },
            },
        },
    }

    local active_mid = {}

    local active_right = {
        {
            provider = "diagnostic_hints",
            hl = { bg = palette.blue, fg = palette.black },
            right_sep = {
                str = " ",
                hl = { bg = palette.blue, fg = palette.black },
            },
        },
        {
            provider = "diagnostic_info",
            hl = { bg = palette.blue, fg = palette.black },
            right_sep = {
                str = " ",
                hl = { bg = palette.blue, fg = palette.black },
            },
        },
        {
            provider = "diagnostic_warnings",
            hl = { bg = palette.yellow, fg = palette.black },
            right_sep = {
                str = " ",
                hl = { bg = palette.yellow, fg = palette.black },
            },
        },
        {
            provider = "diagnostic_errors",
            hl = { bg = palette.red, fg = palette.black },
            right_sep = {
                str = " ",
                hl = { bg = palette.red, fg = palette.black },
            },
        },
    }
    local inactive_right = {}

    vim.opt.showmode = false -- feline で表示するので、vim標準のモード表示は隠す

    local components = {
        active = { active_left, active_mid, active_right },
        inactive = { inactive_left, inactive_right },
    }

    feline.setup({
        components = components,
        force_inactive = {
            filetypes = {
                "^NvimTree$",
                "^fern$",
                "^packer$",
                "^startify$",
                "^fugitive$",
                "^fugitiveblame$",
                "^qf$",
                "^help$",
            },
            buftypes = {},
            bufnames = {},
        },
    })
end

if vim.g.colors_name == "momiji" then
    M.setup(vim.g.momiji_colors)
else
    M.setup(require("local.etc.colors"))

    local group = vim.api.nvim_create_augroup("local-with-feline-color", { clear = true })
    vim.api.nvim_create_autocmd("ColorScheme", {
        pattern = "momiji",
        group = group,
        once = true,
        callback = function()
            M.setup(vim.g.momiji_colors)
        end,
    })
end

return M

local function set(self, key, opt)
    self.__runner[key] = opt
end

local function del(self, key)
    self.__runner[key] = nil
    self.__dweller[key] = nil
end

local function clear(self)
    self.__runner = {}
    self.__dweller = {}
end

local function list(self)
    return self.__runner
end

local function __hook(self, directory, handler)
    handler = handler or print
    local fullpath = vim.fn.fnamemodify(directory, ":p")
    for key, obj in pairs(self.__runner) do
        local leave = self.__dweller[key]
        if leave then
            if not obj:match(fullpath) then
                if obj.leave then
                    xpcall(function()
                        obj:leave(fullpath)
                    end, handler)
                end
                self.__dweller[key] = nil
            end
        elseif obj:match(fullpath) then
            if obj.enter then
                xpcall(function()
                    obj:enter(fullpath)
                end, handler)
            end
            self.__dweller[key] = true
        end
    end
end

local function setup(self, opts)
    opts = opts or {}
    self.__runner = opts.hooks or {}
    local group = vim.api.nvim_create_augroup("local-mod-cwd", { clear = true })
    vim.api.nvim_create_autocmd("DirChanged", {
        pattern = "global",
        group = group,
        callback = function()
            self:__hook((vim.v["event"] or {})["cwd"])
        end,
    })
    if not opts.suspend_hook_on_setup then
        self:__hook(vim.fn.getcwd())
    end
end

return {
    __runner = {},
    __dweller = {},
    __hook = __hook,
    set = set,
    del = del,
    clear = clear,
    list = list,
    setup = setup,
}

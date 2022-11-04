describe("Setting", function()
    it("repeat 'require'", function()
        local cwd1 = require("local.mod.cwd")
        assert.equals(0, vim.tbl_count(cwd1:list()))
        cwd1:set("key-1", {})
        assert.equals(1, vim.tbl_count(cwd1:list()))
        local cwd2 = require("local.mod.cwd")
        assert.equals(1, vim.tbl_count(cwd2:list()))
        cwd2:set("key-2", {})
        assert.equals(2, vim.tbl_count(cwd2:list()))
        local cwd3 = require("local.mod.cwd")
        assert.equals(2, vim.tbl_count(cwd2:list()))
        cwd3:del("key-1")
        assert.equals(1, vim.tbl_count(cwd3:list()))
    end)

    it("hook", function()
        local called = ""
        local cwd = require("local.mod.cwd")
        cwd:clear()
        cwd:set("key-1", {
            match = function(_, fullpath)
                return fullpath:sub(-9) == "test-path"
            end,
            enter = function(_, fullpath)
                called = fullpath:sub(-9)
            end,
            leave = function(_, _) end,
        })
        cwd:hook("test-path")
        cwd:hook("dummy-path")
        assert.equals("test-path", called)
    end)

    it("hook with error", function()
        local cwd = require("local.mod.cwd")
        cwd:clear()
        cwd:set("key-1", {
            ret = true,
            match = function(self, _)
                -- match first, and never
                local ret = self.ret
                self.ret = false
                return ret
            end,
            enter = function(_, _)
                error("dummy") -- raise error
            end,
            leave = function(_, _)
                error("dummy") -- raise error
            end,
        })

        local entered = false
        local leaved = false
        cwd:set("key-2", {
            ret = true,
            match = function(self, _)
                -- match first, and never
                local ret = self.ret
                self.ret = false
                return ret
            end,
            enter = function(_, _)
                entered = true
            end,
            leave = function(_, _)
                leaved = true
            end,
        })

        local errors_first = 0
        local errors_second = 0
        -- action 1:
        -- key-1 raises error on "enter" but ignored
        -- key-2 set "entered" to true
        cwd:hook("", function(_)
            errors_first = errors_first + 1
        end)

        -- action 2:
        -- key-1 raises error on "leave" but ignored
        -- key-2 set "leaved" to true
        cwd:hook("", function(_)
            errors_second = errors_second + 1
        end)

        assert.is_true(entered)
        assert.is_true(leaved)
        assert.equal(1, errors_first)
        assert.equal(1, errors_second)
    end)
end)

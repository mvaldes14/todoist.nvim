local M = {}

local api = require("todoist.api")
local config = require("todoist.config")

---Setup the configuration for the plugin
---@param opts TodoistConfig: The configuration for the plugin
M.setup = function(opts)
    config.set_config(opts)
end

M.show_tasks = function(opts)
    if config.token() then
        api.show_tasks(opts.args)
    end
end

M.add_tasks = function()
    if config.token() then
        api.create_task()
    end
end

M.pick_tasks = function(opts)
    if config.token() then
        api.find_task(opts.args)
    end
end

return M

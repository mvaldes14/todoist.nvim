local M = {}

local api = require("todoist.api")
local config = require("todoist.config")

---Setup the configuration for the plugin
---@param opts TodoistConfig: The configuration for the plugin
M.setup = function(opts)
    opts = opts or {}
    opts.token_api = os.getenv("TODOIST_TOKEN") or opts.token_api
    if opts.token_api == nil then
        vim.notify("No Token found")
    else
        config.set_config(opts)
    end
end

M.show_tasks = function(opts)
    api.show_tasks(opts.args)
end

M.add_tasks = function()
    api.create_task()
end

M.pick_tasks = function(opts)
    api.find_task(opts)
end

return M

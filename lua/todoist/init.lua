local M = {}

local api = require("todoist.api")
local config = require("todoist.config")

---Setup the configuration for the plugin
---@param opts TodoistConfig: The configuration for the plugin
M.setup = function(opts)
    opts = opts or {}
    opts.token_api = os.getenv("TODOIST_TOKEN") or opts.token_api
    config.set_config(opts)
end

M.show_tasks = function()
    api.show_tasks()
end

M.add_tasks = function()
    api.add_tasks()
end

return M

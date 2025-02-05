local M = {}

local api = require("todoist.api")

---The configuration for the plugin
---@class TodoistConfig
---@field token_api string: The api token to use
---@field filter string: Test value
M.config = {
    token_api = "",
    filter = "",
}

---Setup the configuration for the plugin
---@param opts TodoistConfig: The configuration for the plugin
M.setup = function(opts)
    opts = opts or {}
    opts.token_api = os.getenv("TODOIST_TOKEN") or opts.token_api
    if opts.token_api then
        M.config = vim.tbl_deep_extend("force", M.config, opts)
    else
        vim.notify("No API token found")
    end
end

M.get_tasks = function()
    api.api_get_tasks(M.config.token_api)
end

return M

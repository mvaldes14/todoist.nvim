local M = {}

local api = require("todoist.api")

---The configuration for the plugin
---@class TodoistConfig
---@field token string: The api token to use
M.config = {
    token = "",
}

---Setup the configuration for the plugin
---@param opts TodoistConfig: The configuration for the plugin
M.setup = function(opts)
    opts = opts or {}
    local token = os.getenv("TODOIST_TOKEN")
    if token then
        opts.token = token
        vim.tbl_deep_extend("force", M.config, opts)
    else
        vim.notify("No api token found")
    end
end

M.get_tasks = function()
    vim.print("config is", M.config)
    api.get_tasks(M.config.token)
end

return M

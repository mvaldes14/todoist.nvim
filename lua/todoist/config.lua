local M = {}

---The configuration for the plugin
---@class TodoistConfig
---@field token_api string: The api token to use
---@field filters table: Test value
local default_config = {
    token_api = "",
    filters = {
        all = "all",
    },
    default_filter = "all",
}

M.set_config = function(opts)
    opts = opts or {}
    opts.token_api = os.getenv("TODOIST_TOKEN") or opts.token_api
    default_config = vim.tbl_deep_extend("force", default_config, opts)
end

M.get_config = function()
    return default_config
end

---@return boolean
M.token = function()
    if default_config.token_api == "" then
        vim.notify(
            "Please set the TODOIST_TOKEN environment variable or provide a token in the config.",
            vim.log.levels.ERROR
        )
        return false
    end
    return true
end

return M

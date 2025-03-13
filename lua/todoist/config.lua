local M = {}

---The configuration for the plugin
---@class TodoistConfig
---@field token_api string: The api token to use
---@field filters table: Test value
M.config = {
    token_api = "",
    filters = {
        all = "all",
    },
    default_filter = "all",
}

M.set_config = function(opts)
    M.config = vim.tbl_deep_extend("force", M.config, opts)
end

M.get_config = function()
    return M.config
end

return M

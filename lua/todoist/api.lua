local M = {}

local url = "https://api.todoist.com/rest/v2/"
local utils = require("todoist.utils")

---Gets all tasks from all projects
---@params token string: The api token to use
M.get_tasks = function(token)
    local data = utils.get_request(url .. "tasks", token)
    vim.print(data)
end

return M

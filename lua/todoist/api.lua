local M = {}

local url = "https://api.todoist.com/rest/v2/"
local utils = require("todoist.utils")
local todos = require("todoist.todos")
local ui = require("todoist.ui")

-- TODO: Find a way to get the token from the setup instead of passing it around in the api call
-- maybe defined at the module level?

--- Gets all tasks from all projects
--- @params token string: The api token to use
M.api_get_tasks = function(token)
    local ui_win = ui.create_win()
    local data = utils.get_request(url .. "tasks", token)
    local todo_list = todos.list(data)
    for _, v in ipairs(todo_list) do
        local box = "[ ]"
        local due = ""
        if v.completed then
            box = "[x]"
        end
        if v.due then
            due = v.due
        end
        vim.api.nvim_buf_set_lines(ui_win.buf, -1, -1, false, { "- " .. box .. " " .. v.name .. " " .. due })
    end
end

M.api_add_tasks = function()
    -- TODO: Implement this
end

return M

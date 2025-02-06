local M = {}

local url = "https://api.todoist.com/rest/v2/"
local utils = require("todoist.utils")
local todos = require("todoist.data")
local ui = require("todoist.ui")

-- TODO: Find a way to get the token from the setup instead of passing it around in the api call
-- maybe defined at the module level?

--- Gets all tasks from all projects
--- @params token string: The api token to use
local function api_get_tasks(token)
    local data = utils.get_request(url .. "tasks", token)
    return todos.list(data)
end

local function filter_task(token, item_name)
    local data = api_get_tasks(token)
    for _, v in ipairs(data) do
        if v.name == item_name then
            return v.id
        end
    end
end

M.show_tasks = function(token)
    local ns_id = vim.api.nvim_create_namespace("demo")
    local ui_win = ui.create_win()
    local todo_list = api_get_tasks(token)
    for i, v in ipairs(todo_list) do
        local box = "[ ]"
        if v.completed then
            box = "[x]"
        end
        vim.api.nvim_buf_set_lines(ui_win.buf, i - 1, -1, false, { "- " .. box .. " " .. v.name })
        vim.api.nvim_buf_set_extmark(ui_win.buf, ns_id, i - 1, 0, {
            id = i,
            virt_text = { { v.due, "Comment" } },
            virt_text_pos = "eol",
        })
    end
end

M.add_tasks = function()
    vim.ui.input({ prompt = "Add a task" }, function(input)
        print(input)
    end)
end

M.api_complete_tasks = function()
    local cursor = vim.api.nvim_win_get_cursor(0)
    local line = vim.fn.getline(cursor[1])
    print(line)
end

return M

local M = {}

local utils = require("todoist.utils")
local todos = require("todoist.data")
local ui = require("todoist.ui")
local config = require("todoist.config")

local function api_get_tasks(filter)
    local token = config.get_config().token_api
    local data = utils.get_request("tasks", filter, token)
    return todos.list(data)
end

-- local function filter_task()
--     local data = api_get_tasks(config.token_api)
--     for _, v in ipairs(data) do
--         if v.name == item_name then
--             return v.id
--         end
--     end
-- end
--
local function config_filter_check(name)
    local filters = config.get_config().filters
    if filters[name] then
        return filters[name]
    else
        return filters["all"]
    end
end

M.show_tasks = function(args)
    local ns_id = vim.api.nvim_create_namespace("todoist")
    local ui_win = ui.create_win()
    local filter = config_filter_check(args)
    local todo_list = api_get_tasks(filter)
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

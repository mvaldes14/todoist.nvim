local M = {}

local utils = require("todoist.utils")
local todos = require("todoist.data")
local ui = require("todoist.ui")
local config = require("todoist.config")

local function api_get_tasks(filter)
    local token = config.get_config().token_api
    local data = utils.get_request_tasks(filter, token)
    return todos.task_list(data)
end

local function api_get_projects()
    local token = config.get_config().token_api
    local data = utils.get_request_projects(token)
    return todos.project_list(data)
end

-- local function filter_task()
--     local data = api_get_tasks(config.token_api)
--     for _, v in ipairs(data) do
--         if v.name == item_name then
--             return v.id
--         end
--     end
-- end

local function get_project_name(id, project_list)
    local res = ""
    for _, v in ipairs(project_list) do
        if v.id == id then
            res = v.name
        end
    end
    return res
end

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
    local project_list = api_get_projects()
    table.sort(todo_list, function(a, b)
        return a.due < b.due
    end)
    for i, v in ipairs(todo_list) do
        local box = "[ ]"
        if v.completed then
            box = "[x]"
        end
        v.project_name = get_project_name(v.project_id, project_list)
        local task_body = "- " .. box .. " " .. v.name
        vim.api.nvim_buf_set_lines(ui_win.buf, i - 1, -1, false, { task_body .. " " .. v.project_name .. " " .. v.due })
        vim.api.nvim_buf_add_highlight(
            ui_win.buf,
            ns_id,
            "@character",
            i - 1,
            #task_body,
            #task_body + #v.project_name + 1
        )
        vim.api.nvim_buf_add_highlight(ui_win.buf, ns_id, "@number", i - 1, #task_body + #v.project_name + 1, -1)
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

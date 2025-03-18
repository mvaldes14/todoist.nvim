local M = {}

local utils = require("todoist.utils")
local todos = require("todoist.data")
local ui = require("todoist.ui")
local config = require("todoist.config")

local function config_filter_check(name)
    local filters = config.get_config().filters
    if filters[name] then
        return filters[name]
    else
        return config.get_config().default_filter
    end
end

local function api_get_tasks(filter)
    local data = utils.get_request_tasks(filter)
    return todos.task_list(data)
end

local function api_get_projects()
    local data = utils.get_request_projects()
    return todos.project_list(data)
end

local function get_project_name(id, project_list)
    local res = ""
    for _, v in ipairs(project_list) do
        if v.id == id then
            res = v.name
        end
    end
    return res
end

local function form_tasks(filter_name)
    local todo_list = api_get_tasks(filter_name)
    local project_list = api_get_projects()
    table.sort(todo_list, function(a, b)
        return a.due < b.due
    end)
    for _, v in ipairs(todo_list) do
        v.project_name = get_project_name(v.project_id, project_list)
    end
    return todo_list
end

M.find_task = function(args)
    local filter = config_filter_check(args)
    local todo_list = form_tasks(filter)
    ui.show_todos(todo_list)
end

M.show_tasks = function(args)
    local ns_id = vim.api.nvim_create_namespace("todoist")
    local ui_win = ui.create_win()
    local filter = config_filter_check(args)
    local todo_list = form_tasks(filter)
    for i, v in ipairs(todo_list) do
        local task_body = "-[" .. v.id .. "]," .. v.name .. ",#" .. v.project_name .. ", " .. v.due .. ","
        for _, l in pairs(v.labels) do
            task_body = task_body .. " @" .. l
        end
        local test = vim.split(task_body, ",")
        local final_body = string.gsub(task_body, ",", " ")

        vim.api.nvim_buf_set_lines(ui_win.buf, i - 1, -1, false, { final_body })
        vim.api.nvim_buf_add_highlight(ui_win.buf, ns_id, "@comment", i - 1, 0, #test[1]) -- ID
        vim.api.nvim_buf_add_highlight(
            ui_win.buf,
            ns_id,
            "@character",
            i - 1,
            #test[1] + #test[2] + 1,
            #test[1] + #test[2] + #test[3] + 2
        ) -- Task Name
        vim.api.nvim_buf_add_highlight(
            ui_win.buf,
            ns_id,
            "@number",
            i - 1,
            #test[1] + #test[2] + #test[3] + 2,
            #test[1] + #test[2] + #test[3] + #test[4] + 3
        ) -- Project Name
        vim.api.nvim_buf_add_highlight(
            ui_win.buf,
            ns_id,
            "@constructor",
            i - 1,
            #test[1] + #test[2] + #test[3] + #test[4] + 3,
            -1
        ) -- Labels
    end
end

M.create_task = function()
    vim.ui.input({ prompt = "Add a task" }, function(input)
        local req = utils.post_request(input)
        vim.notify("Task created successfully: " .. req["url"], vim.log.levels.INFO)
    end)
end

M.complete_task = function(id)
    local req = utils.close_request(id)
    if req == "" then
        vim.notify("Task completed successfully")
    end
end

return M

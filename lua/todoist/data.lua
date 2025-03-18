local M = {}

local function todo_new(obj)
    local id = vim.tbl_get(obj, "id")
    local name = vim.tbl_get(obj, "content")
    local due = vim.tbl_get(obj, "due", "date")
    local completed = vim.tbl_get(obj, "is_completed")
    local project_id = vim.tbl_get(obj, "project_id")
    local labels = vim.tbl_get(obj, "labels")
    return {
        id = id,
        name = name,
        due = due or "No Due Date",
        completed = completed,
        project_id = project_id,
        project_name = "",
        labels = labels,
    }
end

local function project_new(obj)
    local id = vim.tbl_get(obj, "id")
    local name = vim.tbl_get(obj, "name")
    return {
        id = id,
        name = name,
    }
end

M.task_list = function(data)
    local todo_list = {}
    for _, v in ipairs(data) do
        local t = todo_new(v)
        table.insert(todo_list, t)
    end
    return todo_list
end

M.project_list = function(data)
    local project_list = {}
    for _, v in ipairs(data) do
        local t = project_new(v)
        table.insert(project_list, t)
    end
    return project_list
end

return M

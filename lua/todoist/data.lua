local M = {}

local function todo_new(obj)
    local id = vim.tbl_get(obj, "id")
    local name = vim.tbl_get(obj, "content")
    local due = vim.tbl_get(obj, "due", "date")
    local completed = vim.tbl_get(obj, "is_completed")
    return {
        id = id,
        name = name,
        due = due or "No Due Date",
        completed = completed,
    }
end

M.list = function(data)
    local todo_list = {}
    for _, v in ipairs(data) do
        local t = todo_new(v)
        table.insert(todo_list, t)
    end
    return todo_list
end

return M

local Todo = {}

local function todo_new(obj)
    local id = vim.tbl_get(obj, "id")
    local name = vim.tbl_get(obj, "content")
    local due = vim.tbl_get(obj, "due", "date")
    local completed = vim.tbl_get(obj, "is_completed")
    return {
        id = id,
        name = name,
        due = due,
        completed = completed,
    }
end

---@param data table: The data to parse
---@return table: The list of todos
Todo.list = function(data)
    local todo_list = {}
    for _, v in ipairs(data) do
        local t = todo_new(v)
        table.insert(todo_list, t)
    end
    return todo_list
end

return Todo
